## Running Int2lm

Before running the interpolation program int2lm we have to accurately
prepare the namelist `INPUT` with all the information about our setup
and place it in the working directory. The only technical information
reported here is that the namelist must reflect the number of parallel
processes that will be started, e.g., if we wish to run 96 parallel
processes:

```
 &CONTRL
...
  nprocx=8, nprocy=12,
...
 /END
```

As a general rule it should be nprocx < nprocy (not too much smaller
but also not too few smaller).

Int2lm is a parallel MPI program, so the way it is started depends on
the MPI implementation used and on whether the computing system used
has a batch scheduler or not, and which scheduler.

The typical way to start an MPI process on a modern Linux system is
through the `mpirun` command, this command receives various parameters
depending on the MPI implementation but it usually supports the `-np`
parameter specifying the number of parallel processes.

If running under CentOS or Fedora system, as seen when [installing
MPI](building_prerequisites.md), it is necessary to execute `module
load mpi/openmpi-x86_64` before running `mpirun`.

A batch job for the slurm scheduler (but runnable also interactively)
could look like this:

```
#!/bin/sh

#SBATCH --output icon_2_cosmo7_job.out
#SBATCH --error icon_2_cosmo7_job.out
#SBATCH --time=03:00:00
#SBATCH --ntasks=96
#SBATCH --ntasks-per-core=1
#SBATCH --partition=global

cd /path/where/int2lm/will/run

# load MPI module
module load mpi/openmpi-x86_64

BASE=$HOME/maldives
# environment for grib_api definitions and samples
export GRIB_DEFINITION_PATH=$BASE/grib_api_edzw/1.20.0/definitions.124:$BASE/grib_api_edzw/1.20.0/definitions
export GRIB_SAMPLES_PATH=$BASE/grib_api_edzw/1.20.0/samples

# remove old files (necessary)
rm -f YUCHKDAT YUTIMING YUDEBUG OUTPUT
# run int2lm
mpirun -np 64 $BASE/int2lm_180226_2.05/tstint2lm
```

Notice that the environment variables `$GRIB_DEFINITION_PATH` and
`$GRIB_SAMPLES_PATH` have to be exported to all the instances of
int2lm parallel processes not just to `mpirun`, with OpenMPI this is
done automatically for all the environment variables, but with
different MPI implementations some arguments to `mpirun` may be
required.

[next](running_cosmo.md)

[up](README.md)