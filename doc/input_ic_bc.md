## Input model initial and boundary conditions ##

Input model data to be used as initial and boundary conditions should
then be provided with a particular naming scheme depending on the input model.

### ICON ###

If the input model is ICON, as specified in the int2lm `INPUT`
namelist:

```
 &CONTRL
...
  yinput_model='ICON',
...
 /END
```

the naming scheme is `igfffDDHH0000`, with `DD` equal to the number of
days of forecast and `HH` number of hours. For 3-hourly data up to 72
hours it will thus look like:

```
igfff00000000
igfff00030000
igfff00060000
...
igfff00180000
igfff01000000
igfff01030000
...
igfff03000000
```

It is suggested to get boundary data at least every 3 hours, however,
if you internet connection allows it, ICON can be retrieved also with
an hourly frequency.

### IFS/ERA ###

If the input is ECMWF IFS model or ERA reanalysis we have

```
 &CONTRL
...
  yinput_model='IFS',
...
 /END
```

and the naming scheme is `efsfDDHH0000`, with `DD` equal to the number
of days of forecast and `HH` number of hours. An analysis file
(usually equal to the first boundary file) named with the date and
time of the analisys `easYYYYMMDDHH`, is also needed. For 3-hourly
data up to 72 hours it will thus look like:

```
eas2018062000 -> efsf00000000
efsf00000000
efsf00030000
efsf00060000
...
efsf00180000
efsf01000000
efsf01030000
...
efsf03000000
```

### COSMO ###

If the input model is COSMO itself, we set:

```
 &CONTRL
...
  yinput_model='IFS',
...
 /END
```

and the expected file names are exactly those produced by COSMO model,
e.g.:

```
laf2018062000 -> lfff00000000
lfff00000000
lfff00030000
lfff00060000
...
lfff00180000
lfff01000000
lfff01030000
...
lfff03000000
```

Of course the output of the coarse COSMO model run must contain all
the 3-d prognostic variables and several surface and soil variables in
order for int2lm to prepare a complete input for the following nested
run, this will be explained when namelists will be examined in detail.

[next]()

[up](README.md)