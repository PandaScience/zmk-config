# Variables
WEST = west
BOARD = nice_nano
BUILD_DIR = build

CMAKE_PREFIX_PATH := /zmk-config/zephyr:${CMAKE_PREFIX_PATH}

# Targets
.PHONY: all init update left right reset clean help

all: left right reset

help:
	@echo "Usage:"
	@echo "  make init          - Initialize west workspace"
	@echo "  make left          - Build left shield"
	@echo "  make right         - Build right shield"
	@echo "  make reset         - Build settings reset shield"
	@echo "  make all           - Build all shields (default)"
	@echo "  make clean         - Remove build directory"

init:
	@if [ ! -d ".west" ]; then \
		echo "Initializing west workspace..."; \
		$(WEST) init -l config; \
		echo "Setting CMAKE config options..."; \
		$(WEST) config build.cmake-args -- "-DZMK_CONFIG=/zmk-config/config"; \
		echo "Updating west modules..."; \
		$(WEST) update; \
	fi

left: init
	@echo "Building dasbob_left..."
	@mkdir -p $(BUILD_DIR)
	$(WEST) build -p auto -b $(BOARD) -s zmk/app -d $(BUILD_DIR)/left -- -DSHIELD=dasbob_left
	@ln -sf left/zephyr/zmk.uf2 $(BUILD_DIR)/dasbob_left.uf2

right: init
	@echo "Building dasbob_right..."
	@mkdir -p $(BUILD_DIR)
	$(WEST) build -p auto -b $(BOARD) -s zmk/app -d $(BUILD_DIR)/right -- -DSHIELD=dasbob_right
	@ln -sf right/zephyr/zmk.uf2 $(BUILD_DIR)/dasbob_right.uf2

reset: init
	@echo "Building settings_reset..."
	@mkdir -p $(BUILD_DIR)
	$(WEST) build -p auto -b $(BOARD) -s zmk/app -d $(BUILD_DIR)/reset -- -DSHIELD=settings_reset
	@ln -sf reset/zephyr/zmk.uf2 $(BUILD_DIR)/settings_reset.uf2

clean:
	@echo "Cleaning build directory..."
	rm -rf $(BUILD_DIR)
