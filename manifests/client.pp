# Class: mysql::client
#
# mysql クライアントの設定を管理するクラス。
#
# 現状はクライアントパッケージを導入するのみ。
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql::client ( $version = 'present' ) {
  package { 'mysql-client':
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'mysql-client',
      /(?i-mx:redhat|centos)/ => 'mysql',
    },
    ensure => $version,
  }
}
