# Class: mysql
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql (
  $version = 'present',
  $client = true,
  $server = false,
  $confdir = '/etc/mysql',
  $ssl = false
) {

  case $::operatingsystem {
    /(?i-mx:debian|ubuntu)/: {
      package {
        'mysql-common':
          ensure => $version;
        'libmysqlclient':
          name => $::lsbdistcodename ? {
            'squeeze' => 'libmysqlclient16',
            default => 'libmysqlclient18',
          };
      }
    }
    /(?i-mx:redhat|centos)/: {
      package { 'mysql-common':
        name => 'mysql-libs',
        ensure => $version,
      }
      file { '/etc/my.cnf':
        ensure => link,
        target => "$confdir/my.cnf",
        require => File["$confdir/my.cnf"],
      }
    }
  }

  file {
    "$confdir":
      require => Package['mysql-common'],
      ensure => directory;
    "$confdir/my.cnf":
      ensure => present,
      require => Package['mysql-common'];
    "$confdir/conf.d":
      require => Package['mysql-server'],
      ensure => directory;
  }

  if $client {
    class { 'mysql::client':
      version => $version,
    }
  }
  if $server {
    class { 'mysql::server':
      version => $version,
      active => $server ? {
        'active' => true,
        default => false,
      },
    }
  }
  if $ssl { #TBD
  }
}

define mysql::conf ( $content ) {
  file { "${mysql::confdir}/conf.d/${name}.cnf":
    mode => 640, owner => mysql, group => adm,
    require => File["${mysql::confdir}/conf.d"],
    content => $content,
  }
}

# Class: mysql::ssl
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql::ssl ( $ssldir = '/etc/mysql/ssl' ) {
  file { "${ssldir}":
      ensure => directory, mode => 600,
      require => Package['mysql-server'];
  }
}

define mysql::ssl::cert ( $source, $ssldir = '/etc/mysql/ssl' ) {
  file { "${ssldir}/$name":
    mode => 600, owner => mysql, group => mysql,
    require => File["$ssldir"],
    source => $source;
  }
}
