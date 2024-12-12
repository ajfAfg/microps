APPS = app/udpc.exe \
       app/udps.exe \
       app/tcpc.exe \
       app/tcps.exe \

TESTS = test/test.exe \
        test/step0.exe \
        test/step1.exe \
        test/step2.exe \
        test/step3.exe \
        test/step4.exe \
        test/step5.exe \
        test/step6.exe \
        test/step7.exe \
        test/step8.exe \
        test/step9.exe \
        test/step10.exe \
        test/step11.exe \
        test/step12.exe \
        test/step13.exe \
        test/step14.exe \
        test/step15.exe \
        test/step16.exe \
        test/step17.exe \

DRIVERS = driver/null.o \
          driver/loopback.o \
          driver/dummy.o \

OBJS = util.o \
       net.o \
       ether.o \
       arp.o \
       ip.o \
       icmp.o \
       udp.o \
       tcp.o \
       sock.o \
       ether.o \

CFLAGS := $(CFLAGS) -g -W -Wall -Wno-unused-parameter -iquote .

ifeq ($(shell uname),Linux)
       CFLAGS := $(CFLAGS) -pthread -iquote platform/linux
       DRIVERS := $(DRIVERS) platform/linux/driver/ether_tap.o platform/linux/driver/ether_pcap.o
       LDFLAGS := $(LDFLAGS) -lrt
       OBJS := $(OBJS) platform/linux/sched.o platform/linux/intr.o
endif

ifeq ($(shell uname),Darwin)
       CFLAGS := $(CFLAGS)
       DRIVERS := $(DRIVERS)
endif

.SUFFIXES:
.SUFFIXES: .c .o

.PHONY: all clean

all: $(APPS) $(TESTS)

$(APPS): %.exe : %.o $(OBJS) $(DRIVERS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(TESTS): %.exe : %.o $(OBJS) $(DRIVERS) test/test.h
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(APPS) $(APPS:.exe=.o) $(OBJS) $(DRIVERS) $(TESTS) $(TESTS:.exe=.o)
