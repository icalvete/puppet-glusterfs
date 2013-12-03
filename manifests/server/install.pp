class glusterfs::server::install inherits glusterfs::params {

  package{ $glusterfs::params::package:
    ensure  => present,
  }
}
