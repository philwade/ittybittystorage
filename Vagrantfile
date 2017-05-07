# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # base box
  config.vm.box = "ubuntu/trusty64"

  # provisioning script
  config.vm.provision :shell, :path => "bootstrap.sh"

  # ssh forwarding
  config.ssh.forward_agent = true

  # port forwarding
  config.vm.network :forwarded_port, guest: 4000, host: 8080

  # allocate system CPUs and RAM
  config.vm.provider :virtualbox do |vb|
    host = RbConfig::CONFIG['host_os']

    # give VM access to all cpu cores on host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
    elsif host =~ /linux/
      cpus = `nproc`.to_i
    else
      cpus = 2
    end

    mem = 1024
    vb.customize ["modifyvm", :id, "--memory", mem]
    vb.customize ["modifyvm", :id, "--cpus", cpus]
		vb.name = "ittybitty"
  end

	# restart services on up
	config.trigger.after [:up], :stdout => true do
		system('vagrant ssh -c "sudo service postgresql restart"')
	end

  # enable port forwarding on up, reload & provision
  config.trigger.after [:up, :reload, :provision], :stdout => true do
    system('echo "
    rdr pass inet proto tcp from any to any port 80 -> 127.0.0.1 port 8080
    " | sudo pfctl -ef - >/dev/null 2>&1; echo "Add Port Forwarding (80 => 8080)"')
  end

  # disable port forwarding on halt & destroy
  config.trigger.after [:halt, :destroy], :stdout => true do
    system("sudo pfctl -f /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding'")
  end

end
