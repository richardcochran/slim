#
# Startup for the SLIM 'garm64' board.
#

# Work around multilib compilers.
export LD_LIBRARY_PATH=/lib:/usr/lib
echo export LD_LIBRARY_PATH=/lib:/usr/lib > /etc/profile

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

# Start a shell on the kernel's console device
console=`cat /proc/cmdline | awk -Fconsole= '{print $2}' | awk -F" " '{ print $1 }' | awk -F, '{ print $1 }'`
if [ -z "$console" ]; then
	echo "Console device missing from kernel command line."
else
	echo "Picked console device $console from kernel command line."
	sed -i -e 's/#vanishing#//g' -e "s/@CONSOLE@/$console/g" /etc/inittab
	init -q
fi
