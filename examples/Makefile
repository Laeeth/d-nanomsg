PROGRAMS=bus pair pubsub reqrep survey pipeline filesend

.PHONY: all clean realclean purge

all: $(PROGRAMS)

$(PROGRAMS): % : %.d ../source/kaleidic/nanomsg/bindings.d
	$(DC) $< ../source/kaleidic/nanomsg/bindings.d -I../source -L-lnanomsg

clean:		
	rm -f *.o

realclean purge: clean
	rm -f $(PROGRAMS)
