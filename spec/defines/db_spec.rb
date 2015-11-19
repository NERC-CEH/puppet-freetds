require 'spec_helper'
require 'shared_contexts'

describe 'freetds::db' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  let(:title) { 'XXreplace_meXX' }
  
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
      :host => 'place_value_here',
      #:dsn => $title,
      #:port => undef,
      #:tds_version => undef,
      #:manage_odbc => true,
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_ini_setting('FreeTDS connection to $title database')
      .with(
        'ensure'  => 'present',
        'path'    => '$::osfamily ? { Debian => /etc/freetds/freetds.conf, RedHat => /etc/freetds.conf, default => undef }',
        'section' => '$title',
        'setting' => 'host',
        'value'   => ''
      )
  end
  it do
    is_expected.to contain_ini_setting('ODBC Driver to $title')
      .with(
        'ensure'  => 'present',
        'path'    => '/etc/odbc.ini',
        'section' => '$title',
        'setting' => 'Driver',
        'value'   => 'FreeTDS'
      )
  end
  it do
    is_expected.to contain_ini_setting('ODBC Servername to $title')
      .with(
        'ensure'  => 'present',
        'path'    => '/etc/odbc.ini',
        'section' => '$title',
        'setting' => 'Servername',
        'value'   => '$title'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS port to $title database')
      .with(
        'ensure'  => 'present',
        'path'    => '$::osfamily ? { Debian => /etc/freetds/freetds.conf, RedHat => /etc/freetds.conf, default => undef }',
        'section' => '$title',
        'setting' => 'port',
        'value'   => 'undef'
      )
  end
  it do
    is_expected.to contain_ini_setting('FreeTDS version to $title database')
      .with(
        'ensure'  => 'present',
        'path'    => '$::osfamily ? { Debian => /etc/freetds/freetds.conf, RedHat => /etc/freetds.conf, default => undef }',
        'section' => '$title',
        'setting' => 'tds version',
        'value'   => 'undef'
      )
  end
end
