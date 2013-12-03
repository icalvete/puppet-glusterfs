define glusterfs::volume::start {

  exec{ "start_volume_${name}":
    command     => "/usr/sbin/gluster volume start ${name}",
    user        => 'root',
    unless      => "/usr/sbin/gluster volume info ${name} | /bin/grep Started"
  }
}
