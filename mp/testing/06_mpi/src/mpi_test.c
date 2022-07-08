/*

MPI simple test using a conglomeration of examples from

https://github.com/mpitutorial/mpitutorial

*/
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <assert.h>
#include <time.h>



// Creates an array of random numbers. Each number has a value from 0 - 1
float *create_rand_nums(int num_elements) {
  float *rand_nums = (float *)malloc(sizeof(float) * num_elements);
  assert(rand_nums != NULL);
  int i;
  for (i = 0; i < num_elements; i++) {
    rand_nums[i] = (rand() / (float)RAND_MAX);
  }
  return rand_nums;
}


int main(int argc, char** argv) {
    const int true = 1;
    const int false = 0;

    int run_reduce = true;
    int num_elements_per_proc = 1;
    if (argc != 2) {
      printf("Running hello world only \n");
      run_reduce = false;
    } else {
      num_elements_per_proc = atoi(argv[1]);
    }

    // Initialize the MPI environment
    MPI_Init(NULL, NULL);

    // Get the number of processes
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Create a random array of elements on all processes.
    srand(time(NULL)*world_rank);   // Seed the random number generator to get different results each time for each processor
    float *rand_nums = NULL;
    rand_nums = create_rand_nums(num_elements_per_proc);

    // Sum the numbers locally
    float local_sum = 0;
    int i;
    for (i = 0; i < num_elements_per_proc; i++) {
      local_sum += rand_nums[i];
    }

    // Get the name of the processor
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    // Print off a hello world message
    printf("Hello world from processor %s, rank %d out of %d processors. \n\t local sum: %f \n\t avg: %f \n",
           processor_name, world_rank, world_size, local_sum, local_sum / num_elements_per_proc);

    if (run_reduce) {
      // Reduce all of the local sums into the global sum
      float global_sum;
      MPI_Reduce(&local_sum, &global_sum, 1, MPI_FLOAT, MPI_SUM, 0,
                 MPI_COMM_WORLD);

      // Print the result
      MPI_Barrier(MPI_COMM_WORLD);
      if (world_rank == 0) {
        printf("Total sum = %f, avg = %f\n", global_sum,
               global_sum / (world_size * num_elements_per_proc));
      }
    }

    // Clean up
    free(rand_nums);

    MPI_Barrier(MPI_COMM_WORLD);

    // Finalize the MPI environment.
    MPI_Finalize();
}
