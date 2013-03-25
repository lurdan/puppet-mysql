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
class mysql::client ( $version = 'latest' ) {
  package { 'mysql-client':
    name => $::osfamily ? {
      'Debian' => 'mysql-client',
      'RedHat' => 'mysql',
    },
    ensure => $version,
  }
}

