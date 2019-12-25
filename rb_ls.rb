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
    argument.files.each do |file|
    end
  end
end

Main.main
