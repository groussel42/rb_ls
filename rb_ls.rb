# frozen_string_literal: true
# typed: false

require 'sorbet-runtime'

require_relative './lib/arguments'
require_relative './lib/files'

class Main
  extend T::Sig

  def self.main
    argument = Arguments.new
    argument.parse(ARGV)

    # TODO: show files then folders
    argument.files.each do |file|
    end
  end
end

Main.main
