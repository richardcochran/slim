# depend.mk
#
# This file contains the ugly details needed to make the SLIM build work.
# You need to include this file in your package makefile. However, you
# don't need to understand it.

QQ ?= @
OUTPUT ?= /dev/null

#
# Generate dependencies between the packages.
#

depend:
	$(QQ) printf "%s: " $(stamp)/pkg.$(pkg).prep    >  $(OUTPUT)
	$(QQ) for d in $(PREP_DEPEND); do \
		printf "\\\\\n\t%s " $(stamp)/pkg.$$d   >> $(OUTPUT) ; \
	done
	$(QQ) printf "\n"                               >> $(OUTPUT)
	$(QQ) printf "%s: " $(stamp)/pkg.$(pkg).build   >> $(OUTPUT)
	$(QQ) for d in $(BUILD_DEPEND); do \
		printf "\\\\\n\t%s " $(stamp)/pkg.$$d   >> $(OUTPUT) ; \
	done
	$(QQ) printf "\n" >> $(OUTPUT)
	$(QQ) printf "%s: " $(stamp)/pkg.$(pkg).install >> $(OUTPUT)
	$(QQ) for d in $(INSTALL_DEPEND); do \
		printf "\\\\\n\t%s " $(stamp)/pkg.$$d   >> $(OUTPUT) ; \
	done
	$(QQ) printf "\n"                               >> $(OUTPUT)

#
# Generate a manifest and comply with the source licenses.
#

VER     ?= NA
GET     ?= NA
URL     ?= NA
LICENSE ?= unknown

ifeq ($(LICFILE),)
LICFILE  = unknown
endif

TGZ     ?= unknown

ifeq ($(GET),git)
sha1sum = $(shell gunzip -c $(dld)/$(TGZ) | git get-tar-commit-id)
else
sha1sum = "-"
endif

linkage:
ifneq ($(strip $(BINARIES)),)
	$(QQ) echo $(PKG) $(LICENSE) BINARIES $(BINARIES) >>$(OUTPUT)
	$(QQ) $(needed) $(BINARIES) >>$(OUTPUT)
endif
ifneq ($(strip $(PROVIDES)),)
	$(QQ) echo $(PKG) $(LICENSE) PROVIDES $(PROVIDES) >>$(OUTPUT)
endif

liclist:
ifneq ($(GET),NOOP)
	$(QQ) $(catlic) -d $(redist) -f $(LICFILE) -l $(liclist) -p $(pkg)
endif

manifest:
ifneq ($(GET),NOOP)
	$(QQ) printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
	$(pkg) $(VER) $(GET) $(URL) $(LICENSE) $(LICFILE) $(sha1sum) > $(OUTPUT)
	$(QQ) mkdir -p $(redist)
	$(QQ) $(comply) \
		-d $(redist) -f $(LICFILE) -p $(pkg) -s $(dld)/$(TGZ) -t $(LICENSE)
endif

#
# Rewrite the git packages, replacing any 'treeish' object with the sha1 sum.
#

baseline:
ifeq ($(GET),git)
	$(QQ) echo "   BASELINE" $(pkg)
	$(QQ) $(gitbase) -v sha1sum=$(sha1sum) makefile > makefile.tmp
	$(QQ) mv makefile.tmp makefile
endif

#
# Generate a list of the git packages.
#

gitdev:
ifeq ($(GET),git)
	$(QQ) echo DIRS += $(pkg)
endif

#
# Generate a Kconfig.
#

CATEGORY    ?= "main"
DESCRIPTION ?= "Sorry, no description for this item."
PROMPT      ?= $(pkg)

kc_output = $(OUTPUT).$(CATEGORY)
kc_select = $(PREP_DEPEND) $(BUILD_DEPEND) $(INSTALL_DEPEND)

Kconfig:
	$(QQ) printf "config %s\n" $(pkg)                >> $(kc_output)
	$(QQ) printf "\tprompt \"%s\"\n" "$(PROMPT)"     >> $(kc_output)
	$(QQ) printf "\tdefault n\n"                     >> $(kc_output)
	$(QQ) printf "\tbool\n"                          >> $(kc_output)
ifneq ($(strip $(kc_select)),)
	$(QQ) for s in $(kc_select); do \
		dep=`echo $$s | cut -f1 -d. -` ; \
		printf "\tselect $$dep\n"                >> $(kc_output); \
	done
endif
	$(QQ) printf "\thelp\n"                          >> $(kc_output)
	$(QQ) printf "\t $(DESCRIPTION)\n" | fmt -c -    >> $(kc_output)
	$(QQ) printf "\n"                                >> $(kc_output)
