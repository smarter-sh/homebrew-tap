# ---------------------------------------------------------
# Smarter Homebrew tap (smarter-sh/tap). See README.md and CLAUDE.md.
#
# Homebrew reads only Formula/. These targets check the formula; none of them
# changes it, installs anything with brew, or publishes.
# ---------------------------------------------------------
SHELL := /bin/bash
PYTHON := python3
VENV := venv
FORMULA := Formula/smarter.rb

.PHONY: all init lint test check clean pre-commit-run help

all: help

# pre-commit, in a Python virtual environment of the repository: see requirements/local.txt.
init:
	$(PYTHON) -m venv $(VENV)
	$(VENV)/bin/pip install --upgrade pip
	$(VENV)/bin/pip install -r requirements/local.txt
	$(VENV)/bin/pre-commit install
	@echo 'Activate the Python virtual environment, for pre-commit and codespell: source $(VENV)/bin/activate'

# Ruby syntax and brew style: what brew test-bot --only-tap-syntax checks in CI.
# CI's brew style covers the whole tap: the formula, shell scripts (shellcheck
# and shfmt), and ruby code blocks in Markdown files. Not "brew style .", which
# would also lint the local venv/.
lint:
	ruby -c $(FORMULA)
	brew style Formula skills README.md CLAUDE.md

# Downloads the release binary the formula points at, and checks its sha256.
check:
	skills/homebrew-tap-formula/scripts/check-formula.sh $(FORMULA)

test: lint check

pre-commit-run:
	$(VENV)/bin/pre-commit run --all-files

clean:
	rm -rf $(VENV)

help:
	@echo '===================================================================='
	@echo 'Smarter Homebrew tap'
	@echo '===================================================================='
	@echo 'init            - pre-commit and its hooks (in venv/)'
	@echo 'lint            - ruby -c and brew style on the formula'
	@echo 'check           - the formula url downloads and its sha256 matches'
	@echo 'test            - lint and check'
	@echo 'pre-commit-run  - every pre-commit hook on every file'
	@echo 'clean           - remove venv/'
