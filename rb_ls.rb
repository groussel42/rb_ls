# frozen_string_literal: true

# typed: false

require 'sorbet-runtime'

require_relative './lib/files'
require_relative './lib/parser'
require_relative './lib/print.rb'

class Main
  extend T::Sig

  # TODO: -R
  # TODO: show files then folders
  def self.main
    argument = Parser.new(ARGV)
    argument.parse

    print_inexistants_files(argument.inexistants)
    print_files(argument)
  end
end

Main.main
