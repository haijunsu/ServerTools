#!/bin/bash

#set -x

IMAGE_HOME="/storage/software"



# External F20 mirror
# http://dl.fedoraproject.org/pub/fedora/linux/releases/20/Fedora/x86_64/


# Create a minimal kickstart file and return the temporary file name.
# Do remember to delete this temporary file when it is no longer required.
#
create_ks_file()
{
    dist=$1
    fkstart=$(mktemp -u --tmpdir=$(pwd) .XXXXXXXXXXXXXX)

    cat << EOF > $fkstart
install
text
reboot
lang en_US.UTF-8
keyboard us
network --bootproto dhcp
rootpw testpwd
firewall --enabled --ssh
selinux --enforcing
timezone --utc America/New_York
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200 rd_NO_PLYMOUTH"
zerombr
clearpart --all --initlabel
autopart --type=btrfs

%packages
@core
%end
EOF
    echo "$fkstart"
}

create_centos_guest()
{
    name=$1
    arch=$2
    dist=$3
    locn=$4
    dimg=$5
    fkst=$(create_ks_file $dist)
    bnam=$(basename $fkst)

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
    --network=bridge:virbr0 \
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
    --os-variant $dist \
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
        echo -e "Usage: $0 vm-name distro arch\n"
        echo -e "\tdistro: f19 f20"
        echo -e "\t  arch: i386, x86_64
        e.g. ./`basename $0` f20vm1 f20 x86_64         # create fedora 20 VM
             ./`basename $0` f19vm1 f19 x86_64         # create fedora f19 VM"

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
            ;;


            *)
            echo "$0: invalid distribution name"
            exit 255
    esac
    create_guest $name $arch $dist $locn $dimg

    exit 0
  }
