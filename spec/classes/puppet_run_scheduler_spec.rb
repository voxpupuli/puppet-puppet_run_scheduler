require 'spec_helper'

describe 'puppet_run_scheduler' do
  let(:pre_condition) do
    # This mocks the assert_private() function so that private classes may be tested
    'function assert_private() { }'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
