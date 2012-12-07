part sda 1 83 100M
part sda 2 82 2048M
part sda 3 83 +

format /dev/sda1 ext2
format /dev/sda2 swap
format /dev/sda3 ext4

mountfs /dev/sda1 ext2 /boot
mountfs /dev/sda2 swap
mountfs /dev/sda3 ext4 / noatime

if [ "${arch}" == "x86" ]; then
    stage_uri               http://ftp.osuosl.org/pub/funtoo/funtoo-stable/x86-32bit/$(uname -m)/stage3-latest.tar.xz
elif [ "${arch}" == "amd64" ]; then
    stage_uri               http://ftp.osuosl.org/pub/funtoo/funtoo-stable/x86-64bit/generic_64/stage3-latest.tar.xz
fi  
tree_type   snapshot    http://ftp.osuosl.org/pub/funtoo/funtoo-stable/snapshots/portage-latest.tar.xz

# get kernel dotconfig from running kernel
cat /proc/config.gz | gzip -d > /dotconfig
# get rid of Gentoo official firmware .config..
grep -v CONFIG_EXTRA_FIRMWARE /dotconfig > /dotconfig2 ; mv /dotconfig2 /dotconfig
# ..and lzo compression
grep -v LZO /dotconfig > /dotconfig2 ; mv /dotconfig2 /dotconfig

kernel_config_file      /dotconfig
kernel_sources          gentoo-sources
genkernel_opts          --loglevel=5

timezone                UTC
rootpw                  4th
bootloader              grub
keymap	                us # be-latin1 fr
hostname                blue-dream
extra_packages          dhcpcd vixie-cron syslog-ng openssh zsh git vim xorg-server slim awesome rxvt-unicode xmodmap x11-misc/xclip app-text/zathura firefox virtualbox

rcadd			vixie-cron default
rcadd                   syslog-ng  default
rcadd			dhcpcd	   default
rcadd                   sshd       default

#############################################################################
# 1. commented skip runsteps are actually running!                          #
# 2. put your custom code if any in pre_ or post_ functions                 #
#############################################################################

pre_partition() {
	echo "pre_partition"
}
# skip partition
post_partition() {
	echo "post_partition"
}

pre_setup_mdraid() {
	echo "pre_setup_mdraid"
}
# skip setup_mdraid
post_setup_mdraid() {
	echo "post_setup_mdraid"
}

pre_setup_lvm() {
	echo "pre_setup_lvm"
}
# skip setup_lvm
post_setup_lvm() {
	echo "post_setup_lvm"
}

pre_luks_devices() {
	echo "pre_luks_devices"
}
# skip luks_devices
post_luks_devices() {
	echo "post_luks_devices"
}

pre_format_devices() {
	echo "pre_format_devices"
}
# skip format_devices
post_format_devices() {
	echo "post_format_devices"
}

pre_mount_local_partitions() {
	echo "pre_mount_local_partitions"
}
# skip mount_local_partitions
post_mount_local_partitions() {
	echo "post_mount_local_partitions"
}

pre_mount_network_shares() {
	spawn_chroot "echo \"MAKEOPTS=\\"-j5\\"
USE=\\"${USE} dbus nvidia X truetype 256-color xft\\"
INPUT_DEVICES=\\"evdev keyboard mouse\\"
VIDEO_CARDS=\\"nvidia\\"\" >> /etc/portage/make.conf"
	echo "pre_mount_network_shares"
}
# skip mount_network_shares
post_mount_network_shares() {
	echo "post_mount_network_shares"
}

pre_fetch_stage_tarball() {
	echo "pre_fetch_stage_tarball"
}
# skip fetch_stage_tarball
post_fetch_stage_tarball() {
	echo "post_fetch_stage_tarball"
}

pre_unpack_stage_tarball() {
	echo "pre_unpack_stage_tarball"
}
# skip unpack_stage_tarball
post_unpack_stage_tarball() {
	echo "post_unpack_stage_tarball"
}

pre_prepare_chroot() {
	echo "pre_prepare_chroot"
}
# skip prepare_chroot
post_prepare_chroot() { 
	echo "post_prepare_chroot"
}

pre_setup_fstab() {
	echo "pre_setup_fstab"
}
# skip setup_fstab
post_setup_fstab() { 
	echo "post_setup_fstab"
}

pre_fetch_repo_tree() {
	echo "pre_fetch_repo_tree"
}
# skip fetch_repo_tree
post_fetch_repo_tree() {
	echo "post_fetch_repo_tree"
}

pre_unpack_repo_tree() {
	echo "pre_unpack_repo_tree"
}
# skip unpack_repo_tree
post_unpack_repo_tree() {
    echo "unpack_repo_tree"
    # git style Funtoo portage
    spawn_chroot "cd /usr/portage && git checkout funtoo.org" || die "could not checkout funtoo git repo"
}

pre_copy_kernel() {
	echo "pre_copy_kernel"
	spawn_chroot "echo \"sys-kernel/debian-sources symlink\" >> /etc/portage/package.use"
	spawn_chroot "echo \"blacklist nouveau\" >> /etc/modprobe.d/blacklist.conf"
	spawn_chroot "emerge debian-sources"
}
skip copy_kernel
post_copy_kernel() {
	echo "post_copy_kernel"
}

pre_build_kernel() {
	echo "pre_build_kernel"
	spawn_chroot "cd /usr/src/linux && ./config-extract amd64 && genkernel all" || die "could not build debian kernel"
	
}
skip build_kernel
post_build_kernel() {
	echo "post_build_kernel"
}

pre_build_initramfs() {
	echo "pre_build_initramfs"
}
skip build_initramfs
post_build_initramfs() {
	echo "post_build_initramfs"
}

pre_setup_network_post() {
	echo "pre_setup_network_post"
}
# skip setup_network_post
post_setup_network_post() {
	echo "post_setup_network_post"
}

pre_setup_root_password() {
	echo "pre_setup_root_password"
}
# skip setup_root_password
post_setup_root_password() {
	echo "post_setup_root_password"
}

pre_setup_timezone() {
	echo "pre_setup_timezone"
}
# skip setup_timezone
post_setup_timezone() {
	echo "post_setup_timezone"
}

pre_setup_keymap() {
	echo "pre_setup_keymap"
}
# skip setup_keymap
post_setup_keymap() {
	echo "post_setup_keymap"
}

pre_setup_host() {
	echo "pre_setup_host"
}
# skip setup_host
post_setup_host() {
	echo "post_setup_host"
}

pre_install_bootloader() {
	echo "pre_install_bootloader"
}
# skip install_bootloader
post_install_bootloader() {
	echo "post_install_bootloader"
}

pre_configure_bootloader() {
	echo "pre_configure_bootloader"
}
# skip configure_bootloader
post_configure_bootloader() {
	echo "post_configure_bootloader"
}

pre_install_extra_packages() {
	echo "pre_install_extra_packages"
}
# skip install_extra_packages
post_install_extra_packages() {
	echo "post_install_extra_packages"
}

pre_add_and_remove_services() {
	echo "pre_add_and_remove_services"
}
# skip add_and_remove_services
post_add_and_remove_services() {
	echo "post_add_and_remove_services"
	echo "DISPLAYMANAGER=\"slim\"" >> /etc/conf.d/xdm
	rc-update add xdm default
}

pre_run_post_install_script() { 
	echo "pre_run_post_install_script"
}
# skip run_post_install_script
post_run_post_install_script() {
	echo "post_run_post_install_script"
	ADMIN="michael"
	useradd -m -G users,wheel,usb,video,vboxusers -s /bin/zsh $ADMIN
}
