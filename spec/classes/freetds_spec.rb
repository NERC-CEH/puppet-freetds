require 'spec_helper'
require 'shared_contexts'

describe 'freetds' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  
  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:manage_unixodbc => true,
      #:unixodbc_version => installed,
      #:freetds_version => installed,
      #:global_tds_version => "7.0",
      #:global_port => 1433,
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_package('$::osfamily ? { Debian => [freetds-dev, freetds-bin, tdsodbc], RedHat => [freetds, freetds-devel], default => undef }')
      .with(
        'ensure' => 'installed'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS Description')
      .with(
        'path'    => '/etc/odbcinst.ini',
        'section' => 'FreeTDS',
        'setting' => 'Description',
        'value'   => 'ODBC for TDB'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS Driver')
      .with(
        'path'    => '/etc/odbcinst.ini',
        'section' => 'FreeTDS',
        'setting' => 'Driver',
        'value'   => '$::osfamily ? { Debian => /usr/lib/i386-linux-gnu/odbc, RedHat => /usr/lib, default => undef }/libtdsodbc.so'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS Setup')
      .with(
        'path'    => '/etc/odbcinst.ini',
        'section' => 'FreeTDS',
        'setting' => 'Setup',
        'value'   => '$::osfamily ? { Debian => /usr/lib/i386-linux-gnu/odbc, RedHat => /usr/lib, default => undef }/libtdsS.so'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS Driver64')
      .with(
        'path'    => '/etc/odbcinst.ini',
        'section' => 'FreeTDS',
        'setting' => 'Driver64',
        'value'   => '$::osfamily ? { Debian => /usr/lib/x86_64-linux-gnu/odbc, RedHat => /usr/lib64, default => undef }/libtdsodbc.so'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS Setup64')
      .with(
        'path'    => '/etc/odbcinst.ini',
        'section' => 'FreeTDS',
        'setting' => 'Setup64',
        'value'   => '$::osfamily ? { Debian => /usr/lib/x86_64-linux-gnu/odbc, RedHat => /usr/lib64, default => undef }/libtdsS.so'
      )
  end
  it do
    is_expected.to contain_file('/etc/freetds')
      .with(
        'ensure' => 'directory'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS Global Port')
      .with(
        'before'  => 'Package[$tds_packages]',
        'path'    => '$::osfamily ? { Debian => /etc/freetds/freetds.conf, RedHat => /etc/freetds.conf, default => undef }',
        'section' => 'global',
        'setting' => 'port',
        'value'   => '1433'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS Global tds version')
      .with(
        'before'  => 'Package[$tds_packages]',
        'path'    => '$::osfamily ? { Debian => /etc/freetds/freetds.conf, RedHat => /etc/freetds.conf, default => undef }',
        'section' => 'global',
        'setting' => 'tds version',
        'value'   => '7.0'
      )
  end
  it do
    is_expected.to contain_package('$::osfamily ? { Debian => [unixodbc, unixodbc-dev], RedHat => [unixODBC, unixODBC-devel], default => undef }')
      .with(
        'ensure' => 'installed'
      )
  end
end
