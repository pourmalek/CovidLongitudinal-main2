
clear all

cd "$pathCovidLongitudinal/countries/India"

capture log close 

log using "log CovidLongitudinal India 1 Process.smcl", replace

***************************************************************************
* This is "do CovidLongitudinal India 1 Process.do"

* Project: Longitudinal assessment of COVID-19 models 

* Objective: Process the reported deaths by JOHN and 
	* the estimates by models (DELP, IHME, IMPE, LANL, UCLA, YYGU)
	* for each country ---->> India <<----                                                                 
***************************************************************************



**** "do CovidLongitudinal India 1 Process.do"
**** Get Daily deaths forecast only: DayDeaMeFo`model'update where `model' is DELP, IHME, IMPE, LANL, UCLA, YYGU


** input data files: "$pathCovidLongitudinal/download/`model'/`model' countries long.dta"
**                   "$pathCovidLongitudinal/download/JOHN"
**                   "$pathCovidLongitudinal/download/`model'"

** output data files: "`model' India.dta"
**                   "ALL MODLES India.dta"

** output data dictionary files: "India ALL MODELS update dates data dictionary.csv"
**                               "`model' India data dictionary.csv"
**                               "ALL MODLES India data dictionary.csv"

** graphs:
** "graph 02 India `model' C19 daily deaths all updates.pdf"
** "graph 02 India ALL MODELS C19 daily deaths all updates.pdf"




************************************************************************

* get update dates on which country available in each model


local list DELP IHME IMPE LANL UCLA YYGU

foreach model of local list {

	use "$pathCovidLongitudinal/download/`model'/`model' countries long.dta", clear 
	
	di in red "`model'" " India absent update_date_block"
	
	qui keep if loc_grand_name == "India"
	
	keep if absent == 0
	
	gen model = "`model'"
	
	order model
	
	di "`model'"
	
	di in red `r(N)'
	
	keep model loc_grand_name absent update_date_block
	
	order model loc_grand_name absent update_date_block
	
	tostring update_date_block, gen(update_date_block_string)
	
	gen slash = " ///"
	
	gen update_date_block_slash = update_date_block_string + slash
	
	drop slash
	
	label var model "epidemic model being studied"
	
	label var loc_grand_name "country"
	
	label var absent "this country is absent in this model update"
	
	label var update_date_block "update date block"
	
	label var update_date_block_string "update date block string"
	
	label var update_date_block_slash "update date block slash"

	qui compress
	
	save "India `model' update dates.dta", replace

}
*






use "India DELP update dates.dta", clear 

local list DELP IHME IMPE LANL UCLA YYGU

foreach model of local list {
	
	append using "India `model' update dates.dta"
	
	duplicates drop
	
}
*

save "India ALL MODELS update dates.dta", replace
	
export excel using "India ALL MODELS update dates.xlsx", replace firstrow(variables) 



******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "India ALL MODELS update dates data dictionary.csv", replace 
	
restore







*********************
grstyle init

grstyle color background white







*********************
* gen calendar file

clear

di td(01jan2020) // 21915

di td(01jan2024) // 23376

di td(01jan2024) - td(01jan2020) + 1 // 732



set obs 1462

gen date = .

replace date = 21915 in 1

replace date = date[_n-1] + 1 in 2/l

replace date = date[_n-1] + 1 in 2/1462

format date %tdDDMonCCYY

codebook date

save "calendar.dta", replace







**************************************************************************

* JOHN

cd "$pathCovidLongitudinal/download/JOHN"

use "CovidLongitudinal JOHN.dta", clear 

keep if loc_grand_name == "India"

keep date DayDeaMeSmJOHNIND

label var date "calendar date"

qui compress

cd "$pathCovidLongitudinal/countries/India"

save "JOHN India.dta", replace 




* graph India JOHN daily deaths

twoway ///
(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths) title("C19 daily deaths, India, JOHN", size(medium) color(black)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2))

qui graph export "graph 02 India JOHN C19 daily deaths reported.pdf", replace








**************************************************************************

* DELP

local list ///
20200417 ///
20200424 ///
20200501 ///
20200509 ///
20200517 ///
20200524 ///
20200531 ///
20200607 ///
20200614 ///
20200621 ///
20200628 ///
20200704 ///
20200718 ///
20200723 ///
20200801 ///
20200815 ///
20200829 ///
20200912 ///
20200926 ///
20201008 ///
20201022 ///
20201105 ///
20201119 ///
20201203 ///
20201217 ///
20201231 ///
20210114 ///
20210128 ///
20210211 ///
20210225 ///
20210311 ///
20210325 ///
20210408 ///
20210422 ///
20210506 ///
20210520 ///
20210603 ///
20210610 ///
20210617 ///
20210624 ///
20210701 ///
20210708 ///
20210715 ///
20210722 ///
20210729 ///
20210805 ///
20210812 ///
20210819 ///
20210826 ///
20210902 ///
20210909 ///
20210916 ///
20210923 ///
20210930 ///
20211007 ///
20211014 ///
20211021 ///
20211028 ///
20211104 ///
20211111 ///
20211118 ///
20211125 ///
20211202 ///
20211209 ///
20211216 ///
20211223 ///
20211230 ///
20220106 ///
20220113 ///
20220114 ///
20220115 ///
20220116 ///
20220117 ///
20220118 ///
20220119 ///
20220120 ///
20220121 ///
20220122 ///
20220123 ///
20220124 ///
20220125 ///
20220126 ///
20220127 ///
20220128 ///
20220129 ///
20220130 ///
20220131 ///
20220201 ///
20220202 ///
20220203 ///
20220204 ///
20220205 ///
20220206 ///
20220207 ///
20220208 ///
20220209 ///
20220210 ///
20220211 ///
20220212 ///
20220213 ///
20220214 ///
20220215 ///
20220216 ///
20220217 ///
20220218 ///
20220219 ///
20220220 ///
20220221 ///
20220222 ///
20220223 ///
20220224 ///
20220225 ///
20220226 ///
20220227 ///
20220228 ///
20220301 ///
20220302 ///
20220303 ///
20220304 ///
20220305 ///
20220306 ///
20220307 ///
20220308 ///
20220309 ///
20220310 ///
20220311 ///
20220312 ///
20220313 ///
20220314 ///
20220315 ///
20220316 ///
20220317 ///
20220318 ///
20220319 ///
20220320 ///
20220321 ///
20220322 ///
20220323 ///
20220324 ///
20220325 ///
20220326 ///
20220327 ///
20220328 ///
20220329 ///
20220330 ///
20220331 ///
20220401 ///
20220402 ///
20220403 ///
20220404 ///
20220405 ///
20220406 ///
20220407 ///
20220408 ///
20220409 ///
20220410 ///
20220411 ///
20220412 ///
20220413 ///
20220414 ///
20220415 ///
20220416 ///
20220417 ///
20220418 ///
20220419 ///
20220420 ///
20220421 ///
20220422 ///
20220423 ///
20220424 ///
20220425 ///
20220426 ///
20220427 ///
20220428 ///
20220429 ///
20220430 ///
20220501 ///
20220502 ///
20220503 ///
20220504 ///
20220505 ///
20220506 ///
20220507 ///
20220508 ///
20220509 ///
20220510 ///
20220511 ///
20220512 ///
20220513 ///
20220514 ///
20220515 ///
20220516 ///
20220517 ///
20220518 ///
20220519 ///
20220520 ///
20220521 ///
20220522 ///
20220523 ///
20220524 ///
20220525 ///
20220526 ///
20220527 ///
20220528 ///
20220529 ///
20220530 ///
20220531 ///
20220601 ///
20220602 ///
20220603 ///
20220604 ///
20220605 ///
20220606 ///
20220607 ///
20220608 ///
20220609 ///
20220610 ///
20220611 ///
20220612 ///
20220613 ///
20220614 ///
20220615 ///
20220616 ///
20220617 ///
20220618 ///
20220619 ///
20220620 ///
20220621 ///
20220622 ///
20220623 ///
20220624 ///
20220625 ///
20220626 ///
20220627 ///
20220628 ///
20220629 ///
20220630 ///
20220701 ///
20220702 ///
20220703 ///
20220704 ///
20220705 ///
20220706 ///
20220707 ///
20220708 ///
20220709 ///
20220710 ///
20220711 ///
20220712 ///
20220713 ///
20220714 ///
20220715 ///
20220716 ///
20220717 ///
20220718 ///
20220719 ///
20220720 ///
20220721 ///
20220722 ///
20220723 ///
20220724 ///
20220725 ///
20220726 ///
20220727 ///
20220728 ///
20220729 ///
20220730 ///
20220731 ///
20220801 ///
20220802 ///
20220803 ///
20220804 ///
20220805 ///
20220806 ///
20220807 ///
20220808 ///
20220809 ///
20220810 ///
20220811 ///
20220812 ///
20220813 ///
20220814 ///
20220815 ///
20220816 ///
20220817 ///
20220818 ///
20220819 ///
20220820 ///
20220821 ///
20220822 ///
20220823 ///
20220824 ///
20220825 ///
20220826 ///
20220827 ///
20220828 ///
20220829 ///
20220830 ///
20220831 ///
20220901 ///
20220902 ///
20220903 ///
20220904 ///
20220905 ///
20220906 ///
20220907 ///
20220908 ///
20220909 ///
20220910 ///
20220911 ///
20220912 ///
20220913 ///
20220914 ///
20220915


