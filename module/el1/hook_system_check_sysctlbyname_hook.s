    .align 4
    .globl _main

#include "../common/stalker_cache.h"
#include "../common/stalker_table.h"

#include "hook_system_check_sysctlbyname_hook.h"

_main:
    sub sp, sp, STACK
    ; we branched when parameters were being copied to callee-saved registers
    stp x7, x6, [sp, STACK-0xa0]
    stp x5, x4, [sp, STACK-0x90]
    stp x3, x2, [sp, STACK-0x80]
    stp x1, x0, [sp, STACK-0x70]
    stp x28, x27, [sp, STACK-0x60]
    stp x26, x25, [sp, STACK-0x50]
    stp x24, x23, [sp, STACK-0x40]
    stp x22, x21, [sp, STACK-0x30]
    stp x20, x19, [sp, STACK-0x20]
    stp x29, x30, [sp, STACK-0x10]
    add x29, sp, STACK-0x10

    adr x19, STALKER_CACHE_PTR_PTR
    ldr x28, [x19]

    ; MIB array
    mov x19, x2
    ; length of MIB array
    mov w20, w3

    ; we're sharing this data with handle_svc_hook, and this function we're
    ; hooking doesn't take sysctl_geometry_lock
    ldr x0, [x28, SYSCTL_GEOMETRY_LOCK_PTR]
    ldr x0, [x0]
    ldr x21, [x28, LCK_RW_LOCK_SHARED]
    blr x21
    ; if this sysctl hasn't been added yet, don't do anything
    ldr x21, [x28, STALKER_TABLE_PTR]
    ldr x21, [x21, STALKER_TABLE_REGISTERED_SYSCTL_OFF]
    cbz x21, not_ours
    ldr x21, [x28, SVC_STALKER_SYSCTL_MIB_COUNT_PTR]
    ldr w21, [x21]
    cmp w21, w20
    b.ne not_ours

    ; same length, so compare MIB contents
    ldr x21, [x28, SVC_STALKER_SYSCTL_MIB_PTR]          ; our MIB array
    mov x22, x19                                        ; passed in MIB array
    ; end of our MIB array. The MIB array param and our MIB array are
    ; guarenteed to have matching lengths, so we can pick one of them
    ; to use to check if we hit the end of both
    add x23, x21, w20, lsl 0x2

mib_check_loop:
    ldr w24, [x21], 0x4
    ldr w25, [x22], 0x4
    ; one mismatched elem and we know it isn't ours
    cmp w24, w25
    b.ne not_ours
    ; if we hit the end of our MIB array, it's ours
    subs x26, x23, x21
    cbnz x26, mib_check_loop

ours:
    ldr x0, [x28, SYSCTL_GEOMETRY_LOCK_PTR]
    ldr x0, [x0]
    ldr x19, [x28, LCK_RW_DONE]
    blr x19
    ; if it is ours, branch right to hook_system_check_sysctlbyname's
    ; epilogue, returning no error
    ldr x1, [x28, H_S_C_SBN_EPILOGUE_ADDR]
    add sp, sp, STACK
    mov x0, xzr
    br x1

; in the case our sysctl wasn't being dealt with, return back to
; hook_system_check_sysctlbyname to carry out its normal operation
not_ours:
    ldr x0, [x28, SYSCTL_GEOMETRY_LOCK_PTR]
    ldr x0, [x0]
    ldr x19, [x28, LCK_RW_DONE]
    blr x19
    ldp x29, x30, [sp, STACK-0x10]
    ldp x20, x19, [sp, STACK-0x20]
    ldp x22, x21, [sp, STACK-0x30]
    ldp x24, x23, [sp, STACK-0x40]
    ldp x26, x25, [sp, STACK-0x50]
    ldp x28, x27, [sp, STACK-0x60]
    ldp x1, x0, [sp, STACK-0x70]
    ldp x3, x2, [sp, STACK-0x80]
    ldp x5, x4, [sp, STACK-0x90]
    ldp x7, x6, [sp, STACK-0xa0]
    add sp, sp, STACK
    ; this is missing a RET so svc_stalker can write back the instructions
    ; we overwrote to branch to this code
    ; XXX because of this, NOTHING CAN BE AFTER THIS POINT (or if something
    ; needs to be after this point, make sure to dedicate 24 bytes worth of
    ; space for instruction restoration)
