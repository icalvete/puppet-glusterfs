define glusterfs::volume::create (

  $type              = undef,
  $type_count        = undef,
  $bricks            = undef,
  $start             = true,
  $mount             = true,
  $volume_mountpoint = undef

) {

  if ! $type {
    fail ('GlusterFS volume type needs be [replica|stripe].')
  }

  if ! $type_count {
    fail ('GlusterFS volume needs count parameter.')
  }
  
  if ! $bricks {
    fail ('GlusterFS need parameter')
  }
  
  if $mount {
    if ! $volume_mountpoint {
      fail ('GlusterFS mount parameter is true, volume_mountpoint is needed')
    }
  }

  exec{ "create_volume_${name}":
    command => "/usr/sbin/gluster volume create ${name} ${type} ${type_count} ${bricks}",
    user    => 'root',
    unless  => "/usr/sbin/gluster volume info ${name}",
    tries     => '10',
    try_sleep => '30'
  }

  if $start {
    glusterfs::volume::start {$name:}
  }

  if $mount {
    glusterfs::volume::mount {$name:
      volume_name       => $name,
      volume_mountpoint => $volume_mountpoint,
      require           => Glusterfs::Volume::Start[$name]
    }
  }
}
