# pulsar

master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-pulsar.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-pulsar)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with pulsar](#setup)
    * [What pulsar affects](#what-pulsar-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pulsar](#beginning-with-pulsar)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module Description

This module installs, configures and manages pulsar, an add-on to Galaxy.

For more information on pulsar and the capabilities it provides, please see [https://pulsar.readthedocs.io/en/latest/](https://pulsar.readthedocs.io/en/latest/).

Galaxy is an open web-based platform for accessible, reproducible, and transparent computational biomedical research.

* [Galaxy Project Web Site](https://galaxyproject.org/)
* [Galaxy Documentation](https://galaxyproject.org/docs/)
* [Galaxy Code Repository](https://github.com/galaxyproject/galaxy)

This module uses Puppet 4 data types as well as providing puppet data in the module. It will not work with puppet versions earlier than 4.7, and is currently written to support CentOS/RHEL 7. Other operating systems will be added as time permits.

This module relies on the [stankevich/python](https://forge.puppet.com/stankevich/python) python module for installation of pip, pulsar-app, and other packages. By default, the management of python is disabled in the pulsar module. 

For pulsar to properly install using the git repository as opposed to the pip package, git will need to be managed either with this module (leveraging the puppetlabs/git module) or a different method or module.

For pulsar to properly startup, gcc needs to be present as pulsar installs dependencies into the application directory that require compilation. The gcc installation can be managed with either this module (leveraging the puppetlabs/gcc module) or a different method or module.

By default, the `/etc/supervisor/conf.d/pulsar.conf` file is managed by the pulsar module as it assumes that the millerjl1701/supervisord module is being used. If you are a different module or method for supervisord, the management of this file can be disabled.

## Setup

### What pulsar affects

* Packages (by default) 
    * pulsar-app (via pip)
    * gcc
    * git
    * python-dev
    * python2-pip
    * python-virtualenv.
* Files
    * /etc/supervisor/conf.d/pulsar.conf
    * /opt/pulsar
    * /opt/pulsar/app.yml
    * /opt/pulsar/local_env.sh
    * /opt/pulsar/requirements.txt
    * /opt/pulsar/run.sh
    * /opt/pulsar/server.ini
    * /opt/pulsar/venv
    * /var/log/pulsar
* Services
    * pulsar (as a supervisord program)

### Setup Requirements

This module depends on the following puppet modules:

* [mmckinst-hash2stuff](https://forge.puppet.com/mmckinst/hash2stuff)
* [puppetlabs-gcc](https://forge.puppet.com/puppetlabs/gcc)
* [puppetlabs-git](https://forge.puppet.com/puppetlabs/git)
* [puppetlabs-stdlib](https://forge.puppet.com/puppetlabs/stdlib)
* [puppetlabs-vcsrepo](https://forge.puppet.com/puppetlabs/vcsrepo)
* [stankevich-python](https://forge.puppet.com/stankevich/python)

The [stahnma-epel](https://forge.puppet.com/stahnma/epel) module is listed in the metadata.json file as a dependency as well, since stankevich-python lists it as a dependency. A parameter for this module is provided to disable the use of epel for package installation should you be using yumrepo resources or Spacewalk package management instead.

The supervisord program is expected to be utlilized for the management of the pulsar service. This module does not manage or configuration of the supervisord service. The acceptance tests rely on the millerjl1701/supervisord puppet module for supervisord installation and configuration. If you are using a different method, the supervisord pulsar.conf file management can be disabled.

### Beginning with pulsar

Assuming that the prerequisites are met (supervisord, python and gcc. potentially git), `include pulsar` is all that is needed to install, configure, and start up a pulsar server listening to port localhost:8913.

## Usage

### Installation of pulsar and all needed dependencies with puppet manifest

```puppet
class { 'pulsar':
  manage_gcc    => true,
  manage_git    => true,
  manage_python => true,
}
```

### Installation of pulsar and all needed dependencies using hiera

```yaml
---
pulsar::manage_python: true
pulsar::manage_gcc: true
pulsar::manage_git: true
```

## Reference

Generated puppet strings documentation with examples is available from [https://millerjl1701.github.io/millerjl1701-pulsar](https://millerjl1701.github.io/millerjl1701-pulsar).

The puppet strings documentation is also included in the /docs folder.

### Public Classes

* pulsar: Main class which installs and configures the pulsar service. Parameters may be passed via class declaration or hiera.

### Private Classes

* pulsar::config: Class for generating the configuration files for the pulsar server.
* pulsar::gcc: Class for installing gcc for use by pulsar.
* pulsar::git: Class for installing git for use by pulsar.
* pulsar::install: Class for installing the pulsar server.
* pulsar::python: Class for installing and configuring python for use by pulsar.
* pulsar::service: Class for managing the pulsar service.

## Limitations

This module is currently written for CentOS/RHEL 7 only. Other operating systems will be added as time permits (unless someone submits a PR first. :)

No validation of the server.ini file is performed to check what settings have been added. Passing appropriate parameters and values are left as an exercise for the reader.

## Development

Please see the [CONTRIBUTING document](CONTRIBUTING.md) for information on how to get started developing code and submit a pull request for this module. While written in an opinionated fashion at the start, over time this can become less and less the case.

### Contributors

To see who is involved with this module, see the [GitHub list of contributors](https://github.com/millerjl1701/millerjl1701-pulsar/graphs/contributors) or the [CONTRIBUTORS document](CONTRIBUTORS).

## Credits

Since this module is designed primarily for the management of Galaxy processes, the [Galaxy Project Administration Training repository](https://github.com/galaxyproject/dagobah-training/) was used heavily to guide how pulsar is configured and used in complex environments. The GalaxyProject [ansible galaxy runbooks](https://github.com/galaxyproject/ansible-galaxy) and [use galaxy runbooks](https://github.com/galaxyproject/usegalaxy-playbook/) were also referenced in order to grok the needed pieces installed and configured more efficiently. Thank you to all the instructors and contriibutors past and present who have developed and published these materials.
