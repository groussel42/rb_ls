# string_frozen_literal: true

# TODO: padding -l
# TODO: -l
def long_info(files)
  files.map do |file|
    "#{file.permissions} #{file.stat.size} #{file.gid} #{file.uid} #{file.mtime} #{file.name}"
  end
end

# TODO: -x
# TODO: print in column
def print_files(parser)
  str = parser.arg_l? ? long_info(parser.files) : parser.files.map(&:name)

  str = str.reverse if parser.arg_r?
  puts parser.arg_l? ? str.join("\n") : str.join(' ')
end

def print_inexistants_files(inexistants_files)
  str = ''
  inexistants_files.each { |file| str += "\"#{file}\": No such file or directory\n" }

  puts str + "\n" if str.length.positive?
end
