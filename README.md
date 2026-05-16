# C Project Boilerplate

Structure de départ pour tous les exercices. Clone, code, utilise les cibles `make`.

## Structure

```md
.
├── Makefile
├── src/
│ └── main.c ← point d'entrée (ignoré dans le build de test)
├── include/ ← headers publics
├── tests/
│ ├── unity/ ← framework de TU (unity.c / unity.h)
│ └── test*main.c ← tes tests - renomme ou ajoute des fichiers test*\*.c
└── bin/ ← généré par make, ignoré par git
```

## Cibles disponibles

| Commande        | Description                                      |
| --------------- | ------------------------------------------------ |
| `make`          | Compile le projet (warnings stricts, mode debug) |
| `make test`     | Compile + lance les TU                           |
| `make valgrind` | Lance les TU sous Valgrind (memcheck complet)    |
| `make asan`     | Compile + lance les TU avec ASan + UBSan         |
| `make lint`     | Lance cppcheck sur src/ et include/              |
| `make gdb`      | Ouvre GDB sur le binaire de test                 |
| `make clean`    | Supprime bin/                                    |

## Prérequis

```bash
# Debian/Ubuntu
sudo apt install gcc make valgrind cppcheck gdb

# macOS (Homebrew)
brew install gcc make valgrind cppcheck
# GDB remplacé par lldb sur macOS - adapter la cible gdb si besoin
```

## Unity

[Unity](https://github.com/ThrowTheSwitch/Unity) est inclus directement dans `tests/unity/`.
Deux fichiers suffisent : `unity.c` et `unity.h` - pas de dépendance externe.

Asserts utiles :

```c
TEST_ASSERT_EQUAL_INT(42, result);
TEST_ASSERT_NULL(ptr);
TEST_ASSERT_NOT_NULL(ptr);
TEST_ASSERT_EQUAL_STRING("expected", actual);
TEST_ASSERT_TRUE(condition);
TEST_ASSERT_FALSE(condition);
```

## Workflow recommandé

```bash
# 1. Code ta solution dans src/
# 2. Écris tes TU dans tests/test_*.c
# 3. Vérifie que les tests passent
make test
# 4. Vérifie les fuites mémoire
make valgrind
# 5. Vérifie les comportements indéfinis
make asan
# 6. Vérifie la qualité statique
make lint
```
