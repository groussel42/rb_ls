# frozen_string_literal: true

require_relative './lib/arguments'

argument = Arguments.new
argument.parse(ARGV)

# TODO: show files then folders
