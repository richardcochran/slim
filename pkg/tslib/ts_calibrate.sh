#!/bin/sh
export TSLIB_CONSOLEDEVICE=none
export TSLIB_TSDEVICEFLAGS=RDONLY
export TSLIB_FBDEVICE=/dev/fb0
export TSLIB_TSDEVICE=/dev/input/event0
export TSLIB_CONFFILE=/etc/ts.conf
/usr/bin/ts_calibrate
