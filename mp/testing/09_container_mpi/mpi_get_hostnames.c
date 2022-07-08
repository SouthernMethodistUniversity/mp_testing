#include <stdio.h>
#include "mpi.h"

int main(int argc, char *argv[]) {

   // Setup variables
   int numtasks, rank, len, rc;
   char hostname[MPI_MAX_PROCESSOR_NAME];
   
   // Initialize MPI
   rc = MPI_Init(&argc, &argv);

   // Get number of tasks
   rc = MPI_Comm_size(MPI_COMM_WORLD, &numtasks);

   // Get process rank
   rc = MPI_Comm_rank(MPI_COMM_WORLD, &rank);

   // Get hostname of process
   rc = MPI_Get_processor_name(hostname, &len);
   printf("Number of tasks = %d, My rank = %d, Running on %s\n", numtasks, rank, hostname);

   // Report total number of tasks
   if (rank == 0) {
      printf("The number of tasks is %d\n", numtasks);
   }

   // Done with MPI
   rc = MPI_Finalize();
}

