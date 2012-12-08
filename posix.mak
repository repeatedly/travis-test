# build mode: 32bit or 64bit
ifeq (,$(MODEL))
	MODEL := 64
endif

ifeq (,$(DMD))
	DMD := dmd
endif

LIB     = libtravis.a
DFLAGS  = -Isrc -m$(MODEL) -w -d -property

ifeq ($(BUILD),debug)
	DFLAGS += -g -debug
else
	DFLAGS += -O -release -nofloat -inline
endif

NAMES = travis
FILES = $(addsuffix .d, $(NAMES))
SRCS  = $(addprefix src/, $(FILES))

target: $(LIB)

$(LIB):
	$(DMD) $(DFLAGS) -lib -of$(LIB) $(SRCS)

clean:
	rm $(addprefix $(DOCDIR)/, $(DOCS)) $(LIB)

MAIN_FILE = "empty_travis_unittest.d"

unittest:
	echo 'import travis; void main(){}' > $(MAIN_FILE)
	$(DMD) $(DFLAGS) -unittest -of$(LIB) $(SRCS) -run $(MAIN_FILE)
	rm $(MAIN_FILE)
