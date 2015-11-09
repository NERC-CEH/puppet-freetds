# Cross-platform support
class freetds::params {

  case $::osfamily {
    'Debian': {
      $tds_packages = ['freetds-dev', 'freetds-bin', 'tdsodbc']
      $odbc_packages = ['unixodbc', 'unixodbc-dev']
      $odbc_lib = '/usr/lib/i386-linux-gnu/odbc'
      $odbc_lib64 = '/usr/lib/x86_64-linux-gnu/odbc'
      $freetds_conf = '/etc/freetds/freetds.conf'
    }
    'RedHat': {
      $tds_packages = ['freetds', 'freetds-devel']
      $odbc_packages = ['unixODBC', 'unixODBC-devel']
      $odbc_lib = '/usr/lib'
      $odbc_lib = '/usr/lib64'
      $freetds_conf = '/etc/freetds.conf'
    }
    default: {}
  }

}
