require 'spec_helper_acceptance'

describe 'pulsar class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      user {  'galaxy':
        ensure => present,
      }
      group { 'galaxy':
        ensure => present,
      }
      class { 'python':
        dev             => present,
        manage_gunicorn => false,
        use_epel        => true,
        virtualenv      => present,
      }
      class { 'supervisord':
        manage_python => false,
      }
      class { 'pulsar':
        manage_gcc => true,
        manage_git => true,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('gcc') do
      it { should be_installed }
    end

    describe package('gcc-c++') do
      it { should be_installed }
    end

    describe package('git') do
      it { should be_installed }
    end

    describe package('python') do
      it { should be_installed }
    end

    describe package('python2-pip') do
      it { should be_installed }
    end

    describe package('python-devel') do
      it { should be_installed }
    end

    describe package('python-gunicorn') do
      it { should_not be_installed }
    end

    describe package('python-virtualenv') do
      it { should be_installed }
    end

    describe yumrepo('epel') do
      it { should exist }
      it { should be_enabled }
    end

    describe file('/opt/pulsar') do
      it { should be_directory }
      it { should be_mode 775 }
    end

    describe file('/opt/pulsar/venv') do
      it { should be_directory }
      it { should be_mode 775 }
    end

    describe file('/opt/pulsar/venv/lib/python2.7/site-packages/pulsar') do
      it { should be_directory }
    end

    describe file('/opt/pulsar/requirements.txt') do
      it { should be_file }
      it { should contain 'pulsar-app' }
    end

    describe file('/opt/pulsar/app.yml') do
      it { should be_file }
      it { should be_mode 664 }
      it { should contain 'staging_directory: /opt/pulsar/files/staging' }
      it { should contain '__default__' }
      it { should contain 'persistence_directory: /opt/pulsar/files/persisted_data' }
      it { should contain 'tool_dependency_dir: /opt/pulsar/dependencies' }
    end

    describe file('/opt/pulsar/local_env.sh') do
      it { should be_file }
      it { should be_mode 664 }
      it { should contain '#export DRMAA_LIBRARY_PATH=/path/to/libdrmaa.so' }
    end

    describe file('/opt/pulsar/run.sh') do
      it { should be_file }
      it { should be_mode 775 }
      it { should contain 'PULSAR_CONFIG_DIR=/opt/pulsar' }
      it { should contain 'PULSAR_LOCAL_ENV=/opt/pulsar/local_env.sh' }
      it { should contain 'PULSAR_VIRTUALENV=/opt/pulsar/venv' }
    end

    describe file('/etc/supervisor/conf.d/pulsar.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should contain '[program:pulsar]' }
    end

    describe process('pulsar') do
      it { should be_running }
    end
  end
end
