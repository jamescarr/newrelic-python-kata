##
# Normally this would be a separate manifest / module included
# here but we've opted for simplicity.
##
node newrelic {
  include supervisor
  $newrelic_license_key = '<enter your license key here>'
  Exec {
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }

  class { 'python':
    version    => 'system',
    dev        => true,
    virtualenv => true,
    gunicorn   => true,
  }

  python::virtualenv { '/home/vagrant/newrelic-kata':
    ensure       => present,
    version      => 'system',
    requirements => '/home/vagrant/newrelic-kata/requirements.txt',
    proxy        => 'http://localhost:8000',
    systempkgs   => false,
    distribute   => true,
    require      => Class['python'],
  }

  class { 'newrelic': 
    license => $newrelic_license_key, 
  }

  class { 'newrelic_python': 
    license_key => $newrelic_license_key,
    app_name    => 'New Relic Django Kata',
    require     => Class['newrelic'],
  }

  supervisor::service {'kata':
    ensure      => present,
    enable      => true,
    command     => '/home/vagrant/newrelic-kata/manage.py runserver',
    environment => "NEW_RELIC_CONFIG_FILE='/etc/newrelic/newrelic.ini'",
    user        => 'vagrant',
    group       => 'vagrant',
    require     => [ Class['newrelic_python'], Python::Virtualenv['/home/vagrant/newrelic-kata'] ];
  }
}
