## Importing Cosmo data in grads ##

### Basic import of Cosmo grib data in grads ###

The procedure for importing a single grib file consists in creating
the so-called *ctl* file, which contains the decription of the grib
content for grads, and indexing the grib file itself. For grib1 the
procedure, starting from a grib file named `lfff00000000` is:

```
./grib2ctl.pl lfff00000000p>lfff00000000p.ctl
gribmap -i lfff00000000p.ctl
```

After that, in grads we should open the file `lfff00000000p.ctl`, not
directly the grib file.

For grib2 it is similar but we have to use a different tool (and have
`wgrib2` command installed):

```
./g2ctl lfff00000000p>lfff00000000p.ctl
gribmap -i lfff00000000p.ctl
```

### Postprocessing data for improving grads experience ###

Now we will use grib_api tools and libsim tools to process the grib
files before importing themn in grads.

#### Isolating surface fields only ####

Since Cosmo files `lfff????????` usually contain both surface and
upper air fields on native model levels, as well as soil fields on
underground levels, it may be useful to keep only surface data to
decrease the number of variables seen by grads.

The following script puts all COSMO lfff???????? files together
removing upper air and deep soil fields:

```
#!/bin/sh
rm -f surf.grib o.tmp
# loop on output fields
for file in lfff0???0000; do
echo $file
# eliminate upper air and soil fields
grib_copy -w typeOfLevel!=generalVertical/generalVerticalLayer/depthBelowLandLayer/depthBelowLand $file o.tmp
# put all time ranges together
cat o.tmp >>surf.grib
rm -f o.tmp
done
```
[download the script](../tools/make_surf.sh)

#### Accumulating on the desired interval ####

The file obtained in the previous operation is a step forward if we
are interesting only in visualizing surface fields, however we still
need some improvement.

Accumulated fields, such as surface precipitation, and averaged
fields, such as radiation fluxes, are usually computed from the
beginning of the run, while it is usually preferred to visualise
accumulation or averages between two output time intervals.

The following script removes accumulated and average fields from the
previous file, recomputes them on an hourly interval and puts the
result back in a single file together with the other surface
instantaneous fields:

```
#!/bin/sh
# isolate instantaneous fields
grib_copy -w productDefinitionTemplateNumber=0 surf.grib surf2.grib
# isolate average and accumulated fields
grib_copy -w typeOfStatisticalProcessing=0/1,productDefinitionTemplateNumber=8 surf.grib surfavgcum.grib
# recumulate on 1h intervals with libsim
vg6d_transform --comp-stat-proc=0:0 --comp-step='0 01' surfavgcum.grib avg.grib
# reaverage on 1h intervals with libsim
vg6d_transform --comp-stat-proc=1:1 --comp-step='0 01' surfavgcum.grib cum.grib
# append to instantaneous fields
cat avg.grib cum.grib >> surf2.grib
```
[download the script](../tools/cumulate_surf.sh)

Now `surf2.grib` is suitable for visualisation in grads:

```
g2ctl surf2.grib > surf2.ctl
gribmap -i surf2.ctl
# in grads we will open surf2.ctl
```

[up](README.md)