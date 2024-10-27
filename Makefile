THIS_MK_ABSPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
THIS_MK_DIR := $(dir $(THIS_MK_ABSPATH))

# Enable pipefail for all commands
SHELL=/bin/bash -o pipefail

# Enable second expansion
.SECONDEXPANSION:

# Clear all built in suffixes
.SUFFIXES:

##############################################################################
# Special use variables
##############################################################################
NULL :=
SPACE := $(NULL) $(NULL)
INFO_INDENT := $(SPACE)$(SPACE)$(SPACE)

##############################################################################
# Environment check
##############################################################################
REPO_ROOT_DIR := $(THIS_MK_DIR)
WORK_ROOT_DIR := $(THIS_MK_DIR)/work

PYTHON_BIN ?= python3
VENV_DIR := $(REPO_ROOT_DIR)/venv
VENV_PIP := $(VENV_DIR)/bin/pip
ifneq ($(https_proxy),)
PIP_PROXY := --proxy $(https_proxy)
else
PIP_PROXY :=
endif
VENV_PIP_INSTALL := $(VENV_PIP) install $(PIP_PROXY) --timeout 90
VENV_PYTHON := $(VENV_DIR)/bin/python
VENV_HATCH := $(VENV_DIR)/bin/hatch

##############################################################################
# Set default goal before any targets. The default goal here is "test"
##############################################################################
DEFAULT_TARGET := test

.DEFAULT_GOAL := default
.PHONY: default
default: $(DEFAULT_TARGET)

##############################################################################
# Makefile starts here
##############################################################################

$(WORK_ROOT_DIR):
	mkdir -p $(WORK_ROOT_DIR)

venv:
	$(PYTHON_BIN) -m venv venv
	$(VENV_PIP_INSTALL) --upgrade pip
	$(VENV_PIP_INSTALL) -r requirements.txt

venv-freeze:
	$(VENV_PIP) freeze > requirements.txt

.PHONY: clean
clean:
	rm -rf venv $(WORK_ROOT_DIR)

# Deep clean using git
.PHONY: dev-clean
dev-clean :
	git clean -dfx --exclude=/.vscode --exclude=.lfsconfig

.PHONY: prepare-tools
prepare-tools : venv

##############################################################################
# Style checks
##############################################################################


###############################################################################
#                                HELP
###############################################################################
.PHONY: help
help:
	$(info Build)
	$(info ----------------)
	$(info ALL Targets : all)
