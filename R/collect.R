###############################################################################
## Collect the data that will be used in the Shiny College Rankings App
###############################################################################

## Variables to include in the ranking
## enrollment size, selectivity, yield, netcost, inst aid pct, retention, grad

library(stringr)


###############################################################################
## Grab the IPEDS datasets
###############################################################################
BASE = "http://nces.ed.gov/ipeds/datacenter/data/"
SURVEYS = c("HD2012", "IC2012", "EF2012D", "SFA1112", "GR2012")
for (S in SURVEYS) {
  # build the URL
  URL = paste0(BASE, S, ".zip")
  # download the zip file
  DEST = paste0("rawdata/", S, ".zip")
  download.file(URL, DEST)
}



###############################################################################
## Unzip the files
###############################################################################
ZIP = list.files("rawdata", pattern=".zip$", full.names = T)
for (Z in ZIP) {
  # unzip the file
  unzip(Z, exdir = "rawdata")
  # read in the csv file
  CSV = list.files("rawdata", pattern=".csv$", full.names=T)
  tmp = read.table(CSV, header=T, sep=",", stringsAsFactors=F)
  # assign it to the names object
  S = str_extract(Z, pattern="[A-Z0-9]+")
  cat(Z)
  assign(S, tmp)
  # remove the csv
  file.remove(CSV)
}



###############################################################################
## create the schools to include for the rankings
###############################################################################
schools = subset(HD2012, SECTOR %in% c(1,2) & 
                   OBEREG %in% c(1:8) & 
                   PSET4FLG == 1, 
                 select = "UNITID")
schools = schools$UNITID




###############################################################################
## build the dataset to be used in the BYO rankings Shiny App
###############################################################################

## start the data
rankings = subset(HD2012, UNITID %in% schools, 
                  select = c(UNITID, INSTNM, CITY, STABBR, ZIP))


## the admissions data
tmp = subset(IC2012, UNITID %in% schools, select = c(UNITID, ENRLT, APPLCN, ADMSSN))
rankings = merge(rankings, tmp)

## aid data
tmp = subset(SFA1112, UNITID %in% schools, select = c(UNITID, IGRNT_P, NPGRN2))
rankings =  merge(rankings, tmp)


## FT retention and SF ratio
tmp = subset(EF2012D, UNITID %in% schools, select = c(UNITID, RET_PCF, STUFACR))
rankings =  merge(rankings, tmp)


## grad rate -- need to grab multipe rows, reshape, calc
## I believe the rows I want to are GRTYPE2 =  adju cohort, GRTYPE3 = completers
tmp_c = subset(GR2012, UNITID %in% schools & GRTYPE == 2, select = c(UNITID, GRTOTLT))
names(tmp_c)[2] = "cohort"
tmp_g = subset(GR2012, UNITID %in% schools & GRTYPE == 3, select = c(UNITID, GRTOTLT))
names(tmp_g)[2] = "grads"
tmp = merge(tmp_c, tmp_g)
tmp$gradrate6 = round(tmp$grads / tmp$cohort * 100, 0) ##converted to other rates
tmp_f = subset(tmp, select = c(UNITID, gradrate6))
rankings =  merge(rankings, tmp_f)


## ensure datatypes
rankings$ENRLT = as.numeric(rankings$ENRLT)
rankings$APPLCN = as.numeric(rankings$APPLCN)
rankings$ADMSSN = as.numeric(rankings$ADMSSN)
rankings$IGRNT_P = as.numeric(rankings$IGRNT_P)
rankings$NPGRN2 = as.numeric(rankings$NPGRN2)
rankings$RET_PCF = as.numeric(rankings$RET_PCF)
rankings$STUFACR = as.numeric(rankings$STUFACR)
rankings$gradrate6 = as.numeric(rankings$gradrate6)

## keep only complete cases
rankings = rankings[complete.cases(rankings), ]

## calculate yield rate
rankings = transform(rankings, yield = round(ENRLT / ADMSSN*100, 0))

## calculate admit rate
rankings = transform(rankings, admitrate = round(ADMSSN / APPLCN*100, 0))


###############################################################################
## save the data
###############################################################################
saveRDS(rankings, "data/rankings-db.rds")







