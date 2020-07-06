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

arg_dockerfile_path = ENV["DOCKERFILE_PATH"]
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
      image = Docker::Image.build_from_dir(".", { "dockerfile" => arg_dockerfile_path })
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
    case $image_tag
    when "centos6"
      cmd = "service --status-all"
    else
      cmd = "systemctl list-units --type=service"
    end

    expect(
      command(cmd).exit_status == 0
    ).to eq true
  end

  it "ssh server should be installed" do
    expect(package("openssh-server")).to be_installed
  end

  it "ssh service should be enabled" do
    def is_sshd_enabled()
      case $image_tag
      when "centos6"
        result = command("chkconfig --list | grep '2:on' | grep 'sshd'").stdout.include?("sshd")
      else
        result = "systemctl list-units --type=service"
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
      else
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
    expect(user("test")).to have_authorized_key("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCncHv8KRD6fC6AOASVyGDm29snayWBGzAMgYPhLcm3qJdp2/yrfVO8oN2ipwkGF2Z4QzD+G+Wgkm+w4XptfhfTuaaw50jP5VMTCO+3n6R9wiFidMOucZhZc+WkbSEbQQR0cnK0a+z3euNctR0NCx0pLEENyg9P0cg7bDnDubKFFrM+/KJTTSo4/0kxJH51Tw+HKkLYqAtWTlwHRjQ4lLW2pNVXi6A+nrvxOHKMLSOR6NLXDRxGZQ6BB5Wuo9pvLxu+nHhbBvhca7LCcYMDoaLx7rVU7l+16ec86oIfJJe1T0w/UTgpKKQ1W7DWIwItvh31nLnVWJIqtrx7HUOu0trgvFSajWnJTjWoaON0qc9oduqQ/LjW1BQVeUgHH0B5zwBL5InYhbqJn4O+U2BFYAeh5KKo+uqAsghqbLmadIlEu8y6EKHqeazWXB6EegRLrdBzIqUWj2m1bn6C00tyqXlTC2a7n7YQFmMcxQ7vJCeyjkhjiS0LRokp9sH82vVcsdM= test-key")
  end

  it "user connect localhost" do
    expect(
      command("ssh -i /home/test/.ssh/id_rsa -oStrictHostKeyChecking=no test@localhost").exit_status == 0
    ).to eq true
  end
end
