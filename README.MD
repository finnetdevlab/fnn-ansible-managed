# Ansible Managed Test Images
<p align="center">
    <img src="https://user-images.githubusercontent.com/20422563/81475903-96cad600-9217-11ea-826c-da9b4f44546a.png" alt="fnn-ansible-test-image" width="200"/>
</p>
This repository contains wide range of docker images with aim to test ansible roles and playbooks against them.

## Managed Nodes
> See [Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#managed-node-requirements) for managed node requirements for ansible.

All distributions contain ssh server, python and an init system. Also every image has a user called __test__ with password: _test_. Both __root__ and __test__ user has an authorized ssh key which is located under [/keys](./keys) folder. Also __test__ user has a generated key.

## Distributions

All distributions located under corresponding folder `images/family/distribution/version`.

- [images](./images)
  - [debian](./images/debian)
    - [debian](./images/debian/debian)
      - [8](./images/debian/debian/8)
      - [9](./images/debian/debian/9)
      - [10](./images/debian/debian/10)
      - [11](./images/debian/debian/11)
    - [ubuntu](./images/debian/ubuntu)
      - [14.04](./images/debian/ubuntu/14.04)
      - [16.04](./images/debian/ubuntu/16.04)
      - [18.04](./images/debian/ubuntu/18.04)
      - [20.04](./images/debian/ubuntu/20.04)
  - [redhat](./images/redhat)
    - [centos](./images/redhat/centos)
      - [6](./images/redhat/centos/6)
      - [7](./images/redhat/centos/7)
      - [8](./images/redhat/centos/8)
    - [fedora](./images/redhat/fedora)
      - [26](./images/redhat/fedora/26)
      - [27](./images/redhat/fedora/27)
      - [28](./images/redhat/fedora/28)
      - [29](./images/redhat/fedora/29)
      - [30](./images/redhat/fedora/30)
      - [31](./images/redhat/fedora/31)
      - [32](./images/redhat/fedora/32)
      - [33](./images/redhat/fedora/33)


## Running Tests

Tests are located under [/tests](./tests) folder.

```
tests/test.sh -f redhat -o centos -v 7 -b
```

- `-f` Distribution family (optional)
- `-o` Distribution OS name (optional)
- `-v` Distribution version (optional)
- `-b` Build image (optional)