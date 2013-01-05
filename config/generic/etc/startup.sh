#
# Startup for the SLIM 'generic' board.
#

mount -t tmpfs -o size=64k,mode=0755 tmpfs /dev
mkdir /dev/pts
mount -t devpts devpts /dev/pts
mount -t proc proc /proc
mount -t sysfs sysfs /sys
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s

mount -a

# Set log level to LOG_INFO (debug messages are not logged)
syslogd -C -l 7
