* ==============================================================================
* UGANDA PROXY MEANS TEST
* ==============================================================================

	* Eric Chu, Parker Essick, Leseine Gitau, and Olawumni Ola-Busari
	* Global Human Development Program, Georgetown University

	set more off
	clear all
	macro drop _all

		global path		"/Users/parkeressick/Desktop/Uganda-PMT" // change path
		global data 	"${path}/data/"
		global out		"${path}/output/"
	cd "${path}"
	
	use "$data/UNHS_2016_merged_all_modules.dta", clear
	
* ==============================================================================
* Parker
* ==============================================================================

* Setting up the data and poverty line
* ==============================================================================
	* Setting the survey data
	svyset cluster [pweight=wta_hh], vce(linearized) strata(strata)
	
	* Generate population weights at the household level
	gen wta_pop = wta_hh * hhsize

	* Generate national poverty line
	gen abs_pov_national = (wel_abs < pl_abs)

	* Tabulate and summarize poverty headcount ratio
	tab abs_pov_national [aw=wta_hh]
	sum abs_pov_national [aw=wta_hh]
		scalar pov_ratio=r(mean)
		
* Sources
* ==============================================================================

	/* 	Caitlin Brown, Martin Ravallion, and Dominique van de Walle. 2016. "A 
		Poor Means Test? Econometric Targeting in Africa." World Bank. */
		
	/* 	Hanna, et al. 2020. "The (lack of) Distortionary Effects of Proxy-Means
		Tests: Results from a Nationwide Experiment in Indonesia." */
		
		* Use demographic and asset ownership data to predict poverty status.
		* Includes regional/strata fixed effects
		* Main variables: TV/cell phone/WC ownership, number of rooms
		/* 	Other controls include: roof type, computer, boiling water, clean
			water, electricity, kerosene, LP gas, lease, lighting wattage, floor
			internet, house ownership, urban/rural, private/public toilet */

	/*	Adama Bah. 2015. "Finding the Best Indicators to Identify the Poor." */
	
		/* 	Best rural predictors: HH cooks with wood, TV, fridge, appliances
			# of rooms, house floor size, HH yrs schooling, vehicle, HH max edu,
			HH cooks with gas, # of HHM working, water inside house,
			HHH edu, toilet, HHM job status, water source, HH earnings */
		/* 	Best urban predictors: frige, avg schooling in HH, HHH max edu,
			# of rooms, HH cooks with gas/wood, floor size, floor type, drinking
			water source, toilet, vehicle, HHM school enrollment, water source
			in house, trash can, water from well, receivables (asset) */

* Potential variables of interest for PMT
* ==============================================================================



* Non-PMT Models
* ==============================================================================




* PMT Model
* ==============================================================================
	gen l_wel_abs = ln(wel_abs)
	
	xi: reg l_wel_abs i.subregion [iw=wta_hh]
		predict lnpmt if e(sample)
		gen pmt=exp(lnpmt)
		
	centile pmt, centile(`pov_ratio')
	gen poorpmt=(pmt<=`r(c_1)')
	
	sum poorpmt [iw=wta_hh]
	tab poor poorpmt [iw=wta_hh], nofreq row col
