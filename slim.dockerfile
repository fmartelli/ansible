FROM python:3.11.13-slim

RUN apt -y update > /dev/null 2> /dev/null
RUN apt install -y openssh-server procps sudo systemctl > /dev/null 2> /dev/null
RUN apt clean > /dev/null 2> /dev/null

RUN useradd -ms /bin/bash ansible

# Set the root password for the SSH server (CHANGE THIS PASSWORD!)
RUN echo 'ansible:password' | chpasswd
RUN adduser ansible sudo

RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/sbin/sshd","-D"]

