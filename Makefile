CC = gcc
AR = ar rcv
ifeq ($(windir),)
EXE =
RM = rm -f
else
EXE = .exe
RM = del
endif

CFLAGS = -ffunction-sections -O3

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -Wl,-dead_strip
else
    LDFLAGS += -Wl,--gc-sections
endif

all:libmincrypt.a pxa-mkbootimg$(EXE) pxa-unpackbootimg$(EXE) pxa-dtbTool$(EXE)

static:
	make LDFLAGS="$(LDFLAGS) -static"

libmincrypt.a:
	make -C libmincrypt

pxa-mkbootimg$(EXE):mkbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ -L. -lmincrypt $(LDFLAGS) -s

mkbootimg.o:mkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -I. -Werror

pxa-unpackbootimg$(EXE):unpackbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

unpackbootimg.o:unpackbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

pxa-dtbTool$(EXE):dtbtool.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

dtbtool.o:dtbtool.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

clean:
	$(RM) pxa-mkbootimg *.exe *.o pxa-unpackbootimg pxa-dtbTool
	$(RM) libmincrypt.a *.~
	make -C libmincrypt clean

