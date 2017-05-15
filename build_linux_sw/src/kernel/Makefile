#
# Kernel module makefile for demo 
#
# Copyright (C) 2017 - 2018 xilingxue <xilingxue.cn>
#

SHELL=/bin/bash

KVER := $(shell uname -r)
KDIR := /lib/modules/$(KVER)/build

obj-m += module_demo.o

ifeq ($(INSTALL_MOD_PATH),)
  export INSTALL_MOD_PATH := $(DESTDIR)
endif

INSTALL_DIR := $(INSTALL_MOD_PATH)/lib/modules/$(KVER)/extra

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

install: all
	install -vD -m 644 module_demo.ko $(INSTALL_DIR)/module_demo.ko

uninstall:
	rm -f $(INSTALL_DIR)/module_demo.ko

clean:
	make -C $(KDIR) M=$(PWD) clean
