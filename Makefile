PREFIX ?= /opt/install

BINARY_DIR ?= $(PREFIX)/bin
LIB_DIR ?= $(PREFIX)/lib/docker-multipass

ifndef SUDO_USER
DOCKER_MULTIPASS_INSTALL_USER = $(USER)
else
DOCKER_MULTIPASS_INSTALL_USER = $(SUDO_USER)
endif

.PHONY: uninstall install purge

install: uninstall docker-multipass-config docker-multipass \
	lib/docker-multipass/create \
	lib/docker-multipass/purge lib/docker-multipass/bootstrap-in-vm.sh \
	lib/docker-multipass/unattended.conf \
	lib/docker-multipass/background-foreground \
	lib/docker-multipass/start \
	lib/docker-multipass/stop
	install -d $(BINARY_DIR)
	install -d $(LIB_DIR)
	install $(CURDIR)/docker-multipass $(BINARY_DIR)/docker-multipass
	sed -i '' 's#readonly prefix="`dirname $$0`"#readonly prefix="$(PREFIX)"#g' $(BINARY_DIR)/docker-multipass
	install $(CURDIR)/lib/docker-multipass/purge $(LIB_DIR)/purge
	install $(CURDIR)/lib/docker-multipass/create $(LIB_DIR)/create
	install $(CURDIR)/lib/docker-multipass/bootstrap-in-vm.sh $(LIB_DIR)/bootstrap-in-vm.sh
	install $(CURDIR)/lib/docker-multipass/unattended.conf $(LIB_DIR)/unattended.conf
	install $(CURDIR)/lib/docker-multipass/background-foreground $(LIB_DIR)/background-foreground
	ln -s $(LIB_DIR)/background-foreground $(LIB_DIR)/background
	ln -s $(LIB_DIR)/background-foreground $(LIB_DIR)/foreground
	install $(CURDIR)/lib/docker-multipass/stop $(LIB_DIR)/stop
	install $(CURDIR)/lib/docker-multipass/start $(LIB_DIR)/start
	[ -f "$(HOME)/.docker-multipass-conf" ] || install -o $(DOCKER_MULTIPASS_INSTALL_USER) -g staff $(CURDIR)/docker-multipass-config $(HOME)/.docker-multipass-config

uninstall:
	rm -f $(BINARY_DIR)/docker-multipass
	rm -rf $(LIB_DIR)

purge-vm:
	docker-multipass purge

purge-config:
	rm -f $(HOME)/.docker-multipass-config

purge: purge-vm uninstall purge-config

