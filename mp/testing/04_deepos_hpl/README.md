# HPL tests

We're trying to follow the directions provided here https://github.com/NVIDIA/deepops/tree/master/workloads/bit/hpl because this was suggested in the validation report we were provided.

## Runs

We've tried running expirements like:

```
./launch_hpl_experiment.sh -s dgxa100_80G  -c 8 -i 5 -t 0:20:00 --cruntime enroot
./launch_hpl_experiment.sh -s dgxa100_80G  -c 10 -i 5  --cruntime enroot
```

We get unknown interface warnings:

```
WARNING: An invalid value was given for btl_tcp_if_include.  This
value will be ignored.

  Local host: bcm-dgxa100-0010
  Value:      enp225s0f1
  Message:    Unknown interface name
```

We get error messages like:

```
OMP: Error #13: Assertion failure at kmp_taskdeps.h(53).
OMP: Hint Please submit a bug report with this message, compile and run commands used, and machine configuration info including native compiler and operating system versions. Faster response will be obtained by including all program sources. For information on submitting this issue, please see http://www.intel.com/software/products/support/.
[bcm-dgxa100-0010:1193386] *** Process received signal ***
[bcm-dgxa100-0010:1193386] Signal: Aborted (6)
[bcm-dgxa100-0010:1193386] Signal code:  (-6)
[bcm-dgxa100-0010:1193386] [ 0] /lib/x86_64-linux-gnu/libpthread.so.0(+0x12980)[0x7f88731e7980]
[bcm-dgxa100-0010:1193386] [ 1] /lib/x86_64-linux-gnu/libc.so.6(gsignal+0xc7)[0x7f8872e22fb7]
[bcm-dgxa100-0010:1193386] [ 2] /lib/x86_64-linux-gnu/libc.so.6(abort+0x141)[0x7f8872e24921]
[bcm-dgxa100-0010:1193386] [ 3] /workspace/hpl-linux-x86_64/xhpl[0x4a25b7]
[bcm-dgxa100-0010:1193386] [ 4] /workspace/hpl-linux-x86_64/xhpl[0x48ed5a]
[bcm-dgxa100-0010:1193386] [ 5] /workspace/hpl-linux-x86_64/xhpl[0x4687aa]
[bcm-dgxa100-0010:1193386] [ 6] /workspace/hpl-linux-x86_64/xhpl[0x4c4a98]
[bcm-dgxa100-0010:1193386] [ 7] /workspace/hpl-linux-x86_64/xhpl[0x4cba51]
[bcm-dgxa100-0010:1193386] [ 8] /workspace/hpl-linux-x86_64/xhpl[0x4d109d]
[bcm-dgxa100-0010:1193386] [ 9] /workspace/hpl-linux-x86_64/xhpl[0x51cab7]
[bcm-dgxa100-0010:1193386] [10] /workspace/hpl-linux-x86_64/xhpl[0x5212f4]
[bcm-dgxa100-0010:1193386] [11] /workspace/hpl-linux-x86_64/xhpl[0x498f40]
[bcm-dgxa100-0010:1193386] [12] /workspace/hpl-linux-x86_64/xhpl[0x4dba60]
[bcm-dgxa100-0010:1193386] [13] /lib/x86_64-linux-gnu/libpthread.so.0(+0x76db)[0x7f88731dc6db]
[bcm-dgxa100-0010:1193386] [14] /lib/x86_64-linux-gnu/libc.so.6(clone+0x3f)[0x7f8872f0571f]
[bcm-dgxa100-0010:1193386] *** End of error message ***
/workspace/hpl.sh: line 324: 1193386 Aborted                 (core dumped) numactl --physcpubind=${CPU} ${MEMBIND} ${XHPL} ${DAT}
```

and 

```
[bcm-dgxa100-0008:2545142:0:2545611] Caught signal 11 (Segmentation fault: Sent by the kernel at address (nil))
==== backtrace (tid:2545611) ====
0 0x0000000000024e35 ucs_debug_print_backtrace() /var/tmp/ucx-1.10.0/src/ucs/debug/debug.c:656
1 0x0000000000012980 __funlockfile() ???:0
2 0x00000000004c16a5 __kmpc_omp_task_with_deps() ???:0
3 0x00000000004c44a4 __kmpc_omp_task_with_deps() ???:0
4 0x00000000004cba51 __kmpc_omp_task_alloc() ???:0
5 0x00000000004d109d __kmpc_omp_task_alloc() ???:0
6 0x000000000051cab7 __kmp_external___intel_sse2_strspn() ???:0
7 0x00000000005212f4 __kmp_external___intel_sse2_strspn() ???:0
8 0x0000000000498f40 omp_in_parallel() ???:0
9 0x00000000004dba60 __kmp_external___intel_sse2_strspn() ???:0
10 0x00000000000076db start_thread() ???:0
11 0x000000000012171f clone() ???:0
=================================
[bcm-dgxa100-0008:2545142] *** Process received signal ***
[bcm-dgxa100-0008:2545142] Signal: Segmentation fault (11)
[bcm-dgxa100-0008:2545142] Signal code: (-6)
[bcm-dgxa100-0008:2545142] Failing at address: 0x26d5f6
[bcm-dgxa100-0008:2545142] [ 0] /lib/x86_64-linux-gnu/libpthread.so.0(+0x12980)[0x7fea47149980]
[bcm-dgxa100-0008:2545142] [ 1] /workspace/hpl-linux-x86_64/xhpl[0x4c16a5]
[bcm-dgxa100-0008:2545142] [ 2] /workspace/hpl-linux-x86_64/xhpl[0x4c44a4]
[bcm-dgxa100-0008:2545142] [ 3] /workspace/hpl-linux-x86_64/xhpl[0x4cba51]
[bcm-dgxa100-0008:2545142] [ 4] /workspace/hpl-linux-x86_64/xhpl[0x4d109d]
[bcm-dgxa100-0008:2545142] [ 5] /workspace/hpl-linux-x86_64/xhpl[0x51cab7]
[bcm-dgxa100-0008:2545142] [ 6] /workspace/hpl-linux-x86_64/xhpl[0x5212f4]
[bcm-dgxa100-0008:2545142] [ 7] /workspace/hpl-linux-x86_64/xhpl[0x498f40]
[bcm-dgxa100-0008:2545142] [ 8] /workspace/hpl-linux-x86_64/xhpl[0x4dba60]
[bcm-dgxa100-0008:2545142] [ 9] /lib/x86_64-linux-gnu/libpthread.so.0(+0x76db)[0x7fea4713e6db]
[bcm-dgxa100-0008:2545142] [10] /lib/x86_64-linux-gnu/libc.so.6(clone+0x3f)[0x7fea46e6771f]
[bcm-dgxa100-0008:2545142] *** End of error message ***
/workspace/hpl.sh: line 324: 2545142 Segmentation fault (core dumped) numactl --physcpubind=${CPU} ${MEMBIND} ${XHPL} ${DAT}
srun: debug2: Leaving _file_write
srun: debug2: eio_message_socket_accept: got message connection from 10.211.48.11:53680 23
srun: debug2: received task exit
srun: launch/slurm: _task_finish: Received task exit notification for 1 task of StepId=249.0 (status=0x8b00).
srun: error: bcm-dgxa100-0008: task 61: Exited with exit code 139
srun: debug: task 61 done
```

The jobs do not seem to abort correctly and continue until they timeout. 
After timing out the nodes are left in a drained state.