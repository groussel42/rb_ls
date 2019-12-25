# frozen_string_literal: true

# typed: false

require 'parser'
require 'files'

RSpec.describe Files, '#mode' do
  context 'with normal files' do
    it 'check mode on simple file' do
      argument = Parser.new(['rb_ls.rb'])
      argument.parse
      expect(argument.files[0].mode).to eq '-rw-r--r--'
    end

    it 'check mode on file with all permissions' do
      f = File.new('out', 'w')
      f.write('totor')
      f.chmod(0777)
      f.close

      argument = Parser.new(['out'])
      argument.parse

      expect(argument.files[0].mode).to eq '-rwxrwxrwx'
    end
  end

  it 'check mode on simple directory' do
    argument = Parser.new(['lib'])
    argument.parse

    expect(argument.folders[0].mode).to eq 'drwxr-xr-x'
  end
end
