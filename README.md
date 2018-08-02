# cosmo-model-training

Training material for starting running COSMO model on Maldives Islands
and not only

## Quick start

For starting, clone this project in your home directory, change to the
project directory `cosmo-model-training`, download all the
[Cosmo](http://www.cosmo.model.org/) software in that directory
(int2lm, cosmo, grib_api) and you are ready to start with the tutorial
in [the doc/ directory](doc/README.md).

## Linux distribution

The operating-system-related operations contained in the tutorial
(mainly installation of pre-compiled software packages) assume the
user is working under a CentOS 7 GNU/Linux distribution. If such a
system is not available, it is possible to use one of the `centos*`
recipe files in the [singularity/ directory](singularity) to build a
CentOS containerized environment with
[singularity](http://singularity.lbl.gov/) on a generic Linux system.

There is also a container for generating a Debian system suitable for
performing the tutorial (not fully tested however); it can be used
either for generating a Debian containerized environment or as a hint
for installation of prerequisites on a real Debian/Ubuntu system.

## Useful tools

The [tools/ directory](tools/) of the project contains some useful
scripts for performing various tasks.
