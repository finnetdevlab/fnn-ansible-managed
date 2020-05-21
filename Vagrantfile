$script = <<-SCRIPT
# Install docker
sudo apt -y update;
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -;
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable";
sudo apt -y update;
apt-cache policy docker-ce;
sudo apt -y install docker-ce;
sudo usermod -aG docker vagrant;
sudo apt -y install ruby-full;
sudo gem install rspec serverspec docker-api;
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.hostname = "test"

    config.vm.provision "shell", inline: $script
  
    config.vm.provider :virtualbox do |vb|
      vb.customize [
        "modifyvm", :id,
        "--cpuexecutioncap", "50",
        "--memory", "2048",
      ]
    end
end