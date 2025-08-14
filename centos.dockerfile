FROM centos:8
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
RUN sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
RUN sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Install SSH server
RUN dnf -y update > /dev/null 2> /dev/null
RUN dnf install -y openssh-server python3 procps sudo > /dev/null 2> /dev/null

RUN useradd -ms /bin/bash ansible

# Set the root password for the SSH server (CHANGE THIS PASSWORD!)
RUN echo 'ansible:password' | chpasswd
RUN echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd
RUN rm /run/nologin

RUN ssh-keygen -A

CMD ["/usr/sbin/sshd", "-D"]

