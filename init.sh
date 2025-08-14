#!/bin/bash

set -e

sshpass -p password ssh-copy-id -o "StrictHostKeyChecking accept-new" -i /root/.ssh/ansible_id_rsa.pub ansible@ansible_syncope_1
sshpass -p password ssh-copy-id -o "StrictHostKeyChecking accept-new" -i /root/.ssh/ansible_id_rsa.pub ansible@ansible_syncope_2
sshpass -p password ssh-copy-id -o "StrictHostKeyChecking accept-new" -i /root/.ssh/ansible_id_rsa.pub ansible@ansible_elk_1
sshpass -p password ssh-copy-id -o "StrictHostKeyChecking accept-new" -i /root/.ssh/ansible_id_rsa.pub ansible@ansible_elk_2
sshpass -p password ssh-copy-id -o "StrictHostKeyChecking accept-new" -i /root/.ssh/ansible_id_rsa.pub ansible@ansible_test_1

systemctl enable ssh
systemctl restart ssh

sshpass -p password ssh-copy-id -o "StrictHostKeyChecking accept-new" -i /root/.ssh/ansible_id_rsa.pub ansible@ansible

tail -F /dev/null

