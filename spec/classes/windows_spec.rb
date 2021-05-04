require 'spec_helper'

describe 'puppet_run_scheduler::windows' do
  let(:pre_condition) do
    # This mocks the assert_private() function so that private classes may be tested
    'function assert_private() { }'
  end

  test_on = {supported_os: [{'operatingsystem' => 'windows'}]}

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
