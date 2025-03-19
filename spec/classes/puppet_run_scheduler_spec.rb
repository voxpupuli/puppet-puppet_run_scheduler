# frozen_string_literal: true

require 'spec_helper'

describe 'puppet_run_scheduler' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:win_acl_provider) do
        Puppet::Type.type(:acl).provide :windows
      end
      let(:pre_condition) do
        allow(win_acl_provider).to receive(:validate).and_return(true)
      end

      it { is_expected.to compile }
    end
  end
end
