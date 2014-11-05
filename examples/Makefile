PROGRAMS=bus pair pubsub reqrep survey pipeline filesend

.PHONY: all clean realclean purge

all: $(PROGRAMS)

$(PROGRAMS): % : %.d
	dmd $< ../bindings/nano.d -L-lnanomsg

clean:		
	rm -f *.o

realclean purge: clean
	rm -f $(PROGRAMS)
