#include <stdio.h>
#include "mpi.h"

int main(int argc, char *argv[]) {
   int provided, claimed;
   MPI_Init_thread(0, 0, MPI_THREAD_MULTIPLE, &provided);
   MPI_Query_thread(&claimed);
   printf("Query thread level = %d, Init_thread_level = %d\n", claimed, provided);
   MPI_Finalize();
}

