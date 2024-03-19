# Build configuration for the server project
BUILD_DIR := ./build
SRC_DIR := ./src
EXECUTABLE := server

# Compiler and linker flags
XCODE_SDK := $(shell xcrun --show-sdk-path --sdk macosx)
LINK_FLAGS := -macos_version_min 14.0 -syslibroot $(XCODE_SDK) -lSystem
ASSEMBLER := clang
LINKER := ld

# List of source and object files
SRC_FILES := $(wildcard $(SRC_DIR)/*.s)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.o,$(SRC_FILES))

# Create the build directory
$(BUILD_DIR):
	@echo "Creating build directory..."
	mkdir -p $(BUILD_DIR)

# Compile the source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	@echo "Compiling $<..."
	$(ASSEMBLER) -c $< -o $@

# Link the object files
$(BUILD_DIR)/$(EXECUTABLE): $(OBJ_FILES)
	@echo "Linking object files..."
	$(LINKER) $(LINK_FLAGS) -o $@ $^

# Clean the build directory
clean:
	@echo "Cleaning build directory..."
	rm -rf $(BUILD_DIR)

# Build the project
all: $(BUILD_DIR) $(BUILD_DIR)/$(EXECUTABLE)