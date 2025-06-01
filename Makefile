# dctl Makefile
# A daemon control wrapper for Unix-like systems

# Default installation prefix
PREFIX ?= /usr/local

# Installation directories
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1

# Detect OS type
UNAME_S := $(shell uname -s)

# Set appropriate install command based on OS
ifeq ($(UNAME_S),Darwin)
    INSTALL = install -m 755
    INSTALL_DATA = install -m 644
else
    INSTALL = install -D -m 755
    INSTALL_DATA = install -D -m 644
endif

# Binary name
PROG = dctl

# Version
VERSION = 1.0.0

# Default target
.PHONY: all
all: help

# Help target
.PHONY: help
help:
	@echo "dctl $(VERSION) - Daemon control wrapper"
	@echo ""
	@echo "Available targets:"
	@echo "  make install    - Install dctl to $(BINDIR)"
	@echo "  make uninstall  - Remove dctl from $(BINDIR)"
	@echo "  make symlink    - Create symlink in $(BINDIR) (for development)"
	@echo "  make clean      - Clean any generated files"
	@echo ""
	@echo "Options:"
	@echo "  PREFIX=/path    - Change installation prefix (default: /usr/local)"
	@echo ""
	@echo "Examples:"
	@echo "  make install                    # Install to /usr/local/bin"
	@echo "  make install PREFIX=~/.local    # Install to ~/.local/bin"
	@echo "  make symlink                    # Create development symlink"

# Install target
.PHONY: install
install: check-daemon
	@echo "Installing $(PROG) to $(BINDIR)..."
	@mkdir -p $(BINDIR)
	@$(INSTALL) $(PROG) $(BINDIR)/$(PROG)
	@echo "Installation complete. $(PROG) is now available at $(BINDIR)/$(PROG)"
	@echo ""
	@echo "Make sure $(BINDIR) is in your PATH:"
	@echo "  export PATH=\"$(BINDIR):\$$PATH\""

# Uninstall target
.PHONY: uninstall
uninstall:
	@echo "Removing $(PROG) from $(BINDIR)..."
	@rm -f $(BINDIR)/$(PROG)
	@echo "Uninstall complete."

# Symlink target for development
.PHONY: symlink
symlink: check-daemon
	@echo "Creating symlink for $(PROG) in $(BINDIR)..."
	@mkdir -p $(BINDIR)
	@if [ -L "$(BINDIR)/$(PROG)" ]; then \
		echo "Removing existing symlink..."; \
		rm -f "$(BINDIR)/$(PROG)"; \
	fi
	@ln -s "$(abspath $(PROG))" "$(BINDIR)/$(PROG)"
	@echo "Symlink created: $(BINDIR)/$(PROG) -> $(abspath $(PROG))"
	@echo ""
	@echo "Make sure $(BINDIR) is in your PATH:"
	@echo "  export PATH=\"$(BINDIR):\$$PATH\""

# Check for daemon command
.PHONY: check-daemon
check-daemon:
	@if ! command -v daemon >/dev/null 2>&1; then \
		echo "Error: 'daemon' command not found."; \
		echo ""; \
		echo "Please install daemon first:"; \
		echo "  macOS:    brew install daemon"; \
		echo "  Ubuntu:   sudo apt-get install daemon"; \
		echo "  Fedora:   sudo dnf install daemon"; \
		echo "  FreeBSD:  sudo pkg install daemon"; \
		echo ""; \
		exit 1; \
	fi

# Clean target
.PHONY: clean
clean:
	@echo "Nothing to clean."

# Test installation
.PHONY: test
test:
	@echo "Testing $(PROG) installation..."
	@if command -v $(PROG) >/dev/null 2>&1; then \
		echo "✓ $(PROG) found in PATH at: $$(command -v $(PROG))"; \
		echo "✓ Version: $$($(PROG) -V 2>&1 | head -1)"; \
	else \
		echo "✗ $(PROG) not found in PATH"; \
		echo "  Make sure to add $(BINDIR) to your PATH"; \
		exit 1; \
	fi

.PHONY: dist
dist:
	@echo "Creating distribution tarball..."
	@mkdir -p dist
	@tar czf dist/$(PROG)-$(VERSION).tar.gz \
		--exclude='.git' \
		--exclude='dist' \
		--exclude='*.log' \
		--exclude='*.pid' \
		--transform 's,^,$(PROG)-$(VERSION)/,' \
		$(PROG) Makefile README.md

# Platform-specific notes
.PHONY: platform-info
platform-info:
	@echo "Platform Information:"
	@echo "  OS: $(UNAME_S)"
	@echo "  Install prefix: $(PREFIX)"
	@echo "  Binary directory: $(BINDIR)"
	@echo ""
	@echo "Common installation paths:"
	@echo "  System-wide: /usr/local/bin (default)"
	@echo "  User-local:  ~/.local/bin"
	@echo "  Homebrew:"
ifeq ($(UNAME_S),Darwin)
	@echo "    Intel Mac: /usr/local/bin"
	@echo "    M1 Mac:    /opt/homebrew/bin"
else
	@echo "    Linux:     /usr/local/bin"
endif
