# driver = ENV['DRIVER'] || "KVM"

qemudriver = ENV['DRIVER'] || "kvm"
nested = ENV['NESTED'] || true
cpus = ENV['CPU'] || 2
memory = ENV['RAM'] || 4096
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

  config.vm.boot_timeout = 14400
  config.winrm.timeout = 14400
  config.winrm.retry_delay = 20
  config.winrm.max_tries = 1000
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = qemudriver
    libvirt.nested = nested
    libvirt.cpus = cpus
    libvirt.memory = memory
    libvirt.graphics_ip = "0.0.0.0"
  end
end
