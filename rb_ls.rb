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
    parser = Parser.new(ARGV)
    files, folders, inexistants = parser.parse

    print_inexistants_files(inexistants)
    print_files(files, parser)
  end
end

Main.main
