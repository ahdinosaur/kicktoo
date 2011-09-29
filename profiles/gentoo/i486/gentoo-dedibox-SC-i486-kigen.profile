part sda 1 83 100M
part sda 2 82 4096M
part sda 3 83 +

format /dev/sda1 ext2
format /dev/sda2 swap
format /dev/sda3 ext4

mountfs /dev/sda1 ext2 /boot
mountfs /dev/sda2 swap
mountfs /dev/sda3 ext4 / noatime

# retrieve latest autobuild stage version for stage_uri
wget -q http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i486.txt -O /tmp/stage3.version
latest_stage_version=$(cat /tmp/stage3.version | grep tar.bz2)

stage_uri               http://distfiles.gentoo.org/releases/x86/autobuilds/${latest_stage_version}
tree_type     snapshot  http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2
#tree_type               sync

# compile kernel from sources using the right .config
kernel_config_file      $(pwd)/kconfig/dedibox-SC-x86-kernel.config
kernel_sources          gentoo-sources
kernel_builder          kigen
kigen_kernel_opts       --nocolor --localyesconfig
kigen_initramfs_opts    --nocolor

timezone                UTC
rootpw                  a
bootloader              grub
keymap                  fr
hostname                gentoo
extra_packages          openssh # dhcpcd syslog-ng vim

rcadd                   network     default
rcadd                   sshd       default
#rcadd                   syslog-ng  default

# MUST HAVE
post_install_extra_packages() {
    cat >> ${chroot_dir}/etc/conf.d/network <<EOF
ifconfig_eth0="88.xxx.xxx.xxx netmask 255.255.255.0 brd 88.xxx.xxx.255"
defaultroute="gw 88.xxx.xxx.1"
EOF
}

pre_build_kernel() {
    spawn_chroot "echo PORTDIR_OVERLAY=\"/usr/local/portage\" >> /etc/make.conf" 
    spawn_chroot "mkdir -p /usr/local/portage/sys-kernel/kigen"
    spawn_chroot "wget -q https://github.com/downloads/r1k0/kigen/kigen-0.4.2.ebuild -O /usr/local/portage/sys-kernel/kigen/kigen-0.4.2.ebuild"
    spawn_chroot "ebuild /usr/local/portage/sys-kernel/kigen/kigen-0.4.2.ebuild digest"
    spawn_chroot "mkdir -p /etc/portage"
    spawn_chroot "echo \>=sys-kernel/kigen-0.4.2 ~x86 >> /etc/portage/package.accept_keywords"
}
