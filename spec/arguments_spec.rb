require 'arguments'
require 'files'

RSpec.describe Arguments, '#add_argument' do
  context 'with splitted arguments' do
    it 'random arguments' do
      expected = { l: true, R: true, a: false, r: true, t: false, S: false, U: true,x: false }
      argument = Arguments.new
      argument.parse(%w[-l -R -r -U])

      expect(argument.args).to eq expected
    end

    it 'arguments inexistants' do
      expected = { l: false, R: false, a: false, r: false, t: false, S: false, U: false,x: false }
      argument = Arguments.new
      argument.parse(%w[-v -P -o])

      expect(argument.args).to eq expected
    end

    it 'arguments after double dashes' do
      expected = { l: true, R: false, a: false, r: true, t: false, S: false, U: false,x: false }
      argument = Arguments.new
      argument.parse(%w[-l -r -- -R -a])

      expect(argument.args).to eq expected
    end
  end

  context 'with sticked arguments' do
    it 'random arguments' do
      expected = { l: true, R: true, a: false, r: true, t: false, S: false, U: true,x: false }
      argument = Arguments.new
      argument.parse(%w[-lRrU])

      expect(argument.args).to eq expected
    end

    it 'arguments inexistants' do
      expected = { l: false, R: false, a: false, r: false, t: false, S: false, U: false,x: false }
      argument = Arguments.new
      argument.parse(%w[-vPo])

      expect(argument.args).to eq expected
    end

    it 'arguments after double dashes' do
      expected = { l: true, R: false, a: false, r: true, t: false, S: false, U: false,x: false }
      argument = Arguments.new
      argument.parse(%w[-lr -- -Ra])

      expect(argument.args).to eq expected
    end
  end

  context 'with mixed arguments' do
    it 'random arguments' do
      expected = { l: true, R: true, a: false, r: true, t: false, S: false, U: true,x: false }
      argument = Arguments.new
      argument.parse(%w[-lRr -U])

      expect(argument.args).to eq expected
    end

    it 'arguments inexistants' do
      expected = { l: false, R: false, a: false, r: false, t: false, S: false, U: false,x: false }
      argument = Arguments.new
      argument.parse(%w[-vP -o])

      expect(argument.args).to eq expected
    end

    it 'arguments after double dashes' do
      expected = { l: true, R: false, a: true, r: true, t: false, S: false, U: false,x: false }
      argument = Arguments.new
      argument.parse(%w[-lr -a -- -R])

      expect(argument.args).to eq expected
    end
  end
end

RSpec.describe Arguments, '#parse' do
  # TODO: check folders
  # TODO: check folders with double dashes
  # TODO: check inexsistants folders
  context 'with files' do
    it 'existant files' do
      expected = %w[Gemfile rb_ls.rb]
      argument = Arguments.new
      argument.parse(%w[-l Gemfile lib rb_ls.rb spec -a])

      result = argument.files.map(&:name)

      expect(result).to eq expected
    end

    it 'existant files after double dashes' do
      expected = %w[Gemfile rb_ls.rb]
      argument = Arguments.new
      argument.parse(%w[-l Gemfile lib -- spec rb_ls.rb -a])

      result = argument.files.map(&:name)

      expect(result).to eq expected
    end

    it 'inexistant files' do
      expected = %w[Gemfile]
      argument = Arguments.new
      argument.parse(%w[-l Gemfile lib rb_l.rb spek -a])

      result = argument.files.map(&:name)

      expect(result).to eq expected
    end

    it 'existant folders' do
      expected = %w[lib spec]
      argument = Arguments.new
      argument.parse(%w[-l Gemfile lib rb_ls.rb spec -a])

      result = argument.folders.map(&:name)

      expect(result).to eq expected
    end

    it 'existant folders after double dashes' do
      expected = %w[lib spec]
      argument = Arguments.new
      argument.parse(%w[-l Gemfile lib -- spec rb_ls.rb -a])

      result = argument.folders.map(&:name)

      expect(result).to eq expected
    end

    it 'inexistant folders' do
      expected = %w[lib]
      argument = Arguments.new
      argument.parse(%w[-l Gemfile lib rb_ls.rb spek -a])

      result = argument.folders.map(&:name)

      expect(result).to eq expected
    end
  end
