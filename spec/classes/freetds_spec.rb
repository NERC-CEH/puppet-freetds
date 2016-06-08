require 'spec_helper'

describe 'freetds', :type => :class do   
  context 'when odbc is managed on Debian' do
    let(:params) { {
      :manage_unixodbc => true
    } }
    let(:facts) { {
      :osfamily => 'Debian'
    } }
      
    it { should contain_package('unixodbc') }
    it { should contain_package('unixodbc-dev') }
  end

  context 'when odbc is managed on RedHat' do
    let(:params) { {
      :manage_unixodbc => true
    } }
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_package('unixODBC') }
    it { should contain_package('unixODBC-devel') }
  end

  describe 'when odbc is not managed on Debian' do
    let(:params) { {
      :manage_unixodbc => false
    } }
    let(:facts) { {
      :osfamily => 'Debian'
    } }
      
    it { should_not contain_package('unixodbc') }
    it { should_not contain_package('unixodbc-dev') }
  end

  describe 'when odbc is not managed on RedHat' do
    let(:params) { {
      :manage_unixodbc => false
    } }
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should_not contain_package('unixODBC') }
    it { should_not contain_package('unixODBC-devel') }
  end

  describe 'when freetds version is specified on Debian' do
    let(:params) { {
      :freetds_version => '2'
    } }
    let(:facts) { {
      :osfamily => 'Debian'
    } }
    
    it { should contain_package('freetds-dev').with_ensure('2') }
    it { should contain_package('freetds-bin').with_ensure('2') }
    it { should contain_package('tdsodbc').with_ensure('2') }
  end

  describe 'when freetds version is specified on RedHat' do
    let(:params) { {
      :freetds_version => '2'
    } }
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_package('freetds-devel').with_ensure('2') }
    it { should contain_package('freetds').with_ensure('2') }
  end


  describe 'when applied should manage /etc/odbcinst.ini on Debian' do
    let(:facts) { {
      :osfamily => 'Debian'
    } }

    it { should contain_ini_setting('FreeTDS Description').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Description',
      :value   => 'ODBC for TDB'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Driver').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Driver',
      :value   => '/usr/lib/i386-linux-gnu/odbc/libtdsodbc.so'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Setup').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Setup',
      :value   => '/usr/lib/i386-linux-gnu/odbc/libtdsS.so'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Driver64').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Driver64',
      :value   => '/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Setup64').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Setup64',
      :value   => '/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so'
    ).with_ensure('present')}
  end

  describe 'when applied should manage /etc/odbcinst.ini on RedHat' do
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_ini_setting('FreeTDS Description').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Description',
      :value   => 'ODBC for TDB'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Driver').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Driver',
      :value   => '/usr/lib/libtdsodbc.so'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Setup').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Setup',
      :value   => '/usr/lib/libtdsS.so'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Driver64').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Driver64',
      :value   => '/usr/lib64/libtdsodbc.so'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Setup64').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Setup64',
      :value   => '/usr/lib64/libtdsS.so'
    ).with_ensure('present')}
  end


  describe 'when applied should manage the global port on Debian' do
    let(:params) { {
      :global_port => '1337'
    } }
    let(:facts) { {
      :osfamily => 'Debian'
    } }

    it { should contain_ini_setting('FreeTDS Global Port').with(
      :path    => '/etc/freetds/freetds.conf',
      :section => 'global',
      :setting => 'port',
      :value   => '1337'
     ).with_ensure('present')}
  end

  describe 'when applied should manage the global port on RedHat' do
    let(:params) { {
      :global_port => '1337'
    } }
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_ini_setting('FreeTDS Global Port').with(
      :path    => '/etc/freetds.conf',
      :section => 'global',
      :setting => 'port',
      :value   => '1337'
     ).with_ensure('present')}
  end


  describe 'when applied should mange the global tds version on Debian' do
    let(:params) { {
      :global_tds_version => '18'
    } }
    let(:facts) { {
      :osfamily => 'Debian'
    } }

    it { should contain_ini_setting('FreeTDS Global tds version').with(
      :path    => '/etc/freetds/freetds.conf',
      :section => 'global',
      :setting => 'tds version',
      :value   => '18'
    ).with_ensure('present')}
  end

  describe 'when applied should mange the global tds version on RedHat' do
    let(:params) { {
      :global_tds_version => '18'
    } }
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_ini_setting('FreeTDS Global tds version').with(
      :path    => '/etc/freetds.conf',
      :section => 'global',
      :setting => 'tds version',
      :value   => '18'
    ).with_ensure('present')}
  end


  describe 'the freetds conf should be managed before freetds is installed on Debian' do
    let(:facts) { {
      :osfamily => 'Debian'
    } }

    it { should contain_ini_setting('FreeTDS Global tds version')
                .that_comes_before('Package[freetds-bin]')}
    it { should contain_ini_setting('FreeTDS Global Port')
                .that_comes_before('Package[freetds-bin]')}
  end

  describe 'the freetds conf should be managed before freetds is installed on RedHat' do
    let(:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_ini_setting('FreeTDS Global tds version')
                .that_comes_before('Package[freetds]')}
    it { should contain_ini_setting('FreeTDS Global Port')
                .that_comes_before('Package[freetds]')}
  end
end
