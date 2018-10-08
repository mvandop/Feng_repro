clear all
set more off
set matsize 11000

*** Directories
cd "Z:\home\j\MEGAsync\github\Feng_repro"

import excel "Feng_repdata.xlsx", sheet("Sheet1") firstrow
 
quietly tab State, gen(est)
eststo: reg Emigrants lnCorn year0005
eststo: reg Emigrants lnCornWheat year0005
esttab using "oppenheimer_pooledOLS.tex", booktabs label replace
eststo clear

egen st = group(State)
xtset st year0005
eststo: xtreg Emigrants lnCorn year0005, fe
eststo: xtreg Emigrants lnCorn year0005, re
eststo: xtreg Emigrants lnCornWheat year0005, fe
eststo: xtreg Emigrants lnCornWheat year0005, re
esttab using "oppenheimer_REandFE.tex", booktabs label replace drop(year0005)
eststo clear

eststo: ivreg Emigrants year0005 est* (lnCorn  = Precip annTemp summTemp)
eststo: ivreg Emigrants year0005 est* (lnCornWheat  = Precip annTemp summTemp)
esttab using "oppenheimer_2SLS.tex", booktabs label replace drop(year0005 est*)
eststo clear

eststo: ivregress liml  Emigrants year0005 est* (lnCorn  = Precip annTemp summTemp)
eststo: ivregress liml  Emigrants year0005 est* (lnCornWheat  = Precip annTemp summTemp)
esttab using "oppenheimer_LIML.tex", booktabs label replace drop(year0005 est*)
eststo clear
