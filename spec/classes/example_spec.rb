require 'spec_helper'

describe 'pulsar' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "pulsar class without any parameters changed from defaults" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('pulsar::params') }
          it { is_expected.to contain_class('pulsar::install') }
          it { is_expected.to contain_class('pulsar::config') }
          it { is_expected.to contain_class('pulsar::service') }
          it { is_expected.to contain_class('pulsar::install').that_comes_before('Class[pulsar::config]') }
          it { is_expected.to contain_class('pulsar::service').that_subscribes_to('Class[pulsar::config]') }

          it { is_expected.to contain_class('epel') }
          it { is_expected.to contain_yumrepo('epel') }

          it { is_expected.to contain_class('python').with(
            'dev'             => 'present',
            'manage_gunicorn' => false,
            'use_epel'        => true,
            'virtualenv'      => 'present',
          ) }

          #it { is_expected.to contain_service('pulsar').with(
          #  'ensure'     => 'running',
          #  'enable'     => 'true',
          #  'hasstatus'  => 'true',
          #  'hasrestart' => 'true',
          #) }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'pulsar class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('pulsar') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
