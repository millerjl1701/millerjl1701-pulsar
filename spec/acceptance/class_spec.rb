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

    describe package('pulsar') do
      it { should be_installed }
    end

    describe service('pulsar') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
