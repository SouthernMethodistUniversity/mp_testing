EXECS=mpi_test
MPICC?=mpicc

all: ${EXECS}

mpi_test: mpi_test.c
	${MPICC} -o mpi_test mpi_test.c
clean:
	rm -f ${EXECS}
