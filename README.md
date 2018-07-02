# cosmo-model-training #

Training material for starting running COSMO model on Maldives Islands
and not only

For starting, clone this project in your home directory, change to the
project directory `cosmo-model-training`, download all the
[Cosmo](http://www.cosmo.model.org/) software in that directory
(int2lm, cosmo, grib_api) and you are ready to start with the tutorial
in [the doc/ directory](doc/).

The tutorial refers to a CentOS 7 system. If such a system is not
available, it is possible to use one of the `centos*.def` definition
files in the main directory to build a CentOS containerized
environment with [singularity](http://singularity.lbl.gov/) on a
generic Linux system.

There is also a container for generating a Debian system suitable for
performing most of the tutorial sections (only grib2 in grads is not
supported).
