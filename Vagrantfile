# -*- mode: ruby -*-
# vi: set ft=ruby :

#-------------------------------------------------------------------------------
# Vagrantfile and provisioning scripts adapted and extended from
# Homestead (@author Taylor Otwell, cf. https://github.com/laravel/homestead)
# and Vaprobash (@author Chris Fidao, cf. https://github.com/fideloper/Vaprobash)
#-------------------------------------------------------------------------------

require 'yaml'

settings = YAML::load(File.read(File.dirname(__FILE__) + '/homestead.yml'))

scriptDir = File.dirname(__FILE__) + "/provision/scripts"
aliasesPath = "provision/aliases"
phpIniPath = "provision/php/php-development.ini"

Vagrant.configure(2) do |config|

  # copy bash aliases
  if File.exists? aliasesPath then
      config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"
  end

  # Fix "stdin is not a tty"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Configure The Box
  config.vm.box = settings["box"] ||= "laravel/homestead-7"
  config.vm.box_version = settings["version"] ||= ">=0.2.0"
  config.vm.hostname = settings["hostname"] ||= "homestead.dev"

  # Configure A Private Network IP
  config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

  # Configure A Few VirtualBox Settings
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
    vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
  end

#  config.vm.synced_folder "./apps", "/var/www",
#      :mount_options => ["dmode=777", "fmode=777"]

  # Default Port Forwarding
  default_ports = {
    80   => 8000,
    443  => 44300,
    3306 => 3306,
    5432 => 5432,
    1080 => 1080
  }

  # Use Default Port Forwarding Unless Overridden
  default_ports.each do |guest, host|
    config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
  end

  # Configure The Public Key For SSH Access
  if settings.include? 'authorize'
    if File.exists? File.expand_path(settings["authorize"])
      config.vm.provision "shell" do |s|
        s.inline = "echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
        s.args = [File.read(File.expand_path(settings["authorize"]))]
      end
    end
  end

  # Copy The SSH Private Keys To The Box
  if settings.include? 'keys'
    settings["keys"].each do |key|
      config.vm.provision "shell" do |s|
        s.privileged = false
        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
        s.args = [File.read(File.expand_path(key)), key.split('/').last]
      end
    end
  end


  config.vm.provision "shell",
    inline: "echo '>>> Patience you must have, my young padawan.'"

  # Fix PHP PPA
  config.vm.provision "shell",
    path: scriptDir + "/fix-php-ppa.sh"

  # copy php.ini for Development
  if File.exists? phpIniPath then
      config.vm.provision "file",
      source: phpIniPath,
      destination: "/tmp/php.ini"
  end
  config.vm.provision "shell",
    privileged: true,
    inline: "cp /tmp/php.ini /etc/php/7.1/fpm/php.ini"


  # Install MariaDB
  config.vm.provision "shell",
    path: scriptDir + "/install-maria.sh"

  # Configure All Of The Configured Databases
  if settings.has_key?("databases")
      settings["databases"].each do |db|
        config.vm.provision "shell" do |s|
          s.path = scriptDir + "/create-mysql.sh"
          s.args = [db]
        end
      end
  end

  # Install RabbitMQ
  # config.vm.provision "shell",
  #   path: scriptDir + "/install-rabbitmq.sh",
  #   args: ["user", "password"]

  # Install Mailcatcher
  config.vm.provision "shell",
    path: scriptDir + "/install-mailcatcher.sh"

  # Install Elastic
  config.vm.provision "shell",
    path: scriptDir + "/install-elastic.sh"

  # Install Yarn
  config.vm.provision "shell",
    path: scriptDir + "/install-yarn.sh"

  # Serve Laravel sites with Nginx
  for site in settings["sites"]
    config.vm.provision "shell" do |s|
        s.path = scriptDir + "/serve-laravel.sh"
        s.args = [site["map"], site["to"], site["port"] ||= "80", site["ssl"] ||= "443", site['alias'] ||= "unknown.local"]
      end

      # Configure The Cron Schedule
      if (site.has_key?("schedule"))
        config.vm.provision "shell" do |s|
          if (site["schedule"])
            s.path = scriptDir + "/cron-schedule.sh"
            s.args = [site["map"].tr('^A-Za-z0-9', ''), site["to"]]
          else
            s.inline = "rm -f /etc/cron.d/$1"
            s.args = [site["map"].tr('^A-Za-z0-9', '')]
          end
        end
      end
  end

  # Update Composer On Every Provision
  config.vm.provision "shell" do |s|
    s.inline = "/usr/local/bin/composer self-update"
  end

  def unique_sites(sites)
    sites.collect{|s| s["to"]}.uniq
  end

 # Run composer install & generate key in each app root
 # for site in unique_sites(settings['sites'])
 #     config.vm.provision "shell",
 #       path: scriptDir + "/init-apps.sh",
 #       args: [site],
 #       privileged: false
 # end

  config.vm.provision :shell,
    :privileged => false,
    :path => scriptDir + "/start-services.sh",
    :run => "always"

  config.vm.provision "shell",
    inline: "echo '>>> Powerful you have become, the dark side I sense in you!'"

end