foreach update of local list {
	 	
	cd "$pathCovidLongitudinal/download/DELP"
	
	di in red "This is DELP update " `update'

	use "CovidLongitudinal DELP `update'.dta", clear
	
	keep if loc_grand_name == "India" 

	duplicates drop		
	
	
	
	* gen daily deaths
		
	gen DayDeaMeRaDELP`update' =  TotDeaMeRaDELP`update'[_n] - TotDeaMeRaDELP`update'[_n-1] 
	
	label var DayDeaMeRaDELP`update' "Daily deaths mean raw DELP"
	
	drop TotDeaMeRaDELP`update' 
	
	
	
	
	* smooth
	
	sort loc_grand_name date
	
	qui tsset date, daily   
			
	qui tssmooth ma DayDeaMeRaDELP`update'_window = DayDeaMeRaDELP`update' if DayDeaMeRaDELP`update' >= 0, window(3 1 3) 

	qui tssmooth ma DayDeaMeSmDELP`update' = DayDeaMeRaDELP`update'_window, weights( 1 2 3 <4> 3 2 1) replace

	drop *_window
	
	label var DayDeaMeSmDELP`update' "Daily deaths mean smooth DELP" 
	
	
	
	* gen Daily deaths smooth forecast only 
			
	clonevar DayDeaMeFoDELP`update' = DayDeaMeSmDELP`update' 
	
	label var DayDeaMeFoDELP`update' "Daily deaths mean smooth forecast only DELP"
				
	replace DayDeaMeFoDELP`update' = . if date < update_date`update' 

	
	
	
	cd "$pathCovidLongitudinal/countries/India"
	
	
	merge m:1 date using "calendar.dta"
	
	drop _merge
	
	qui compress
	
	save "DELP `update' India.dta", replace 

}
*




* merge updates

cd "$pathCovidLongitudinal/countries/India"

foreach update of local list {

	merge m:m date using "DELP `update' India.dta"
	
	drop _merge

}
*	

qui compress

save "DELP India.dta", replace




* add JOHN

merge m:m date using "JOHN India.dta"

drop _merge

qui compress

save "DELP India.dta", replace



******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "DELP India data dictionary.csv", replace 
	
restore



foreach update of local list {
	
	* graph India DELP daily deaths each update 
	
	twoway ///
	(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 	
	(line DayDeaMeFoDELP`update' date, sort lwidth(thin) lcolor(red)) /// 
	if date >= td(01Jan2020) & date <= td(01Jan2023) ///
	, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
	xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
	ytitle(Daily deaths) title("C19 daily deaths, DELP, update `update'", size(medium) color(black)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
	subtitle("India, forecast only") legend(position(6) order(1 "JOHN" 2 "DELP forecast ") rows(1) size(small)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) 
	
	qui graph export "graph 01 India DELP daily deaths update `update'.pdf", replace	

}





* graph India DELP daily deaths all updates

twoway ///
(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) ///
(line DayDeaMeFoDELP20200417 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200424 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200501 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200509 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200517 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200524 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200531 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200607 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200614 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200621 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200628 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200704 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200718 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200723 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200801 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200815 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200829 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200912 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20200926 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20201008 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20201022 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20201105 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20201119 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20201203 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20201217 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20201231 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210114 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210128 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210211 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210225 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210311 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210325 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210408 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210422 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210506 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210520 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210603 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210610 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210617 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210624 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210701 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210708 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210715 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210722 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210729 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210805 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210812 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210819 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210826 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210902 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210909 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210916 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210923 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20210930 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211007 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211014 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211021 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211028 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211104 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211111 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211118 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211125 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211202 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211209 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211216 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211223 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20211230 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220106 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220113 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220114 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220115 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220116 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220117 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220118 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220119 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220120 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220121 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220122 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220123 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220124 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220125 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220126 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220127 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220128 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220129 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220130 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220131 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220201 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220202 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220203 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220204 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220205 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220206 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220207 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220208 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220209 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220210 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220211 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220212 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220213 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220214 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220215 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220216 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220217 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220218 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220219 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220220 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220221 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220222 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220223 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220224 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220225 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220226 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220227 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220228 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220301 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220302 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220303 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220304 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220305 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220306 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220307 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220308 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220309 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220310 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220311 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220312 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220313 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220314 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220315 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220316 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220317 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220318 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220319 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220320 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220321 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220322 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220323 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220324 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220325 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220326 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220327 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220328 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220329 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220330 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220331 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220401 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220402 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220403 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220404 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220405 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220406 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220407 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220408 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220409 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220410 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220411 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220412 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220413 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220414 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220415 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220416 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220417 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220418 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220419 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220420 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220421 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220422 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220423 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220424 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220425 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220426 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220427 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220428 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220429 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220430 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220501 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220502 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220503 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220504 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220505 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220506 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220507 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220508 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220509 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220510 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220511 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220512 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220513 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220514 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220515 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220516 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220517 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220518 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220519 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220520 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220521 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220522 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220523 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220524 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220525 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220526 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220527 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220528 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220529 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220530 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220531 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220601 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220602 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220603 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220604 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220605 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220606 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220607 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220608 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220609 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220610 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220611 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220612 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220613 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220614 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220615 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220616 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220617 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220618 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220619 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220620 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220621 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220622 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220623 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220624 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220625 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220626 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220627 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220628 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220629 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220630 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220701 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220702 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220703 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220704 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220705 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220706 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220707 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220708 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220709 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220710 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220711 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220712 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220713 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220714 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220715 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220716 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220717 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220718 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220719 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220720 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220721 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220722 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220723 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220724 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220725 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220726 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220727 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220728 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220729 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220730 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220731 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220801 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220802 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220803 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220804 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220805 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220806 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220807 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220808 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220809 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220810 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220811 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220812 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220813 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220814 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220815 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220816 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220817 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220818 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220819 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220820 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220821 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220822 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220823 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220824 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220825 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220826 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220827 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220828 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220829 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220830 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220831 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220901 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220902 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220903 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220904 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220905 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220906 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220907 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220908 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220909 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220910 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220911 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220912 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220913 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220914 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220915 date, sort lwidth(thin) lcolor(red)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths) title("C19 daily deaths, India, DELP, all updates", size(medium) color(black)) ///
legend(position(6) order(1 "JOHN" 2 "DELP forecast ") rows(1) size(small)) legend(region(lcolor(none))) legend(bexpand) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2))

