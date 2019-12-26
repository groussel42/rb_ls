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

    print_inexistants_files(inexistants) unless inexistants.empty? || inexistants.nil?
    print_files(files, parser)
    folders.each do |folder|
      through_folder(folder, parser)
    end
  end
end

def through_folder(folder, parser)
  files   = []
  folders = []

  puts "\n#{folder.name}:"
  Dir.entries(folder.path).each do |file|
    file_path = "#{folder.path}/#{file}"

    files << Files.new(file_path) if File.file? file_path
    folders << Files.new(file_path) if File.directory?(file_path) && !%w[. ..].include?(file)
  end

  print_files(files, parser)
  folders.each { |fold| through_folder(fold, parser) } if parser.arg_R?
end

Main.main
