define multisync::group(
  $path,
  $group = $title,
) {
  require multisync

  file { $path:
    ensure => directory,
  }->
  file { "${multisync::csync2_confdir}/csync2.${group}.key":
    owner  => root,
    group  => root,
    mode   => '0600',
    source => "puppet:///modules/multisync/${group}.key",
  }->
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