qui graph export "graph 02 India DELP C19 daily deaths all updates.pdf", replace














**************************************************************************

* IHME 


local list ///
20200903 ///
20200911 ///
20200918 ///
20200924 ///
20201002 ///
20201009 ///
20201015 ///
20201022 ///
20201029 ///
20201112 ///
20201119 ///
20201203 ///
20201210 ///
20201217 ///
20201223 ///
20210115 ///
20210122 ///
20210128 ///
20210204 ///
20210212 ///
20210220 ///
20210225 ///
20210306 ///
20210311 ///
20210317 ///
20210325 ///
20210401 ///
20210409 ///
20210416 ///
20210423 ///
20210506 ///
20210514 ///
20210521 ///
20210528 ///
20210604 ///
20210610 ///
20210618 ///
20210625 ///
20210702 ///
20210715 ///
20210723 ///
20210730 ///
20210806 ///
20210820 ///
20210826 ///
20210902 ///
20210910 ///
20210916 ///
20210923 ///
20210930 ///
20211015 ///
20211021 ///
20211104 ///
20211119 ///
20211221 ///
20220108 ///
20220114 ///
20220121 ///
20220204 ///
20220218 ///
20220321 ///
20220408 ///
20220506 ///
20220610 ///
20220719 ///
20220912 ///
20221024 ///
20221118 ///
20221216


foreach update of local list {

	cd "$pathCovidLongitudinal/download/IHME"
	
	di in red "This is IHME update " `update'

	use "IHME all countries `update'.dta", clear
	
	rename location_name country
	
	keep if country == "India" 
	
	duplicates drop
	
	capture drop counter one_or_two
	
	rename country loc_grand_name
	
	label var loc_grand_name "country"

	capture label var DayDeaMeRaIHME`update' "Daily deaths mean raw IHME" 

	label var DayDeaMeSmIHME`update' "Daily deaths mean smoothed IHME" 
	
	label var date "calendar date"
	

	
	* gen daily deaths // done in /code/downloads/IHME/do CovidLongitudinal IHME.do
	
	
	
	* smooth // done in /code/downloads/IHME/do CovidLongitudinal IHME.do
	
		

	
	
	* gen Daily deaths smooth forecast only
			
	clonevar DayDeaMeFoIHME`update' = DayDeaMeSmIHME`update' 
	
	label var DayDeaMeFoIHME`update' "Daily deaths mean smooth forecast only IHME"
	
	gen update_date`update' = date("`update'", "YMD")
	
	gen epoch`update' = update_date`update'
	
	replace DayDeaMeFoIHME`update' = . if date < update_date`update' 


	
	/* local epoch`update' = epoch`update' // for xline(`epoch202YNNDD',
	
	di %td `epoch`update''
	
	local wanted : di %td `epoch`update'' // for denoted with red line: `wanted'"
	
	
	* graph India IHME daily deaths epoch each update 
	
	twoway ///
	(line DayDeaMeFoIHME`update' date, sort lwidth(thin) lcolor(black)) /// 
	if date >= td(01Jan2020) & loc_grand_name != "" ///
	, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
	xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.2fc)) ///
	ytitle(Daily deaths) title("C19 daily deaths, India, IHME, update `update'", size(medium) color(black)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
	xline(`epoch`update'', lwidth(thin) lcolor(red)) ///
	subtitle("forecast  start date is denoted with red line: `wanted'") ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) 
	*/
	
	cd "$pathCovidLongitudinal/countries/India"
	
	/* qui graph export "graph 00 India IHME daily deaths epoch `update'.pdf", replace */
	
	capture drop location_id population_2022 population_2021 population_2020
	
	label var update_date`update' "update date"

	label var epoch`update' "epoch IHME"
	
	capture label var location_id "location id IHME"
	
	capture label var deaths_data_type "deaths data type IHME"
	
	merge m:1 date using "calendar.dta"
	
	drop _merge
	
	qui compress
	
	save "IHME `update' India.dta", replace emptyok	
	


}
*












* merge updates

cd "$pathCovidLongitudinal/countries/India"

foreach update of local list {

	merge m:m date using "IHME `update' India.dta"
	
	drop _merge

}
*	

qui compress

save "IHME India.dta", replace




* add JOHN

merge m:1 date using "JOHN India.dta"

drop _merge

qui compress

save "IHME India.dta", replace



******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "IHME India data dictionary.csv", replace 
	
restore



