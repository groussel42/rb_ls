# frozen_string_literal: true

# typed: true

class Parser
  extend T::Sig

  attr_reader :argv, :files, :folders, :inexistants, :args

  def initialize(argv)
    @argv         = argv
    @files        = []
    @folders      = []
    @inexistants  = []
    @args         = [%i[l R a r t S U x], Array.new(8, false)].transpose.to_h
  end

  # FIXME: arguments going in inexistant files array
  # TODO: -a
  # TODO: -U
  # TODO: -t
  # TODO: -S
  def parse
    dash_dash = false

    @argv.each do |argument|
      dash_dash = true if argument == '--'

      add_argument(argument) if argument[0] == '-' && !dash_dash
      @files << Files.new(argument) if File.file? argument
      @folders << Files.new(argument) if File.directory? argument
      @inexistants << argument unless File.exist?(argument)
    end

    if arg_t?
      @files.sort_by! { |file| file.stat.mtime }
      @folders.sort_by! { |file| file.stat.mtime }
    elsif !arg_U?
      @files.sort_by!(&:name)
      @folders.sort_by!(&:name)
    end
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
