# frozen_string_literal: true

# typed: true

class Parser
  extend T::Sig

  attr_reader :argv, :args

  def initialize(argv)
    @argv         = argv
    @args         = [%i[l R a r t S U x], Array.new(8, false)].transpose.to_h
  end

  # FIXME: arguments going in inexistant files array
  # TODO: -a
  # TODO: -U
  # TODO: -t
  # TODO: -S
  # TODO: sort by name
  sig { returns(T::Array[T.any(T::Array[Files], T::Array[String], T::Array[T.noreturn])]) }
  def parse
    files       = []
    folders     = []
    inexistants = []
    dash_dash   = false

    path = Dir.pwd
    @argv.each do |argument|
      dash_dash = true if argument == '--'

      add_argument(argument) if argument[0] == '-' && !dash_dash
      files << Files.new("#{path}/#{argument}") if File.file? "#{path}/#{argument}"
      folders << Files.new("#{path}/#{argument}") if File.directory? "#{path}/#{argument}"
      inexistants << argument unless File.exist? "#{path}/#{argument}"
    end

    [files, folders, inexistants]
  end

  sig { params(argument: String).void }
  def add_argument(argument)
    argument = argument[1..-1]

    argument.chars.each do |letter|
      @args[letter.to_sym] = true if %w[l R a r t S U x].include? letter
    end
  end

  %w[l R a r t S U x].each do |method|
    define_method "arg_#{method}?" do
      @args[method.to_sym]
    end
  end
end
