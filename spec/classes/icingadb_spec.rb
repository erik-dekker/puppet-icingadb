# frozen_string_literal: true

require 'spec_helper'

describe 'icingadb' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:params) { {:db_password => 'supersecret'} }

        it { should contain_package('icingadb') }
        it { should_not contain_class('icinga::repos') }
        it { should contain_file('/etc/icingadb/config.yml').with('owner' => 'icingadb', 'group' => 'icingadb', 'mode' => '0640') }
        it { should contain_service('icingadb').with('ensure' => 'running', 'enable' => true) }
      end

      context 'with ensure => stopped, enable => false, manage_repo => true, manage_package => false' do
        let(:params) {{
          :db_password    => 'supersecret',
          :ensure         => 'stopped',
          :enable         => false,
          :manage_repo    => true,
          :manage_package => false
        }}

        it { should contain_class('icinga::repos') }
        it { should_not contain_package('icingadb') }
        it { should contain_service('icingadb').with('ensure' => 'stopped', 'enable' => false) }
      end

      context 'with redis_host => redis.example.com, redis_port => 4711, redis_password => secretsuper' do
        let(:params) {{
          :db_password    => 'secretsuper',
          :redis_host     => 'redis.example.com',
          :redis_port     => 4711,
          :redis_password => 'secretsuper'
        }}

        it { should contain_file('/etc/icingadb/config.yml').with_content(/host: redis.example.com/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/port: 4711/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/password: secretsuper/) }
      end

      context 'with db_type => mysql, import_db_schema => true'  do
        let(:params) {{
          :db_password      => 'supersecret',
          :db_type          => 'mysql',
          :import_db_schema => true
        }}

        it { should contain_exec('icingadb-mysql-import-schema').with('command' => "mysql -u icingadb -p'supersecret' icingadb < \"/usr/share/icingadb/schema/mysql/mysql.schema.sql\"") }
      end

      context 'with db_type => mysql, db_host => mysql.example.com, db_port => 4711, db_name => foo, db_username => bar, db_max_open_conns => 42, import_db_schema => true'  do
        let(:params) {{
          :db_password       => 'supersecret',
          :db_type           => 'mysql',
          :db_host           => 'mysql.example.com',
          :db_port           => 4711,
          :db_name           => 'foo',
          :db_username       => 'bar',
          :db_max_open_conns => 42,
          :import_db_schema  => true
        }}

        it { should contain_exec('icingadb-mysql-import-schema').with('command' => "mysql -h mysql.example.com -P 4711 -u bar -p'supersecret' foo < \"/usr/share/icingadb/schema/mysql/mysql.schema.sql\"") }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/type: mysql/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/host: mysql.example.com/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/port: 4711/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/database: foo/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/user: bar/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/password: supersecret/) }
      end

      context 'with logging_level => debug, logging_output => console, logging_options => { redis => debug, retention => error }' do
        let(:params) {{
          :db_password     => 'secretsuper',
          :logging_level   => 'debug',
          :logging_output  => 'console',
          :logging_options => { :redis => 'debug', :retention => 'error' },
        }}

        it { should contain_file('/etc/icingadb/config.yml').with_content(/level: debug/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/output: console/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/redis: debug/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/retention: error/) }
      end

      context 'with history_days => 365, sla_days => 365, retention_options => { downtime => 10, state => 30 }' do
        let(:params) {{
          :db_password       => 'secretsuper',
          :history_days      => 365,
          :sla_days          => 365,
          :retention_options => { :downtime => 10, :state => 30}
        }}

        it { should contain_file('/etc/icingadb/config.yml').with_content(/history\-days: 365/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/sla\-days: 365/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/downtime: 10/) }
        it { should contain_file('/etc/icingadb/config.yml').with_content(/state: 30/) }
      end

      context 'with db_type => pgsql, import_db_schema => true'  do
        let(:params) {{
          :db_password      => 'supersecret',
          :db_type          => 'pgsql',
          :import_db_schema => true
        }}

        it { is_expected.to compile.and_raise_error(/is not supported/) }
      end

    end
  end
end
