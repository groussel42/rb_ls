require 'arguments'
require 'files'

RSpec.describe Files, '#string_mode' do
  context 'with normal files' do
    it 'check mode on simple file' do
      argument = Arguments.new
      argument.parse(['rb_ls.rb'])

      expect(argument.files[0].string_mode).to eq '-rw-r--r--'
    end

    it 'check mode on file without any permission' do
      f = File.new('out', 'w')
      f.write('totor')
      f.chmod(0000)
      f.close

      argument = Arguments.new
      argument.parse(['out'])

      expect(argument.files[0].string_mode).to eq '----------'
    end
  end

  it 'check mode on simple directory' do
    argument = Arguments.new
    argument.parse(['lib'])

    expect(argument.folders[0].string_mode).to eq 'drwxr-xr-x'
  end
end
