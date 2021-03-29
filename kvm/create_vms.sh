#!/bin/bash

#set -x

<<<<<<< HEAD
IMAGE_HOME="/home/storage/software"
UBUNTU_ISO="${IMAGE_HOME}/ubuntu-18.04.3-live-server-amd64.iso"
CENTOS_ISO="${IMAGE_HOME}/CentOS-8-x86_64-1905-dvd1.iso"
VM_DISK_HOME="/home/storage/VMs"
=======
IMAGE_HOME="/storage/software"



# External F20 mirror
# http://dl.fedoraproject.org/pub/fedora/linux/releases/20/Fedora/x86_64/

>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8

# Create a minimal kickstart file and return the temporary file name.
# Do remember to delete this temporary file when it is no longer required.
#
<<<<<<< HEAD
# https://computingforgeeks.com/rhel-centos-kickstart-automated-installation-kvm-virt-install/
#
create_centos_ks_file()
{
    VM_NAME=$1
    ROOT_PW=$2
    fkstart=$(mktemp -u --tmpdir=$(pwd) ${VM_NAME}.XXXXXXXXXXXXXX)
=======
create_ks_file()
{
    dist=$1
    fkstart=$(mktemp -u --tmpdir=$(pwd) .XXXXXXXXXXXXXX)

>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8
    cat << EOF > $fkstart
install
text
reboot
lang en_US.UTF-8
keyboard us
network --bootproto dhcp
<<<<<<< HEAD
network  --hostname=${VM_NAME}.cisdd.ads
rootpw ${ROOT_PW}
=======
rootpw testpwd
>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8
firewall --enabled --ssh
selinux --enforcing
timezone --utc America/New_York
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200 rd_NO_PLYMOUTH"
zerombr
clearpart --all --initlabel
<<<<<<< HEAD
autopart --type=lvm

%packages
@core
@base
vim
bash-completion

=======
autopart --type=btrfs

%packages
@core
>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8
%end
EOF
    echo "$fkstart"
}

<<<<<<< HEAD
create_linux_guest()
{
    name=$1
    variant=$2 
    locn=$3
    dimg=$4
    fkst=$5
    bnam=$(basename $fkst)
    echo "fkst: ${bnam}"
=======
create_centos_guest()
{
    name=$1
    arch=$2
    dist=$3
    locn=$4
    dimg=$5
    fkst=$(create_ks_file $dist)
    bnam=$(basename $fkst)
>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8

    echo "Creating domain $name..."
    echo "Disk image will be created at: $dimg"

    # Create the qcow2 disk image with preallocation and 'fallocate'
    # (which pre-allocates all the blocks to a file) it for maximum
    # performance.
    #
    #   fallocate -l `ls -al $diskimage | awk '{print $5}'` $diskimage
    #
    echo "Creating qcow2 disk image..."
    qemu-img create -f qcow2 -o preallocation=metadata $dimg 10G
    echo `ls -lash $dimg`

    virt-install --connect=qemu:///system \
<<<<<<< HEAD
    --network=bridge:virbr1 \
=======
    --network=bridge:virbr0 \
>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8
    --initrd-inject=$bnam \
    --extra-args="ks=file:/$bnam console=tty0 console=ttyS0,115200" \
    --name=$name \
    --disk path=$dimg,format=qcow2,cache=none \
    --ram 2048 \
    --vcpus=2 \
    --check-cpu \
    --accelerate \
    --cpuset auto \
    --os-type linux \
<<<<<<< HEAD
    --os-variant ${variant}\
=======
    --os-variant $dist \
>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8
    --hvm \
    --location=$locn \
    --nographics \
    --console=pty

    rm $fkst
    return 0
}

# main
{
    # check if min no. of arguments are 3
    #
    if [ "$#" != 3 ]; then
<<<<<<< HEAD
        echo -e "Usage: $0 vm-name os-type rootpw\n"
        echo -e "\os-type: ubuntu, centos"
        e.g. ./`basename $0` f20vm1 centos rootpw        # create centos8 20 VM
             ./`basename $0` f19vm1 ubuntu rootpw         # create ubuntu18.04 VM"
=======
        echo -e "Usage: $0 vm-name distro arch\n"
        echo -e "\tdistro: f19 f20"
        echo -e "\t  arch: i386, x86_64
        e.g. ./`basename $0` f20vm1 f20 x86_64         # create fedora 20 VM
             ./`basename $0` f19vm1 f19 x86_64         # create fedora f19 VM"
>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8

        exit 255
    fi

    # check if Linux bridging is configured
    #
    show_bridge=`brctl show | awk 'NR==2 {print $1}'`
    if [ $? -ne 0 ] ; then
        echo "Bridged Networking is not configured. " \
             "please do so if your guest needs an IP similar to your host."
        exit 255
    fi

    name=$1
    dist=$2
<<<<<<< HEAD
    root_pw=$3
    dimg="$VM_DISK_HOME/$name.qcow2"

    locn=""
    case "$dist" in
        ubuntu)
            locn=${UBUNTU_ISO}
            ;;

        centos)
            locn=${CENTOS_ISO}
	    fkst=$(create_centos_ks_file $name $root_pw)
            create_linux_guest $name "rhl8.0" $locn $dimg $fkst
=======
    arch=$3
    dimg="$IMAGE_HOME/$name.qcow2"

    locn=""
    case "$dist" in
        f19)
            dist="fedora19"
            locn=${location1/ARCH/$arch}
            ;;

        f20)
            dist="fedora20"
            locn=${location2/ARCH/$arch}
>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8
            ;;


            *)
<<<<<<< HEAD
            echo "$0: invalid os type name"
            exit 255
    esac
=======
            echo "$0: invalid distribution name"
            exit 255
    esac
    create_guest $name $arch $dist $locn $dimg
>>>>>>> 4c657dbbbc01293b54636561576b432095c835b8

    exit 0
  }