foreach update of local list {
	
	* graph India IHME daily deaths each update 
	
	twoway ///
	(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 	
	(line DayDeaMeFoIHME`update' date, sort lwidth(thin) lcolor(black)) /// 
	if date >= td(01Jan2020) & date <= td(01Jan2023) ///
	, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
	xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
	ytitle(Daily deaths) title("C19 daily deaths, IHME, update `update'", size(medium) color(black)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
	subtitle("India, forecast only") legend(position(6) order(1 "JOHN" 2 "IHME forecast ") rows(1) size(small)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) 
	
	qui graph export "graph 01 India IHME daily deaths update `update'.pdf", replace	

}




* graph India IHME daily deaths all updates

twoway ///
(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 
(line DayDeaMeFoIHME20200903 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20200911 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20200918 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20200924 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201002 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201009 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201015 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201022 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201029 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201112 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201119 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201203 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201210 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201217 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20201223 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210115 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210122 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210128 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210204 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210212 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210220 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210225 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210306 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210311 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210317 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210325 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210401 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210409 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210416 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210423 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210506 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210514 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210521 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210528 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210604 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210610 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210618 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210625 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210702 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210715 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210723 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210730 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210806 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210820 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210826 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210902 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210910 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210916 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210923 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20210930 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20211015 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20211021 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20211104 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20211119 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20211221 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220108 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220114 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220121 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220204 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220218 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220321 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220408 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220506 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220610 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220719 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20220912 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20221024 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20221118 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20221216 date, sort lwidth(thin) lcolor(black)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths) title("C19 daily deaths, India, IHME, all updates", size(medium) color(black)) ///
legend(position(6) order(1 "JOHN" 2 "IHME forecast ") rows(1) size(small)) legend(region(lcolor(none))) legend(bexpand) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2))

qui graph export "graph 02 India IHME C19 daily deaths all updates.pdf", replace












**************************************************************************

* IMPE

local list ///
20200428 ///
20200429 ///
20200430 ///
20200501 ///
20200502 ///
20200503 ///
20200504 ///
20200505 ///
20200506 ///
20200507 ///
20200508 ///
20200509 ///
20200510 ///
20200511 ///
20200512 ///
20200513 ///
20200514 ///
20200515 ///
20200516 ///
20200517 ///
20200519 ///
20200520 ///
20200521 ///
20200522 ///
20200523 ///
20200524 ///
20200525 ///
20200526 ///
20200527 ///
20200528 ///
20200529 ///
20200530 ///
20200531 ///
20200601 ///
20200602 ///
20200603 ///
20200604 ///
20200606 ///
20200609 ///
20200614 ///
20200616 ///
20200619 ///
20200621 ///
20200623 ///
20200626 ///
20200628 ///
20200702 ///
20200703 ///
20200704 ///
20200707 ///
20200711 ///
20200714 ///
20200715 ///
20200718 ///
20200720 ///
20200722 ///
20200725 ///
20200727 ///
20200731 ///
20200808 ///
20200810 ///
20200811 ///
20200813 ///
20200814 ///
20200817 ///
20200823 ///
20200825 ///
20200827 ///
20200831 ///
20200902 ///
20200906 ///
20200908 ///
20200912 ///
20200915 ///
20200919 ///
20200923 ///
20200925 ///
20201003 ///
20201006 ///
20201012 ///
20201019 ///
20201025 ///
20201028 ///
20201101 ///
20201110 ///
20201114 ///
20201118 ///
20201123 ///
20201129 ///
20201204 ///
20201212 ///
20201220 ///
20201226 ///
20210104 ///
20210110 ///
20210112 ///
20210118 ///
20210124 ///
20210130 ///
20210203 ///
20210210 ///
20210217 ///
20210226 ///
20210305 ///
20210312 ///
20210319 ///
20210329 ///
20210406 ///
20210417 ///
20210424 ///
20210510 ///
20210516 ///
20210522 ///
20210527 ///
20210604 ///
20210611 ///
20210618 ///
20210626 ///
20210702 ///
20210709 ///
20210719 ///
20210806 ///
20210819 ///
20210825 ///
20210909 ///
20210924 ///
20211006 ///
20211021 ///
20211027 ///
20211103 ///
20211115 ///
20211121 ///
20211129 ///
20211205 ///
20211213 ///
20211226 ///
20220102 ///
20220120 ///
20220131 ///
20220315 ///
20220530 ///
20220620 ///
20220703 ///
20220712 ///
20220728 ///
20220808 ///
20220901 ///
20221225


foreach update of local list {

	cd "$pathCovidLongitudinal/download/IMPE"
	
	di in red "This is IMPE update " `update'

	use "IMPE `update'.dta", clear
		
	keep if loc_grand_name == "India"

	duplicates drop
		
	
	
	
	* gen daily deaths // done in /code/downloads/IMPE/do CovidLongitudinal IMPE.do
	
	
	
	
	* smooth
		
	sort date
			
	qui tsset date, daily   
			
	qui tssmooth ma DayDeaMeRaIMPE`update'_window = DayDeaMeRaIMPE`update' if DayDeaMeRaIMPE`update' >= 0, window(3 1 3) 

	qui tssmooth ma DayDeaMeSmIMPE`update' = DayDeaMeRaIMPE`update'_window, weights( 1 2 3 <4> 3 2 1) replace

	drop *_window
	
	label var DayDeaMeSmIMPE`update' "Daily deaths mean smooth IMPE" 
	
	
	
	
	* gen Daily deaths smooth forecast only
			
	clonevar DayDeaMeFoIMPE`update' = DayDeaMeSmIMPE`update' 
	
	label var DayDeaMeFoIMPE`update' "Daily deaths smooth mean forecast only IMPE"
		
	gen update_date`update' = date("`update'", "YMD")
				
	qui replace DayDeaMeFoIMPE`update' = . if date < update_date`update' 
	
	
	
	capture drop fit_type death_calibrated v1
	
	label var loc_grand_name "country"
	
	label var date "calendar date"
	
	label var DayDeaMeRaIMPE`update' "Daily deaths mean raw IMPE"
	
	label var DayDeaMeSmIMPE`update' "Daily deaths mean smooth IMPE"
	
	label var DayDeaMeFoIMPE`update' "Daily deaths mean smooth forecast only IMPE"
	
	label var update_date`update' "update date"
	
	
	
	
	
	qui compress	
	
	cd "$pathCovidLongitudinal/countries/India"
	
	save "IMPE `update' India.dta", replace emptyok
	
	
	*

	
}
*




* merge updates

cd "$pathCovidLongitudinal/countries/India"

foreach update of local list {

	merge m:m date using "IMPE `update' India.dta"
	
	drop _merge

}
*	


capture drop fit_type death_calibrated v1 // IMPE extra vars 

qui compress

save "IMPE India.dta", replace




* add JOHN

merge m:1 date using "JOHN India.dta"

drop _merge

	drop if date < td(01jan2020)

	drop if date > td(01jan2023) 

qui compress

save "IMPE India.dta", replace




******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "IMPE India data dictionary.csv", replace 
	
restore




foreach update of local list {
	
	* graph India IMPE daily deaths each update 
	
	twoway ///
	(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 	
	(line DayDeaMeFoIMPE`update' date, sort lwidth(thin) lcolor(magenta)) /// 
	if date >= td(01Jan2020) & date <= td(01Jan2023) ///
	, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
	xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
	ytitle(Daily deaths) title("C19 daily deaths, IMPE, update `update'", size(medium) color(black)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
	subtitle("India, forecast only") legend(position(6) order(1 "JOHN" 2 "IMPE forecast ") rows(1) size(small)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) 
	
	qui graph export "graph 01 India IMPE daily deaths update `update'.pdf", replace	

}





* graph India IMPE daily deaths all updates

twoway ///
(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 
(line DayDeaMeFoIMPE20200428 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200429 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200430 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200501 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200502 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200503 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200504 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200505 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200506 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200507 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200508 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200509 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200510 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200511 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200512 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200513 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200514 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200515 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200516 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200517 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200519 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200520 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200521 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200522 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200523 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200524 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200525 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200526 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200527 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200528 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200529 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200530 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200531 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200601 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200602 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200603 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200604 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200606 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200609 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200614 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200616 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200619 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200621 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200623 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200626 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200628 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200702 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200703 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200704 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200707 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200711 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200714 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200715 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200718 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200720 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200722 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200725 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200727 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200731 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200808 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200810 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200811 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200813 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200814 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200817 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200823 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200825 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200827 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200831 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200902 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200906 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200908 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200912 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200915 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200919 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200923 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20200925 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201003 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201006 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201012 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201019 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201025 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201028 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201101 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201110 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201114 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201118 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201123 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201129 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201204 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201212 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201220 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20201226 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210104 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210110 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210112 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210118 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210124 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210130 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210203 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210210 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210217 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210226 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210305 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210312 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210319 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210329 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210406 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210417 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210424 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210510 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210516 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210522 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210527 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210604 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210611 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210618 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210626 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210702 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210709 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210719 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210806 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210819 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210825 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210909 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20210924 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211006 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211021 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211027 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211103 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211115 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211121 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211129 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211205 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211213 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20211226 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220102 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220120 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220131 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220315 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220530 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220620 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220703 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220712 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220728 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220808 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20220901 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIMPE20221225 date, sort lwidth(thin) lcolor(magenta)) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths) title("C19 daily deaths, India, IMPE, all updates", size(medium) color(black)) ///
legend(position(6) order(1 "JOHN" 2 "IMPE forecast ") rows(1) size(small)) legend(region(lcolor(none))) legend(bexpand) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2))

qui graph export "graph 02 India IMPE C19 daily deaths all updates.pdf", replace















**************************************************************************

* LANL

local list ///
20200426 ///
20200429 ///
20200506 ///
20200510 ///
20200513 ///
20200517 ///
20200520 ///
20200524 ///
20200527 ///
20200531 ///
20200603 ///
20200607 ///
20200610 ///
20200613 ///
20200617 ///
20200621 ///
20200623 ///
20200628 ///
20200701 ///
20200705 ///
20200708 ///
20200712 ///
20200715 ///
20200719 ///
20200722 ///
20200726 ///
20200729 ///
20200802 ///
20200805 ///
20200809 ///
20200812 ///
20200816 ///
20200819 ///
20200823 ///
20200826 ///
20200830 ///
20200902 ///
20200906 ///
20200909 ///
20200913 ///
20200916 ///
20200920 ///
20200923 ///
20200927 ///
20200930 ///
20201004 ///
20201007 ///
20201011 ///
20201014 ///
20201018 ///
20201021 ///
20201025 ///
20201028 ///
20201101 ///
20201104 ///
20201108 ///
20201111 ///
20201115 ///
20201118 ///
20201122 ///
20201125 ///
20201129 ///
20201202 ///
20201206 ///
20201209 ///
20201213 ///
20201216 ///
20201220 ///
20201223 ///
20210103 ///
20210105 ///
20210110 ///
20210113 ///
20210117 ///
20210120 ///
20210124 ///
20210127 ///
20210131 ///
20210203 ///
20210207 ///
20210210 ///
20210214 ///
20210217 ///
20210221 ///
20210224 ///
20210228 ///
20210303 ///
20210307 ///
20210310 ///
20210314 ///
20210321 ///
20210324 ///
20210328 ///
20210331 ///
20210404 ///
20210407 ///
20210411 ///
20210414 ///
20210418 ///
20210421 ///
20210425 ///
20210428 ///
20210502 ///
20210505 ///
20210509 ///
20210512 ///
20210516 ///
20210519 ///
20210523 ///
20210526 ///
20210602 ///
20210606 ///
20210613 ///
20210620 ///
20210627 ///
20210704 ///
20210711 ///
20210718 ///
20210725 ///
20210801 ///
20210808 ///
20210815 ///
20210822 ///
20210829 ///
20210905 ///
20210912 ///
20210919 ///
20210926


foreach update of local list {

	cd "$pathCovidLongitudinal/download/LANL"
	
	di in red "This is LANL update " `update'

	use "CovidLongitudinal LANL `update'.dta", clear
	
	keep if loc_grand_name == "India" 

	duplicates drop
		
	
	
	
	* gen daily deaths // done in /code/downloads/LANL/do CovidLongitudinal LANL.do
	
	
	
	* smooth
		
	sort loc_grand_name date
			
	qui tsset date, daily   
			        
	qui tssmooth ma DayDeaMeRaLANL`update'_window = DayDeaMeRaLANL`update' if DayDeaMeRaLANL`update' >= 0, window(3 1 3) 

	qui tssmooth ma DayDeaMeSmLANL`update' = DayDeaMeRaLANL`update'_window, weights( 1 2 3 <4> 3 2 1) replace

	drop *_window
	
	label var DayDeaMeSmLANL`update' "Daily deaths mean smooth LANL" 
	
	
	
	
	* gen Daily deaths smooth forecast only 
				
	clonevar DayDeaMeFoLANL`update' = DayDeaMeSmLANL`update' 
	
	label var DayDeaMeFoLANL`update' "Daily deaths mean smooth forecast only LANL"
	
	gen update_date`update' = date("`update'", "YMD")
			
	replace DayDeaMeFoLANL`update' = . if date < update_date`update' 
	
	
	
	label var date "calendar date"
	
	label var DayDeaMeRaLANL`update' "Daily deaths mean raw LANL"
	
	label var loc_grand_name "country"
	
	label var date "calendar date"
	
	label var update_date`update' "update date"
	
	qui compress	
	
	cd "$pathCovidLongitudinal/countries/India"
	
	save "LANL `update' India.dta", replace 
	

}
*





* merge updates

cd "$pathCovidLongitudinal/countries/India"

foreach update of local list {

	merge m:m date using "LANL `update' India.dta"
	
	drop _merge

}
*	

qui compress

save "LANL India.dta", replace




* add JOHN

merge m:1 date using "JOHN India.dta"

drop _merge

qui compress

save "LANL India.dta", replace




******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "LANL India data dictionary.csv", replace 
	
restore




foreach update of local list {
	
	* graph India LANL daily deaths each update 
	
	twoway ///
	(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 	
	(line DayDeaMeFoLANL`update' date, sort lwidth(thin) lcolor(brown)) /// 
	if date >= td(01Jan2020) & date <= td(01Jan2023) ///
	, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
	xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
	ytitle(Daily deaths) title("C19 daily deaths, LANL, update `update'", size(medium) color(black)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
	subtitle("India, forecast only") legend(position(6) order(1 "JOHN" 2 "LANL forecast ") rows(1) size(small)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) 
	
	qui graph export "graph 01 India LANL daily deaths update `update'.pdf", replace	

}





* graph India LANL daily deaths all updates

twoway ///
(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 
(line DayDeaMeFoLANL20200426 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200429 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200506 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200510 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200513 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200517 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200520 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200524 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200527 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200531 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200603 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200607 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200610 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200613 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200617 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200621 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200623 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200628 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200701 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200705 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200708 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200712 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200715 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200719 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200722 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200726 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200729 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200802 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200805 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200809 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200812 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200816 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200819 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200823 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200826 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200830 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200902 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200906 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200909 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200913 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200916 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200920 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200923 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200927 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20200930 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201004 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201007 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201011 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201014 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201018 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201021 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201025 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201028 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201101 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201104 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201108 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201111 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201115 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201118 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201122 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201125 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201129 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201202 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201206 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201209 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201213 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201216 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201220 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201223 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210103 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210105 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210110 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210113 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210117 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210120 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210124 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210127 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210131 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210203 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210207 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210210 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210214 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210217 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210221 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210224 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210228 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210303 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210307 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210310 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210314 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210321 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210324 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210328 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210331 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210404 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210407 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210411 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210414 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210418 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210421 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210425 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210428 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210502 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210505 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210509 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210512 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210516 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210519 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210523 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210526 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210602 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210606 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210613 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210620 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210627 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210704 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210711 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210718 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210725 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210801 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210808 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210815 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210822 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210829 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210905 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210912 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210919 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210926 date, sort lwidth(thin) lcolor(brown)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths) title("C19 daily deaths, India, LANL, all updates", size(medium) color(black)) ///
legend(position(6) order(1 "JOHN" 2 "LANL forecast ") rows(1) size(small)) legend(region(lcolor(none))) legend(bexpand) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2))

qui graph export "graph 02 India LANL C19 daily deaths all updates.pdf", replace



















**************************************************************************

* UCLA



local list ///
20210103 ///
20210110 ///
20210206 ///
20210307 ///
20210315 ///
20210328 ///
20210404 ///
20210712 ///
20210719 ///
20210726 ///
20210802 ///
20210809 ///
20210816 ///
20210823 ///
20210830 ///
20210906 ///
20210913 ///
20210920 ///
20210927 ///
20211004 ///
20211011 ///
20211018 ///
20211025 ///
20211101 ///
20211108 ///
20211122 ///
20211129 ///
20211206 ///
20211213 ///
20211220


foreach update of local list {

	cd "$pathCovidLongitudinal/download/UCLA"
	
	di in red "This is UCLA update " `update'

	use "CovidLongitudinal UCLA `update'.dta", clear
		
	keep if loc_grand_name == "India" 

	duplicates drop
		
	
	
	
	* gen daily deaths // avilable form downloaded data
			
		
	
	
	* smooth
		
	sort loc_grand_name date
	
	qui tsset date, daily   
			        
	qui tssmooth ma DayDeaMeRaUCLA`update'_window = DayDeaMeRaUCLA`update' if DayDeaMeRaUCLA`update' >= 0, window(3 1 3) 

	qui tssmooth ma DayDeaMeSmUCLA`update' = DayDeaMeRaUCLA`update'_window, weights( 1 2 3 <4> 3 2 1) replace

	drop *_window
	
	label var DayDeaMeSmUCLA`update' "Daily deaths mean smooth UCLA" 
	
	*
	
	
	
	
	* gen Daily deaths smooth forecast only  
				
	clonevar DayDeaMeFoUCLA`update' = DayDeaMeSmUCLA`update' 
	
	label var DayDeaMeFoUCLA`update' "Daily deaths mean smooth forecast only UCLA"
	
	capture gen update_date`update' = date("`update'", "YMD")
			
	replace DayDeaMeFoUCLA`update' = . if date < update_date`update' 
	
	
	
	qui compress	
	
	cd "$pathCovidLongitudinal/countries/India"
	
	save "UCLA `update' India.dta", replace 
	
	/* line DayDeaMeRaUCLA`update' DayDeaMeSmUCLA`update' DayDeaMeFoUCLA`update' date

	qui graph export "UCLA `update' India.pdf", replace */
	
}
*




* merge updates

cd "$pathCovidLongitudinal/countries/India"

foreach update of local list {

	merge m:m date using "UCLA `update' India.dta"
	
	drop _merge

}
*	

qui compress

save "UCLA India.dta", replace




* add JOHN

merge m:1 date using "JOHN India.dta"

drop _merge

qui compress

save "UCLA India.dta", replace




******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "UCLA India data dictionary.csv", replace 
	
restore



foreach update of local list {
	
	* graph India UCLA daily deaths each update 
	
	twoway ///
	(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 	
	(line DayDeaMeFoUCLA`update' date, sort lwidth(thin) lcolor(blue)) /// 
	if date >= td(01Jan2020) & date <= td(01Jan2023) ///
	, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
	xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
	ytitle(Daily deaths) title("C19 daily deaths, UCLA, update `update'", size(medium) color(black)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
	subtitle("India, forecast only") legend(position(6) order(1 "JOHN" 2 "UCLA forecast ") rows(1) size(small)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) 
	
	qui graph export "graph 01 India UCLA daily deaths update `update'.pdf", replace	

}



* graph India UCLA daily deaths all updates

twoway ///
(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 
(line DayDeaMeFoUCLA20210103 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210110 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210206 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210307 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210315 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210328 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210404 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210712 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210719 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210726 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210802 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210809 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210816 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210823 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210830 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210906 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210913 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210920 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20210927 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211004 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211011 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211018 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211025 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211101 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211108 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211122 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211129 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211206 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211213 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoUCLA20211220 date, sort lwidth(thin) lcolor(blue)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths) title("C19 daily deaths, India, UCLA, all updates", size(medium) color(black)) ///
legend(position(6) order(1 "JOHN" 2 "UCLA forecast ") rows(1) size(small)) legend(region(lcolor(none))) legend(bexpand) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2))

qui graph export "graph 02 India UCLA C19 daily deaths all updates.pdf", replace












**************************************************************************

* YYGU

local list ///
20200407 ///
20200408 ///
20200409 ///
20200410 ///
20200411 ///
20200412 ///
20200413 ///
20200414 ///
20200415 ///
20200416 ///
20200417 ///
20200418 ///
20200419 ///
20200420 ///
20200421 ///
20200422 ///
20200423 ///
20200424 ///
20200425 ///
20200426 ///
20200427 ///
20200428 ///
20200429 ///
20200430 ///
20200501 ///
20200502 ///
20200503 ///
20200504 ///
20200505 ///
20200506 ///
20200507 ///
20200508 ///
20200509 ///
20200510 ///
20200511 ///
20200512 ///
20200513 ///
20200514 ///
20200515 ///
20200516 ///
20200517 ///
20200518 ///
20200519 ///
20200520 ///
20200521 ///
20200522 ///
20200523 ///
20200524 ///
20200525 ///
20200526 ///
20200527 ///
20200528 ///
20200529 ///
20200530 ///
20200531 ///
20200601 ///
20200602 ///
20200603 ///
20200604 ///
20200605 ///
20200606 ///
20200607 ///
20200608 ///
20200609 ///
20200610 ///
20200611 ///
20200612 ///
20200613 ///
20200614 ///
20200615 ///
20200616 ///
20200617 ///
20200618 ///
20200619 ///
20200620 ///
20200621 ///
20200622 ///
20200623 ///
20200624 ///
20200625 ///
20200626 ///
20200627 ///
20200628 ///
20200629 ///
20200630 ///
20200701 ///
20200702 ///
20200703 ///
20200704 ///
20200705 ///
20200706 ///
20200707 ///
20200708 ///
20200709 ///
20200710 ///
20200711 ///
20200712 ///
20200713 ///
20200714 ///
20200715 ///
20200716 ///
20200717 ///
20200718 ///
20200719 ///
20200720 ///
20200721 ///
20200722 ///
20200723 ///
20200724 ///
20200725 ///
20200726 ///
20200727 ///
20200728 ///
20200729 ///
20200730 ///
20200731 ///
20200801 ///
20200802 ///
20200803 ///
20200804 ///
20200805 ///
20200806 ///
20200807 ///
20200808 ///
20200809 ///
20200810 ///
20200811 ///
20200812 ///
20200813 ///
20200814 ///
20200815 ///
20200816 ///
20200817 ///
20200818 ///
20200819 ///
20200820 ///
20200821 ///
20200822 ///
20200823 ///
20200824 ///
20200825 ///
20200826 ///
20200827 ///
20200828 ///
20200829 ///
20200830 ///
20200831 ///
20200901 ///
20200902 ///
20200903 ///
20200904 ///
20200905 ///
20200906 ///
20200907 ///
20200908 ///
20200909 ///
20200910 ///
20200911 ///
20200912 ///
20200913 ///
20200914 ///
20200915 ///
20200916 ///
20200917 ///
20200918 ///
20200919 ///
20200920 ///
20200921 ///
20200922 ///
20200923 ///
20200924 ///
20200925 ///
20200926 ///
20200927 ///
20200928 ///
20200929 ///
20200930 ///
20201001 ///
20201002 ///
20201003 ///
20201004 ///
20201005


foreach update of local list {

	cd "$pathCovidLongitudinal/download/YYGU"
	
	di in red "This is YYGU update " `update'

	use "CovidLongitudinal YYGU `update'.dta", clear
		
	keep if loc_grand_name == "India" 

	duplicates drop
	
	duplicates drop loc_grand_name date, force
	
	
	
	
	* gen daily deaths // avilable form downloaded data
			
		
	
	
	* smooth
		
	sort loc_grand_name date
	
	qui tsset date, daily   
			        
	qui tssmooth ma DayDeaMeRaYYGU`update'_window = DayDeaMeRaYYGU`update' if DayDeaMeRaYYGU`update' >= 0, window(3 1 3) 

	qui tssmooth ma DayDeaMeSmYYGU`update' = DayDeaMeRaYYGU`update'_window, weights( 1 2 3 <4> 3 2 1) replace

	drop *_window
	
	label var DayDeaMeSmYYGU`update' "Daily deaths smooth mean YYGU" 
	
	*
	
	
	
	
	* gen FORE, that is forecast only 
				
	clonevar DayDeaMeFoYYGU`update' = DayDeaMeSmYYGU`update' 
	
	label var DayDeaMeFoYYGU`update' "Daily deaths smooth mean forecast only YYGU"
	
	capture gen update_date`update' = date("`update'", "YMD")
			
	replace DayDeaMeFoYYGU`update' = . if date < update_date`update' 
	
	qui compress	
	
	cd "$pathCovidLongitudinal/countries/India"
	
	save "YYGU `update' India.dta", replace 
	
	/* line DayDeaMeRaYYGU`update' DayDeaMeSmYYGU`update' DayDeaMeFoYYGU`update' date

	qui graph export "YYGU `update' India.pdf", replace */
	
}
*




* merge updates

cd "$pathCovidLongitudinal/countries/India"

foreach update of local list {

	merge m:m date using "YYGU `update' India.dta"
	
	drop _merge

}
*	

qui compress

save "YYGU India.dta", replace




* add JOHN

merge m:m date using "JOHN India.dta"

drop _merge

qui compress

save "YYGU India.dta", replace



******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "YYGU India data dictionary.csv", replace 
	
restore




foreach update of local list {
	
	* graph India YYGU daily deaths each update 
	
	twoway ///
	(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 	
	(line DayDeaMeFoYYGU`update' date, sort lwidth(thin) lcolor(gold)) /// 
	if date >= td(01Jan2020) & date <= td(01Jan2023) ///
	, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
	xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
	ytitle(Daily deaths) title("C19 daily deaths, YYGU, update `update'", size(medium) color(black)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
	subtitle("India, forecast only") legend(position(6) order(1 "JOHN" 2 "YYGU forecast ") rows(1) size(small)) ///
	xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) 
	
	qui graph export "graph 01 India YYGU daily deaths update `update'.pdf", replace	

}




* graph India YYGU daily deaths all updates

twoway ///
(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 
(line DayDeaMeFoYYGU20200407 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200408 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200409 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200410 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200411 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200412 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200413 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200414 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200415 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200416 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200417 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200418 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200419 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200420 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200421 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200422 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200423 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200424 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200425 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200426 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200427 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200428 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200429 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200430 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200501 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200502 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200503 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200504 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200505 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200506 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200507 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200508 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200509 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200510 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200511 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200512 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200513 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200514 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200515 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200516 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200517 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200518 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200519 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200520 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200521 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200522 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200523 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200524 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200525 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200526 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200527 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200528 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200529 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200530 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200531 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200601 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200602 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200603 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200604 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200605 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200606 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200607 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200608 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200609 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200610 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200611 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200612 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200613 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200614 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200615 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200616 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200617 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200618 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200619 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200620 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200621 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200622 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200623 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200624 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200625 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200626 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200627 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200628 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200629 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200630 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200701 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200702 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200703 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200704 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200705 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200706 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200707 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200708 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200709 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200710 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200711 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200712 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200713 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200714 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200715 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200716 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200717 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200718 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200719 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200720 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200721 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200722 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200723 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200724 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200725 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200726 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200727 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200728 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200729 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200730 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200731 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200801 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200802 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200803 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200804 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200805 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200806 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200807 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200808 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200809 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200810 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200811 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200812 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200813 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200814 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200815 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200816 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200817 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200818 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200819 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200820 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200821 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200822 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200823 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200824 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200825 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200826 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200827 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200828 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200829 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200830 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200831 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200901 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200902 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200903 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200904 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200905 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200906 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200907 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200908 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200909 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200910 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200911 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200912 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200913 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200914 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200915 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200916 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200917 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200918 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200919 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200920 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200921 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200922 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200923 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200924 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200925 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200926 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200927 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200928 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200929 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200930 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20201001 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20201002 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20201003 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20201004 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20201005 date, sort lwidth(thin) lcolor(gold)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths) title("C19 daily deaths, India, YYGU, all updates", size(medium) color(black)) ///
legend(position(6) order(1 "JOHN" 2 "YYGU forecast ") rows(1) size(small)) legend(region(lcolor(none))) legend(bexpand) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2))

qui graph export "graph 02 India YYGU C19 daily deaths all updates.pdf", replace







*************************************************************

* merge models

local list IHME IMPE LANL UCLA YYGU

use "DELP India.dta", clear

foreach model of local list {

	merge m:m date loc_grand_name using "`model' India.dta", force
	
	drop _merge
	
	isid date loc_grand_name, missok
	
}
*

qui compress

save "ALL MODLES India.dta", replace



******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "ALL MODLES India data dictionary.csv", replace 
	
restore

	

	


* graph India ALL MODELS daily deaths all updates

twoway ///
(line DayDeaMeFoYYGU20200407 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200408 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200409 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200410 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200411 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200412 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200413 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200414 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200415 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200416 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200417 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoYYGU20200417 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200418 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200419 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200420 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200421 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200422 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200423 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200424 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoYYGU20200424 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200425 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200426 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200426 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200427 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200428 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200428 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200429 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200429 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200429 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200430 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200430 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200501 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200501 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200501 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200502 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200502 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200503 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200503 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200504 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200504 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200505 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200505 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200506 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200506 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200506 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200507 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200507 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200508 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200508 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200509 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200509 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200509 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200510 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200510 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200510 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200511 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200511 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200512 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200512 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200513 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200513 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200513 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200514 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200514 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200515 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200515 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200516 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200516 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200517 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200517 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200517 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200517 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200518 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200519 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200519 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200520 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200520 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200520 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200521 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200521 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200522 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200522 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200523 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200523 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200524 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200524 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200524 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200524 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200525 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200525 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200526 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200526 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200527 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200527 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200527 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200528 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200528 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200529 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200529 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200530 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200530 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200531 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200531 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200531 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200531 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200601 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200601 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200602 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200602 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200603 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200603 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200603 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200604 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200604 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200605 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200606 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200606 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200607 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoLANL20200607 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200607 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200608 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200609 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200609 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200610 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200610 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200611 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200612 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200613 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200613 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200614 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200614 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200614 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200615 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200616 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200616 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200617 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200617 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200618 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200619 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200619 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200620 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200621 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200621 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200621 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200621 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200622 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200623 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200623 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200623 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200624 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200625 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200626 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200626 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200627 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200628 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200628 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200628 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200628 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200629 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200630 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200701 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200701 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200702 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200702 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200703 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200703 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200704 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200704 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200704 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200705 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200705 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200706 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200707 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200707 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200708 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200708 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200709 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200710 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200711 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200711 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200712 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200712 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200713 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200714 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200714 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200715 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200715 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200715 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200716 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200717 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200718 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200718 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200718 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200719 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200719 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200720 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200720 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200721 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200722 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200722 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200722 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200723 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoYYGU20200723 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200724 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200725 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200725 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200726 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200726 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200727 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200727 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200728 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200729 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200729 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200730 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200731 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200731 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200801 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoYYGU20200801 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200802 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200802 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200803 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200804 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200805 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200805 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200806 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200807 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200808 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200808 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200809 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200809 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200810 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200810 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200811 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200811 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200812 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200812 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200813 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200813 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200814 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200814 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200815 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoYYGU20200815 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200816 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200816 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200817 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200817 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200818 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200819 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200819 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200820 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200821 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200822 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200823 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200823 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200823 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200824 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200825 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200825 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200826 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200826 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200827 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200827 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200828 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200829 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoYYGU20200829 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200830 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200830 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200831 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200831 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200901 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200902 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200902 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200902 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIHME20200903 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoYYGU20200903 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200904 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200905 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200906 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200906 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200906 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200907 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200908 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200908 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200909 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200909 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200910 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIHME20200911 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoYYGU20200911 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200912 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20200912 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200912 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200913 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200913 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200914 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200915 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200915 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200916 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200916 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200917 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIHME20200918 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoYYGU20200918 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200919 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200919 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200920 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200920 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200921 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200922 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200923 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20200923 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200923 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIHME20200924 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoYYGU20200924 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20200925 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20200925 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoDELP20200926 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoYYGU20200926 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200927 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200927 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200928 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20200929 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20200930 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20200930 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20201001 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIHME20201002 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoYYGU20201002 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20201003 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoYYGU20201003 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoLANL20201004 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoYYGU20201004 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoYYGU20201005 date, sort lwidth(thin) lcolor(gold)) ///
(line DayDeaMeFoIMPE20201006 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201007 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20201008 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20201009 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20201011 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20201012 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201014 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20201015 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20201018 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20201019 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201021 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20201022 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20201022 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20201025 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201025 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20201028 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201028 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20201029 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20201101 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201101 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201104 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20201105 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoLANL20201108 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20201110 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201111 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20201112 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20201114 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201115 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20201118 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201118 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20201119 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20201119 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20201122 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20201123 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201125 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20201129 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201129 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201202 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20201203 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20201203 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20201204 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201206 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201209 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20201210 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20201212 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201213 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20201216 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20201217 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20201217 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20201220 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20201220 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20201223 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20201223 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20201226 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20201231 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoLANL20210103 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210103 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIMPE20210104 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210105 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210110 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210110 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210110 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIMPE20210112 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210113 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210114 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210115 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210117 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210118 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210120 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20210122 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210124 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210124 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210127 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210128 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210128 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210130 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210131 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210203 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210203 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20210204 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoUCLA20210206 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoLANL20210207 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210210 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210210 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210211 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210212 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210214 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210217 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210217 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20210220 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210221 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210224 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210225 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210225 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210226 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210228 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210303 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210305 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIHME20210306 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210307 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210307 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoLANL20210310 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210311 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210311 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210312 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210314 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210315 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIHME20210317 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210319 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210321 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210324 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210325 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210325 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210328 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210328 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIMPE20210329 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210331 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20210401 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210404 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210404 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIMPE20210406 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210407 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210408 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210409 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210411 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210414 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20210416 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210417 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210418 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210421 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210422 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210423 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210424 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210425 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210428 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210502 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210505 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210506 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210506 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210509 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210510 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210512 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIHME20210514 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210516 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210516 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210519 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210520 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210521 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210522 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210523 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoLANL20210526 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210527 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIHME20210528 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210602 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210603 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210604 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210604 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210606 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210610 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210610 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210611 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210613 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210617 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210618 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210618 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210620 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210624 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210625 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210626 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210627 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210701 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210702 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210702 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210704 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoDELP20210708 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20210709 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210711 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210712 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210715 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210715 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210718 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoIMPE20210719 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoUCLA20210719 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210722 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210723 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210725 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210726 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210729 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210730 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210801 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210802 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210805 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210806 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210806 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210808 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210809 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210812 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoLANL20210815 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210816 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210819 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20210819 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIHME20210820 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210822 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210823 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIMPE20210825 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20210826 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210826 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210829 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210830 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210902 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210902 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210905 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210906 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210909 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20210909 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoIHME20210910 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210912 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210913 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210916 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210916 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoLANL20210919 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210920 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210923 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210923 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20210924 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoLANL20210926 date, sort lwidth(thin) lcolor(brown)) ///
(line DayDeaMeFoUCLA20210927 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20210930 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20210930 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoUCLA20211004 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIMPE20211006 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20211007 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoUCLA20211011 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20211014 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20211015 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoUCLA20211018 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20211021 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20211021 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20211021 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoUCLA20211025 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIMPE20211027 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20211028 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoUCLA20211101 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIMPE20211103 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20211104 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20211104 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoUCLA20211108 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20211111 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20211115 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20211118 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20211119 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20211121 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoUCLA20211122 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20211125 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20211129 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoUCLA20211129 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20211202 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20211205 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoUCLA20211206 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20211209 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20211213 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoUCLA20211213 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoDELP20211216 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoUCLA20211220 date, sort lwidth(thin) lcolor(blue)) ///
(line DayDeaMeFoIHME20211221 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20211223 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20211226 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20211230 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220102 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220106 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220108 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220113 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220114 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220114 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220115 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220116 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220117 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220118 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220119 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220120 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220120 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220121 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220121 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220122 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220123 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220124 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220125 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220126 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220127 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220128 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220129 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220130 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220131 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220131 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220201 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220202 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220203 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220204 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220204 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220205 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220206 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220207 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220208 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220209 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220210 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220211 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220212 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220213 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220214 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220215 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220216 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220217 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220218 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220218 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220219 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220220 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220221 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220222 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220223 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220224 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220225 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220226 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220227 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220228 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220301 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220302 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220303 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220304 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220305 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220306 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220307 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220308 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220309 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220310 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220311 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220312 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220313 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220314 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220315 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220315 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220316 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220317 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220318 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220319 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220320 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220321 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220321 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220322 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220323 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220324 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220325 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220326 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220327 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220328 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220329 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220330 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220331 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220401 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220402 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220403 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220404 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220405 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220406 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220407 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220408 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220408 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220409 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220410 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220411 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220412 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220413 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220414 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220415 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220416 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220417 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220418 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220419 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220420 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220421 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220422 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220423 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220424 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220425 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220426 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220427 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220428 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220429 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220430 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220501 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220502 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220503 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220504 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220505 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220506 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220506 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220507 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220508 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220509 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220510 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220511 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220512 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220513 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220514 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220515 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220516 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220517 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220518 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220519 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220520 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220521 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220522 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220523 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220524 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220525 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220526 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220527 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220528 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220529 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220530 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220530 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220531 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220601 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220602 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220603 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220604 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220605 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220606 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220607 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220608 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220609 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220610 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220610 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220611 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220612 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220613 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220614 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220615 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220616 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220617 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220618 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220619 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220620 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220620 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220621 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220622 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220623 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220624 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220625 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220626 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220627 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220628 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220629 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220630 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220701 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220702 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220703 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220703 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220704 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220705 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220706 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220707 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220708 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220709 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220710 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220711 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220712 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220712 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220713 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220714 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220715 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220716 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220717 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220718 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220719 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220719 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220720 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220721 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220722 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220723 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220724 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220725 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220726 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220727 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220728 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220728 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220729 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220730 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220731 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220801 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220802 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220803 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220804 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220805 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220806 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220807 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220808 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220808 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220809 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220810 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220811 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220812 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220813 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220814 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220815 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220816 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220817 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220818 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220819 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220820 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220821 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220822 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220823 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220824 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220825 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220826 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220827 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220828 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220829 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220830 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220831 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220901 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIMPE20220901 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeFoDELP20220902 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220903 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220904 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220905 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220906 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220907 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220908 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220909 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220910 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220911 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220912 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20220912 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoDELP20220913 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220914 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoDELP20220915 date, sort lwidth(thin) lcolor(red)) ///
(line DayDeaMeFoIHME20221024 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20221118 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIHME20221216 date, sort lwidth(thin) lcolor(black)) ///
(line DayDeaMeFoIMPE20221225 date, sort lwidth(thin) lcolor(magenta)) ///
(line DayDeaMeSmJOHNIND date, sort lwidth(thick) lcolor(cyan)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths) title("C19 daily deaths, India, all models, all updates, forecast only", size(medium) color(black)) ///
legend(position(6) order(872 "JOHN" 11 "DELP" 274 "IHME" 25 "IMPE" 22 "LANL" 387 "UCLA" 1 "YYGU") ///
rows(2) size(small)) legend(region(lcolor(none))) legend(bexpand) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2))

qui graph export "graph 02 India ALL MODELS C19 daily deaths all updates.pdf", replace

	






cd "$pathCovidLongitudinal/countries/India"


view "log CovidLongitudinal India 1 Process.smcl"

log close

exit, clear
