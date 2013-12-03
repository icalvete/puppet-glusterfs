define glusterfs::brick (

  $dev        = undef,
  $mountpoint = "/srv/${name}",
  $fstype     = 'xfs',

) {

  if ! $dev {
    fail ('GlusterFS needs a device to create a brick.')
  }

  if $fstype == 'xfs' {
    package {'xfsprogs':
      ensure => present,
      before => Exec["mkfs_brick_${name}"]
    }
  }

  exec{ "mkfs_brick_${name}":
    command => "/sbin/mkfs.${fstype} -i size=512 ${dev}",
    user    => 'root',
    unless  => "/sbin/blkid ${dev}"
  }

  exec{ "create_brick_${name}_mountpoint":
    command => "/bin/mkdir ${mountpoint}",
    user    => 'root',
    unless  => "/usr/bin/test -d ${mountpoint}"
  }

  mount{ $mountpoint:
    ensure  => mounted,
    device  => $dev,
    fstype  => $fstype,
    options => 'defaults',
    dump    => 1,
    pass    => 2,
    require => Exec["mkfs_brick_${name}", "create_brick_${name}_mountpoint"]
  }
}
