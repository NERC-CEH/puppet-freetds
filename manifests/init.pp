# == Class: freetds
#
# This is the freetds manifest, it classifies a node to install the freetds 
# driver. This is useful if you want to connect to tds database servers such as
# Microsft SQL Server
#
# === Parameters
# [*manage_unixodbc*] set if we should manage the unixodbc packages. Defaults to true
# [*unixodbc_version*] the version of the unixodbc packages to install. This is only used if
#   manage_unixodbc is set to true
# [*freetds_version*] the version of the freetds packages to install
# [*global_tds_version*] sets a default global version of the tds protocol to be used by 
#   underlying databases
# [*global_port*] sets a default port which tds databases communicate over
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class freetds (
  $manage_unixodbc    = true,
  $unixodbc_version   = installed,
  $freetds_version    = installed,
  $global_tds_version = '7.0',
  $global_port        = 1433
) {
  $tds_packages = $freetds::params::tds_packages
  $odbc_packages = $freetds::params::odbc_packages
  $odbc_lib = $freetds::params::odbc_lib
  $odbc_lib64 = $freetds::params::odbc_lib64
  $freetds_conf = $freetds::params::freetds_conf

  if $manage_unixodbc {
    package { $odbc_packages:
      ensure => $unixodbc_version,
    }
  }

  package { $tds_packages:
    ensure => $freetds_version,
  }

  # Manage the /etc/odbcinst.ini
  ini_setting { 'FreeTDS Description' :
    path    => '/etc/odbcinst.ini',
    section => 'FreeTDS',
    setting => 'Description',
    value   => 'ODBC for TDB',
  }
  ini_setting { 'FreeTDS Driver' :
    path    => '/etc/odbcinst.ini',
    section => 'FreeTDS',
    setting => 'Driver',
    value   => "${odbc_lib}/libtdsodbc.so",
  }
  ini_setting { 'FreeTDS Setup' :
    path    => '/etc/odbcinst.ini',
    section => 'FreeTDS',
    setting => 'Setup',
    value   => "${odbc_lib}/libtdsS.so",
  }
  ini_setting { 'FreeTDS Driver64' :
    path    => '/etc/odbcinst.ini',
    section => 'FreeTDS',
    setting => 'Driver64',
    value   => "${odbc_lib64}/libtdsodbc.so",
  }
  ini_setting { 'FreeTDS Setup64' :
    path    => '/etc/odbcinst.ini',
    section => 'FreeTDS',
    setting => 'Setup64',
    value   => "${odbc_lib64}/libtdsS.so",
  }

  file { '/etc/freetds' :
    ensure => directory,
  }

  # Set some defaults in the freetds configuration file
  ini_setting { 'FreeTDS Global Port' :
    path    => $freetds_conf,
    section => 'global',
    setting => 'port',
    value   => $global_port,
    before  => Package[$tds_packages],
  }
  ini_setting { 'FreeTDS Global tds version' :
    path    => $freetds_conf,
    section => 'global',
    setting => 'tds version',
    value   => $global_tds_version,
    before  => Package[$tds_packages],
  }

  File['/etc/freetds'] -> Ini_setting<| path == $freetds_conf |>
}
