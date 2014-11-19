# == Class: multisync
#
# This class installs the csync2 and lsyncd packages and sets up the
# basic directory structure on the client that's required for the
# compilation script. You don't have to include this class manually, it
# is included automatically.
#
# === Authors
#
# Ingmar Steen <iksteen@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ingmar Steen, unless otherwise noted.
#
class multisync(
    $csync2_confdir = $multisync::params::csync2_confdir,
    $csync2_package = 'csync2',
    $lsyncd_package = 'lsyncd',
) inherits multisync::params {
  package { 'csync2':
    ensure => installed,
    name   => $csync2_package,
  }

  package { 'lsyncd':
    ensure => installed,
    name   => $lsyncd_package,
  }

  file { $csync2_confdir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
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
