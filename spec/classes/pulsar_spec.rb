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

          it { is_expected.to contain_class('pulsar::gcc') }
          it { is_expected.to contain_class('pulsar::git') }
          it { is_expected.to contain_class('pulsar::python') }
          it { is_expected.to contain_class('pulsar::install') }
          it { is_expected.to contain_class('pulsar::config') }
          it { is_expected.to contain_class('pulsar::service') }
          it { is_expected.to contain_class('pulsar::gcc').that_comes_before('Class[pulsar::git]') }
          it { is_expected.to contain_class('pulsar::git').that_comes_before('Class[pulsar::python]') }
          it { is_expected.to contain_class('pulsar::python').that_comes_before('Class[pulsar::install]') }
          it { is_expected.to contain_class('pulsar::install').that_comes_before('Class[pulsar::config]') }
          it { is_expected.to contain_class('pulsar::service').that_subscribes_to('Class[pulsar::config]') }

          it { is_expected.to contain_class('epel') }
          it { is_expected.to contain_yumrepo('epel') }

          it { is_expected.to contain_package('gcc') }
          it { is_expected.to contain_package('gcc-c++') }

          it { is_expected.to contain_package('git') }

          it { is_expected.to contain_class('python').with(
            'dev'             => 'present',
            'manage_gunicorn' => false,
            'use_epel'        => true,
            'virtualenv'      => 'present',
          ) }

          it { is_expected.to contain_file('/opt/pulsar').with(
            'ensure' => 'directory',
            'owner'  => 'galaxy',
            'group'  => 'galaxy',
            'mode'   => '0775',
          ) }

          it { is_expected.to contain_python__virtualenv('/opt/pulsar/venv').with(
            'ensure'  => 'present',
            'owner'   => 'galaxy',
            'group'   => 'galaxy',
            'mode'    => '0775',
            'require' => 'File[/opt/pulsar]',
          ) }

          it { is_expected.to contain_file('/opt/pulsar/requirements.txt').with(
            'ensure'  => 'present',
            'owner'   => 'galaxy',
            'group'   => 'galaxy',
            'mode'    => '0664',
            'require' => 'File[/opt/pulsar]',
          ) }
          it { is_expected.to contain_file('/opt/pulsar/requirements.txt').with_content(/^pulsar-app$/) }
          it { is_expected.to contain_python__requirements('pulsar_pip_requirements').with(
            'requirements'           => '/opt/pulsar/requirements.txt',
            'virtualenv'             => '/opt/pulsar/venv',
            'owner'                  => 'galaxy',
            'group'                  => 'galaxy',
            'cwd'                    => '/opt/pulsar',
            'manage_requirements'    => 'false',
            'fix_requirements_owner' => 'true',
            'log_dir'                => '/opt/pulsar',
            'require'                => 'File[/opt/pulsar/requirements.txt]',
          ) }

          #it { is_expected.to contain_service('pulsar').with(
          #  'ensure'     => 'running',
          #  'enable'     => 'true',
          #  'hasstatus'  => 'true',
          #  'hasrestart' => 'true',
          #) }
        end

        context 'pulsar class with pulsar_pip_install set to false' do
          let(:params){
            {
              :pulsar_pip_install => false,
            }
          }

          it { is_expected.to contain_vcsrepo('/opt/pulsar').with(
            'ensure'   => 'present',
            'provider' => 'git',
            'source'   => 'https://github.com/galaxyproject/pulsar',
            'revision' => 'master',
            'user'     => 'galaxy',
            'owner'    => 'galaxy',
            'group'    => 'galaxy',
          ) }
          it { is_expected.to contain_python__virtualenv('/opt/pulsar/.venv').with(
            'ensure'  => 'present',
            'require' => 'Vcsrepo[/opt/pulsar]',
          ) }
          it { is_expected.to contain_python__requirements('pulsar_pip_requirements').with(
            'virtualenv'             => '/opt/pulsar/.venv',
          ) }
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
