# =============================================================================
# Boilerplate — Formation C
# Cible         Description
# -----------   ---------------------------------------------------------------
# make          Compile le projet (debug, warnings stricts)
# make test     Compile + lance les TU (Unity)
# make valgrind Lance les TU sous Valgrind (memcheck complet)
# make asan     Compile + lance les TU avec AddressSanitizer + UBSan
# make lint     Lance cppcheck sur src/ et include/
# make gdb      Compile en mode debug et ouvre GDB sur le binaire de test
# make clean    Supprime les artefacts
# =============================================================================

CC      = gcc
STD     = -std=c11
WARNS   = -Wall -Wextra -Wpedantic -Wformat=2 -Wuninitialized \
          -Wno-unused-parameter
CFLAGS  = $(STD) $(WARNS) -g -Iinclude

# Sources du projet (exclut main.c du build de test)
SRCS        = $(wildcard src/*.c)
SRCS_NOMAIM = $(filter-out src/main.c, $(SRCS))

# Binaires
TARGET       = bin/main
TEST_TARGET  = bin/test_runner

# Unity (single-file test framework)
UNITY_DIR = tests/unity
UNITY_SRC = $(UNITY_DIR)/unity.c
UNITY_INC = -I$(UNITY_DIR)

# Sources de tests
TEST_SRCS = $(wildcard tests/test_*.c)

# Valgrind
VALGRIND = valgrind \
           --tool=memcheck \
           --leak-check=full \
           --show-leak-kinds=all \
           --track-origins=yes \
           --error-exitcode=1 \
           --verbose

# AddressSanitizer + UndefinedBehaviorSanitizer
ASAN_FLAGS = -fsanitize=address,undefined \
             -fno-omit-frame-pointer \
             -fno-sanitize-recover=all \
             -g

# cppcheck
LINT       = cppcheck
LINTFLAGS  = --enable=all \
             --suppress=missingIncludeSystem \
             --suppress=checkersReport \
             --std=c11 \
             --error-exitcode=1 \
             -Iinclude

# =============================================================================
.PHONY: all test valgrind asan lint gdb clean

all: $(TARGET)

# ---- Compilation principale --------------------------------------------------
$(TARGET): $(SRCS) | bin
	$(CC) $(CFLAGS) -o $@ $^

bin:
	mkdir -p bin

# ---- Tests Unity -------------------------------------------------------------
$(TEST_TARGET): $(UNITY_SRC) $(TEST_SRCS) $(SRCS_NOMAIM) | bin
	$(CC) $(CFLAGS) $(UNITY_INC) -o $@ $^

test: $(TEST_TARGET)
	./$(TEST_TARGET)

# ---- Valgrind (sur les TU) ---------------------------------------------------
valgrind: $(TEST_TARGET)
	$(VALGRIND) ./$(TEST_TARGET)

# ---- ASan + UBSan (sur les TU) ----------------------------------------------
asan: $(UNITY_SRC) $(TEST_SRCS) $(SRCS_NOMAIM) | bin
	$(CC) $(CFLAGS) $(ASAN_FLAGS) $(UNITY_INC) \
	      -o bin/test_runner_asan $^
	./bin/test_runner_asan

# ---- Linter ------------------------------------------------------------------
lint:
	$(LINT) $(LINTFLAGS) src/ include/

# ---- GDB (sur le binaire de test) -------------------------------------------
gdb: $(TEST_TARGET)
	gdb ./$(TEST_TARGET)

# ---- Clean ------------------------------------------------------------------
clean:
	rm -rf bin/
