require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

ENV['PUPPET_INSTALL_TYPE'] || ENV['PUPPET_INSTALL_TYPE'] = 'agent'
ENV['PUPPET_INSTALL_VERSION'] || ENV['PUPPET_INSTALL_VERSION'] = '1.10.9'


run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'pulsar')
    hosts.each do |host|
      on host, puppet('module', 'install', 'mmckinst-hash2stuff'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'millerjl1701-supervisord'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-gcc'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-git'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-vcsrepo'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'stahnma-epel'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'stankevich-python'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
