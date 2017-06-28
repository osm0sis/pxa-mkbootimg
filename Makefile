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

all:libmincrypt.a pxa-mkbootimg$(EXE) pxa-unpackbootimg$(EXE) pxa1088-dtbTool$(EXE) pxa1908-dtbTool$(EXE)

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

pxa1088-dtbTool$(EXE):pxa1088-dtbtool.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

pxa1088-dtbtool.o:pxa1088-dtbtool.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

pxa1908-dtbTool$(EXE):pxa1908-dtbtool.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

pxa1908-dtbtool.o:pxa1908-dtbtool.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

clean:
	$(RM) pxa-mkbootimg pxa-unpackbootimg pxa1908-dtbTool pxa1088-dtbTool
	$(RM) *.a *.~ *.exe *.o
	make -C libmincrypt clean

