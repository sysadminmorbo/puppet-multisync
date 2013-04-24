# == Resource: multisync::group
#
# Internal resource that sets up the requirements for a sync group on a
# client. It copies the group key, ensures the sync directory exists and
# collects the exported group members.
#
# === Authors
#
# Ingmar Steen <iksteen@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ingmar Steen, unless otherwise noted.
#
define multisync::group(
  $path,
  $group = $title,
) {
  require multisync

  # Create the sync directory
  file { $path:
    ensure => directory,
  }->
  # Copy the group key
  file { "${multisync::csync2_confdir}/csync2.${group}.key":
    owner  => root,
    group  => root,
    mode   => '0600',
    source => "puppet:///modules/multisync/${group}.key",
  }->
  # Create the configuration directory for the compilation script
  file { "${::multisync_basedir}/groups/${group}":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Exec['compile multisync config'],
  }

  # Fetch all the group members
  Multisync::Groupmember <<| group == $group  |>>
}
