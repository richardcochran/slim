prep:
	$(Q) true

build:
	$(Q) $(MAKE) $(J) -C $(SRC) CC=$(CROSS_COMPILE)gcc

stage:
	$(Q) true

