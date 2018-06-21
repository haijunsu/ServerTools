#!/bin/bash
echo "`whoami` ALL=(ALL) NOPASSWD: ALL" > `whoami` 
chmod 440 `whoami`
sudo chown root:root `whoami`
sudo mv `whoami` /etc/sudoers.d/
