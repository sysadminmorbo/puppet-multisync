# == Class: multisync::config
#
# Internal class that copies the required set up scripts to the client. It
# compiles the lsyncd / csync2 configuration files if trigged and generates
# an SSH key for csync2 if it doesn't exist yet.
#
# === Authors
#
# Ingmar Steen <iksteen@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ingmar Steen, unless otherwise noted.
#
class multisync::config {
  # Generate SSL key
  file { "${::multisync_basedir}/bin/gen-ssh-key.sh":
    ensure => file,
    mode   => '0755',
    owner  => root,
    group  => root,
    source => 'puppet:///modules/multisync/gen-ssh-key.sh',
  }

  exec { "${::multisync_basedir}/bin/gen-ssh-key.sh \"${::fqdn}\" \"${multisync::csync2_confdir}\"":
    creates => "${multisync::csync2_confdir}/csync2_ssl_cert.pem",
    require => File["${::multisync_basedir}/bin/gen-ssh-key.sh"],
  }

  # Compile csync2 configuration
  file { "${::multisync_basedir}/bin/compile-config.rb":
    ensure => file,
    mode   => '0755',
    owner  => root,
    group  => root,
    source => 'puppet:///modules/multisync/compile-config.rb',
    notify => Exec['compile multisync config'],
  }

  file { "${::multisync_basedir}/data/lsyncd.conf.tmpl":
    ensure => file,
    mode   => '0644',
    owner  => root,
    group  => root,
    source => 'puppet:///modules/multisync/lsyncd.conf.tmpl',
    notify => Exec['compile multisync config'],
  }

  exec { 'compile multisync config':
    command     => "${::multisync_basedir}/bin/compile-config.rb",
    environment => [
      "fqdn=${::fqdn}",
      "csync2_confdir=${multisync::csync2_confdir}",
    ],
    refreshonly => true,
    require     => [
      File["${::multisync_basedir}/bin/compile-config.rb"],
      File["${::multisync_basedir}/data/lsyncd.conf.tmpl"],
    ],
  }

  exec { 'reload multisync lsyncd config':
    command     => 'killall -HUP lsyncd',
    path        => ['/bin', '/usr/bin'],
    refreshonly => true,
    subscribe   => Exec['compile multisync config'],
  }
}
