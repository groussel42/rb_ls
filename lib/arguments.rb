class Arguments
  attr_reader :files, :folders, :args

  def initialize
    @files    = []
    @folders  = []
    @args     = [%i[l R a r t S U x], Array.new(8, false)].transpose.to_h
  end

  def parse(arguments)
    dash_dash = false

    arguments.each do |argument|
      dash_dash = true if argument == '--'

      add_argument(argument) if argument[0] == '-' && !dash_dash
      @files << argument if File.file? argument
      @folders << argument if File.directory? argument
      # TODO: if file doesn't exist
    end
  end

  def add_argument(argument)
    argument = argument[1..-1]
    @args[argument.to_sym] = true if %w[l R a r t S U x].include? argument
  end

  def arg_l?
    @args[:l]
  end

  def arg_R?
    @args[:R]
  end

  def arg_a?
    @args[:a]
  end

  def arg_r?
    @args[:r]
  end

  def arg_t?
    @args[:t]
  end

  def arg_S?
    @args[:S]
  end

  def arg_U?
    @args[:U]
  end

  def arg_x?
    @args[:x]
  end
end
