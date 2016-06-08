require 'spec_helper'

describe 'freetds::db', :type => :define do
  let(:pre_condition) { 'include freetds' }
  let(:title) { 'test-db' }

  describe 'when applied, dsn should be created on Debian' do
    let(:params) { { :host => 'myhost' } }
    let(:facts) { {
      :osfamily => 'Debian'
    } }

    it { should contain_ini_setting('FreeTDS connection to test-db database').with(
      :path    => '/etc/freetds/freetds.conf',
      :section => 'test-db',
      :setting => 'host',
      :value   => 'myhost'
    ).with_ensure('present')}
  end

  describe 'when applied, dsn should be created on RedHat' do
    let(:params) { { :host => 'myhost' } }
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_ini_setting('FreeTDS connection to test-db database').with(
      :path    => '/etc/freetds.conf',
      :section => 'test-db',
      :setting => 'host',
      :value   => 'myhost'
    ).with_ensure('present')}
  end


  describe 'when odbc is managed on Debian' do
    let(:params) { { 
      :manage_odbc => true,
      :host        => 'myhost'
    } }
    let(:facts) { {
      :osfamily => 'Debian'
    } }

    it { should contain_ini_setting('ODBC Driver to test-db').with(
      :path    => '/etc/odbc.ini',
      :section => 'test-db',
      :setting => 'Driver',
      :value   => 'FreeTDS'
    ).with_ensure('present')}

    it { should contain_ini_setting('ODBC Servername to test-db').with(
      :path    => '/etc/odbc.ini',
      :section => 'test-db',
      :setting => 'Servername',
      :value   => 'test-db'
    ).with_ensure('present')}
  end

  describe 'when odbc is managed on RedHat' do
    let(:params) { {
      :manage_odbc => true,
      :host        => 'myhost'
    } }
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_ini_setting('ODBC Driver to test-db').with(
      :path    => '/etc/odbc.ini',
      :section => 'test-db',
      :setting => 'Driver',
      :value   => 'FreeTDS'
    ).with_ensure('present')}

    it { should contain_ini_setting('ODBC Servername to test-db').with(
      :path    => '/etc/odbc.ini',
      :section => 'test-db',
      :setting => 'Servername',
      :value   => 'test-db'
    ).with_ensure('present')}
  end


  describe 'when odbc is not managed on Debian' do
    let(:params) { {
      :manage_odbc => false,
      :host        => 'host'
    } }
    let(:facts) { {
      :osfamily => 'Debian'
    } }

    it { should_not contain_ini_setting('ODBC Driver to test-db') }
    it { should_not contain_ini_setting('ODBC Servername to test-db') }
  end

  describe 'when odbc is not managed on RedHat' do
    let(:params) { {
      :manage_odbc => false,
      :host        => 'host'
    } }
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should_not contain_ini_setting('ODBC Driver to test-db') }
    it { should_not contain_ini_setting('ODBC Servername to test-db') }
  end
end
