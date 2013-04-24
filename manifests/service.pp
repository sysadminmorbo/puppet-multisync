class multisync::service {
  case $::operatingsystem {
    archlinux: {
      file { '/etc/systemd/system/multisync.service':
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/multisync/multisync.service',
      }->
      service { 'multisync':
        ensure  => running,
        enable  => true,
        require => [
          Package['csync2'],
          Package['lsyncd'],
          Exec['compile multisync config'],
        ],
      }
    }
    debian: {
      file { '/etc/init.d/multisync':
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0755',
        source => 'puppet:///modules/multisync/multisync.debian',
      }->
      service { 'multisync':
        ensure  => running,
        enable  => true,
        require => [
          Package['csync2'],
          Package['lsyncd'],
          Exec['compile multisync config'],
        ],
      }
    }
    centos: {
      file { '/etc/init.d/multisync':
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0755',
        source => 'puppet:///modules/multisync/multisync.rh',
      }->
      service { 'multisync':
        ensure  => running,
        enable  => true,
        require => [
          Package['csync2'],
          Package['lsyncd'],
          Exec['compile multisync config'],
        ],
      }
    }
    default: {
      notify { "automatic starting of multisync service not supported on ${::operatingsystem}": }
    }
  }
}
