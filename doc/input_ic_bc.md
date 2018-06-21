## Input model initial and boundary conditions ##

Input model data to be used as initial and boundary conditions should
then be provided with a particular naming scheme depending on the input model.

If the input model is ICON, as specifiend in the int2lm `INPUT`
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

It is suggested to get boundary data al least every 3 hours, however,
if you internet connection allows it, ICON can be retrieved also with
an hourly frequency.

If the input is ECMWF IFS model or ERA reanalysis we have

```
 &CONTRL
...
  yinput_model='IFS',
...
 /END
```

and the naming scheme is `igfffDDHH0000`, with `DD` equal to the number of
days of forecast and `HH` number of hours. For 3-hourly data up to 72
hours it will thus look like:

[next]()

[up](README.md)