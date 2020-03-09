# Creating the /hana volume
sudo pvcreate /dev/sdc
sudo pvcreate /dev/sdd
sudo pvcreate /dev/sde
sudo pvcreate /dev/sdf

sudo vgcreate data-vg01 /dev/sdc /dev/sdd /dev/sde /dev/sdf
sudo lvcreate --extents 100%FREE --stripes 4 --name data-lv01 data-vg01
sudo mkfs -t ext4 /dev/data-vg01/data-lv01
sudo mkdir /hana /hana/data /hana/log
# Update fstab
echo "/dev/data-vg01/data-lv01  /hana  ext4  defaults  0  2" | sudo tee -a /etc/fstab

# Creating the /hana/shared volume
sudo parted /dev/sdg --script mklabel gpt mkpart ext4part ext4 0% 100%
partprobe /dev/sdg1

sudo mkdir /hana/shared
# Update fstab
echo "/dev/sdg1 /hana/shared  ext4  defaults  0  2" | sudo tee -a /etc/fstab

# Creating the /usr/sap volume
sudo parted /dev/sdh --script mklabel gpt mkpart ext4part ext4 0% 100%
partprobe /dev/sdh1

sudo mkdir /usr/sap
# Update fstab
echo "/dev/sdh1 /usr/sap  ext4  defaults  0  2" | sudo tee -a /etc/fstab

# Creating the /hana/backup volume

sudo pvcreate /dev/sdi
sudo pvcreate /dev/sdj
sudo pvcreate /dev/sdk

sudo vgcreate backup-vg01 /dev/sdi /dev/sdj /dev/sdk
sudo lvcreate --extents 100%FREE --stripes 3 --name backup-lv01 backup-vg01
sudo mkfs -t ext4 /dev/backup-vg01/backup-lv01
sudo mkdir /hana/backup

echo "/dev/backup-vg01/backup-lv01  /hana/backup  ext4  defaults  0  2" | sudo tee -a /etc/fstab


