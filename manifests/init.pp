class multisync {
  $csync2_confdir = $::operatingsystem ? {
    centos  => '/etc/csync2',
    default => '/etc',
  }

  package { 'csync2':
    ensure => installed,
  }
  package { 'lsyncd':
    ensure => installed,
  }


  file { $::multisync_basedir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { "${::multisync_basedir}/bin":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }


  file { "${::multisync_basedir}/data":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { "${::multisync_basedir}/groups":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Exec['compile multisync config'],
  }

  include multisync::config
  include multisync::service
}
