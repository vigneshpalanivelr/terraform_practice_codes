#cloud-config
# /usr/bin/cloud-init init
# curl http://169.254.169.254/latest/user-data
# python2 -c "import crypt, getpass, pwd; print(crypt.crypt('vignesh', '\$6\$saltsalt\$'))"

ssh_groups:
  - ${ssh_group}

sudo_groups:
  - ${sudo_group}

runcmd:
  - systemctl restart sshd
  - systemctl restart sssd
