# env.sh
#
# Sets the environment for working with SLIM comfortably.
# First, set the BOARD variable, then source this file.
# For example:
#
# export BOARD=p2020rdb
#
# . scripts/env.sh
#

case $BOARD in
	generic)
		CROSS_COMPILE=
		;;
	beaglebone)
		CROSS_COMPILE=arm-linux-gnueabihf-
		;;
	imx35pdk)
		CROSS_COMPILE=arm-none-linux-gnueabi-
		;;
	lite5200)
		CROSS_COMPILE=powerpc-linux-gnu-
		;;
	m5234bcc)
		export SKIP_STRIP=y
		CROSS_COMPILE=m68k-uclinux-
		;;
	mpc8313erdb)
		CROSS_COMPILE=powerpc-e300c3-linux-gnu-
		;;
	mpc8572ds|p2020ds|p2020rdb)
		CROSS_COMPILE=powerpc-none-linux-gnuspe-
		;;
	nslu)
		CROSS_COMPILE=armeb-unknown-linux-gnueabi-
		;;
	*)
		CROSS_COMPILE=
		;;
esac

append()
{
	echo $PATH | grep -q $1
	if [ $? -eq 0 ]; then
		return
	fi
	if [ -d $1 ]; then
		PATH=$PATH:$1
	fi
}

# Crosstool compiler for arm ixp4xx
append /opt/x-tools/armeb-unknown-linux-gnueabi/bin
# Freescale M5234BCC
append /opt/x-tools/freescale-coldfire-2011.09/bin
# Freescale i.MX35
append /opt/freescale/usr/local/gcc-4.1.2-glibc-2.5-nptl-3/arm-none-linux-gnueabi/bin
# Freescale lite5200
append /opt/freescale/usr/local/gcc-4.5.55-eglibc-2.11.55/powerpc-linux-gnu/bin
# Freescale mpc8313
append /opt/freescale/usr/local/gcc-4.1.78-eglibc-2.5.78-1/powerpc-e300c3-linux-gnu/bin
# Freescale p2020
append /opt/freescale/usr/local/gcc-4.3.74-eglibc-2.8.74-dp-2/powerpc-none-linux-gnuspe/bin
# Code Sourcery arm
append /opt/x-tools/arm-2011.09-70/bin
# Linaro arm
append /opt/x-tools/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux/bin

export BOARD
export CROSS_COMPILE
export PATH

PS1="slim_${BOARD}> "
