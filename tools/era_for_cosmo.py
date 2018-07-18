#!/usr/bin/python

import optparse
import datetime
import os, shutil, sys
import ecmwfapi
#import ECMWFDataServer

def makedt(dts):
    try:
        return datetime.datetime(year=int(dts[0:4]), month=int(dts[4:6]),
                                 day=int(dts[6:8]), hour=int(dts[8:10]))
    except:
        print("date %s not valid" % (dts,))
        raise

def retrieve_level(reqbase, reqext={}, append=False):
    # merge requests
    req = reqbase.copy()
    req.update(reqext)
    
    if append: # save real target name and d/l request to a tmp target file
        savetarget = req['target']
        req['target'] = req['target']+'.tmp'
    server = ecmwfapi.ECMWFDataServer()
    server.retrieve(req)
    if append: # append to real target by file objects
        if os.path.isfile(req['target']):
            targetobj = open(savetarget, 'ab')
            shutil.copyfileobj(open(req['target'],'rb'), targetobj)
            targetobj.close()
            os.unlink(req['target']) # rm tmp target file
        req['target'] = savetarget # restore real target

    
def retrieve_time(now, inputtype, opts, step, outdir):
# base mars dictionary
    marsbase = {
        "class": opts.marsclass,
        "dataset": opts.dataset,
        "expver": "1",
        "stream": "oper",
        "date": now.strftime("%Y-%m-%d"),
        "time": now.strftime("%H:00:00"),
        "area": opts.area,
        "grid": opts.grid
    }

    if inputtype == "a":
        marsbase["type"] = "an"
        marsbase["target"] = os.path.join(outdir, now.strftime("eas%Y%m%d%H"))
    elif inputtype == "f":
        marsbase["type"] = "fc"
        marsbase["target"] = os.path.join(outdir, "efsf%02d%02d0000" % (step/24,step%24))
        marsbase["step"] = str(step)
    elif inputtype == "e":
        marsbase["type"] = "an"
        marsbase["target"] = os.path.join(outdir, "ec_ext.grib")

# specialized dictionaries
# variable
    marsml = {"levtype": "ml", "levelist": "all",
              "param": "u/v/w/t/q/clwc/ciwc/crwc/cswc/lnsp"}
    marspl = {"levtype": "pl", "levelist": "200", "param": "z"}
    marssfc = {"levtype": "sfc",
               "param": "skt/tsn/sd/src/stl1/stl2/stl3/stl4/swvl1/swvl2/swvl3/swvl4/ci/istl1"}
# constant
    marsextparml = {"levtype": "ml", "levelist": "1", "param": "z"}
    marsextparsfc = {"levtype": "sfc", "param": "z/lsm/slt"}

    print("Starting retrieving %s" % marsbase["target"])
    if inputtype == "a" or inputtype == "f":
        retrieve_level(marsbase, marsml, False)
        retrieve_level(marsbase, marspl, True)
        retrieve_level(marsbase, marssfc, True)
    else:
        retrieve_level(marsbase, marsextparml, False)
        retrieve_level(marsbase, marsextparsfc, True)

parser = optparse.OptionParser(usage="%prog --start-date=YYmmddHH [OPTIONS]",
                               description="""This program downloads data from public ECMWF archives of ERA5 and
ERA-Interim reanalysis projects, either in analysis mode or in
forecast mode, ready for Cosmo model.

Horizontal grid step is hardcoded to 0.25 deg for ERA5 and 0.5 deg for
ERA-Interim.

In analysis mode all the analyses between start-date and end-date at
step analysis-step are retrieved in the current directory, one file
per analysis time.

In forecast mode all the forecasts with reference time between
start-date and end-date at step analysis-step, from zero to
forecast-range forecast range at step forecast-step are retrieved in
the subdirectory with name YYYYmmddhh.

The file names are those expected by the Cosmo model.

No check is made on the availability of reference and forecast times
specified, so queries may fail.

In order for the program to work, you need to install the
ecmwf-api-client python package and have in your home directory a
valid license key for access to ECMWF public data.
"""
)
parser.add_option("--dataset", help="name of dataset to query, may be one of 'interim' for ERA-Interim or 'era5' for ERA5 [default: %default]",
                  default="era5")
parser.add_option("--input-type", help="type of input data, may be 'a(nalysis)' or 'f(orecast)' [default: %default]",
                  default="a")
parser.add_option("--start-date", help="initial time in format YYYYmmddhh")
parser.add_option("--end-date", help="final time in format YYYYmmddhh, for forecast input type it indicates the initial time of the last forecast retrieved, if not specified it is equal to start-date")
parser.add_option("--analysis-step", help="step in hours of successive analyses (for analysis input) or of successive forecast initial times (for forecast input) [default: %default]",
                  type="int", default=3)
parser.add_option("--forecast-step", help="step in hours for successive forecast steps (for forecast input type) [default: %default]",
                  type="int", default=3)
parser.add_option("--forecast-range", help="forecast range in hours (for forecast input type) [default: %default]",
                  type="int", default=12)
parser.add_option("--area", help="geographical bounds of the area to retrieve in the form 'N/W/S/E' [default: %default]",
                  default="13/63/-7/83")
parser.add_option("--subdir", help="subdirectory where to save output to avoid overwriting forecast files, default empty (current directory) for analysis mode and %Y%m%d%H for forecast mode")
parser.add_option("--extpardir", help="subdirectory where to save external constant parameters, this is done only once for the first reference time requested; if the argument is not provided, no external parameters are retrieved")

opts, args = parser.parse_args()

if opts.dataset == "era5":
    opts.marsclass = "ea"
    opts.grid = "0.25/0.25"
elif opts.dataset == "interim":
    opts.marsclass = "ei"
    opts.grid = "0.5/0.5"
else:
    print("Dataset %s not valid" % opts.dataset)
    sys.exit(1)

dtstart = makedt(opts.start_date)
if opts.end_date is None: opts.end_date = opts.start_date
dtend = makedt(opts.end_date)
dtstep = datetime.timedelta(hours=opts.analysis_step)

if opts.extpardir is not None:
    if opts.extpardir != "":
        try:
            os.makedirs(opts.extpardir)
        except:
            pass
    retrieve_time(dtstart, "e", opts, 0, opts.extpardir)

if opts.input_type.startswith("a"): # analysis mode
    dtnow = dtstart
    if opts.subdir is None:
        opts.subdir = ""

    while dtnow <= dtend:
        subdir = dtnow.strftime(opts.subdir)
        if subdir != "":
            try:
                os.makedirs(subdir)
            except:
                pass
        retrieve_time(dtnow, "a", opts, 0, subdir)
        dtnow = dtnow + dtstep
elif opts.input_type.startswith("f"): # forecast mode
    dtnow = dtstart
    if opts.subdir is None:
        opts.subdir = "%Y%m%d%H"

    while dtnow <= dtend:
        subdir = dtnow.strftime(opts.subdir)
        if subdir != "":
            try:
                os.makedirs(subdir)
            except:
                pass
# retrieve analysis and link it to first boundary file
        retrieve_time(dtnow, "a", opts, 0, subdir)
        try:
            os.unlink(os.path.join(subdir,"efsf00000000"))
        except:
            pass
        os.symlink(dtnow.strftime("eas%Y%m%d%H"),
        os.path.join(subdir,"efsf00000000"))
# retrieve following boundary files
        for h in range(opts.forecast_step,
                       opts.forecast_range+opts.forecast_step,
                       opts.forecast_step):
            retrieve_time(dtnow, "f", opts, h, subdir)
        dtnow = dtnow + dtstep
    
    
                 

