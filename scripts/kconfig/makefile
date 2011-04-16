DEFINES = -DCURSES_LOC="<ncurses.h>" -DLOCALE

CFLAGS = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 $(DEFINES)

LXDIALOG_OBJ = lxdialog/checklist.o lxdialog/inputbox.o	lxdialog/menubox.o \
lxdialog/textbox.o lxdialog/util.o lxdialog/yesno.o

all:

conf: conf.o zconf.tab.o

mconf: mconf.o zconf.tab.o $(LXDIALOG_OBJ) -lncurses

zconf.tab.o: zconf.tab.c

zconf.tab.c: zconf.tab.c_shipped
	cp zconf.tab.c_shipped zconf.tab.c
	cp lex.zconf.c_shipped lex.zconf.c
	cp zconf.hash.c_shipped zconf.hash.c

clean:
	rm -f zconf.tab.c lex.zconf.c zconf.hash.c
	rm -f conf.o mconf.o zconf.tab.o $(LXDIALOG_OBJ)

distclean: clean
	rm -f conf mconf
