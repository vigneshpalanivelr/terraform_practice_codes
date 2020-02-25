#!/bin/bash
# /usr/bin/cloud-init init
# curl http://169.254.169.254/latest/user-data
# python2 -c "import crypt, getpass, pwd; print(crypt.crypt('vignesh', '\$6\$saltsalt\$'))"

# Create User and Group
# useradd -p "${root_passwd}" ${root_user}
groupadd ${ssh_group} 
useradd --password $(openssl passwd ${root_passwd}) ${root_user}
usermod -g ${ssh_group} ${root_user}

# Add to Sudoers
#Error: echo -e "%${sudo_group} \tALL=(ALL) \tNOPASSWD: ALL" >> /etc/sudoers.d/my-sudoers-config
printf "%%%s \tALL=(ALL) \tNOPASSWD: ALL\n" "${sudo_group}" >> /etc/sudoers.d/my-sudoers-config

# Enable Password Authentication
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config

# Re-Start The services
systemctl restart sshd
systemctl restart sssd
service sshd restart
service sssd restart
