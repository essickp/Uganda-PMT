* settings
set more off // <- always a helpful command if you run long do files

* set globals to load data
global PATH "C:\Users\wb525527\OneDrive - WBG\Documents\Uganda PER\data" // <- that's where you store the data
global results "${PATH}\results"  // <- that's where you save the results you produce

* load the data
use "${PATH}\UNHS_2016_merged_all_modules.dta", clear


********************************************************************************
************************* general **********************************************
********************************************************************************

* important variables:
* hid is the household identifier
* pid is the personal identifier




********************************************************************************
************************* welfare aggregate ************************************
********************************************************************************

* this is the variable giving household consumption
sum wel_abs

* if you run a regression, you might want to take the log of consumption.
gen l_wel_abs = ln(wel_abs)



********************************************************************************
************************* weights and poverty estimates ************************
********************************************************************************

* The weight variable is wta_hh (on an individual level)
* for example, if you want to look at the overall gender distribution in the country, do the following
tab sex [iw=wta_hh] // <- use importance weights as they replicate poplation totals

* generate population weights at the household level
* (multiply population weights by household size)
gen wta_pop = wta_hh * hhsize

tab sex [iw=wta_hh] if relathh9==1 // sex of household heads. weighed by population they represent

* generate the national poverty line
gen abs_pov_national = (wel_abs < pl_abs) // <- a household is defined as poor if it's (adult equivalence-adjusted) consumption is below the national poverty ine 

* the variable ctry_adq gives the equivalence scale that Uganda uses. You can use this one, or one of the internationally more commonly used ones such as modified OECD.
sum ctry_adq

* tabulate poverty
tab abs_pov_national [aw=wta_hh] // <- analytical weights (aw) weigh the observations by their sampling probability
* (so all the weights sum up to the number of observations)
// <- 20% of the population is poor according to the national poverty line


********************************************************************************
************************* merge in additional data *****************************
********************************************************************************

* first step: save current dataset in a temporary file (gets deleted after execution of code)
tempfile uganda_1
save "`uganda_1'", replace 

* load dataset to be merged
use "C:\Users\wb525527\OneDrive - WBG\Documents\Uganda PER\project georgetown\data for students\raw files\pov16.dta",clear // <- adjust file path

rename hhid hid // <- rename household ID  

tostring hid, replace

keep hid cpexp30 fcpexp30  // <- keep necessary variables (optional). You could also merge the entire dataset.

* merge using the temporary dataset
merge 1:n hid using "`uganda_1'" // <- using the temporary dataset
drop if _merge==2 // <- drop unused observations from using data




********************************************************************************
************************* set survey design ************************************
********************************************************************************

* set survey design
svyset cluster [pweight=wta_hh], vce(linearized) strata(strata) // <- this tells stata how the survey design works
* so the regressions commands can be adjusted accordingly

* survey regression command
xi: svy: reg wel_abs i.subregion // <- just an example
