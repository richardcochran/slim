install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC) && cp $(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
#	$(Q) $(start) -n 800 -f template.init

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) @DISTCLEAN@

include depend.mk
