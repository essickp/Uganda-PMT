* ==============================================================================
* UGANDA PROXY MEANS TEST
* ==============================================================================

	* Eric Chu, Parker Essick, Leseine Gitau, Olawumni Ola-Busari
	* Global Human Development Program, Georgetown University

	set more off
	clear all
	macro drop _all

		global path		"/Users/parkeressick/Desktop/Uganda PMT"
		global data 	"${path}/data/"
		global out		"${path}/output/"
	cd "${path}"
	
	use "$data/UNHS_2016_merged_all_modules.dta", clear
