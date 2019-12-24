# typed: true

class Files
  extend T::Sig

  attr_reader :name, :stat

  sig { params(name: String).void }
  def initialize(name)
    @name = name
    @stat = File.stat(name)
  end

  sig { returns(String) }
  def string_mode
    str = ''

    str << file_type
    str << mode_permission
    # TODO: sticky bits
    # TODO: ACL

    str
  end

  sig { returns(String) }
  def file_type
    case
    when @stat.blockdev?  then 'b'
    when @stat.chardev?   then 'c'
    when @stat.directory? then 'd'
    when @stat.socket?    then 's'
    when @stat.symlink?   then 'l'
    when @stat.pipe?      then 'p'
    else '-'
    end
  end

  sig { returns(String) }
  def mode_permission
    binary  = @stat.mode.to_s(2).chars.last(9).join
    str     = ''

    binary.scan(/.../).each do |char|
      str += char[0] == '1' ? 'r' : '-'
      str += char[1] == '1' ? 'w' : '-'
      str += char[2] == '1' ? 'x' : '-'
    end

    str
  end
end
