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

          it { is_expected.to contain_file('/opt/pulsar').with(
            'ensure' => 'directory',
            'owner'  => 'galaxy',
            'group'  => 'galaxy',
            'mode'   => '0775',
          ) }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with(
            'ensure' => 'present',
            'owner'  => 'galaxy',
            'group'  => 'galaxy',
            'mode'   => '0664',
          ) }
          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^staging_directory: \/opt\/pulsar\/files\/staging$/) }
          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^managers:\n  __default__:$/) }
          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^#job_directory_mode: 0777$/) }
          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^#private_token: changemeinproduction$/) }
          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^persistence_directory: \/opt\/pulsar\/files\/persisted_data$/) }
          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^#assign_ids: uuid$/) }
          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^tool_dependency_dir: \/opt\/pulsar\/dependencies$/) }
          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^#file_cache_dir: cache$/) }

          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with(
            'ensure' => 'present',
            'owner'  => 'galaxy',
            'group'  => 'galaxy',
            'mode'   => '0664',
          ) }
          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^#export DRMAA_LIBRARY_PATH=\/path\/to\/libdrmaa.so$/) }
          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^#export GALAXY_HOME=\/path\/to\/galaxy$/) }
          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^#export GALAXY_VIRTUAL_ENV=\/path\/to\/galaxy\/.venv$/) }
          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^#export TEST_GALAXY_LIBS=1$/) }
          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^# . .venv\/bin\/activate$/) }

          it { is_expected.to contain_file('/opt/pulsar/run.sh').with(
            'ensure' => 'present',
            'owner'  => 'galaxy',
            'group'  => 'galaxy',
            'mode'   => '0775',
          ) }
          it { is_expected.to contain_file('/opt/pulsar/run.sh').with_content(/^PULSAR_CONFIG_DIR=\/opt\/pulsar$/) }
          it { is_expected.to contain_file('/opt/pulsar/run.sh').with_content(/^PULSAR_LOCAL_ENV=\/opt\/pulsar\/local_env.sh$/) }
          it { is_expected.to contain_file('/opt/pulsar/run.sh').with_content(/^PULSAR_VIRTUALENV=\/opt\/pulsar\/venv$/) }

          it { is_expected.to contain_file('/opt/pulsar/server.ini').with(
            'ensure' => 'present',
            'owner'  => 'galaxy',
            'group'  => 'galaxy',
            'mode'   => '0664',
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

        context 'pulsar class with manage_gcc set to false' do
          let(:params){
            {
              :manage_gcc => false,
            }
          }

          it { is_expected.to_not contain_package('gcc') }
          it { is_expected.to_not contain_package('gcc-c++') }
        end

        context 'pulsar class with manage_git set to false' do
          let(:params){
            {
              :manage_git => false,
            }
          }

          it { is_expected.to_not contain_package('git') }
        end

        context 'pulsar class with manage_python set to false' do
          let(:params){
            {
              :manage_python => false,
            }
          }

          it { is_expected.to contain_class('python') }
        end

        context 'pulsar class with manage_python_dev set to absent' do
          let(:params){
            {
              :manage_python_dev => 'absent',
            }
          }

          it { is_expected.to contain_class('python').with_dev('absent') }
        end

        context 'pulsar class with manage_python_use_epel set to false' do
          let(:params){
            {
              :manage_python_use_epel => false,
            }
          }

          it { is_expected.to contain_class('python').with_use_epel('false') }
        end

        context 'pulsar class with manage_python_virtualenv set to absent' do
          let(:params){
            {
              :manage_python_virtualenv => 'absent',
            }
          }

          it { is_expected.to contain_class('python').with_virtualenv('absent') }
        end

        context 'pulsar class with pulsar_config_dir set to /etc/pulsar' do
          let(:params){
            {
              :pulsar_config_dir => '/etc/pulsar',
            }
          }

          it { is_expected.to contain_file('/etc/pulsar/app.yml') }
          it { is_expected.to contain_file('/etc/pulsar/local_env.sh') }
          it { is_expected.to contain_file('/etc/pulsar/run.sh') }
          it { is_expected.to contain_file('/etc/pulsar/server.ini') }
          it { is_expected.to contain_file('/etc/pulsar/run.sh').with_content(/^PULSAR_CONFIG_DIR=\/etc\/pulsar$/) }
          it { is_expected.to contain_file('/etc/pulsar/run.sh').with_content(/^PULSAR_LOCAL_ENV=\/etc\/pulsar\/local_env.sh$/) }
        end

        context 'pulsar class with pulsar_dir set to /opt/foo' do
          let(:params){
            {
              :pulsar_dir => '/opt/foo',
            }
          }

          it { is_expected.to contain_file('/opt/foo').with_ensure('directory') }
          it { is_expected.to contain_python__virtualenv('/opt/foo/venv').with(
            'ensure'  => 'present',
            'require' => 'File[/opt/foo]',
          ) }
          it { is_expected.to contain_file('/opt/foo/requirements.txt').with(
            'ensure'  => 'present',
            'require' => 'File[/opt/foo]',
          ) }
          it { is_expected.to contain_python__requirements('pulsar_pip_requirements').with(
            'requirements' => '/opt/foo/requirements.txt',
            'virtualenv'   => '/opt/foo/venv',
            'cwd'          => '/opt/foo',
            'log_dir'      => '/opt/foo',
            'require'      => 'File[/opt/foo/requirements.txt]',
          ) }
        end

        context 'pulsar class with pulsar_dirmode set to 0755' do
          let(:params){
            {
              :pulsar_dirmode => '0755',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar').with_mode('0755') }
          it { is_expected.to contain_file('/opt/pulsar/run.sh').with_mode('0755') }
          it { is_expected.to contain_python__virtualenv('/opt/pulsar/venv').with_mode('0755') }
        end

        context 'pulsar class with pulsar_drmaa_path set to /opt/drmaa' do
          let(:params){
            {
              :pulsar_drmaa_path => '/opt/drmaa',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^export DRMAA_LIBRARY_PATH=\/opt\/drmaa$/) }
        end

        context 'pulsar class with pulsar_filemode set to 0644' do
          let(:params){
            {
              :pulsar_filemode => '0644',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_mode('0644') }
          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_mode('0644') }
          it { is_expected.to contain_file('/opt/pulsar/requirements.txt').with_mode('0644') }
          it { is_expected.to contain_file('/opt/pulsar/server.ini').with_mode('0644') }
        end

        context 'pulsar class with pulsar_file_cache_dir set to /opt/pulsar/cache' do
          let(:params){
            {
              :pulsar_file_cache_dir => '/opt/pulsar/cache',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^file_cache_dir: \/opt\/pulsar\/cache$/)  }
        end

        context 'pulsar class with pulsar_galaxy_path set to /opt/galaxy' do
          let(:params){
            {
              :pulsar_galaxy_path => '/opt/galaxy',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^export GALAXY_HOME=\/opt\/galaxy$/) }
        end

        context 'pulsar class with pulsar_galaxy_venv_path set to /opt/galaxy' do
          let(:params){
            {
              :pulsar_galaxy_venv_path => '/opt/galaxy/venv',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^export GALAXY_VIRTUAL_ENV=\/opt\/galaxy\/venv$/) }
        end

        context 'pulsar class with pulsar_galaxy_verify set to true' do
          let(:params){
            {
              :pulsar_galaxy_verify => true,
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^export TEST_GALAXY_LIBS=1$/) }
        end

        context 'pulsar class with pulsar_git_repository set to https://example.com/galaxy/pulsar when pulsar_pip_install is also set to false' do
          let(:params){
            {
              :pulsar_git_repository => 'https://example.com/galaxy/pulsar',
              :pulsar_pip_install    => false,
            }
          }

          it { is_expected.to contain_vcsrepo('/opt/pulsar').with_source('https://example.com/galaxy/pulsar') }
        end

        context 'pulsar class with pulsar_git_revision set to devel when pulsar_pip_install is also set to false' do
          let(:params){
            {
              :pulsar_git_revision => 'devel',
              :pulsar_pip_install    => false,
            }
          }

          it { is_expected.to contain_vcsrepo('/opt/pulsar').with_revision('devel') }
        end

        context 'pulsar class with pulsar_group set to pulsar' do
          let(:params){
            {
              :pulsar_group => 'pulsar',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar').with_group('pulsar') }
          it { is_expected.to contain_file('/opt/pulsar/requirements.txt').with_group('pulsar') }
          it { is_expected.to contain_python__requirements('pulsar_pip_requirements').with_group('pulsar') }
        end

        context 'pulsar class with pulsar_group set to pulsar in addition to pulsar_pip_install set to false' do
          let(:params){
            {
              :pulsar_group       => 'pulsar',
              :pulsar_pip_install => false,
            }
          }

          it { is_expected.to contain_vcsrepo('/opt/pulsar').with_group('pulsar') }
        end

        context 'pulsar class with pulsar_job_directory_mode set to 0755' do
          let(:params){
            {
              :pulsar_job_directory_mode => '0755',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^job_directory_mode: 0755$/) }
        end

        context 'pulsar class with pulsar_job_run_as_user set to true' do
          let(:params){
            {
              :pulsar_job_run_as_user => true,
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^. venv\/bin\/activate$/) }
        end

        context 'pulsar class with pulsar_job_run_as_user set to true and pulsar_pip_install set to false' do
          let(:params){
            {
              :pulsar_job_run_as_user => true,
              :pulsar_pip_install     => false,
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/local_env.sh').with_content(/^. .venv\/bin\/activate$/) }
        end

        context 'pulsar class with pulsar_named_managers set to hash' do
          let(:params){
            {
              :pulsar_named_managers => { 'foo' => { 'type' => 'bar', 'jobs' => '2', } },
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^managers:\n  foo:\n    type: bar\n    jobs: 2$/) }
        end

        context 'pulsar class with pulsar_owner set to pulsar' do
          let(:params){
            {
              :pulsar_owner => 'pulsar',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar').with_owner('pulsar') }
          it { is_expected.to contain_file('/opt/pulsar/requirements.txt').with_owner('pulsar') }
          it { is_expected.to contain_python__requirements('pulsar_pip_requirements').with_owner('pulsar') }
        end

        context 'pulsar class with pulsar_owner set to pulsar in addition to pulsar_pip_install set to false' do
          let(:params){
            {
              :pulsar_owner => 'pulsar',
              :pulsar_pip_install    => false,
            }
          }

          it { is_expected.to contain_vcsrepo('/opt/pulsar').with(
            'user'  => 'pulsar',
            'owner' => 'pulsar',
          ) }
        end

        context 'pulsar class with pulsar_persistence_dir set to /opt/pulsar/persist' do
          let(:params){
            {
              :pulsar_persistence_dir => '/opt/pulsar/persist',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^persistence_directory: \/opt\/pulsar\/persist$/) }
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
          it { is_expected.to contain_file('/opt/pulsar/requirements.txt').with(
            'ensure'  => 'present',
            'require' => 'Vcsrepo[/opt/pulsar]',
          ) }
          it { is_expected.to contain_python__requirements('pulsar_pip_requirements').with(
            'virtualenv'             => '/opt/pulsar/.venv',
          ) }
          it { is_expected.to contain_file('/opt/pulsar/run.sh').with_content(/^PULSAR_VIRTUALENV=\/opt\/pulsar\/.venv$/) }
        end

        context 'pulsar class with pulsar_private_token set' do
          let(:params){
            {
              :pulsar_private_token => 'onewillneverknow',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^private_token: onewillneverknow$/) }
        end

        context 'pulsar class with pulsar_requirements to include drmaa' do
          let(:params){
            {
              :pulsar_requirements => [ 'pulsar-app', 'drmaa', ],
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/requirements.txt').with_content(/^pulsar-app$/) }
          it { is_expected.to contain_file('/opt/pulsar/requirements.txt').with_content(/^drmaa$/) }
        end

        context 'pulsar class with pulsar_staging_dir set to /opt/pulsar/staged' do
          let(:params){
            {
              :pulsar_staging_dir => '/opt/pulsar/staged',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^staging_directory: \/opt\/pulsar\/staged$/) }
        end

        context 'pulsar class with pulsar_tool_dependency_dir set to /opt/pulsar/deps' do
          let(:params){
            {
              :pulsar_tool_dependency_dir => '/opt/pulsar/deps',
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^tool_dependency_dir: \/opt\/pulsar\/deps$/) }
        end

        context 'pulsar class with pulsar_use_uuids set to true' do
          let(:params){
            {
              :pulsar_use_uuids => true,
            }
          }

          it { is_expected.to contain_file('/opt/pulsar/app.yml').with_content(/^assign_ids: uuid$/) }
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
