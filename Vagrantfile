# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'digest'
DOMAIN = "local.com"
UBUNTU_BOX = "bento/ubuntu-17.10"
DEBIAN_BOX = "sharlak/debian_stretch_64"
CENTOS7_BOX = "belonesox/centos-7-noselinux-vbadd"
#CENTOS7_BOX = "centos/7"

STD_ANSIBLE_GROUPS =  {
            "patroni-testing-cluster" => [],
            "all" => [],
            "all:vars" => [
                "domain =  '#{DOMAIN}'",
                "debug = 1",
                "virtual_ip_for_keepalived: '192.168.5.251'"
            ]
        }

def set_std_ansible_params(ansible)
      ansible.verbose = "vv"
      ansible.groups = STD_ANSIBLE_GROUPS 
#      ansible.raw_ssh_args = ' -o RemoteForward="7999 git.office.custis.ru:7999" '
end
  
def set_network(conf)
    default_host_gw = `ip route show`[/default.*/][/\d+\.\d+\.\d+\.\d+/]

    start_port = (Digest::SHA256.hexdigest conf.vm.hostname)[1..4].to_i(16)+1000
    subip = (Digest::SHA256.hexdigest conf.vm.hostname)[0..1].to_i(16) % 250 + 2
    conf.vm.network "private_network", ip: "192.168.5.#{subip}"

    preferred_interfaces = ['eth0.*', 'eth\d.*', 'enp0s.*', 'enp\ds.*']
    host_interfaces = %x( VBoxManage list bridgedifs | grep ^Name ).gsub(/Name:\s+/, '').split("\n")
    network_interface_to_use = preferred_interfaces.map{ |pi| host_interfaces.find { |vm| vm =~ /#{Regexp.new(pi)}/ } }.compact[0]
    conf.vm.network "public_network", bridge: network_interface_to_use #, adapter: "1"

    python_script_4_routing = <<-PYTHON
#!/usr/bin/env python
import commands

output = commands.getstatusoutput('ip route')
lines = output[1].splitlines()
line_num = min(2, len(lines)-1)
maybedefault = lines[line_num]
terms = maybedefault.split()
first = terms[0]
last = terms[-1]

output = commands.getoutput('ip -o link show')
lastinterface = output.splitlines()[-1].split(':')[1].strip()
if first != 'default' or last != lastinterface:
      print "Fixing routing from %s to %s " % (last, lastinterface)
      scmd = 'ip route add default via #{default_host_gw} dev %s' % lastinterface
      # commands.getstatusoutput('ip route del default')
      commands.getstatusoutput(scmd)

PYTHON

    conf.vm.provision "shell", run: "always", inline: python_script_4_routing
end

def set_std_provision(conf)
    if Vagrant.has_plugin?("vagrant-hosts")
      conf.vm.provision :hosts, :sync_hosts => true    
    end  
    set_network(conf)      
end


Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox" do |conf|
    conf.gui = false
    conf.memory = "2048" 
    conf.cpus = 2
  end


  config.vm.synced_folder '.', '/vagrant', disabled: true

  (1..3).each do |i|
      vmname = "patroni-testing-#{i}"
      STD_ANSIBLE_GROUPS["patroni-testing-cluster"].push(vmname)
      config.vm.define vmname do |conf|
        conf.vm.box = CENTOS7_BOX
        conf.disksize.size = '180GB'
        #pvresize /dev/sda2
        #lvresize -l +100%FREE /dev/centos/root

        #parted -s /dev/sda mkpart primary ext2  85.9GB 193GB
        #parted -s /dev/sda set 3 lvm on
        #pvcreate /dev/sda3
        #vgextend centos /dev/sda3
        #lvextend -l 100%FREE /dev/centos/root
        #xfs_growfs /dev/mapper/centos-root 

        #193274MB
        #parted /dev/sda resizepart 2 193274MB

        config.ssh.username = 'root'
        config.ssh.password = 'vagrant'
        config.ssh.forward_x11 = true
        
        conf.vm.hostname = vmname  + "." + DOMAIN
        set_std_provision(conf)
        conf.vm.provision "ansible" do |ansible|
          set_std_ansible_params(ansible)
          ansible.host_vars = {
              vmname => {
                "db_server_index" => i, 
              }
          }
          ansible.playbook = "db-cluster.yml"
        end
        config.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory", "4096"]
          vb.customize ["modifyvm", :id, "--cpus", "2"]
        end  
      end
    end
end
