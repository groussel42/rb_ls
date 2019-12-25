# frozen_string_literal: true

# typed: false

require 'sorbet-runtime'

require_relative './lib/parser'
require_relative './lib/files'

class Main
  extend T::Sig

  def self.main
    argument = Parser.new(ARGV)
    argument.parse

    # TODO: show files then folders
    print_inexistants_files(argument.inexistants)
    argument.files.each do |file|
    end
  end
end

def print_inexistants_files(inexistants_files)
  str = ''
  inexistants_files.each { |file| str += "\"#{file}\": No such file or directory\n" }

  puts str if str.length.positive?
end

Main.main
