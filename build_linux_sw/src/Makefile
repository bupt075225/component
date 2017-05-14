#
# Common makefile for demo 
#
# Copyright (C) 2016 - 2018 xilingxue <xilingxue.cn>
#

USR_APP_DIR=usr/app_demo
USR_LIB_DIR=usr/lib_demo
KERNEL_MODULE_DIR=kernel

all:
	cd $(USR_APP_DIR) && $(MAKE) $@
	cd $(USR_LIB_DIR) && $(MAKE) $@
	cd $(KERNEL_MODULE_DIR) && $(MAKE) $@

install:
	cd $(USR_APP_DIR) && $(MAKE) $@
	cd $(USR_LIB_DIR) && $(MAKE) $@
	cd $(KERNEL_MODULE_DIR) && $(MAKE) $@

uninstall:
	cd $(USR_APP_DIR) && $(MAKE) $@
	cd $(USR_LIB_DIR) && $(MAKE) $@
	cd $(KERNEL_MODULE_DIR) && $(MAKE) $@

clean:
	cd $(USR_APP_DIR) && $(MAKE) $@
	cd $(USR_LIB_DIR) && $(MAKE) $@
	cd $(KERNEL_MODULE_DIR) && $(MAKE) $@

help:
	@echo "    all(the default) : make all"
	@echo "    clean            : clean files"
	@echo "    install          : install"
	@echo "    uninstall        : uninstall"
