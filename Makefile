##Usage: make <command>
##
##Commands:

SITE_HOME := ./build/site
SITE_PORT = 8080

.PHONY: lint test build-site serve help

default: help

build-site:         ## Build site
	@echo "TBD"

lint:               ## Check all scripts in the repository for syntax errors.
	@echo "TBD"


serve:              ## Serve site locally
	@echo "Start httpd locally: http://localhost:$(SITE_PORT)/"
	@(sleep 2; open "http://localhost:$(SITE_PORT)/") &
	@cd "${SITE_HOME}" && python3 -m http.server ${SITE_PORT}

help:               ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'