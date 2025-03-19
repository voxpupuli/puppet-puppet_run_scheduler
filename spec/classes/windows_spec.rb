# frozen_string_literal: true

require 'spec_helper'

describe 'puppet_run_scheduler::windows' do
  test_on = { supported_os: [{ 'operatingsystem' => 'windows' }] }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:win_acl_provider) do
        Puppet::Type.type(:acl).provide :windows
      end
      let(:pre_condition) do
        allow(win_acl_provider).to receive(:validate).and_return(true)
        # This mocks the assert_private() function so that private classes may be tested
        'include puppet_run_scheduler
        function assert_private() { }'
      end

      it { is_expected.to compile }
    end
  end
end
