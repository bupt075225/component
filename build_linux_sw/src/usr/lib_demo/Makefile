#
# User space shared library makefile for demo 
#
# Copyright (C) 2016 - 2018 xilingxue <xilingxue.cn>
#

ifndef  PREFIX
  PREFIX=/usr/local
endif

SHELL=/bin/bash

LIBDIR := $(PREFIX)/lib

# C compiler
CC=gcc

# C flags
CFLAGS += -g -Wall -fPIC

# linking flags
LDFLAGS += -shared

# target lib
TARGET_LIB = libfoo.so
LIBS=

# source files
SRCS=foo.c
OBJS=$(SRCS:.c=.o)

all: ${TARGET_LIB}

libfoo.so: $(SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

install: all
	@install -vD -m 755 libfoo.so $(DESTDIR)$(LIBDIR)/libfoo.so

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/libfoo.so

clean:
	rm -f ${TARGET_LIB} ${OBJS}
