require 'spec_helper_acceptance'

describe 'pulsar class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'pulsar': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
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

    #describe service('pulsar') do
    #  it { should be_enabled }
    #  it { should be_running }
    #end
  end
end
