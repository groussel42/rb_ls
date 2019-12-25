# frozen_string_literal: true

# typed: false

require 'parser'
require 'files'

RSpec.describe Parser, '#add_argument' do
  context 'with splitted arguments' do
    it 'random arguments' do
      expected = { l: true, R: true, a: false, r: true, t: false, S: false, U: true,x: false }
      argument = Parser.new(%w[-l -R -r -U])
      argument.parse

      expect(argument.args).to eq expected
    end

    it 'arguments inexistants' do
      expected = { l: false, R: false, a: false, r: false, t: false, S: false, U: false,x: false }
      argument = Parser.new(%w[-v -P -o])
      argument.parse

      expect(argument.args).to eq expected
    end

    it 'arguments after double dashes' do
      expected = { l: true, R: false, a: false, r: true, t: false, S: false, U: false,x: false }
      argument = Parser.new(%w[-l -r -- -R -a])
      argument.parse

      expect(argument.args).to eq expected
    end
  end

  context 'with sticked arguments' do
    it 'random arguments' do
      expected = { l: true, R: true, a: false, r: true, t: false, S: false, U: true,x: false }
      argument = Parser.new(%w[-lRrU])
      argument.parse

      expect(argument.args).to eq expected
    end

    it 'arguments inexistants' do
      expected = { l: false, R: false, a: false, r: false, t: false, S: false, U: false,x: false }
      argument = Parser.new(%w[-vPo])
      argument.parse

      expect(argument.args).to eq expected
    end

    it 'arguments after double dashes' do
      expected = { l: true, R: false, a: false, r: true, t: false, S: false, U: false,x: false }
      argument = Parser.new(%w[-lr -- -Ra])
      argument.parse

      expect(argument.args).to eq expected
    end
  end

  context 'with mixed arguments' do
    it 'random arguments' do
      expected = { l: true, R: true, a: false, r: true, t: false, S: false, U: true,x: false }
      argument = Parser.new(%w[-lRr -U])
      argument.parse

      expect(argument.args).to eq expected
    end

    it 'arguments inexistants' do
      expected = { l: false, R: false, a: false, r: false, t: false, S: false, U: false,x: false }
      argument = Parser.new(%w[-vP -o])
      argument.parse

      expect(argument.args).to eq expected
    end

    it 'arguments after double dashes' do
      expected = { l: true, R: false, a: true, r: true, t: false, S: false, U: false,x: false }
      argument = Parser.new(%w[-lr -a -- -R])
      argument.parse

      expect(argument.args).to eq expected
    end
  end
end

RSpec.describe Parser, '#parse' do
  context 'with files' do
    it 'existant files' do
      expected = %w[Gemfile rb_ls.rb]
      argument = Parser.new(%w[-l Gemfile lib rb_ls.rb spec -a])
      argument.parse

      result = argument.files.map(&:name)

      expect(result).to eq expected
    end

    it 'existant files after double dashes' do
      expected = %w[Gemfile rb_ls.rb]
      argument = Parser.new(%w[-l Gemfile lib -- spec rb_ls.rb -a])
      argument.parse

      result = argument.files.map(&:name)

      expect(result).to eq expected
    end

    it 'inexistant files' do
      expected = %w[Gemfile]
      argument = Parser.new(%w[-l Gemfile lib rb_l.rb spek -a])
      argument.parse

      result = argument.files.map(&:name)

      expect(result).to eq expected
    end

    it 'existant folders' do
      expected = %w[lib spec]
      argument = Parser.new(%w[-l Gemfile lib rb_ls.rb spec -a])
      argument.parse

      result = argument.folders.map(&:name)

      expect(result).to eq expected
    end

    it 'existant folders after double dashes' do
      expected = %w[lib spec]
      argument = Parser.new(%w[-l Gemfile lib -- spec rb_ls.rb -a])
      argument.parse

      result = argument.folders.map(&:name)

      expect(result).to eq expected
    end

    it 'inexistant folders' do
      expected = %w[lib]
      argument = Parser.new(%w[-l Gemfile lib rb_ls.rb spek -a])
      argument.parse

      result = argument.folders.map(&:name)

      expect(result).to eq expected
    end
  end
end

RSpec.describe Parser, '#parse' do
  it 'arg_l?' do
    expected = [true, false, false, false, false, false, false, false]
    argument = Parser.new(%w[-l])
    argument.parse

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
    argument = Parser.new(%w[-R])
    argument.parse

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
    argument = Parser.new(%w[-a])
    argument.parse

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
    argument = Parser.new(%w[-r])
    argument.parse

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
    argument = Parser.new(%w[-t])
    argument.parse

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
    argument = Parser.new(%w[-S])
    argument.parse

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
    argument = Parser.new(%w[-U])
    argument.parse

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
    argument = Parser.new(%w[-x])
    argument.parse

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
