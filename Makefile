CC = gcc
AR = ar rcv
ifeq ($(windir),)
EXE =
RM = rm -f
else
EXE = .exe
RM = del
endif

CFLAGS = -ffunction-sections #-O3

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -Wl,-dead_strip
else
    LDFLAGS += -Wl,--gc-sections
endif

all:libmincrypt.a pxa1088-mkbootimg$(EXE) pxa1088-unpackbootimg$(EXE) pxa1088-dtbTool$(EXE)

static:
	make LDFLAGS="$(LDFLAGS) -static"

libmincrypt.a:
	make -C libmincrypt

pxa1088-mkbootimg$(EXE):mkbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ -L. -lmincrypt $(LDFLAGS) -s

mkbootimg.o:mkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -I. -Werror

pxa1088-unpackbootimg$(EXE):unpackbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

unpackbootimg.o:unpackbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

pxa1088-dtbTool$(EXE):dtbtool.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

dtbtool.o:dtbtool.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

clean:
	$(RM) mkbootimg.o pxa1088-mkbootimg pxa1088-mkbootimg.exe unpackbootimg.o pxa1088-unpackbootimg pxa1088-unpackbootimg.exe dtbtool.o pxa1088-dtbTool pxa1088-dtbTool.exe
	$(RM) libmincrypt.a Makefile.~
	make -C libmincrypt clean

