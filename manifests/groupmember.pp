define multisync::groupmember(
    $path,
    $host,
    $group    = $title,
) {
  file { "${::multisync_basedir}/groups/${group}/${host}":
    ensure  => file,
    content => $path,
    notify  => Exec['compile multisync config'],
  }
}
