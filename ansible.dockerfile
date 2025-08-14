#FROM python:3.6.8-slim

#RUN sed -i 's/http:\/\/deb.debian.org/\[trusted=yes\] http:\/\/archive.debian.org/g' /etc/apt/sources.list > /dev/null 2> /dev/null
#RUN sed -i 's/http:\/\/security.debian.org/\[trusted=yes\] http:\/\/archive.debian.org/g' /etc/apt/sources.list > /dev/null 2> /dev/null
#RUN sed -i 's/stretch-updates/stretch/g' /etc/apt/sources.list > /dev/null 2> /dev/null
#RUN sed -i 's/main/precise main restricted universe multiverse/g' /etc/apt/sources.list > /dev/null 2> /dev/null
#RUN sed -i '$ d' /etc/apt/sources.list > /dev/null 2> /dev/null

FROM python:3.11.0-slim

RUN apt -y update > /dev/null 2> /dev/null
#RUN apt -y install ansible > /dev/null 2> /dev/null
RUN apt install -y openssh-server procps sshpass sudo systemctl > /dev/null 2> /dev/null
RUN apt clean > /dev/null 2> /dev/null

#RUN ansible --version 

RUN useradd -ms /bin/bash ansible

# Set the root password for the SSH server (CHANGE THIS PASSWORD!)
RUN echo 'ansible:password' | chpasswd
RUN adduser ansible sudo

RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd

RUN ssh-keygen -P "" -C "Ansible KEY" -f /root/.ssh/ansible_id_rsa

COPY init.sh /init.sh
RUN chmod +x /init.sh

#RUN python -m venv ansible
#RUN source ansible/bin/activate
RUN pip install --upgrade pip
RUN pip install ansible==9.13.0

ENTRYPOINT ["/init.sh"]

