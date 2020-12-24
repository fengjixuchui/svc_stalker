#ifndef HANDLE_SVC_HOOK_
#define HANDLE_SVC_HOOK_

#define STACK                       (0x200)

#define NUM_INSTRS_BEFORE_CACHE     (9)
#define STALKER_CACHE_PTR_PTR       (-((4*NUM_INSTRS_BEFORE_CACHE)+8))

/* local variables */
#define SAVED_STATE_PTR             (STACK-0x70)
#define EXC_CODES                   (STACK-0x78)    /* XXX array of 2 uint64_t */
#define CUR_PID                     (STACK-0x88)
#define STALKER_LOCK_GROUP_NAME     (STACK-0x90)

/* sysctl stuff */
#define SIZEOF_STRUCT_SYSCTL_OID    (0x50)

#define OFFSETOF_OID_PARENT         (0x0)
#define OFFSETOF_OID_LINK           (0x8)
#define OFFSETOF_OID_NUMBER         (0x10)
#define OFFSETOF_OID_KIND           (0x14)
#define OFFSETOF_OID_ARG1           (0x18)
#define OFFSETOF_OID_ARG2           (0x20)
#define OFFSETOF_OID_NAME           (0x28)
#define OFFSETOF_OID_HANDLER        (0x30)
#define OFFSETOF_OID_FMT            (0x38)
#define OFFSETOF_OID_DESCR          (0x40)
#define OFFSETOF_OID_VERSION        (0x48)
#define OFFSETOF_OID_REFCNT         (0x4c)

#define OID_AUTO                    (-1)

#define CTLTYPE_INT                 (2)
#define CTLFLAG_OID2                (0x00400000)
#define CTLFLAG_ANYBODY             (0x10000000)
#define CTLFLAG_RD                  (0x80000000)

#define SYSCTL_OID_VERSION          (1)

/* exception stuff */
#define EXC_SYSCALL                 (7)
#define EXC_MACH_SYSCALL            (8)

#define BEFORE_CALL                 (0)

#endif
