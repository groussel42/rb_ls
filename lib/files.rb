# frozen_string_literal: true

# typed: true

require 'etc'

class Files
  extend T::Sig

  attr_reader :name, :path, :stat

  sig { params(path: String).void }
  def initialize(path)
    @path = path
    @name = File.basename(path)
    @stat = File.stat(path)
  end

  def mode
    mode = file_type + permissions
    mode[3] = setuid_bit(mode) if File.setuid? name
    mode[6] = 's' if File.setgid? name
    mode[-1] = sticky_bit(mode) if File.sticky? name

    mode
  end

  sig { returns(String) }
  def file_type
    case
    when stat.blockdev?  then 'b'
    when stat.chardev?   then 'c'
    when stat.directory? then 'd'
    when stat.socket?    then 's'
    when stat.symlink?   then 'l'
    when stat.pipe?      then 'p'
    else '-'
    end
  end

  def mtime
    stat.mtime.strftime('%Y-%m-%d %H:%M:%S')
  end

  def gid
    Etc.getgrgid.name
  end

  def uid
    Etc.getpwuid.name
  end

  sig { returns(String) }
  def permissions
    ary     = %w[r w x]
    result  = permission_binary.chars.map.each_with_index do |bit, index|
      bit == '1' ? ary[index % 3] : '-'
    end

    result.join
  end

  sig { returns(String) }
  def permission_binary
    stat.mode.to_s(2).chars.last(9).join
  end

  def setuid_bit(mode)
    mode[3] == 'x' ? 's' : 'S'
  end

  def sticky_bit(mode)
    mode[-1] == 'x' ? 't' : 'T'
  end
end
