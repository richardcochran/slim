prep:
	$(Q) true

build:
	$(Q) $(MAKE) -C $(SRC) CC=$(CROSS_COMPILE)gcc

stage:
	$(Q) true

