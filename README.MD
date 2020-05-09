# Ansible Managed Test Images
<p align="center">
    <img src="https://user-images.githubusercontent.com/20422563/81475903-96cad600-9217-11ea-826c-da9b4f44546a.png" alt="fnn-ansible-test-image" width="200"/>
</p>
This repository contains wide range of docker images with aim to test ansible roles and playbooks againt them. Docker images are build with intension to run single application on minimum requirements. But with ansible you can handle more than one application, deamon processes and much more.

In order to test ansible role and playbooks on different os environments you can use fnn-ansible-managed. Diffrent os and versions are kept in different branches in order to enable dockerhub builds and ci/di pipelines apart from each other.

## Managed Node Requirements
> See [Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#managed-node-requirements) for managed node requirements for ansible.

- Ansible Managed Node Requirements
  - ssh
  - python
- Deamon Process Requirements
  - init system
