
Vagrant.configure("2") do |config|
  config.vm.box = "windev"
  config.vm.guest = :windows
  
  config.vm.hostname = "windev"

  config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
  config.vm.network :forwarded_port, guest: 22, host: 32022, id: "ssh", auto_correct: true
  config.vm.network :forwarded_port, guest: 5985, host: 55986, id: "winrm", auto_correct: true
  config.vm.network :forwarded_port, guest: 5901, host: 5901, id: "vnc1", auto_correct: true
  config.vm.network :forwarded_port, guest: 5900, host: 5900, id: "vnc2", auto_correct: true
 
  config.vm.communicator = "winrm"
  config.winrm.ssl_peer_verification = false
  config.winrm.transport = :plaintext
  config.winrm.basic_auth_only = true
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  config.vm.boot_timeout = 7200
  config.winrm.timeout = 7200
  config.winrm.retry_delay = 20
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = ENV['CPU']
    libvirt.memory = ENV['RAM']
    libvirt.graphics_ip = "0.0.0.0"
    libvirt.nested = true
    libvirt.usb_controller :model => "qemu-xhci"
    libvirt.usb :product => '0xa022', :vendor => '0x076b'
  end
  config.vm.provider :virtualbox do |vb|
    vb.cpus = 2
    vb.memory = 8192
    vb.customize ["modifyvm", :id, "--vrde", "on"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--vrdeaddress", "10.0.250.10"]
    vb.customize ["modifyvm", :id, "--vram", "12"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    vb.customize ["modifyvm", :id, "--nic1", "nat"]
    vb.customize ["modifyvm", :id, "--acpi", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--longmode", "on"]
    vb.customize ["usbfilter", 'add', '0', '--target', :id, '--name', 'SmartCard', '--vendorid', '0x076b', '--productid', '0xa022']
  end
end
