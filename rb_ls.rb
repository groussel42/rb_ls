# frozen_string_literal: true
# typed: false

require 'sorbet-runtime'

require_relative './lib/arguments'
require_relative './lib/files'

extend T::Sig

class Main
  def self.main
    argument = Arguments.new
    argument.parse(ARGV)

    # TODO: show files then folders
    argument.files.each do |file|
    end
  end
end

Main.main
