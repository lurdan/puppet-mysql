# Class: mysql::server
#
# mysql サーバの設定を管理するクラス。
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql::server ( $version = 'present', $active = true ) {

  package { 'mysql-server':
    ensure => $version,
    responsefile => defined(Apt::Preseed['mysql-server']) ? {
      true => '/var/cache/debconf/mysql-server.preseed',
      default => false,
    }
  }

  service { 'mysql-server':
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'mysql',
      /(?i-mx:redhat|centos)/ => 'mysqld',
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
