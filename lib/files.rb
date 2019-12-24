class Files
  attr_reader :name, :stat

  def initialize(name)
    @name = name
    @stat = File.stat(name)
  end

  def string_mode
    str = ''

    str << file_type
    str << mode_permission
    # TODO: sticky bits
    # TODO: ACL

    str
  end

  def file_type
    return '-' if @stat.file?
    return 'b' if @stat.blockdev?
    return 'c' if @stat.chardev?
    return 'd' if @stat.directory?
    return 's' if @stat.socket?
    return 'l' if @stat.symlink?
    return 'p' if @stat.pipe?
  end

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
