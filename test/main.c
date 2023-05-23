#include <cdh/Logger.h>
#include <stdlib.h>
#include <cdh/Memory.h>

int main() {
    cdh_logStream = stdout;

    cdh_debug_free(cdh_debug_malloc(10));
    void* mallocPtr = malloc(20);
    void* reallocPtr = realloc(mallocPtr, 40);
    void* callocPtr = calloc(5, sizeof(long));
    size_t difference = (char*)callocPtr - (char*)reallocPtr;
    cdh_log("Difference between realloc and calloc %lld\n", difference);
    free(reallocPtr);
    free(callocPtr);

    return 0;
}