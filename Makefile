project_name = melange-fest

DUNE = opam exec -- dune

.DEFAULT_GOAL := help

.PHONY: help
help: ## Print this help message
	@echo "List of available make commands";
	@echo "";
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: create-switch
create-switch: ## Create opam switch
	opam switch create . 5.1.1 -y --deps-only

.PHONY: init
init: create-switch install ## Configure everything to develop this repository in local

.PHONY: install
install: ## Install development dependencies
	npm install
	opam update
	opam install -y . --deps-only --with-test --with-doc

.PHONY: build
build: ## Build the project
	$(DUNE) build

.PHONY: build_verbose
build_verbose: ## Build the project
	$(DUNE) build --verbose

.PHONY: serve
serve: ## Serve the application with a local HTTP server
	npm run serve

.PHONY: bundle
bundle: ## Bundle the JavaScript application
	npm run bundle

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	$(DUNE) clean

.PHONY: format
format: ## Format the codebase with ocamlformat
	$(DUNE) build @fmt --auto-promote

.PHONY: format-check
format-check: ## Checks if format is correct
	$(DUNE) build @fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	$(DUNE) build --watch @react @node

.PHONY: test
test: ## Run test suite
	$(DUNE) test --no-buffer

.PHONY: docs
docs: ## Build the docs
	$(DUNE) build @doc

.PHONY: preview
preview: docs ## Preview the docs
	cd _build/default/_doc/_html/ && python -m http.server
