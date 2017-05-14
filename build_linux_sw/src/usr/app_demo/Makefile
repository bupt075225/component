#
# User space application makefile for demo 
#
# Copyright (C) 2016 - 2018 xilingxue <xilingxue.cn>
#

ifndef  PREFIX
  PREFIX=/usr/local
endif

SHELL=/bin/bash

SBINDIR := $(PREFIX)/sbin

CC=gcc

CFLAGS+=-g -Wall
PROGRAMS=demo
LIBS=

SRCS=example.c
OBJS=$(SRCS:.c=.o)

all: $(PROGRAMS)

demo: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

install: all
	@install -vD -m 755 demo $(DESTDIR)$(SBINDIR)/demo

uninstall:
	rm -f $(DESTDIR)$(SBINDIR)/demo

clean:
	rm -f $(PROGRAMS) *.o
