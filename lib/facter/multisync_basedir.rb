# Get the base directory for scripts on the host system.
Facter.add('multisync_basedir') do
  setcode do
    File.join(Puppet[:vardir], 'multisync')
  end
end