end

RSpec.describe Arguments, '#parse' do
  it 'arg_l?' do
    expected = [true, false, false, false, false, false, false, false]
    argument = Arguments.new
    argument.parse(%w[-l])

    expect(
      [
        argument.arg_l?,
        argument.arg_R?,
        argument.arg_a?,
        argument.arg_r?,
        argument.arg_t?,
        argument.arg_S?,
        argument.arg_U?,
        argument.arg_x?
      ]
    ).to eq expected
  end

  it 'arg_R?' do
    expected = [false, true, false, false, false, false, false, false]
    argument = Arguments.new
    argument.parse(%w[-R])

    expect(
      [
        argument.arg_l?,
        argument.arg_R?,
        argument.arg_a?,
        argument.arg_r?,
        argument.arg_t?,
        argument.arg_S?,
        argument.arg_U?,
        argument.arg_x?
      ]
    ).to eq expected
  end

  it 'arg_a?' do
    expected = [false, false, true, false, false, false, false, false]
    argument = Arguments.new
    argument.parse(%w[-a])

    expect(
      [
        argument.arg_l?,
        argument.arg_R?,
        argument.arg_a?,
        argument.arg_r?,
        argument.arg_t?,
        argument.arg_S?,
        argument.arg_U?,
        argument.arg_x?
      ]
    ).to eq expected
  end

  it 'arg_r?' do
    expected = [false, false, false, true, false, false, false, false]
    argument = Arguments.new
    argument.parse(%w[-r])

    expect(
      [
        argument.arg_l?,
        argument.arg_R?,
        argument.arg_a?,
        argument.arg_r?,
        argument.arg_t?,
        argument.arg_S?,
        argument.arg_U?,
        argument.arg_x?
      ]
    ).to eq expected
  end

  it 'arg_t?' do
    expected = [false, false, false, false, true, false, false, false]
    argument = Arguments.new
    argument.parse(%w[-t])

    expect(
      [
        argument.arg_l?,
        argument.arg_R?,
        argument.arg_a?,
        argument.arg_r?,
        argument.arg_t?,
        argument.arg_S?,
        argument.arg_U?,
        argument.arg_x?
      ]
    ).to eq expected
  end

  it 'arg_S?' do
    expected = [false, false, false, false, false, true, false, false]
    argument = Arguments.new
    argument.parse(%w[-S])

    expect(
      [
        argument.arg_l?,
        argument.arg_R?,
        argument.arg_a?,
        argument.arg_r?,
        argument.arg_t?,
        argument.arg_S?,
        argument.arg_U?,
        argument.arg_x?
      ]
    ).to eq expected
  end

  it 'arg_U?' do
    expected = [false, false, false, false, false, false, true, false]
    argument = Arguments.new
    argument.parse(%w[-U])

    expect(
      [
        argument.arg_l?,
        argument.arg_R?,
        argument.arg_a?,
        argument.arg_r?,
        argument.arg_t?,
        argument.arg_S?,
        argument.arg_U?,
        argument.arg_x?
      ]
    ).to eq expected
  end

  it 'arg_x?' do
    expected = [false, false, false, false, false, false, false, true]
    argument = Arguments.new
    argument.parse(%w[-x])

    expect(
      [
        argument.arg_l?,
        argument.arg_R?,
        argument.arg_a?,
        argument.arg_r?,
        argument.arg_t?,
        argument.arg_S?,
        argument.arg_U?,
        argument.arg_x?
      ]
    ).to eq expected
  end
end
