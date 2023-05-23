#include <cdh/Memory.h>
#include <cdh/Asserts.h>
#include <cdh/Debug.h>
#include <cdh/ErrorCodes.h>
#include <cdh/Logger.h>

#include <stdlib.h>

// I use all these identifiers here so need to remove macros to avoid conflicts
#undef malloc
#undef realloc
#undef calloc
#undef free
#undef cdh_debug_malloc
#undef cdh_debug_realloc
#undef cdh_debug_calloc
#undef cdh_debug_free

void* cdh_debug_malloc(const size_t numOfBytes, const char* file, const int line) {
    cdh_log("[Memory] Malloc of %llu bytes (%s, %d)\n", numOfBytes, file, line);

    void* ptr = malloc(numOfBytes);
    assertOrExecute(ptr != NULL, cdh_crash(CDH_NULL_MALLOC_OUPUT));

    cdh_log("[Memory] Malloc created 0x%p (%s, %d)\n", ptr, file, line);

    return ptr;
}

void* cdh_debug_realloc(void* heapPointer, const size_t numOfBytes, const char* file, const int line) {
    cdh_log("[Memory] Realloc of 0x%p for %llu bytes (%s, %d)\n", heapPointer, numOfBytes, file, line);

    void* ptr = realloc(heapPointer, numOfBytes);
    assertOrExecute(ptr != NULL, cdh_crash(CDH_NULL_REALLOC_OUTPUT));

    if(ptr != heapPointer) {
        cdh_log("[Memory] Realloc created new allocation 0x%p (%s, %d)\n", ptr, file, line);
    }

    return ptr;
}

void* cdh_debug_calloc(const size_t elementCount, const size_t sizeOfElement, const char* file, const int line) {
    cdh_log("[Memory] Calloc of %llu elements each of %llu bytes (%s, %d)\n", elementCount, sizeOfElement, file, line);

    void* ptr = calloc(elementCount, sizeOfElement);
    assertOrExecute(ptr != NULL, cdh_crash(CDH_NULL_CALLOC_OUTPUT));

    cdh_log("[Memory] Calloc created 0x%p (%s, %d)\n", ptr, file, line);

    return ptr;
}

void cdh_debug_free(void* heapPointer, const char* file, const int line) {
    cdh_log("[Memory] Free of 0x%p (%s, %d)\n", heapPointer, file, line);

    free(heapPointer);
}
