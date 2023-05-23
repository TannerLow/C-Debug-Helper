#include <cdh/Debug.h>
#include <cdh/Logger.h>

#include <stdlib.h>

int _cdh_crash(int errorCode, const char* file, unsigned int line) {
    cdh_log("[ERROR] Encountered error with code %d (%s, %d)\n", errorCode, file, line);
    exit(errorCode);
}