ebs_type        = "gp2"      # Other Types 'standard','io1','sc1','st1'
ebs_iops        = 0
ebs_encrypted   = false

#name = "/dev/sda" : Root Volume
ebs_device_names = [
  {
    name = "/dev/sdb",
    size = "1"
  },
  {
    name = "/dev/sdc",
    size = "1"
  },
  {
    name = "/dev/sdd",
    size = "1"
  },
]
