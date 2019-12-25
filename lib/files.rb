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
    file_type + permissions
    # TODO: sticky bits
    # TODO: ACL
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
    binary_groups = format_binary_array

    binary_groups.each do |group|
      group[0] = group[0] == '1' ? 'r' : '-'
      group[1] = group[1] == '1' ? 'w' : '-'
      group[2] = group[2] == '1' ? 'x' : '-'
    end

    binary_groups.join
  end

  sig { returns(T::Array[String]) }
  def format_binary_array
    stat.mode.to_s(2).chars.last(9).join.scan(/.../)
  end
end
