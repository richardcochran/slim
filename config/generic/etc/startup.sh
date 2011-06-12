#
# Startup for the SLIM 'generic' board.
#

mount -a

# Set log level to LOG_INFO (debug messages are not logged)
syslogd -C -l 7
