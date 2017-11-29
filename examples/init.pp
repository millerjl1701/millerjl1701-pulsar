node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'pulsar':
    require => Notify['enduser-before'],
    before  => Notify['enduser-after'],
  }

}
