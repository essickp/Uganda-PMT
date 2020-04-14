* ==============================================================================
* UGANDA PROXY MEANS TEST
* ==============================================================================

	* Eric Chu, Parker Essick, Leseine Gitau, and Olawumni Ola-Busari
	* Global Human Development Program, Georgetown University

	set more off
	clear all
	macro drop _all

		global path		"{insert your path}"
		global data 	"${path}/data/"
		global out		"${path}/output/"
	cd "${path}"
	
	use "$data/UNHS_2016_merged_all_modules.dta", clear
	
	* Sample edit for GitHub
