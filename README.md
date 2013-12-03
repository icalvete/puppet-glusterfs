#puppet-glusterfs

Puppet manifest to install and configure GlusterFS

[![Build Status](https://secure.travis-ci.org/icalvete/puppet-glusterfs.png)](http://travis-ci.org/icalvete/puppet-glusterfs)

See [GlusterFS site](http://www.gluster.org/)

##Example:


```
node /ubuntu0[0-9].smartpurposes.net/ inherits test_defaults {
  $volume_name = 'gais_home'
  $volume_data = {
    '10.241.5.6' => { 'dev'        => '/dev/vdb1',
                      'mountpoint' => "/srv/${volume_name}_brick1",
                    },
    '10.241.5.7' => { 'dev'        => '/dev/vdb1',
                      'mountpoint' => "/srv/${volume_name}_brick1",
                    }
  }

  $volume_mountpoint = '/home'
  $volume_type       = 'replica'

  class {'roles::glusterfs_server':
    volume_name       => $volume_name,
    volume_data       => $volume_data,
    volume_mountpoint => $volume_mountpoint,
    volume_type       => $volume_type
  }
}

class roles::glusterfs_server (

  $volume_name       = undef,
  $volume_data       = undef,
  $volume_mountpoint = undef,
  $volume_type       = undef

) inherits roles {

  if ! $volume_name {
    fail('A GlusterFS cluster needs a volumen_name.')
  }
  
  if ! $volume_data and ! is_hash($volume_data) {
    fail('A GlusterFS cluster needs some volumen data.')
  }
  
  if ! $volume_mountpoint {
    fail('A GlusterFS cluster needs a volume mountpoint.')
  }
  
  if ! $volume_type {
    fail('A GlusterFS cluster needs a volume type.')
  }
  
  $peers  = keys($volume_data)
  $size   = size($peers)
  $bricks = glusterFunctions($volume_data, 'formatBricks')

  include glusterfs::server
  
  glusterfs::brick {$volume_name:
    dev        => $volume_data[$::ipaddress_eth1]['dev'],
    mountpoint => $volume_data[$::ipaddress_eth1]['mountpoint'],
  }
  
  glusterfs::peer::probe{$peers:
    require => Class['glusterfs::server'],
    before  => Glusterfs::Volume::Create[$volume_name]
  }

  glusterfs::volume::create {$volume_name:
    type              => $volume_type,
    type_count        => $size,
    bricks            => $bricks,
    volume_mountpoint => $volume_mountpoint,
    require           => Glusterfs::Brick[$volume_name]
  }
}

```

##Authors:

Israel Calvete Talavera <icalvete@gmail.com>
