# Class: mysql::server
#
# manage mysql server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql::server ( $version = 'latest', $active = true ) {

  $plugin_dir = "/usr/${::fc_libdir}/mysql/plugin"

  package { 'mysql-server':
    ensure => $version,
    responsefile => defined(Apt::Preseed['mysql-server']) ? {
      true => '/var/cache/debconf/mysql-server.preseed',
      default => false,
    }
  }

  service { 'mysql-server':
    name => $::osfamily ? {
      'Debian' => 'mysql',
      'RedHat' => 'mysqld',
    },
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    enable => $active,
#    hasstatus => true,
    require => Package['mysql-server'],
    subscribe => File["${mysql::confdir}/my.cnf"],
  }
  Mysql::Conf <| |> -> Service['mysql-server']
}



define mysql::server::plugin ( $source ) {
  file { "${mysql::server::plugin_dir}/${name}.so":
    source => $source,
    notify => Service['mysql-server'],
  }
}






class mysql::server::hugetlb {


#TODO:  large_pages

#vm.hugetlb_shm_group = 102
#vm.nr_hugepages = 20
#kernel.shmmax = (innodb_buffer_pool_size + α)
#kernel.shmall = 786432

#/etc/security/limits.conf
#mysql soft memlock unlimited
#mysql hard memlock unlimited


}
