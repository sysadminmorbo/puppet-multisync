# == Class: multisync::service
#
# Internal class that sets up the service script to start lsyncd. This
# class is included automatically.
#
# === Authors
#
# Ingmar Steen <iksteen@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ingmar Steen, unless otherwise noted.
#
class multisync::service {
  case $::osfamily {
    'Archlinux': {
      file { '/etc/systemd/system/multisync.service':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/multisync/multisync.service',
        require => [
          Package['csync2'],
          Package['lsyncd'],
        ],
      }

      service { 'multisync':
        ensure  => running,
        enable  => true,
        require => [
          File['/etc/systemd/system/multisync.service'],
          Exec['compile multisync config'],
        ],
      }
    }

    'Debian': {
      file { '/etc/init.d/multisync':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0755',
        source  => 'puppet:///modules/multisync/multisync.debian',
        require => [
          Package['csync2'],
          Package['lsyncd'],
        ],
      }

      service { 'multisync':
        ensure  => running,
        enable  => true,
        require => [
          File['/etc/init.d/multisync'],
          Exec['compile multisync config'],
        ],
      }
    }

    'RedHat': {
      file { '/etc/init.d/multisync':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0755',
        source  => 'puppet:///modules/multisync/multisync.rh',
        require => [
          Package['csync2'],
          Package['lsyncd'],
        ],
      }

      service { 'multisync':
        ensure  => running,
        enable  => true,
        require => [
          File['/etc/init.d/multisync'],
          Exec['compile multisync config'],
        ],
      }
    }

    default: {
      notify { "automatic starting of multisync service not supported on ${::osfamily}": }
    }
  }
}
