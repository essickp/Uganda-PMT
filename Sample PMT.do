* ==============================================================================
* SAMPLE PMT FROM GHDP 638 IN-CLASS EXERCISE
* ==============================================================================
	cd "{insert cd}"
	use "Class 12 Targeting", clear

* Define "official" or "actual" poor
	gen poor=(pccons<16800)
	summ poor[fweight=hhsize]

* METHOD 1: DEFINE UNIVERSAL POOR *
	gen pooru=1
	label var pooru "Eligible: universal targeting"

	* Error of inclusion and exclusion
		tab poor pooru [fweight=hhsize], nofreq row col

* METHOD 2: DEFINE DEMOGRAPHIC POOR *
	gen poord=((nr_babies+ nr_kids)>0)
	label var poord "Eligible: demographic targeting"

	* Error of inclusion and exclusion
		tab poor poord [fweight=hhsize], nofreq row col

* METHOD 3: DEFINE GEOGRAPHIC POOR *
	tab region poor [fweight=hhsize], nofreq row
	gen poorg=(( region==7 | region==8|region==11|region==12|region==16 ))
	label var poorg "Eligible: geographic targeting"

	* Error of inclusion and exclusion
		tab poor poorg [fweight=hhsize], nofreq row col

* METHOD 4: DEFINE PROXY-MEANS TESTED POOR *

	* Generate log of consumption
		gen lncons=ln(pccons)

	* Estimate a regression made of (the log of) consumption
		reg lncons nr_babies nr_kids nr_adults nr_elderly h_pensioner		///
			h_notworking h_specialist h_clerical h_construction h_trade 	///
			h_healtheduc s_publicsector s_notworking utilitybill nrcars		///
			nrvacuumcleaners nrmobiles poorg

	* Predict the (log of) consumption
		predict lnconspred

	* Take the anti-log of the predicted log of consumption
		gen pcconspred=exp(lnconspred)

	* Inspect the distribution of the predicted consumption
		* Determine the cut-off for the bottom 30% to match the official poverty
		* headcount ratio
			tab pcconspred [fweight=hhsize]
				/// 17,800 is the PL that yields 30% poverty rate

	* Define PTM poor
		gen poorpmt=(pcconspred<17800)
		label var poorpmt "Eligible: PMT targeting"

	* Error of inclusion and exclusion
		tab poor poorpmt [fweight=hhsize], nofreq row col

	* Compare targeting method
		tab poor pooru [fweight=hhsize]
		tab poor poord [fweight=hhsize]
		tab poor poorg [fweight=hhsize]
		tab poor poorpmt [fweight=hhsize]
		
		tab poor pooru [fweight=hhsize], nofreq row col
		tab poor poord [fweight=hhsize], nofreq row col
		tab poor poorg [fweight=hhsize], nofreq row col
		tab poor poorpmt [fweight=hhsize], nofreq row col
					
			** Above, error of inclusion in PMT is 30.43%, exlusion is 29.28%.
