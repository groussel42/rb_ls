# frozen_string_literal: true

# typed: true

class Files
  extend T::Sig

  attr_reader :name, :stat

  sig { params(name: String).void }
  def initialize(name)
    @name = name
    @stat = File.stat(name)
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
