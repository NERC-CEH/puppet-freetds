# Cross-platform support
class freetds::params {

  # Name of FreeTDS package to install
  $tds_packages = $::osfamily ? {
    'Debian' => ['freetds-dev', 'freetds-bin', 'tdsodbc'],
    'RedHat' => ['freetds', 'freetds-devel'],
    default  => undef,
  }

  # Name of ODBC packge to install
  $odbc_packages = $::osfamily ? {
    'Debian' => ['unixodbc', 'unixodbc-dev'],
    'RedHat' => ['unixODBC', 'unixODBC-devel'],
    default  => undef,
  }

  # Path to 32-bit ODBC libs
  $odbc_lib = $::osfamily ? {
    'Debian' => '/usr/lib/i386-linux-gnu/odbc',
    'RedHat' => '/usr/lib',
    default  => undef,
  }

  # Path to 64-bit ODBC libs
  $odbc_lib64 = $::osfamily ? {
    'Debian' => '/usr/lib/x86_64-linux-gnu/odbc',
    'RedHat' => '/usr/lib64',
    default  => undef,
  }

  # Path to freetds.conf
  $freetds_conf = $::osfamily ? {
    'Debian' => '/etc/freetds/freetds.conf',
    'RedHat' => '/etc/freetds.conf',
    default  => undef,
  }
}
