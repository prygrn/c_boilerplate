#include "unity/unity.h"
/* Inclure le header de la lib à tester */
/* #include "my_module.h" */

/* setUp() et tearDown() sont appelés avant/après chaque test */
void setUp(void)    {}
void tearDown(void) {}

/* ------------------------------------------------------------------ */
/* Exemple — remplacer par les vrais tests de l'exercice               */
/* ------------------------------------------------------------------ */

void test_placeholder(void)
{
    /* TEST_ASSERT_EQUAL_INT(expected, actual); */
    /* TEST_ASSERT_NULL(ptr); */
    /* TEST_ASSERT_NOT_NULL(ptr); */
    /* TEST_ASSERT_EQUAL_STRING("expected", actual); */
    TEST_PASS();
}

/* ------------------------------------------------------------------ */

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_placeholder);

    return UNITY_END();
}
