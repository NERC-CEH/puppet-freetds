# == Define: freetds::db
#
# This is the freetds db resource type, it will register a database as a System
# Data Source Name and set that to use freetds driver
#
# === Parameters
# [*host*] the hostname of the database which you which to connect to
# [*dsn*] the Data Source Name which you want to register on this system.
#   Defaults to the title of this defined resource
# [*port*] the port to connect to the database on (optional)
# [*tds_version*] the version of TDS to use (optional)
# [*manage_odbc*] If we should manage the the datasource in /etc/odbc.ini
#   Defaults to the manage::unixodbc setting of the init class
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
define freetds::db (
  $host,
  $dsn         = $title,
  $port        = undef,
  $tds_version = undef,
  $manage_odbc = $freetds::manage_unixodbc
){
  if $manage_odbc {
    # Define connections to database
    ini_setting { "ODBC Driver to ${dsn}" :
      ensure  => present,
      path    => '/etc/odbc.ini',
      section => $dsn,
      setting => 'Driver',
      value   => 'FreeTDS',
    }

    ini_setting { "ODBC Servername to ${dsn}" :
      ensure  => present,
      path    => '/etc/odbc.ini',
      section => $dsn,
      setting => 'Servername',
      value   => $dsn,
    }
  }

  ini_setting { "FreeTDS connection to ${dsn} database" :
    ensure  => present,
    path    => '/etc/freetds/freetds.conf',
    section => $dsn,
    setting => 'host',
    value   => $host,
  }

  if $port {
    ini_setting { "FreeTDS port to ${dsn} database" :
      ensure  => present,
      path    => '/etc/freetds/freetds.conf',
      section => $dsn,
      setting => 'port',
      value   => $port,
    }
  }

  if $tds_version {
    ini_setting { "FreeTDS version to ${dsn} database" :
      ensure  => present,
      path    => '/etc/freetds/freetds.conf',
      section => $dsn,
      setting => 'tds version',
      value   => $tds_version,
    }
  }
}
