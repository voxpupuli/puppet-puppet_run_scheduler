# frozen_string_literal: true

require 'spec_helper'

describe 'puppet_run_scheduler::posix' do
  let(:pre_condition) do
    # This mocks the assert_private() function so that private classes may be tested
    'include puppet_run_scheduler
    function assert_private() { }'
  end

  test_on = { supported_os: [{ 'operatingsystem' => 'CentOS' },
                             { 'operatingsystem' => 'OracleLinux' },
                             { 'operatingsystem' => 'RedHat' },
                             { 'operatingsystem' => 'Scientific' },
                             { 'operatingsystem' => 'Debian' },
                             { 'operatingsystem' => 'Ubuntu' },
                             { 'operatingsystem' => 'Fedora' },
                             { 'operatingsystem' => 'SLES' },
                             { 'operatingsystem' => 'Solaris' },
                             { 'operatingsystem' => 'Darwin' },] }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      if os_facts[:os]['family'] == 'Darwin'
        it { is_expected.to contain_cron('puppet-run-scheduler').with_environment(['LANG=en_US.UTF-8']) }
      else
        it { is_expected.to contain_cron('puppet-run-scheduler').without_environment }
      end
    end
  end
end
