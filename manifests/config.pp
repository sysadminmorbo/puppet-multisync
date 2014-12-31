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
  $multisync_module_path = get_module_path('multisync')

  $csync2_ssl_cert =
    generate( "/usr/bin/perl",
              "${multisync_module_path}/files/generate_ssl_keypair",
              "--type", "cert", "--fqdn", "$::fqdn",
              "--directory", $::multisync::persist_directory)
  $csync2_ssl_key =
    generate( "/usr/bin/perl",
              "${multisync_module_path}/files/generate_ssl_keypair",
              "--type", "key", "--fqdn", "$::fqdn",
              "--directory", $::multisync::persist_directory)

  file { "${multisync::csync2_confdir}/csync2_ssl_cert.pem":
      content => $csync2_ssl_cert,
      owner   => 'root',
      group   => 'root',
      mode    => 700
  }

  file { "${multisync::csync2_confdir}/csync2_ssl_key.pem":
      content => $csync2_ssl_key,
      owner   => 'root',
      group   => 'root',
      mode    => 700
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
      "hostname=${::fqdn}",
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
