require "serverspec"
require "docker-api"

# Used to specify serverspec backend driver options
arg_os_family = ENV["OS_FAMILY"]
if arg_os_family.nil?
  raise "os family not defined"
end

# Used to define image tag
arg_os_name = ENV["OS_NAME"]
if arg_os_name.nil?
  raise "os name not defined"
end

# Used to define image tag
arg_os_version = ENV["OS_VERSION"]
if arg_os_version.nil?
  raise "os version not defined"
end

$arg_dockerfile_path = ENV["DOCKERFILE_PATH"]
arg_build_image = ENV["BUILD"]

$image_name = "fnn-ansible-managed"
$image_tag = "#{arg_os_name}#{arg_os_version}"

def try_until(func, expect, times)
  tries = 0
  result = func.call()
  while !result && tries < times
    sleep(5)
    result = func.call()
    tries += 1
  end

  expect(result).to eq expect
end

describe "test #{arg_os_name} #{arg_os_version}" do
  before(:all) do
    if not arg_build_image.nil?
      puts "docker build -t #{$image_name}:#{$image_tag} -f #{$arg_dockerfile_path} ."
      image = Docker::Image.build_from_dir(".", { "dockerfile" => $arg_dockerfile_path })
      image.tag("repo" => $image_name, "tag" => $image_tag, force: true)
    end

    puts "docker run --name #{$image_name}-#{$image_tag} -it --rm --security-opt seccomp=unconfined --stop-signal=SIGRTMIN+3 --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro #{$image_name}:#{$image_tag}"
    @container = Docker::Container.create(
      "Image" => "#{$image_name}:#{$image_tag}",
      "Volumes": {
        "/run": {},
        "/sys/fs/cgroup": {},
        "/tmp": {},
      },
      "Mounts": [
        {
          "Type": "bind",
          "Source": "/sys/fs/cgroup",
          "Destination": "/sys/fs/cgroup",
          "Mode": "ro",
          "RW": false,
          "Propagation": "rprivate",
        },
      ],
      "HostConfig": {
        "Binds": [
          "/sys/fs/cgroup:/sys/fs/cgroup:ro",
        ],
        "Privileged": false,
        "SecurityOpt": [
          "seccomp=unconfined",
        ],
        "Tmpfs": {
          "/run": "",
          "/run/lock": "",
        },
      },
      "StopSignal": "SIGRTMIN+3",
    ).start

    set :os, family: arg_os_family
    set :backend, :docker
    set :docker_container, @container.id
  end

  after(:all) do
    @container.delete(:force => true)
  end

  it "init system should be running" do
    def is_init_running()
      case $image_tag
      when "centos6"
        cmd = "service --status-all"
      when "centos7", "centos8", "fedora26", "fedora27", "fedora28", "fedora29", "fedora30", "fedora31", "fedora32"
        cmd = "systemctl list-units --type=service"
      end

      return command(cmd).exit_status == 0
    end

    try_until(method(:is_init_running), true, 5)
  end

  it "ssh server should be installed" do
    expect(package("openssh-server")).to be_installed
  end

  it "ssh service should be enabled" do
    def is_sshd_enabled()
      case $image_tag
      when "centos6"
        result = command("chkconfig --list | grep '2:on' | grep 'sshd'").stdout.include?("sshd")
      when "centos7", "centos8", "fedora26", "fedora27", "fedora28", "fedora29", "fedora30", "fedora31", "fedora32"
        result = command("systemctl list-unit-files | grep enabled | grep 'sshd'").stdout.include?("sshd")
      end
      return result
    end

    try_until(method(:is_sshd_enabled), true, 10)
  end

  it "ssh service should be running" do
    def is_sshd_running()
      case $image_tag
      when "centos6"
        result = command("service sshd status").stdout.include?("running")
      when "centos7", "centos8", "fedora26", "fedora27", "fedora28", "fedora29", "fedora30", "fedora31", "fedora32"
        result = command("systemctl list-units --type=service --state=running | grep 'sshd.service'").stdout.include?("sshd.service")
      end
      return result
    end

    try_until(method(:is_sshd_running), true, 5)
  end

  it "python should be installed" do
    expect(
      command("python --version").exit_status == 0 ||
      command("python3 --version").exit_status == 0
    ).to eq true
  end

  it "user test should exists" do
    expect(user("test")).to exist
    expect(user("test")).to have_home_directory("/home/test")
  end

  it "user test should belong to sudo group" do
    expect(user("test")).to belong_to_group ["wheel", "sudo"]
  end

  it "user test should have authorized key" do
    expect(user("test")).to have_authorized_key("ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8zMijQ5/u5N/0u3XqrJI3bdl7m1jX9VCBLpRFo+PQDaDmN8KGG3KKQVvV/UkD6DTT6IDsWnJy9+Jj2dfMBT8LZLzGiZh9i+yTMgnKEXhPSLTCiay6raIn+TYvGzCIweepTgiGTQ/vm4XyXZ3BnazRV3e+eOINV/fsPmeyU0kt67JjF0d8s4ihxu7NQOE1+APi3ApHHgFLkqNo4oYDuPIKUOnSLyyWtfvAXt73vLjAgVPABoadCqR3VBUHXHEnploBBzeBtqNyN2FRfa6a1ew4k54ok/oNXpMnhqzs/YNLR3+uev+oHfm4EGbvEIAnE/+XqMhnj+sG/NhsgSN8I400w== test-key")
  end

  it "root should connect localhost using default key" do
    def can_connect_itself()
      return command("ssh -i /config/keys/id_rsa -oStrictHostKeyChecking=no root@localhost").exit_status == 0
    end

    try_until(method(:can_connect_itself), true, 5)
  end

  it "user should connect localhost using default key" do
    def can_connect_itself()
      return command("ssh -i /config/keys/id_rsa -oStrictHostKeyChecking=no test@localhost").exit_status == 0
    end

    try_until(method(:can_connect_itself), true, 5)
  end

  it "user should connect localhost using self generated key" do
    def can_connect_itself()
      return command("ssh -i /home/test/.ssh/id_rsa -oStrictHostKeyChecking=no test@localhost").exit_status == 0
    end

    try_until(method(:can_connect_itself), true, 5)
  end
end
