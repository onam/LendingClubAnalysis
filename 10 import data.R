
##==============================================================================
## INITIALIZE AND LOAD LIBRARIES
##==============================================================================

rm(list=ls())

library(data.table)

##==============================================================================
## READ IN DATA
##==============================================================================

# system.time(dat <- read.table('Data//LoanStatsNew.csv', skip=1, header=TRUE, sep=','))
# system.time(dat <- read.table('Data//LoanStatsNew.csv', skip=1, header=TRUE, nrows=143434, sep=','))
# system.time(dat <- read.table('Data//LoanStatsNew.csv', skip=1, header=TRUE, nrows=143433, sep=','))
system.time(dat <- read.table('Data//LoanStatsNew.csv', skip=1, header=TRUE, nrows=143432, sep=','))
datbackup = dat
dat = as.data.table(datbackup)
str(dat)


##==============================================================================
## CLEAN UP DATA
## Mostly convert factor columns to proper numeric or date format
##==============================================================================

## View the structure of any factor columns, which are usually imported wrong
str(dat[,which(sapply(dat, class)=='factor'), with=F])

## Convert some cols to numeric
dat$apr = as.numeric(gsub('%', '', as.character(dat$apr)))/100
dat$int_rate = as.numeric(gsub('%', '', as.character(dat$int_rate)))/100
dat$revol_util = as.numeric(gsub('%', '', as.character(dat$revol_util)))/100

## Convert some cols to date
dat$accept_d = as.Date(dat$accept_d)
dat$exp_d = as.Date(dat$exp_d)
dat$list_d = as.Date(dat$list_d)
dat$issue_d = as.Date(dat$issue_d)
dat$last_pymnt_d = as.Date(dat$last_pymnt_d)
dat$last_credit_pull_d = as.Date(dat$last_credit_pull_d)

## This one has some "null" values, which need to be converted
## to character, then nulls to NA, then converted to date
table(dat$next_pymnt_d, useNA='always')
dat$next_pymnt_d = as.character(dat$next_pymnt_d)
dat[next_pymnt_d=="null", next_pymnt_d:=NA]
dat$next_pymnt_d = as.Date(dat$next_pymnt_d)
table(dat$next_pymnt_d, useNA='always')

## This one has date and time values, so use POSIX to include times
dat$earliest_cr_line = as.POSIXct(dat$earliest_cr_line)

## View the structure of any factor columns, which are usually imported wrong
str(dat[,which(sapply(dat, class)=='factor'), with=F])


str(dat)

##==============================================================================
## SAVE RESULTS
##==============================================================================
saveRDS(dat, file='Data/LoanStatsNew_regular.RData')


