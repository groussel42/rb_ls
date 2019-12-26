# string_frozen_literal: true

# TODO: -l
def long_info(files)
  padding = calc_padding(files)

  files.map do |file|
    sprintf("%#{padding[:permissions]}s %#{padding[:size]}d %#{padding[:uid]}s %#{padding[:gid]}s %s", file.permissions, file.stat.size, file.uid, file.gid, file.name)
  end
end

def calc_padding(files)
  padding = {
    permissions: 0,
    size: 0,
    gid: 0,
    uid: 0
  }

  files.each do |file|
    padding[:permissions] = file.permissions.length if file.permissions.length > padding[:permissions]
    padding[:size] = file.stat.size.to_s.length if file.stat.size.to_s.length > padding[:size]
    padding[:gid] = file.gid.length if file.gid.length > padding[:gid]
    padding[:uid] = file.uid.length if file.uid.length > padding[:uid]
  end

  padding
end

# TODO: -x
# TODO: print in column
def print_files(files, parser)
  str = parser.arg_l? ? long_info(files) : files.map(&:name)

  str = str.reverse if parser.arg_r?
  puts parser.arg_l? ? str.join("\n") : str.join('  ')
end

def print_inexistants_files(inexistants_files)
  str = ''
  inexistants_files.each { |file| str += "\"#{file}\": No such file or directory\n" }

  puts str + "\n" if str.length.positive?
end
