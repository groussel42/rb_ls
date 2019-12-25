# frozen_string_literal: true

# typed: true

class Parser
  extend T::Sig

  attr_reader :argv, :files, :folders, :args

  def initialize(argv)
    @argv     = argv
    @files    = []
    @folders  = []
    @args     = [%i[l R a r t S U x], Array.new(8, false)].transpose.to_h
  end

  def parse
    dash_dash = false

    @argv.each do |argument|
      dash_dash = true if argument == '--'

      add_argument(argument) if argument[0] == '-' && !dash_dash
      @files << Files.new(argument) if File.file? argument
      @folders << Files.new(argument) if File.directory? argument
      # TODO: if file doesn't exist
    end
  end

  sig { params(argument: String).void }
  def add_argument(argument)
    argument = argument[1..-1]

    argument.chars.each do |letter|
      @args[letter.to_sym] = true if %w[l R a r t S U x].include? letter
    end
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
