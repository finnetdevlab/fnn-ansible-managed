#!/bin/bash
#
# Docker Engine starts containers with the default shell. After first execution
# every other opereration runs in a subshell and they do not source environment
# variables. This scritps ensures that environment variable sources are executed
# before every command.
#
# WARNING: It is not a good practice. Use only for testing.
#

function update_env() {
    env_file_paths[0]=/etc/environment
    env_file_paths[1]=/etc/profile
    env_file_paths[2]=/etc/bashrc
    env_file_paths[3]=/etc/bash.bashrc
    env_file_paths[4]=~/.bash_profile
    env_file_paths[5]=~/.bashrc
    env_file_paths[6]=~/.profile
    env_file_paths[7]=~/.cshrc
    env_file_paths[7]=~/.zshrc
    env_file_paths[7]=~/.tcshrc

    for file in $env_file_paths; do
        source $file &> /dev/null
    done

    for file in /etc/env.d/*.sh; do
        source $file &> /dev/null
    done

    for file in /etc/profile.d/*.sh; do
        source $file &> /dev/null
    done
}

trap update_env DEBUG