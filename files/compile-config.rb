#! /usr/bin/env ruby

require 'digest/md5'

lsyncdver = `lsyncd --version`.split(' ')[1]
lsyncdver = /^(?:(\d+)\.)?(?:(\d+)\.)?(\d+)$/.match(lsyncdver)

if lsyncdver[1].to_i < 2
  raise RuntimeError('lsyncd too old (need >= 2.0.0)')
end

fqdn = ENV['fqdn']
csync2_confdir = ENV['csync2_confdir']
groups_dir = File.dirname(__FILE__) + '/../groups'
lsyncdconf = File.dirname(__FILE__) + '/../data/lsyncd.conf.tmpl'
source_map = Hash.new

# Iterate groups
Dir["#{groups_dir}/*"].sort.each { |group_dir|
  group = File.basename(group_dir)
  hosts = Dir["#{group_dir}/*"].sort.map { |h| File.basename(h) }
  paths = hosts.map { |host|
    path = File.open(File.join(group_dir, host)).first
    "  on #{host}: #{path};"
  }.join("\n")
  prefix = "prefix path {\n#{paths}\n}"

  # Check if localhost is a member of this group
  ix = hosts.index(fqdn)
  if ! ix.nil?
    path = File.open(File.join(group_dir, fqdn)).first
    next_host = (ix == hosts.length - 1) ? hosts[0] : hosts[ix + 1]
    prev_host = (ix == 0) ? hosts.last : hosts[ix - 1]

    # Group name is md5(group:slave_fqdn) to work around
    # character restrictions.
    group_name = Digest::MD5.hexdigest "#{group}:#{next_host}"
    File.open("#{csync2_confdir}/csync2_#{group_name}.cfg", 'w') { |f|
      f.puts "group #{group_name} {"
      f.puts "  host #{fqdn};"
      f.puts "  host (#{next_host});"
      f.puts "  key #{csync2_confdir}/csync2_#{group}.key;"
      f.puts "  include %path%;"
      f.puts "  auto none;"
      f.puts "}"
      f.puts
      f.puts prefix
    }
    source_map[group_name] = path

    group_name = Digest::MD5.hexdigest "#{group}:#{fqdn}"
    File.open("#{csync2_confdir}/csync2_#{group_name}.cfg", 'w') { |f|
      f.puts "group #{group_name} {"
      f.puts "  host #{prev_host};"
      f.puts "  host (#{fqdn});"
      f.puts "  key #{csync2_confdir}/csync2_#{group}.key;"
      f.puts "  include %path%;"
      f.puts "  auto none;"
      f.puts "}"
      f.puts
      f.puts prefix
    }
  end
}

source_map.each_pair { |k,v| source_map[k] = "    [\"#{v}\"] = \"#{k}\"" }
sources = source_map.values.join(",\n")
tmpl = File.open(lsyncdconf).read

# in lsyncd < 2.1.0 settings is a variable instead of a function
if lsyncdver[1].to_i == 2 and lsyncdver[2].to_i == 0
  tmpl.gsub! /^settings {$/, 'settings = {'
end
tmpl.gsub!(/\$\$CSYNC2_CONFDIR\$\$/, csync2_confdir)
tmpl.gsub!(/\$\$SOURCES\$\$/, sources)
File.open('/etc/lsyncd-multisync.conf', 'w') { |f|
  f.write tmpl
}
