# Aplication options
APP = $(notdir $(CURDIR)) # Application name is name of root holder
GXX_STANDARD = 17 # 11, 14, 17, 20
OUT_FILE_NAME = $(APP)

# Compiler options
CC = clang++
CXXFLAGS = -c -02 -emit-llvm -Wall -Wextra -std=c++$(GXX_STANDARD)
LXXFLAGS =
OPTFLAGS = -enable-new-pm=0

BUILD_PATH = build

# ------------------------------------------------------------------------------------------

# Library options
#LIBS = SSE # SFM

# Activate SSE
#ifeq ($(filter SSE, $(LIBS)), SSE)
#	CXXFLAGS += -mavx -mavx2
#endif

# Include library
#LIB_PATH =
#LIB_DEPEND = boost_program_options

# Include SFML
#ifeq ($(filter SFML, $(LIBS)), SFML)
#	LIB_PATH += 
#	LIB_DEPEND += sfml-audio  sfml-graphics  sfml-network  sfml-system  sfml-window
#endif

# Set library flags
#CXXFLAGS += $(patsubst %,-I%/include,$(LIB_PATH))
#LXXFLAGS += $(patsubst %,-L%/lib,$(LIB_PATH)) $(addprefix -l, $(LIB_DEPEND))

# ------------------------------------------------------------------------------------------

# Set name folder
SRC_DIR = src 
BIN_DIR = bin

# Search for source files
SRC_FULL_PATH = $(shell find . -name "*.cpp")
EXLUDED = # Excluded files
SRC = $(filter-out $(EXLUDED),$(notdir $(SRC_FULL_PATH)))
OBJ = $(addprefix $(BIN_DIR)/, $(SRC:.cpp=.o))

# ------------------------------------------------------------------------------------------

# Setting build parameters
ifeq ($(BUILD), Debug)
	CXXFLAGS += -O1 -g -fdiagnostics-color=always
	BUILD_PATH = build-debug
	OBJ = $(addprefix $(BIN_DIR)/, $(SRC:.cpp=d.o))
else
	CXXFLAGS += -Os -s -DNDEBUG
	BUILD_PATH = build-release
endif

# ------------------------------------------------------------------------------------------

# Set include path
CXXFLAGS += -I$(CURDIR)/src

# Сonfiguring file search paths
VPATH = $(dir $(SRC_FULL_PATH))

# ------------------------------------------------------------------------------------------
# Main build Rule
build: buildInfo $(BUILD_PATH)/$(OUT_FILE_NAME)

# ------------------------------------------------------------------------------------------

# Print build info
buildInfo:
	echo "Start compile $(APP)in $(BUILD) mode"
#echo $(CXXFLAGS)

# Build project 
$(BUILD_PATH)/$(OUT_FILE_NAME): $(OBJ) Makefile
	mkdir -p $(BUILD_PATH)
	$(CC) $(OBJ) -o $(BUILD_PATH)/$(OUT_FILE_NAME) $(LXXFLAGS)

# Dependency checking
#include $(addprefix $(BIN_DIR)/, $(SRC:.cpp=.d))

# Compilation source 
$(BIN_DIR)/%.o: %.cpp Makefile
	echo "[ Compile $< ($(BUILD))]"
	$(CC) $< -c -o $@ $(CXXFLAGS)

# Compilation source
#$(BIN_DIR)/%d.o: %.cpp Makefile
	echo "[$< ($(BUILD))]"
	$(CC) $< -c -o $@ $(CXXFLAGS)

# Updating dependencies
#$(BIN_DIR)/%.d: %.cpp Makefile
	mkdir -p bin
	$(CC) $< -MM -MT '$(BIN_DIR)/$*.o $(BIN_DIR)/$*.d' -MF $@ $(CXXFLAGS)

# ------------------------------------------------------------------------------------------
.PHONY: pass
pass:
	make Makefile.pass

# ------------------------------------------------------------------------------------------
.PHONY: init gitInit clean distclean
init:
	@mkdir -p bin
	@mkdir -p build
	@mkdir -p build-pass
	@echo "[Init cmake for passes]"
	@cmake -S ./ -B ./build-pass

gitInit:
	@git init

clean:
	@rm -r bin

distclean:
	@rm -r bin
	@rm -r build
	@rm -r build-pass