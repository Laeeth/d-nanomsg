PROGRAMS=bus pair pubsub reqrep survey pipeline filesend

.PHONY: all clean realclean purge

all: $(PROGRAMS)

$(PROGRAMS): % : %.d
	dmd $< ../bindings/nano.d -L-lnanomsg

filesend.o:	filesend.d
		dmd filesend.d ../bindings/nano.d -L/opt/nanomsg-0.4-beta/.libs/libnanomsg.so
clean:		
	rm -f *.o

realclean purge: clean
	rm -f $(PROGRAMS)
