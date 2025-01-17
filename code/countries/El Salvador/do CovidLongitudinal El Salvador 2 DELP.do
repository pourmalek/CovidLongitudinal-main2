
clear all

cd "$pathCovidLongitudinal/countries/El Salvador"

capture log close 

log using "log CovidLongitudinal El Salvador 2 DELP.smcl", replace

***************************************************************************
* This is "do CovidLongitudinal El Salvador 2 DELP.do"

* Project: Longitudinal assessment of COVID-19 models 

* Objective: Run calculations for error measures
	* for each country ---->> El Salvador <<----                                                                 
***************************************************************************


** model = DELP ** <<-- modify 1
* lcolor red

* run calculations for error - daily deaths: four error types (graphs 3 to 11), updates together


* input data files: "DELP El Salvador.dta"
* output data files: "DELP El Salvador error.dta" (with error measures saved)

* output data dictionary files: "DELP El Salvador error data dictionary.csv"


* graph 03 Error
* graph 04 Absolute Error
* graph 05 Percent Error
* graph 06 Absolute Percent Error

* graph 07 mean over updates of median error by calendar months
* graph 08 Daily deaths, mean over updates of median absolute error by calendar months
* graph 09 Daily deaths, mean over updates of median % error by calendar months
* graph 10 Daily deaths, mean over updates of median absolute % error by calendar months

* graph 11 Daily deaths, Average MAPE over updates and calendar months




** graphs:
* "graph 03 El Salvador DELP C19 daily deaths error.pdf"
* "graph 04 El Salvador DELP C19 daily deaths absolute error.pdf"
* "graph 05 El Salvador DELP C19 daily deaths percent error.pdf"
* "graph 06 El Salvador DELP C19 daily deaths absolute percent error.pdf"

* "graph 07 El Salvador DELP C19 daily deaths average median error.pdf"
* "graph 08 El Salvador DELP C19 daily deaths average median absolute error.pdf"
* "graph 09 El Salvador DELP C19 daily deaths average median percent error.pdf"
* "graph 10 El Salvador DELP C19 daily deaths average median absolute percent error.pdf"

* "graph 11 El Salvador DELP C19 daily deaths Average MAPE over updates and calendar months.pdf"


*********************

/*


CALCULATIONS:

Error = minus (Reference minus Model)

Absolute error = | minus (Reference minus Model) |

Percent error = 100 * (minus (Reference minus Model)) / Reference

Absolute percent error = 100 * | minus (Reference minus Model) | / Reference




Error = - (Reference - Model)

Absolute error = | - (Reference - Model) |

Percent error = 100 * (- (Reference - Model)) / Reference

Absolute percent error = 100 * | - (Reference - Model)| / Reference

*/







use "DELP El Salvador.dta", clear 




* gen months time bin


gen month = month(date)

gen monthstr = ""
replace monthstr = "01" if month == 1
replace monthstr = "02" if month == 2
replace monthstr = "03" if month == 3

replace monthstr = "04" if month == 4
replace monthstr = "05" if month == 5
replace monthstr = "06" if month == 6

replace monthstr = "07" if month == 7
replace monthstr = "08" if month == 8
replace monthstr = "09" if month == 9

replace monthstr = "10" if month == 10
replace monthstr = "11" if month == 11
replace monthstr = "12" if month == 12



gen year = year(date)

gen yearstr = ""
replace yearstr = "2020" if year == 2020
replace yearstr = "2021" if year == 2021
replace yearstr = "2022" if year == 2022
replace yearstr = "2023" if year == 2023


egen yearmonth = concat(yearstr monthstr), p(m)

replace yearmonth = "" if yearmonth == "2023m01"

sort date yearmonth 

isid date

label var month "calendar month"

label var monthstr "calendar month string"

label var year "calendar year"

label var yearstr "calendar year string" 

label var yearmonth "calendar year and month"

*


// <<-- modify 2

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


sort date


* (1) gen error TYPES by calendar months and model updates

foreach update of local list {

	* Running not quietly displays that the Stata is working and has not frozen. 

capture drop DDErrorDELP`update'
gen DDErrorDELP`update' = - (DayDeaMeSmJOHN - DayDeaMeFoDELP`update')
label var DDErrorDELP`update' "DayDeaMeFoDELP`update' error"
qui replace DDErrorDELP`update' = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDErrorDELP`update' = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDErrorDELP`update' = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador
                                                            // <<-- modify 3
capture drop DDAbsErrDELP`update'
gen DDAbsErrDELP`update' = abs(- (DayDeaMeSmJOHN - DayDeaMeFoDELP`update'))
label var DDAbsErrDELP`update' "DayDeaMeFoDELP`update' absolute error"
qui replace DDAbsErrDELP`update' = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbsErrDELP`update' = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbsErrDELP`update' = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador

capture drop DDPerErrDELP`update'
gen DDPerErrDELP`update' = (100 * (- (DayDeaMeSmJOHN - DayDeaMeFoDELP`update'))) / DayDeaMeSmJOHN
replace DDPerErrDELP`update' = 0 if DDErrorDELP`update' == 0
label var DDPerErrDELP`update' "DayDeaMeFoDELP`update' percent error"
qui replace DDPerErrDELP`update' = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDPerErrDELP`update' = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDPerErrDELP`update' = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador

capture drop DDAbPeErDELP`update'
gen DDAbPeErDELP`update' = (100 * abs(- (DayDeaMeSmJOHN - DayDeaMeFoDELP`update'))) / DayDeaMeSmJOHN
replace DDAbPeErDELP`update' = 0 if DDAbsErrDELP`update' == 0
label var DDAbPeErDELP`update' "DayDeaMeFoDELP`update' absolute percent error"
qui replace DDAbPeErDELP`update' = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbPeErDELP`update' = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbPeErDELP`update' = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador

}
*





* (2) gen MEDIAN of error types by calendar months and updates = _Med1

* Wait note: wait ...

foreach update of local list {
		
capture drop DDErrorDELP`update'_Med1
bysort yearmonth : egen DDErrorDELP`update'_Med1 = median(DDErrorDELP`update')
label var DDErrorDELP`update'_Med1 "DayDeaDELP median error by calendar months and updates"
qui replace DDErrorDELP`update'_Med1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDErrorDELP`update'_Med1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDErrorDELP`update'_Med1 = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador

capture drop DDAbsErrDELP`update'_Med1
bysort yearmonth : egen DDAbsErrDELP`update'_Med1 = median(DDAbsErrDELP`update')
label var DDAbsErrDELP`update'_Med1 "DayDeaDELP median absolute error by calendar months and updates"
qui replace DDAbsErrDELP`update'_Med1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbsErrDELP`update'_Med1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbsErrDELP`update'_Med1 = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador

capture drop DDPerErrDELP`update'_Med1
bysort yearmonth : egen DDPerErrDELP`update'_Med1 = median(DDPerErrDELP`update')
label var DDPerErrDELP`update'_Med1 "DayDeaDELP median % error by calendar months and updates"
qui replace DDPerErrDELP`update'_Med1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDPerErrDELP`update'_Med1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDPerErrDELP`update'_Med1 = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador

capture drop DDAbPeErDELP`update'_Med1
bysort yearmonth : egen DDAbPeErDELP`update'_Med1 = median(DDAbPeErDELP`update')
label var DDAbPeErDELP`update'_Med1 "DayDeaDELP median absolute % error by calendar months and updates" 
qui replace DDAbPeErDELP`update'_Med1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbPeErDELP`update'_Med1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbPeErDELP`update'_Med1 = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador

}
*



 
* (3) gen AVERAGE over updates of MEDIAN of error types by calendar months = _Mean1

* Wait note: wait ...



* gen DDErrorDELP_Mean1 // gen AVERAGE over updates of MEDIAN of error types by calendar months = _Mean1

 // <<-- modify 4

order DDErrorDELP20200417_Med1
order DDErrorDELP20200424_Med1
order DDErrorDELP20200501_Med1
order DDErrorDELP20200509_Med1
order DDErrorDELP20200517_Med1
order DDErrorDELP20200524_Med1
order DDErrorDELP20200531_Med1
order DDErrorDELP20200607_Med1
order DDErrorDELP20200614_Med1
order DDErrorDELP20200621_Med1
order DDErrorDELP20200628_Med1
order DDErrorDELP20200704_Med1
order DDErrorDELP20200718_Med1
order DDErrorDELP20200723_Med1
order DDErrorDELP20200801_Med1
order DDErrorDELP20200815_Med1
order DDErrorDELP20200829_Med1
order DDErrorDELP20200912_Med1
order DDErrorDELP20200926_Med1
order DDErrorDELP20201008_Med1
order DDErrorDELP20201022_Med1
order DDErrorDELP20201105_Med1
order DDErrorDELP20201119_Med1
order DDErrorDELP20201203_Med1
order DDErrorDELP20201217_Med1
order DDErrorDELP20201231_Med1
order DDErrorDELP20210114_Med1
order DDErrorDELP20210128_Med1
order DDErrorDELP20210211_Med1
order DDErrorDELP20210225_Med1
order DDErrorDELP20210311_Med1
order DDErrorDELP20210325_Med1
order DDErrorDELP20210408_Med1
order DDErrorDELP20210422_Med1
order DDErrorDELP20210506_Med1
order DDErrorDELP20210520_Med1
order DDErrorDELP20210603_Med1
order DDErrorDELP20210610_Med1
order DDErrorDELP20210617_Med1
order DDErrorDELP20210624_Med1
order DDErrorDELP20210701_Med1
order DDErrorDELP20210708_Med1
order DDErrorDELP20210715_Med1
order DDErrorDELP20210722_Med1
order DDErrorDELP20210729_Med1
order DDErrorDELP20210805_Med1
order DDErrorDELP20210812_Med1
order DDErrorDELP20210819_Med1
order DDErrorDELP20210826_Med1
order DDErrorDELP20210902_Med1
order DDErrorDELP20210909_Med1
order DDErrorDELP20210916_Med1
order DDErrorDELP20210923_Med1
order DDErrorDELP20210930_Med1
order DDErrorDELP20211007_Med1
order DDErrorDELP20211014_Med1
order DDErrorDELP20211021_Med1
order DDErrorDELP20211028_Med1
order DDErrorDELP20211104_Med1
order DDErrorDELP20211111_Med1
order DDErrorDELP20211118_Med1
order DDErrorDELP20211125_Med1
order DDErrorDELP20211202_Med1
order DDErrorDELP20211209_Med1
order DDErrorDELP20211216_Med1
order DDErrorDELP20211223_Med1
order DDErrorDELP20211230_Med1
order DDErrorDELP20220106_Med1
order DDErrorDELP20220113_Med1
order DDErrorDELP20220114_Med1
order DDErrorDELP20220115_Med1
order DDErrorDELP20220116_Med1
order DDErrorDELP20220117_Med1
order DDErrorDELP20220118_Med1
order DDErrorDELP20220119_Med1
order DDErrorDELP20220120_Med1
order DDErrorDELP20220121_Med1
order DDErrorDELP20220122_Med1
order DDErrorDELP20220123_Med1
order DDErrorDELP20220124_Med1
order DDErrorDELP20220125_Med1
order DDErrorDELP20220126_Med1
order DDErrorDELP20220127_Med1
order DDErrorDELP20220128_Med1
order DDErrorDELP20220129_Med1
order DDErrorDELP20220130_Med1
order DDErrorDELP20220131_Med1
order DDErrorDELP20220201_Med1
order DDErrorDELP20220202_Med1
order DDErrorDELP20220203_Med1
order DDErrorDELP20220204_Med1
order DDErrorDELP20220205_Med1
order DDErrorDELP20220206_Med1
order DDErrorDELP20220207_Med1
order DDErrorDELP20220208_Med1
order DDErrorDELP20220209_Med1
order DDErrorDELP20220210_Med1
order DDErrorDELP20220211_Med1
order DDErrorDELP20220212_Med1
order DDErrorDELP20220213_Med1
order DDErrorDELP20220214_Med1
order DDErrorDELP20220215_Med1
order DDErrorDELP20220216_Med1
order DDErrorDELP20220217_Med1
order DDErrorDELP20220218_Med1
order DDErrorDELP20220219_Med1
order DDErrorDELP20220220_Med1
order DDErrorDELP20220221_Med1
order DDErrorDELP20220222_Med1
order DDErrorDELP20220223_Med1
order DDErrorDELP20220224_Med1
order DDErrorDELP20220225_Med1
order DDErrorDELP20220226_Med1
order DDErrorDELP20220227_Med1
order DDErrorDELP20220228_Med1
order DDErrorDELP20220301_Med1
order DDErrorDELP20220302_Med1
order DDErrorDELP20220303_Med1
order DDErrorDELP20220304_Med1
order DDErrorDELP20220305_Med1
order DDErrorDELP20220306_Med1
order DDErrorDELP20220307_Med1
order DDErrorDELP20220308_Med1
order DDErrorDELP20220309_Med1
order DDErrorDELP20220310_Med1
order DDErrorDELP20220311_Med1
order DDErrorDELP20220312_Med1
order DDErrorDELP20220313_Med1
order DDErrorDELP20220314_Med1
order DDErrorDELP20220315_Med1
order DDErrorDELP20220316_Med1
order DDErrorDELP20220317_Med1
order DDErrorDELP20220318_Med1
order DDErrorDELP20220319_Med1
order DDErrorDELP20220320_Med1
order DDErrorDELP20220321_Med1
order DDErrorDELP20220322_Med1
order DDErrorDELP20220323_Med1
order DDErrorDELP20220324_Med1
order DDErrorDELP20220325_Med1
order DDErrorDELP20220326_Med1
order DDErrorDELP20220327_Med1
order DDErrorDELP20220328_Med1
order DDErrorDELP20220329_Med1
order DDErrorDELP20220330_Med1
order DDErrorDELP20220331_Med1
order DDErrorDELP20220401_Med1
order DDErrorDELP20220402_Med1
order DDErrorDELP20220403_Med1
order DDErrorDELP20220404_Med1
order DDErrorDELP20220405_Med1
order DDErrorDELP20220406_Med1
order DDErrorDELP20220407_Med1
order DDErrorDELP20220408_Med1
order DDErrorDELP20220409_Med1
order DDErrorDELP20220410_Med1
order DDErrorDELP20220411_Med1
order DDErrorDELP20220412_Med1
order DDErrorDELP20220413_Med1
order DDErrorDELP20220414_Med1
order DDErrorDELP20220415_Med1
order DDErrorDELP20220416_Med1
order DDErrorDELP20220417_Med1
order DDErrorDELP20220418_Med1
order DDErrorDELP20220419_Med1
order DDErrorDELP20220420_Med1
order DDErrorDELP20220421_Med1
order DDErrorDELP20220422_Med1
order DDErrorDELP20220423_Med1
order DDErrorDELP20220424_Med1
order DDErrorDELP20220425_Med1
order DDErrorDELP20220426_Med1
order DDErrorDELP20220427_Med1
order DDErrorDELP20220428_Med1
order DDErrorDELP20220429_Med1
order DDErrorDELP20220430_Med1
order DDErrorDELP20220501_Med1
order DDErrorDELP20220502_Med1
order DDErrorDELP20220503_Med1
order DDErrorDELP20220504_Med1
order DDErrorDELP20220505_Med1
order DDErrorDELP20220506_Med1
order DDErrorDELP20220507_Med1
order DDErrorDELP20220508_Med1
order DDErrorDELP20220509_Med1
order DDErrorDELP20220510_Med1
order DDErrorDELP20220511_Med1
order DDErrorDELP20220512_Med1
order DDErrorDELP20220513_Med1
order DDErrorDELP20220514_Med1
order DDErrorDELP20220515_Med1
order DDErrorDELP20220516_Med1
order DDErrorDELP20220517_Med1
order DDErrorDELP20220518_Med1
order DDErrorDELP20220519_Med1
order DDErrorDELP20220520_Med1
order DDErrorDELP20220521_Med1
order DDErrorDELP20220522_Med1
order DDErrorDELP20220523_Med1
order DDErrorDELP20220524_Med1
order DDErrorDELP20220525_Med1
order DDErrorDELP20220526_Med1
order DDErrorDELP20220527_Med1
order DDErrorDELP20220528_Med1
order DDErrorDELP20220529_Med1
order DDErrorDELP20220530_Med1
order DDErrorDELP20220531_Med1
order DDErrorDELP20220601_Med1
order DDErrorDELP20220602_Med1
order DDErrorDELP20220603_Med1
order DDErrorDELP20220604_Med1
order DDErrorDELP20220605_Med1
order DDErrorDELP20220606_Med1
order DDErrorDELP20220607_Med1
order DDErrorDELP20220608_Med1
order DDErrorDELP20220609_Med1
order DDErrorDELP20220610_Med1
order DDErrorDELP20220611_Med1
order DDErrorDELP20220612_Med1
order DDErrorDELP20220613_Med1
order DDErrorDELP20220614_Med1
order DDErrorDELP20220615_Med1
order DDErrorDELP20220616_Med1
order DDErrorDELP20220617_Med1
order DDErrorDELP20220618_Med1
order DDErrorDELP20220619_Med1
order DDErrorDELP20220620_Med1
order DDErrorDELP20220621_Med1
order DDErrorDELP20220622_Med1
order DDErrorDELP20220623_Med1
order DDErrorDELP20220624_Med1
order DDErrorDELP20220625_Med1
order DDErrorDELP20220626_Med1
order DDErrorDELP20220627_Med1
order DDErrorDELP20220628_Med1
order DDErrorDELP20220629_Med1
order DDErrorDELP20220630_Med1
order DDErrorDELP20220701_Med1
order DDErrorDELP20220702_Med1
order DDErrorDELP20220703_Med1
order DDErrorDELP20220704_Med1
order DDErrorDELP20220705_Med1
order DDErrorDELP20220706_Med1
order DDErrorDELP20220707_Med1
order DDErrorDELP20220708_Med1
order DDErrorDELP20220709_Med1
order DDErrorDELP20220710_Med1
order DDErrorDELP20220711_Med1
order DDErrorDELP20220712_Med1
order DDErrorDELP20220713_Med1
order DDErrorDELP20220714_Med1
order DDErrorDELP20220715_Med1
order DDErrorDELP20220716_Med1
order DDErrorDELP20220717_Med1
order DDErrorDELP20220718_Med1
order DDErrorDELP20220719_Med1
order DDErrorDELP20220720_Med1
order DDErrorDELP20220721_Med1
order DDErrorDELP20220722_Med1
order DDErrorDELP20220723_Med1
order DDErrorDELP20220724_Med1
order DDErrorDELP20220725_Med1
order DDErrorDELP20220726_Med1
order DDErrorDELP20220727_Med1
order DDErrorDELP20220728_Med1
order DDErrorDELP20220729_Med1
order DDErrorDELP20220730_Med1
order DDErrorDELP20220731_Med1
order DDErrorDELP20220801_Med1
order DDErrorDELP20220802_Med1
order DDErrorDELP20220803_Med1
order DDErrorDELP20220804_Med1
order DDErrorDELP20220805_Med1
order DDErrorDELP20220806_Med1
order DDErrorDELP20220807_Med1
order DDErrorDELP20220808_Med1
order DDErrorDELP20220809_Med1
order DDErrorDELP20220810_Med1
order DDErrorDELP20220811_Med1
order DDErrorDELP20220812_Med1
order DDErrorDELP20220813_Med1
order DDErrorDELP20220814_Med1
order DDErrorDELP20220815_Med1
order DDErrorDELP20220816_Med1
order DDErrorDELP20220817_Med1
order DDErrorDELP20220818_Med1
order DDErrorDELP20220819_Med1
order DDErrorDELP20220820_Med1
order DDErrorDELP20220821_Med1
order DDErrorDELP20220822_Med1
order DDErrorDELP20220823_Med1
order DDErrorDELP20220824_Med1
order DDErrorDELP20220825_Med1
order DDErrorDELP20220826_Med1
order DDErrorDELP20220827_Med1
order DDErrorDELP20220828_Med1
order DDErrorDELP20220829_Med1
order DDErrorDELP20220830_Med1
order DDErrorDELP20220831_Med1
order DDErrorDELP20220901_Med1
order DDErrorDELP20220902_Med1
order DDErrorDELP20220903_Med1
order DDErrorDELP20220904_Med1
order DDErrorDELP20220905_Med1
order DDErrorDELP20220906_Med1
order DDErrorDELP20220907_Med1
order DDErrorDELP20220908_Med1
order DDErrorDELP20220909_Med1
order DDErrorDELP20220910_Med1
order DDErrorDELP20220911_Med1
order DDErrorDELP20220912_Med1
order DDErrorDELP20220913_Med1
order DDErrorDELP20220914_Med1
order DDErrorDELP20220915_Med1
		
		
capture drop DDErrorDELP_Mean1 // "DDErrorDELP mean over updates of median error by calendar months"
egen DDErrorDELP_Mean1 = rowmean(DDErrorDELP20220915_Med1-DDErrorDELP20200417_Med1) // <<-- modify 5
label var DDErrorDELP_Mean1 "DDErrorDELP mean over updates of median error by calendar months"
qui replace DDErrorDELP_Mean1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDErrorDELP_Mean1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDErrorDELP_Mean1 = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador






* gen DDAbsErrDELP_Mean1 // gen AVERAGE over updates of MEDIAN of error types by calendar months = _Mean1

 // <<-- modify 6
 
order DDAbsErrDELP20200417_Med1
order DDAbsErrDELP20200424_Med1
order DDAbsErrDELP20200501_Med1
order DDAbsErrDELP20200509_Med1
order DDAbsErrDELP20200517_Med1
order DDAbsErrDELP20200524_Med1
order DDAbsErrDELP20200531_Med1
order DDAbsErrDELP20200607_Med1
order DDAbsErrDELP20200614_Med1
order DDAbsErrDELP20200621_Med1
order DDAbsErrDELP20200628_Med1
order DDAbsErrDELP20200704_Med1
order DDAbsErrDELP20200718_Med1
order DDAbsErrDELP20200723_Med1
order DDAbsErrDELP20200801_Med1
order DDAbsErrDELP20200815_Med1
order DDAbsErrDELP20200829_Med1
order DDAbsErrDELP20200912_Med1
order DDAbsErrDELP20200926_Med1
order DDAbsErrDELP20201008_Med1
order DDAbsErrDELP20201022_Med1
order DDAbsErrDELP20201105_Med1
order DDAbsErrDELP20201119_Med1
order DDAbsErrDELP20201203_Med1
order DDAbsErrDELP20201217_Med1
order DDAbsErrDELP20201231_Med1
order DDAbsErrDELP20210114_Med1
order DDAbsErrDELP20210128_Med1
order DDAbsErrDELP20210211_Med1
order DDAbsErrDELP20210225_Med1
order DDAbsErrDELP20210311_Med1
order DDAbsErrDELP20210325_Med1
order DDAbsErrDELP20210408_Med1
order DDAbsErrDELP20210422_Med1
order DDAbsErrDELP20210506_Med1
order DDAbsErrDELP20210520_Med1
order DDAbsErrDELP20210603_Med1
order DDAbsErrDELP20210610_Med1
order DDAbsErrDELP20210617_Med1
order DDAbsErrDELP20210624_Med1
order DDAbsErrDELP20210701_Med1
order DDAbsErrDELP20210708_Med1
order DDAbsErrDELP20210715_Med1
order DDAbsErrDELP20210722_Med1
order DDAbsErrDELP20210729_Med1
order DDAbsErrDELP20210805_Med1
order DDAbsErrDELP20210812_Med1
order DDAbsErrDELP20210819_Med1
order DDAbsErrDELP20210826_Med1
order DDAbsErrDELP20210902_Med1
order DDAbsErrDELP20210909_Med1
order DDAbsErrDELP20210916_Med1
order DDAbsErrDELP20210923_Med1
order DDAbsErrDELP20210930_Med1
order DDAbsErrDELP20211007_Med1
order DDAbsErrDELP20211014_Med1
order DDAbsErrDELP20211021_Med1
order DDAbsErrDELP20211028_Med1
order DDAbsErrDELP20211104_Med1
order DDAbsErrDELP20211111_Med1
order DDAbsErrDELP20211118_Med1
order DDAbsErrDELP20211125_Med1
order DDAbsErrDELP20211202_Med1
order DDAbsErrDELP20211209_Med1
order DDAbsErrDELP20211216_Med1
order DDAbsErrDELP20211223_Med1
order DDAbsErrDELP20211230_Med1
order DDAbsErrDELP20220106_Med1
order DDAbsErrDELP20220113_Med1
order DDAbsErrDELP20220114_Med1
order DDAbsErrDELP20220115_Med1
order DDAbsErrDELP20220116_Med1
order DDAbsErrDELP20220117_Med1
order DDAbsErrDELP20220118_Med1
order DDAbsErrDELP20220119_Med1
order DDAbsErrDELP20220120_Med1
order DDAbsErrDELP20220121_Med1
order DDAbsErrDELP20220122_Med1
order DDAbsErrDELP20220123_Med1
order DDAbsErrDELP20220124_Med1
order DDAbsErrDELP20220125_Med1
order DDAbsErrDELP20220126_Med1
order DDAbsErrDELP20220127_Med1
order DDAbsErrDELP20220128_Med1
order DDAbsErrDELP20220129_Med1
order DDAbsErrDELP20220130_Med1
order DDAbsErrDELP20220131_Med1
order DDAbsErrDELP20220201_Med1
order DDAbsErrDELP20220202_Med1
order DDAbsErrDELP20220203_Med1
order DDAbsErrDELP20220204_Med1
order DDAbsErrDELP20220205_Med1
order DDAbsErrDELP20220206_Med1
order DDAbsErrDELP20220207_Med1
order DDAbsErrDELP20220208_Med1
order DDAbsErrDELP20220209_Med1
order DDAbsErrDELP20220210_Med1
order DDAbsErrDELP20220211_Med1
order DDAbsErrDELP20220212_Med1
order DDAbsErrDELP20220213_Med1
order DDAbsErrDELP20220214_Med1
order DDAbsErrDELP20220215_Med1
order DDAbsErrDELP20220216_Med1
order DDAbsErrDELP20220217_Med1
order DDAbsErrDELP20220218_Med1
order DDAbsErrDELP20220219_Med1
order DDAbsErrDELP20220220_Med1
order DDAbsErrDELP20220221_Med1
order DDAbsErrDELP20220222_Med1
order DDAbsErrDELP20220223_Med1
order DDAbsErrDELP20220224_Med1
order DDAbsErrDELP20220225_Med1
order DDAbsErrDELP20220226_Med1
order DDAbsErrDELP20220227_Med1
order DDAbsErrDELP20220228_Med1
order DDAbsErrDELP20220301_Med1
order DDAbsErrDELP20220302_Med1
order DDAbsErrDELP20220303_Med1
order DDAbsErrDELP20220304_Med1
order DDAbsErrDELP20220305_Med1
order DDAbsErrDELP20220306_Med1
order DDAbsErrDELP20220307_Med1
order DDAbsErrDELP20220308_Med1
order DDAbsErrDELP20220309_Med1
order DDAbsErrDELP20220310_Med1
order DDAbsErrDELP20220311_Med1
order DDAbsErrDELP20220312_Med1
order DDAbsErrDELP20220313_Med1
order DDAbsErrDELP20220314_Med1
order DDAbsErrDELP20220315_Med1
order DDAbsErrDELP20220316_Med1
order DDAbsErrDELP20220317_Med1
order DDAbsErrDELP20220318_Med1
order DDAbsErrDELP20220319_Med1
order DDAbsErrDELP20220320_Med1
order DDAbsErrDELP20220321_Med1
order DDAbsErrDELP20220322_Med1
order DDAbsErrDELP20220323_Med1
order DDAbsErrDELP20220324_Med1
order DDAbsErrDELP20220325_Med1
order DDAbsErrDELP20220326_Med1
order DDAbsErrDELP20220327_Med1
order DDAbsErrDELP20220328_Med1
order DDAbsErrDELP20220329_Med1
order DDAbsErrDELP20220330_Med1
order DDAbsErrDELP20220331_Med1
order DDAbsErrDELP20220401_Med1
order DDAbsErrDELP20220402_Med1
order DDAbsErrDELP20220403_Med1
order DDAbsErrDELP20220404_Med1
order DDAbsErrDELP20220405_Med1
order DDAbsErrDELP20220406_Med1
order DDAbsErrDELP20220407_Med1
order DDAbsErrDELP20220408_Med1
order DDAbsErrDELP20220409_Med1
order DDAbsErrDELP20220410_Med1
order DDAbsErrDELP20220411_Med1
order DDAbsErrDELP20220412_Med1
order DDAbsErrDELP20220413_Med1
order DDAbsErrDELP20220414_Med1
order DDAbsErrDELP20220415_Med1
order DDAbsErrDELP20220416_Med1
order DDAbsErrDELP20220417_Med1
order DDAbsErrDELP20220418_Med1
order DDAbsErrDELP20220419_Med1
order DDAbsErrDELP20220420_Med1
order DDAbsErrDELP20220421_Med1
order DDAbsErrDELP20220422_Med1
order DDAbsErrDELP20220423_Med1
order DDAbsErrDELP20220424_Med1
order DDAbsErrDELP20220425_Med1
order DDAbsErrDELP20220426_Med1
order DDAbsErrDELP20220427_Med1
order DDAbsErrDELP20220428_Med1
order DDAbsErrDELP20220429_Med1
order DDAbsErrDELP20220430_Med1
order DDAbsErrDELP20220501_Med1
order DDAbsErrDELP20220502_Med1
order DDAbsErrDELP20220503_Med1
order DDAbsErrDELP20220504_Med1
order DDAbsErrDELP20220505_Med1
order DDAbsErrDELP20220506_Med1
order DDAbsErrDELP20220507_Med1
order DDAbsErrDELP20220508_Med1
order DDAbsErrDELP20220509_Med1
order DDAbsErrDELP20220510_Med1
order DDAbsErrDELP20220511_Med1
order DDAbsErrDELP20220512_Med1
order DDAbsErrDELP20220513_Med1
order DDAbsErrDELP20220514_Med1
order DDAbsErrDELP20220515_Med1
order DDAbsErrDELP20220516_Med1
order DDAbsErrDELP20220517_Med1
order DDAbsErrDELP20220518_Med1
order DDAbsErrDELP20220519_Med1
order DDAbsErrDELP20220520_Med1
order DDAbsErrDELP20220521_Med1
order DDAbsErrDELP20220522_Med1
order DDAbsErrDELP20220523_Med1
order DDAbsErrDELP20220524_Med1
order DDAbsErrDELP20220525_Med1
order DDAbsErrDELP20220526_Med1
order DDAbsErrDELP20220527_Med1
order DDAbsErrDELP20220528_Med1
order DDAbsErrDELP20220529_Med1
order DDAbsErrDELP20220530_Med1
order DDAbsErrDELP20220531_Med1
order DDAbsErrDELP20220601_Med1
order DDAbsErrDELP20220602_Med1
order DDAbsErrDELP20220603_Med1
order DDAbsErrDELP20220604_Med1
order DDAbsErrDELP20220605_Med1
order DDAbsErrDELP20220606_Med1
order DDAbsErrDELP20220607_Med1
order DDAbsErrDELP20220608_Med1
order DDAbsErrDELP20220609_Med1
order DDAbsErrDELP20220610_Med1
order DDAbsErrDELP20220611_Med1
order DDAbsErrDELP20220612_Med1
order DDAbsErrDELP20220613_Med1
order DDAbsErrDELP20220614_Med1
order DDAbsErrDELP20220615_Med1
order DDAbsErrDELP20220616_Med1
order DDAbsErrDELP20220617_Med1
order DDAbsErrDELP20220618_Med1
order DDAbsErrDELP20220619_Med1
order DDAbsErrDELP20220620_Med1
order DDAbsErrDELP20220621_Med1
order DDAbsErrDELP20220622_Med1
order DDAbsErrDELP20220623_Med1
order DDAbsErrDELP20220624_Med1
order DDAbsErrDELP20220625_Med1
order DDAbsErrDELP20220626_Med1
order DDAbsErrDELP20220627_Med1
order DDAbsErrDELP20220628_Med1
order DDAbsErrDELP20220629_Med1
order DDAbsErrDELP20220630_Med1
order DDAbsErrDELP20220701_Med1
order DDAbsErrDELP20220702_Med1
order DDAbsErrDELP20220703_Med1
order DDAbsErrDELP20220704_Med1
order DDAbsErrDELP20220705_Med1
order DDAbsErrDELP20220706_Med1
order DDAbsErrDELP20220707_Med1
order DDAbsErrDELP20220708_Med1
order DDAbsErrDELP20220709_Med1
order DDAbsErrDELP20220710_Med1
order DDAbsErrDELP20220711_Med1
order DDAbsErrDELP20220712_Med1
order DDAbsErrDELP20220713_Med1
order DDAbsErrDELP20220714_Med1
order DDAbsErrDELP20220715_Med1
order DDAbsErrDELP20220716_Med1
order DDAbsErrDELP20220717_Med1
order DDAbsErrDELP20220718_Med1
order DDAbsErrDELP20220719_Med1
order DDAbsErrDELP20220720_Med1
order DDAbsErrDELP20220721_Med1
order DDAbsErrDELP20220722_Med1
order DDAbsErrDELP20220723_Med1
order DDAbsErrDELP20220724_Med1
order DDAbsErrDELP20220725_Med1
order DDAbsErrDELP20220726_Med1
order DDAbsErrDELP20220727_Med1
order DDAbsErrDELP20220728_Med1
order DDAbsErrDELP20220729_Med1
order DDAbsErrDELP20220730_Med1
order DDAbsErrDELP20220731_Med1
order DDAbsErrDELP20220801_Med1
order DDAbsErrDELP20220802_Med1
order DDAbsErrDELP20220803_Med1
order DDAbsErrDELP20220804_Med1
order DDAbsErrDELP20220805_Med1
order DDAbsErrDELP20220806_Med1
order DDAbsErrDELP20220807_Med1
order DDAbsErrDELP20220808_Med1
order DDAbsErrDELP20220809_Med1
order DDAbsErrDELP20220810_Med1
order DDAbsErrDELP20220811_Med1
order DDAbsErrDELP20220812_Med1
order DDAbsErrDELP20220813_Med1
order DDAbsErrDELP20220814_Med1
order DDAbsErrDELP20220815_Med1
order DDAbsErrDELP20220816_Med1
order DDAbsErrDELP20220817_Med1
order DDAbsErrDELP20220818_Med1
order DDAbsErrDELP20220819_Med1
order DDAbsErrDELP20220820_Med1
order DDAbsErrDELP20220821_Med1
order DDAbsErrDELP20220822_Med1
order DDAbsErrDELP20220823_Med1
order DDAbsErrDELP20220824_Med1
order DDAbsErrDELP20220825_Med1
order DDAbsErrDELP20220826_Med1
order DDAbsErrDELP20220827_Med1
order DDAbsErrDELP20220828_Med1
order DDAbsErrDELP20220829_Med1
order DDAbsErrDELP20220830_Med1
order DDAbsErrDELP20220831_Med1
order DDAbsErrDELP20220901_Med1
order DDAbsErrDELP20220902_Med1
order DDAbsErrDELP20220903_Med1
order DDAbsErrDELP20220904_Med1
order DDAbsErrDELP20220905_Med1
order DDAbsErrDELP20220906_Med1
order DDAbsErrDELP20220907_Med1
order DDAbsErrDELP20220908_Med1
order DDAbsErrDELP20220909_Med1
order DDAbsErrDELP20220910_Med1
order DDAbsErrDELP20220911_Med1
order DDAbsErrDELP20220912_Med1
order DDAbsErrDELP20220913_Med1
order DDAbsErrDELP20220914_Med1
order DDAbsErrDELP20220915_Med1


capture drop DDAbsErrDELP_Mean1 // "DDAbsErrDELP mean over updates of median absolute error by calendar months"
egen DDAbsErrDELP_Mean1 = rowmean(DDAbsErrDELP20220915_Med1-DDAbsErrDELP20200417_Med1) // <<-- modify 7
label var DDAbsErrDELP_Mean1 "DDAbsErrDELP mean over updates of median absolute error by calendar months"
qui replace DDAbsErrDELP_Mean1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbsErrDELP_Mean1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbsErrDELP_Mean1 = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador







* gen DDPerErrDELP_Mean1 // gen AVERAGE over updates of MEDIAN of error types by calendar months = _Mean1

// <<-- modify 8

order DDPerErrDELP20200417_Med1
order DDPerErrDELP20200424_Med1
order DDPerErrDELP20200501_Med1
order DDPerErrDELP20200509_Med1
order DDPerErrDELP20200517_Med1
order DDPerErrDELP20200524_Med1
order DDPerErrDELP20200531_Med1
order DDPerErrDELP20200607_Med1
order DDPerErrDELP20200614_Med1
order DDPerErrDELP20200621_Med1
order DDPerErrDELP20200628_Med1
order DDPerErrDELP20200704_Med1
order DDPerErrDELP20200718_Med1
order DDPerErrDELP20200723_Med1
order DDPerErrDELP20200801_Med1
order DDPerErrDELP20200815_Med1
order DDPerErrDELP20200829_Med1
order DDPerErrDELP20200912_Med1
order DDPerErrDELP20200926_Med1
order DDPerErrDELP20201008_Med1
order DDPerErrDELP20201022_Med1
order DDPerErrDELP20201105_Med1
order DDPerErrDELP20201119_Med1
order DDPerErrDELP20201203_Med1
order DDPerErrDELP20201217_Med1
order DDPerErrDELP20201231_Med1
order DDPerErrDELP20210114_Med1
order DDPerErrDELP20210128_Med1
order DDPerErrDELP20210211_Med1
order DDPerErrDELP20210225_Med1
order DDPerErrDELP20210311_Med1
order DDPerErrDELP20210325_Med1
order DDPerErrDELP20210408_Med1
order DDPerErrDELP20210422_Med1
order DDPerErrDELP20210506_Med1
order DDPerErrDELP20210520_Med1
order DDPerErrDELP20210603_Med1
order DDPerErrDELP20210610_Med1
order DDPerErrDELP20210617_Med1
order DDPerErrDELP20210624_Med1
order DDPerErrDELP20210701_Med1
order DDPerErrDELP20210708_Med1
order DDPerErrDELP20210715_Med1
order DDPerErrDELP20210722_Med1
order DDPerErrDELP20210729_Med1
order DDPerErrDELP20210805_Med1
order DDPerErrDELP20210812_Med1
order DDPerErrDELP20210819_Med1
order DDPerErrDELP20210826_Med1
order DDPerErrDELP20210902_Med1
order DDPerErrDELP20210909_Med1
order DDPerErrDELP20210916_Med1
order DDPerErrDELP20210923_Med1
order DDPerErrDELP20210930_Med1
order DDPerErrDELP20211007_Med1
order DDPerErrDELP20211014_Med1
order DDPerErrDELP20211021_Med1
order DDPerErrDELP20211028_Med1
order DDPerErrDELP20211104_Med1
order DDPerErrDELP20211111_Med1
order DDPerErrDELP20211118_Med1
order DDPerErrDELP20211125_Med1
order DDPerErrDELP20211202_Med1
order DDPerErrDELP20211209_Med1
order DDPerErrDELP20211216_Med1
order DDPerErrDELP20211223_Med1
order DDPerErrDELP20211230_Med1
order DDPerErrDELP20220106_Med1
order DDPerErrDELP20220113_Med1
order DDPerErrDELP20220114_Med1
order DDPerErrDELP20220115_Med1
order DDPerErrDELP20220116_Med1
order DDPerErrDELP20220117_Med1
order DDPerErrDELP20220118_Med1
order DDPerErrDELP20220119_Med1
order DDPerErrDELP20220120_Med1
order DDPerErrDELP20220121_Med1
order DDPerErrDELP20220122_Med1
order DDPerErrDELP20220123_Med1
order DDPerErrDELP20220124_Med1
order DDPerErrDELP20220125_Med1
order DDPerErrDELP20220126_Med1
order DDPerErrDELP20220127_Med1
order DDPerErrDELP20220128_Med1
order DDPerErrDELP20220129_Med1
order DDPerErrDELP20220130_Med1
order DDPerErrDELP20220131_Med1
order DDPerErrDELP20220201_Med1
order DDPerErrDELP20220202_Med1
order DDPerErrDELP20220203_Med1
order DDPerErrDELP20220204_Med1
order DDPerErrDELP20220205_Med1
order DDPerErrDELP20220206_Med1
order DDPerErrDELP20220207_Med1
order DDPerErrDELP20220208_Med1
order DDPerErrDELP20220209_Med1
order DDPerErrDELP20220210_Med1
order DDPerErrDELP20220211_Med1
order DDPerErrDELP20220212_Med1
order DDPerErrDELP20220213_Med1
order DDPerErrDELP20220214_Med1
order DDPerErrDELP20220215_Med1
order DDPerErrDELP20220216_Med1
order DDPerErrDELP20220217_Med1
order DDPerErrDELP20220218_Med1
order DDPerErrDELP20220219_Med1
order DDPerErrDELP20220220_Med1
order DDPerErrDELP20220221_Med1
order DDPerErrDELP20220222_Med1
order DDPerErrDELP20220223_Med1
order DDPerErrDELP20220224_Med1
order DDPerErrDELP20220225_Med1
order DDPerErrDELP20220226_Med1
order DDPerErrDELP20220227_Med1
order DDPerErrDELP20220228_Med1
order DDPerErrDELP20220301_Med1
order DDPerErrDELP20220302_Med1
order DDPerErrDELP20220303_Med1
order DDPerErrDELP20220304_Med1
order DDPerErrDELP20220305_Med1
order DDPerErrDELP20220306_Med1
order DDPerErrDELP20220307_Med1
order DDPerErrDELP20220308_Med1
order DDPerErrDELP20220309_Med1
order DDPerErrDELP20220310_Med1
order DDPerErrDELP20220311_Med1
order DDPerErrDELP20220312_Med1
order DDPerErrDELP20220313_Med1
order DDPerErrDELP20220314_Med1
order DDPerErrDELP20220315_Med1
order DDPerErrDELP20220316_Med1
order DDPerErrDELP20220317_Med1
order DDPerErrDELP20220318_Med1
order DDPerErrDELP20220319_Med1
order DDPerErrDELP20220320_Med1
order DDPerErrDELP20220321_Med1
order DDPerErrDELP20220322_Med1
order DDPerErrDELP20220323_Med1
order DDPerErrDELP20220324_Med1
order DDPerErrDELP20220325_Med1
order DDPerErrDELP20220326_Med1
order DDPerErrDELP20220327_Med1
order DDPerErrDELP20220328_Med1
order DDPerErrDELP20220329_Med1
order DDPerErrDELP20220330_Med1
order DDPerErrDELP20220331_Med1
order DDPerErrDELP20220401_Med1
order DDPerErrDELP20220402_Med1
order DDPerErrDELP20220403_Med1
order DDPerErrDELP20220404_Med1
order DDPerErrDELP20220405_Med1
order DDPerErrDELP20220406_Med1
order DDPerErrDELP20220407_Med1
order DDPerErrDELP20220408_Med1
order DDPerErrDELP20220409_Med1
order DDPerErrDELP20220410_Med1
order DDPerErrDELP20220411_Med1
order DDPerErrDELP20220412_Med1
order DDPerErrDELP20220413_Med1
order DDPerErrDELP20220414_Med1
order DDPerErrDELP20220415_Med1
order DDPerErrDELP20220416_Med1
order DDPerErrDELP20220417_Med1
order DDPerErrDELP20220418_Med1
order DDPerErrDELP20220419_Med1
order DDPerErrDELP20220420_Med1
order DDPerErrDELP20220421_Med1
order DDPerErrDELP20220422_Med1
order DDPerErrDELP20220423_Med1
order DDPerErrDELP20220424_Med1
order DDPerErrDELP20220425_Med1
order DDPerErrDELP20220426_Med1
order DDPerErrDELP20220427_Med1
order DDPerErrDELP20220428_Med1
order DDPerErrDELP20220429_Med1
order DDPerErrDELP20220430_Med1
order DDPerErrDELP20220501_Med1
order DDPerErrDELP20220502_Med1
order DDPerErrDELP20220503_Med1
order DDPerErrDELP20220504_Med1
order DDPerErrDELP20220505_Med1
order DDPerErrDELP20220506_Med1
order DDPerErrDELP20220507_Med1
order DDPerErrDELP20220508_Med1
order DDPerErrDELP20220509_Med1
order DDPerErrDELP20220510_Med1
order DDPerErrDELP20220511_Med1
order DDPerErrDELP20220512_Med1
order DDPerErrDELP20220513_Med1
order DDPerErrDELP20220514_Med1
order DDPerErrDELP20220515_Med1
order DDPerErrDELP20220516_Med1
order DDPerErrDELP20220517_Med1
order DDPerErrDELP20220518_Med1
order DDPerErrDELP20220519_Med1
order DDPerErrDELP20220520_Med1
order DDPerErrDELP20220521_Med1
order DDPerErrDELP20220522_Med1
order DDPerErrDELP20220523_Med1
order DDPerErrDELP20220524_Med1
order DDPerErrDELP20220525_Med1
order DDPerErrDELP20220526_Med1
order DDPerErrDELP20220527_Med1
order DDPerErrDELP20220528_Med1
order DDPerErrDELP20220529_Med1
order DDPerErrDELP20220530_Med1
order DDPerErrDELP20220531_Med1
order DDPerErrDELP20220601_Med1
order DDPerErrDELP20220602_Med1
order DDPerErrDELP20220603_Med1
order DDPerErrDELP20220604_Med1
order DDPerErrDELP20220605_Med1
order DDPerErrDELP20220606_Med1
order DDPerErrDELP20220607_Med1
order DDPerErrDELP20220608_Med1
order DDPerErrDELP20220609_Med1
order DDPerErrDELP20220610_Med1
order DDPerErrDELP20220611_Med1
order DDPerErrDELP20220612_Med1
order DDPerErrDELP20220613_Med1
order DDPerErrDELP20220614_Med1
order DDPerErrDELP20220615_Med1
order DDPerErrDELP20220616_Med1
order DDPerErrDELP20220617_Med1
order DDPerErrDELP20220618_Med1
order DDPerErrDELP20220619_Med1
order DDPerErrDELP20220620_Med1
order DDPerErrDELP20220621_Med1
order DDPerErrDELP20220622_Med1
order DDPerErrDELP20220623_Med1
order DDPerErrDELP20220624_Med1
order DDPerErrDELP20220625_Med1
order DDPerErrDELP20220626_Med1
order DDPerErrDELP20220627_Med1
order DDPerErrDELP20220628_Med1
order DDPerErrDELP20220629_Med1
order DDPerErrDELP20220630_Med1
order DDPerErrDELP20220701_Med1
order DDPerErrDELP20220702_Med1
order DDPerErrDELP20220703_Med1
order DDPerErrDELP20220704_Med1
order DDPerErrDELP20220705_Med1
order DDPerErrDELP20220706_Med1
order DDPerErrDELP20220707_Med1
order DDPerErrDELP20220708_Med1
order DDPerErrDELP20220709_Med1
order DDPerErrDELP20220710_Med1
order DDPerErrDELP20220711_Med1
order DDPerErrDELP20220712_Med1
order DDPerErrDELP20220713_Med1
order DDPerErrDELP20220714_Med1
order DDPerErrDELP20220715_Med1
order DDPerErrDELP20220716_Med1
order DDPerErrDELP20220717_Med1
order DDPerErrDELP20220718_Med1
order DDPerErrDELP20220719_Med1
order DDPerErrDELP20220720_Med1
order DDPerErrDELP20220721_Med1
order DDPerErrDELP20220722_Med1
order DDPerErrDELP20220723_Med1
order DDPerErrDELP20220724_Med1
order DDPerErrDELP20220725_Med1
order DDPerErrDELP20220726_Med1
order DDPerErrDELP20220727_Med1
order DDPerErrDELP20220728_Med1
order DDPerErrDELP20220729_Med1
order DDPerErrDELP20220730_Med1
order DDPerErrDELP20220731_Med1
order DDPerErrDELP20220801_Med1
order DDPerErrDELP20220802_Med1
order DDPerErrDELP20220803_Med1
order DDPerErrDELP20220804_Med1
order DDPerErrDELP20220805_Med1
order DDPerErrDELP20220806_Med1
order DDPerErrDELP20220807_Med1
order DDPerErrDELP20220808_Med1
order DDPerErrDELP20220809_Med1
order DDPerErrDELP20220810_Med1
order DDPerErrDELP20220811_Med1
order DDPerErrDELP20220812_Med1
order DDPerErrDELP20220813_Med1
order DDPerErrDELP20220814_Med1
order DDPerErrDELP20220815_Med1
order DDPerErrDELP20220816_Med1
order DDPerErrDELP20220817_Med1
order DDPerErrDELP20220818_Med1
order DDPerErrDELP20220819_Med1
order DDPerErrDELP20220820_Med1
order DDPerErrDELP20220821_Med1
order DDPerErrDELP20220822_Med1
order DDPerErrDELP20220823_Med1
order DDPerErrDELP20220824_Med1
order DDPerErrDELP20220825_Med1
order DDPerErrDELP20220826_Med1
order DDPerErrDELP20220827_Med1
order DDPerErrDELP20220828_Med1
order DDPerErrDELP20220829_Med1
order DDPerErrDELP20220830_Med1
order DDPerErrDELP20220831_Med1
order DDPerErrDELP20220901_Med1
order DDPerErrDELP20220902_Med1
order DDPerErrDELP20220903_Med1
order DDPerErrDELP20220904_Med1
order DDPerErrDELP20220905_Med1
order DDPerErrDELP20220906_Med1
order DDPerErrDELP20220907_Med1
order DDPerErrDELP20220908_Med1
order DDPerErrDELP20220909_Med1
order DDPerErrDELP20220910_Med1
order DDPerErrDELP20220911_Med1
order DDPerErrDELP20220912_Med1
order DDPerErrDELP20220913_Med1
order DDPerErrDELP20220914_Med1
order DDPerErrDELP20220915_Med1
		

capture drop DDPerErrDELP_Mean1 // "DDPerErrDELP mean over updates of median % error by calendar months"
egen DDPerErrDELP_Mean1 = rowmean(DDPerErrDELP20220915_Med1-DDPerErrDELP20200417_Med1) // <<-- modify 9
label var DDPerErrDELP_Mean1 "DDPerErrDELP mean over updates of median % error by calendar months"
qui replace DDPerErrDELP_Mean1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDPerErrDELP_Mean1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDPerErrDELP_Mean1 = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador








* gen DDAbPeErDELP_Mean1 // gen AVERAGE over updates of MEDIAN of error types by calendar months = _Mean1

 // <<-- modify 10
 
order DDAbPeErDELP20200417_Med1
order DDAbPeErDELP20200424_Med1
order DDAbPeErDELP20200501_Med1
order DDAbPeErDELP20200509_Med1
order DDAbPeErDELP20200517_Med1
order DDAbPeErDELP20200524_Med1
order DDAbPeErDELP20200531_Med1
order DDAbPeErDELP20200607_Med1
order DDAbPeErDELP20200614_Med1
order DDAbPeErDELP20200621_Med1
order DDAbPeErDELP20200628_Med1
order DDAbPeErDELP20200704_Med1
order DDAbPeErDELP20200718_Med1
order DDAbPeErDELP20200723_Med1
order DDAbPeErDELP20200801_Med1
order DDAbPeErDELP20200815_Med1
order DDAbPeErDELP20200829_Med1
order DDAbPeErDELP20200912_Med1
order DDAbPeErDELP20200926_Med1
order DDAbPeErDELP20201008_Med1
order DDAbPeErDELP20201022_Med1
order DDAbPeErDELP20201105_Med1
order DDAbPeErDELP20201119_Med1
order DDAbPeErDELP20201203_Med1
order DDAbPeErDELP20201217_Med1
order DDAbPeErDELP20201231_Med1
order DDAbPeErDELP20210114_Med1
order DDAbPeErDELP20210128_Med1
order DDAbPeErDELP20210211_Med1
order DDAbPeErDELP20210225_Med1
order DDAbPeErDELP20210311_Med1
order DDAbPeErDELP20210325_Med1
order DDAbPeErDELP20210408_Med1
order DDAbPeErDELP20210422_Med1
order DDAbPeErDELP20210506_Med1
order DDAbPeErDELP20210520_Med1
order DDAbPeErDELP20210603_Med1
order DDAbPeErDELP20210610_Med1
order DDAbPeErDELP20210617_Med1
order DDAbPeErDELP20210624_Med1
order DDAbPeErDELP20210701_Med1
order DDAbPeErDELP20210708_Med1
order DDAbPeErDELP20210715_Med1
order DDAbPeErDELP20210722_Med1
order DDAbPeErDELP20210729_Med1
order DDAbPeErDELP20210805_Med1
order DDAbPeErDELP20210812_Med1
order DDAbPeErDELP20210819_Med1
order DDAbPeErDELP20210826_Med1
order DDAbPeErDELP20210902_Med1
order DDAbPeErDELP20210909_Med1
order DDAbPeErDELP20210916_Med1
order DDAbPeErDELP20210923_Med1
order DDAbPeErDELP20210930_Med1
order DDAbPeErDELP20211007_Med1
order DDAbPeErDELP20211014_Med1
order DDAbPeErDELP20211021_Med1
order DDAbPeErDELP20211028_Med1
order DDAbPeErDELP20211104_Med1
order DDAbPeErDELP20211111_Med1
order DDAbPeErDELP20211118_Med1
order DDAbPeErDELP20211125_Med1
order DDAbPeErDELP20211202_Med1
order DDAbPeErDELP20211209_Med1
order DDAbPeErDELP20211216_Med1
order DDAbPeErDELP20211223_Med1
order DDAbPeErDELP20211230_Med1
order DDAbPeErDELP20220106_Med1
order DDAbPeErDELP20220113_Med1
order DDAbPeErDELP20220114_Med1
order DDAbPeErDELP20220115_Med1
order DDAbPeErDELP20220116_Med1
order DDAbPeErDELP20220117_Med1
order DDAbPeErDELP20220118_Med1
order DDAbPeErDELP20220119_Med1
order DDAbPeErDELP20220120_Med1
order DDAbPeErDELP20220121_Med1
order DDAbPeErDELP20220122_Med1
order DDAbPeErDELP20220123_Med1
order DDAbPeErDELP20220124_Med1
order DDAbPeErDELP20220125_Med1
order DDAbPeErDELP20220126_Med1
order DDAbPeErDELP20220127_Med1
order DDAbPeErDELP20220128_Med1
order DDAbPeErDELP20220129_Med1
order DDAbPeErDELP20220130_Med1
order DDAbPeErDELP20220131_Med1
order DDAbPeErDELP20220201_Med1
order DDAbPeErDELP20220202_Med1
order DDAbPeErDELP20220203_Med1
order DDAbPeErDELP20220204_Med1
order DDAbPeErDELP20220205_Med1
order DDAbPeErDELP20220206_Med1
order DDAbPeErDELP20220207_Med1
order DDAbPeErDELP20220208_Med1
order DDAbPeErDELP20220209_Med1
order DDAbPeErDELP20220210_Med1
order DDAbPeErDELP20220211_Med1
order DDAbPeErDELP20220212_Med1
order DDAbPeErDELP20220213_Med1
order DDAbPeErDELP20220214_Med1
order DDAbPeErDELP20220215_Med1
order DDAbPeErDELP20220216_Med1
order DDAbPeErDELP20220217_Med1
order DDAbPeErDELP20220218_Med1
order DDAbPeErDELP20220219_Med1
order DDAbPeErDELP20220220_Med1
order DDAbPeErDELP20220221_Med1
order DDAbPeErDELP20220222_Med1
order DDAbPeErDELP20220223_Med1
order DDAbPeErDELP20220224_Med1
order DDAbPeErDELP20220225_Med1
order DDAbPeErDELP20220226_Med1
order DDAbPeErDELP20220227_Med1
order DDAbPeErDELP20220228_Med1
order DDAbPeErDELP20220301_Med1
order DDAbPeErDELP20220302_Med1
order DDAbPeErDELP20220303_Med1
order DDAbPeErDELP20220304_Med1
order DDAbPeErDELP20220305_Med1
order DDAbPeErDELP20220306_Med1
order DDAbPeErDELP20220307_Med1
order DDAbPeErDELP20220308_Med1
order DDAbPeErDELP20220309_Med1
order DDAbPeErDELP20220310_Med1
order DDAbPeErDELP20220311_Med1
order DDAbPeErDELP20220312_Med1
order DDAbPeErDELP20220313_Med1
order DDAbPeErDELP20220314_Med1
order DDAbPeErDELP20220315_Med1
order DDAbPeErDELP20220316_Med1
order DDAbPeErDELP20220317_Med1
order DDAbPeErDELP20220318_Med1
order DDAbPeErDELP20220319_Med1
order DDAbPeErDELP20220320_Med1
order DDAbPeErDELP20220321_Med1
order DDAbPeErDELP20220322_Med1
order DDAbPeErDELP20220323_Med1
order DDAbPeErDELP20220324_Med1
order DDAbPeErDELP20220325_Med1
order DDAbPeErDELP20220326_Med1
order DDAbPeErDELP20220327_Med1
order DDAbPeErDELP20220328_Med1
order DDAbPeErDELP20220329_Med1
order DDAbPeErDELP20220330_Med1
order DDAbPeErDELP20220331_Med1
order DDAbPeErDELP20220401_Med1
order DDAbPeErDELP20220402_Med1
order DDAbPeErDELP20220403_Med1
order DDAbPeErDELP20220404_Med1
order DDAbPeErDELP20220405_Med1
order DDAbPeErDELP20220406_Med1
order DDAbPeErDELP20220407_Med1
order DDAbPeErDELP20220408_Med1
order DDAbPeErDELP20220409_Med1
order DDAbPeErDELP20220410_Med1
order DDAbPeErDELP20220411_Med1
order DDAbPeErDELP20220412_Med1
order DDAbPeErDELP20220413_Med1
order DDAbPeErDELP20220414_Med1
order DDAbPeErDELP20220415_Med1
order DDAbPeErDELP20220416_Med1
order DDAbPeErDELP20220417_Med1
order DDAbPeErDELP20220418_Med1
order DDAbPeErDELP20220419_Med1
order DDAbPeErDELP20220420_Med1
order DDAbPeErDELP20220421_Med1
order DDAbPeErDELP20220422_Med1
order DDAbPeErDELP20220423_Med1
order DDAbPeErDELP20220424_Med1
order DDAbPeErDELP20220425_Med1
order DDAbPeErDELP20220426_Med1
order DDAbPeErDELP20220427_Med1
order DDAbPeErDELP20220428_Med1
order DDAbPeErDELP20220429_Med1
order DDAbPeErDELP20220430_Med1
order DDAbPeErDELP20220501_Med1
order DDAbPeErDELP20220502_Med1
order DDAbPeErDELP20220503_Med1
order DDAbPeErDELP20220504_Med1
order DDAbPeErDELP20220505_Med1
order DDAbPeErDELP20220506_Med1
order DDAbPeErDELP20220507_Med1
order DDAbPeErDELP20220508_Med1
order DDAbPeErDELP20220509_Med1
order DDAbPeErDELP20220510_Med1
order DDAbPeErDELP20220511_Med1
order DDAbPeErDELP20220512_Med1
order DDAbPeErDELP20220513_Med1
order DDAbPeErDELP20220514_Med1
order DDAbPeErDELP20220515_Med1
order DDAbPeErDELP20220516_Med1
order DDAbPeErDELP20220517_Med1
order DDAbPeErDELP20220518_Med1
order DDAbPeErDELP20220519_Med1
order DDAbPeErDELP20220520_Med1
order DDAbPeErDELP20220521_Med1
order DDAbPeErDELP20220522_Med1
order DDAbPeErDELP20220523_Med1
order DDAbPeErDELP20220524_Med1
order DDAbPeErDELP20220525_Med1
order DDAbPeErDELP20220526_Med1
order DDAbPeErDELP20220527_Med1
order DDAbPeErDELP20220528_Med1
order DDAbPeErDELP20220529_Med1
order DDAbPeErDELP20220530_Med1
order DDAbPeErDELP20220531_Med1
order DDAbPeErDELP20220601_Med1
order DDAbPeErDELP20220602_Med1
order DDAbPeErDELP20220603_Med1
order DDAbPeErDELP20220604_Med1
order DDAbPeErDELP20220605_Med1
order DDAbPeErDELP20220606_Med1
order DDAbPeErDELP20220607_Med1
order DDAbPeErDELP20220608_Med1
order DDAbPeErDELP20220609_Med1
order DDAbPeErDELP20220610_Med1
order DDAbPeErDELP20220611_Med1
order DDAbPeErDELP20220612_Med1
order DDAbPeErDELP20220613_Med1
order DDAbPeErDELP20220614_Med1
order DDAbPeErDELP20220615_Med1
order DDAbPeErDELP20220616_Med1
order DDAbPeErDELP20220617_Med1
order DDAbPeErDELP20220618_Med1
order DDAbPeErDELP20220619_Med1
order DDAbPeErDELP20220620_Med1
order DDAbPeErDELP20220621_Med1
order DDAbPeErDELP20220622_Med1
order DDAbPeErDELP20220623_Med1
order DDAbPeErDELP20220624_Med1
order DDAbPeErDELP20220625_Med1
order DDAbPeErDELP20220626_Med1
order DDAbPeErDELP20220627_Med1
order DDAbPeErDELP20220628_Med1
order DDAbPeErDELP20220629_Med1
order DDAbPeErDELP20220630_Med1
order DDAbPeErDELP20220701_Med1
order DDAbPeErDELP20220702_Med1
order DDAbPeErDELP20220703_Med1
order DDAbPeErDELP20220704_Med1
order DDAbPeErDELP20220705_Med1
order DDAbPeErDELP20220706_Med1
order DDAbPeErDELP20220707_Med1
order DDAbPeErDELP20220708_Med1
order DDAbPeErDELP20220709_Med1
order DDAbPeErDELP20220710_Med1
order DDAbPeErDELP20220711_Med1
order DDAbPeErDELP20220712_Med1
order DDAbPeErDELP20220713_Med1
order DDAbPeErDELP20220714_Med1
order DDAbPeErDELP20220715_Med1
order DDAbPeErDELP20220716_Med1
order DDAbPeErDELP20220717_Med1
order DDAbPeErDELP20220718_Med1
order DDAbPeErDELP20220719_Med1
order DDAbPeErDELP20220720_Med1
order DDAbPeErDELP20220721_Med1
order DDAbPeErDELP20220722_Med1
order DDAbPeErDELP20220723_Med1
order DDAbPeErDELP20220724_Med1
order DDAbPeErDELP20220725_Med1
order DDAbPeErDELP20220726_Med1
order DDAbPeErDELP20220727_Med1
order DDAbPeErDELP20220728_Med1
order DDAbPeErDELP20220729_Med1
order DDAbPeErDELP20220730_Med1
order DDAbPeErDELP20220731_Med1
order DDAbPeErDELP20220801_Med1
order DDAbPeErDELP20220802_Med1
order DDAbPeErDELP20220803_Med1
order DDAbPeErDELP20220804_Med1
order DDAbPeErDELP20220805_Med1
order DDAbPeErDELP20220806_Med1
order DDAbPeErDELP20220807_Med1
order DDAbPeErDELP20220808_Med1
order DDAbPeErDELP20220809_Med1
order DDAbPeErDELP20220810_Med1
order DDAbPeErDELP20220811_Med1
order DDAbPeErDELP20220812_Med1
order DDAbPeErDELP20220813_Med1
order DDAbPeErDELP20220814_Med1
order DDAbPeErDELP20220815_Med1
order DDAbPeErDELP20220816_Med1
order DDAbPeErDELP20220817_Med1
order DDAbPeErDELP20220818_Med1
order DDAbPeErDELP20220819_Med1
order DDAbPeErDELP20220820_Med1
order DDAbPeErDELP20220821_Med1
order DDAbPeErDELP20220822_Med1
order DDAbPeErDELP20220823_Med1
order DDAbPeErDELP20220824_Med1
order DDAbPeErDELP20220825_Med1
order DDAbPeErDELP20220826_Med1
order DDAbPeErDELP20220827_Med1
order DDAbPeErDELP20220828_Med1
order DDAbPeErDELP20220829_Med1
order DDAbPeErDELP20220830_Med1
order DDAbPeErDELP20220831_Med1
order DDAbPeErDELP20220901_Med1
order DDAbPeErDELP20220902_Med1
order DDAbPeErDELP20220903_Med1
order DDAbPeErDELP20220904_Med1
order DDAbPeErDELP20220905_Med1
order DDAbPeErDELP20220906_Med1
order DDAbPeErDELP20220907_Med1
order DDAbPeErDELP20220908_Med1
order DDAbPeErDELP20220909_Med1
order DDAbPeErDELP20220910_Med1
order DDAbPeErDELP20220911_Med1
order DDAbPeErDELP20220912_Med1
order DDAbPeErDELP20220913_Med1
order DDAbPeErDELP20220914_Med1
order DDAbPeErDELP20220915_Med1

capture drop DDAbPeErDELP_Mean1 // "DDAbPeErDELP mean over updates of median absolute % error by calendar months"
egen DDAbPeErDELP_Mean1 = rowmean(DDAbPeErDELP20220915_Med1-DDAbPeErDELP20200417_Med1) // <<-- modify 11
label var DDAbPeErDELP_Mean1 "DDAbPeErDELP mean over updates of median absolute % error by calendar months"
qui replace DDAbPeErDELP_Mean1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbPeErDELP_Mean1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbPeErDELP_Mean1 = . if date < td(17apr2020) // 17apr2020 is the earliest date of DELP forecasts for El Salvador


 
 
 
 




* (4) gen AVERAGE over calendar months of _Mean1  = _Mean2

* Wait note: wait ...

		
egen DDErrorDELP_Mean2 = mean(DDErrorDELP_Mean1) // get mean for all calendar months of _Mean1
label var DDErrorDELP_Mean2 "DDErrorDELP Mean over calendar months of median error over updates"

egen DDAbsErrDELP_Mean2 = mean(DDAbsErrDELP_Mean1) // get mean for all calendar months of _Mean1
label var DDAbsErrDELP_Mean2 "DDAbsErrDELP Mean over calendar months of median absolute error over updates"

egen DDPerErrDELP_Mean2 = mean(DDPerErrDELP_Mean1) // get mean for all calendar months of _Mean1
label var DDPerErrDELP_Mean2 "DDPerErrDELP Mean over calendar months of median % error over updates"

egen DDAbPeErDELP_Mean2 = mean(DDAbPeErDELP_Mean1) // get mean for all calendar months of _Mean1
label var DDAbPeErDELP_Mean2 "DDAbPeErDELP Mean over calendar months of median absolute % error over updates"





drop if date < td(01jan2020)

drop if date > td(01jan2023)


qui compress




******
* graph 03 Daily deaths, Error // <<-- modify 12

twoway ///
(line DDErrorDELP20200417 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200424 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200501 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200509 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200517 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200524 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200531 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200607 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200614 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200621 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200628 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200704 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200718 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200723 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200801 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200815 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200829 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200912 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20200926 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20201008 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20201022 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20201105 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20201119 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20201203 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20201217 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20201231 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210114 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210128 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210211 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210225 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210311 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210325 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210408 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210422 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210506 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210520 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210603 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210610 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210617 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210624 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210701 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210708 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210715 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210722 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210729 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210805 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210812 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210819 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210826 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210902 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210909 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210916 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210923 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20210930 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211007 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211014 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211021 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211028 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211104 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211111 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211118 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211125 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211202 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211209 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211216 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211223 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20211230 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220106 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220113 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220114 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220115 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220116 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220117 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220118 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220119 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220120 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220121 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220122 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220123 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220124 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220125 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220126 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220127 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220128 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220129 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220130 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220131 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220201 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220202 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220203 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220204 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220205 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220206 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220207 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220208 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220209 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220210 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220211 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220212 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220213 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220214 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220215 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220216 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220217 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220218 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220219 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220220 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220221 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220222 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220223 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220224 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220225 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220226 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220227 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220228 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220301 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220302 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220303 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220304 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220305 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220306 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220307 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220308 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220309 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220310 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220311 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220312 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220313 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220314 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220315 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220316 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220317 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220318 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220319 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220320 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220321 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220322 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220323 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220324 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220325 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220326 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220327 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220328 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220329 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220330 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220331 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220401 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220402 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220403 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220404 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220405 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220406 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220407 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220408 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220409 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220410 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220411 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220412 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220413 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220414 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220415 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220416 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220417 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220418 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220419 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220420 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220421 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220422 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220423 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220424 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220425 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220426 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220427 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220428 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220429 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220430 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220501 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220502 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220503 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220504 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220505 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220506 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220507 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220508 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220509 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220510 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220511 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220512 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220513 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220514 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220515 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220516 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220517 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220518 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220519 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220520 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220521 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220522 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220523 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220524 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220525 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220526 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220527 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220528 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220529 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220530 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220531 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220601 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220602 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220603 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220604 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220605 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220606 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220607 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220608 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220609 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220610 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220611 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220612 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220613 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220614 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220615 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220616 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220617 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220618 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220619 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220620 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220621 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220622 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220623 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220624 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220625 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220626 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220627 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220628 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220629 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220630 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220701 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220702 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220703 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220704 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220705 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220706 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220707 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220708 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220709 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220710 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220711 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220712 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220713 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220714 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220715 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220716 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220717 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220718 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220719 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220720 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220721 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220722 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220723 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220724 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220725 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220726 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220727 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220728 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220729 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220730 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220731 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220801 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220802 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220803 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220804 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220805 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220806 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220807 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220808 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220809 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220810 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220811 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220812 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220813 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220814 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220815 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220816 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220817 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220818 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220819 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220820 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220821 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220822 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220823 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220824 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220825 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220826 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220827 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220828 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220829 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220830 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220831 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220901 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220902 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220903 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220904 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220905 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220906 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220907 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220908 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220909 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220910 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220911 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220912 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220913 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220914 date, sort lcolor(red) lwidth(thin)) ///
(line DDErrorDELP20220915 date, sort lcolor(red) lwidth(thin)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths error", size(medium) color(black)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3)) ///
subtitle("El Salvador, DELP, all updates, forecast only", size(small)) 

qui graph export "graph 03 El Salvador DELP C19 daily deaths error.pdf", replace





******
* graph 04 Daily deaths, Absolute Error // <<-- modify 13

twoway ///
(line DDAbsErrDELP20200417 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200424 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200501 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200509 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200517 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200524 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200531 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200607 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200614 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200621 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200628 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200704 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200718 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200723 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200801 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200815 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200829 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200912 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20200926 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20201008 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20201022 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20201105 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20201119 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20201203 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20201217 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20201231 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210114 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210128 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210211 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210225 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210311 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210325 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210408 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210422 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210506 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210520 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210603 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210610 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210617 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210624 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210701 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210708 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210715 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210722 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210729 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210805 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210812 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210819 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210826 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210902 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210909 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210916 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210923 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20210930 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211007 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211014 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211021 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211028 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211104 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211111 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211118 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211125 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211202 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211209 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211216 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211223 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20211230 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220106 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220113 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220114 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220115 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220116 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220117 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220118 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220119 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220120 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220121 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220122 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220123 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220124 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220125 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220126 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220127 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220128 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220129 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220130 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220131 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220201 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220202 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220203 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220204 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220205 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220206 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220207 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220208 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220209 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220210 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220211 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220212 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220213 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220214 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220215 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220216 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220217 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220218 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220219 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220220 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220221 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220222 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220223 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220224 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220225 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220226 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220227 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220228 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220301 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220302 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220303 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220304 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220305 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220306 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220307 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220308 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220309 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220310 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220311 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220312 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220313 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220314 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220315 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220316 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220317 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220318 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220319 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220320 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220321 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220322 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220323 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220324 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220325 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220326 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220327 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220328 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220329 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220330 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220331 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220401 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220402 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220403 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220404 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220405 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220406 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220407 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220408 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220409 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220410 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220411 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220412 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220413 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220414 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220415 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220416 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220417 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220418 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220419 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220420 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220421 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220422 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220423 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220424 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220425 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220426 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220427 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220428 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220429 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220430 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220501 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220502 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220503 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220504 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220505 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220506 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220507 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220508 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220509 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220510 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220511 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220512 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220513 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220514 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220515 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220516 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220517 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220518 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220519 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220520 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220521 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220522 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220523 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220524 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220525 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220526 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220527 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220528 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220529 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220530 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220531 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220601 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220602 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220603 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220604 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220605 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220606 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220607 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220608 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220609 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220610 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220611 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220612 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220613 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220614 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220615 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220616 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220617 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220618 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220619 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220620 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220621 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220622 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220623 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220624 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220625 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220626 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220627 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220628 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220629 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220630 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220701 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220702 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220703 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220704 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220705 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220706 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220707 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220708 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220709 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220710 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220711 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220712 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220713 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220714 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220715 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220716 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220717 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220718 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220719 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220720 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220721 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220722 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220723 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220724 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220725 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220726 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220727 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220728 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220729 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220730 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220731 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220801 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220802 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220803 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220804 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220805 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220806 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220807 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220808 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220809 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220810 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220811 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220812 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220813 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220814 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220815 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220816 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220817 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220818 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220819 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220820 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220821 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220822 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220823 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220824 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220825 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220826 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220827 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220828 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220829 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220830 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220831 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220901 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220902 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220903 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220904 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220905 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220906 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220907 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220908 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220909 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220910 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220911 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220912 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220913 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220914 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbsErrDELP20220915 date, sort lcolor(red) lwidth(thin)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths absolute error", size(medium) color(black)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3)) ///
subtitle("El Salvador, DELP, all updates, forecast only", size(small))

qui graph export "graph 04 El Salvador DELP C19 daily deaths absolute error.pdf", replace








******
* graph 05 Daily deaths, Percent Error // <<-- modify 14

twoway ///
(line DDPerErrDELP20200417 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200424 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200501 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200509 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200517 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200524 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200531 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200607 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200614 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200621 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200628 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200704 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200718 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200723 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200801 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200815 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200829 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200912 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20200926 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20201008 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20201022 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20201105 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20201119 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20201203 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20201217 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20201231 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210114 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210128 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210211 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210225 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210311 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210325 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210408 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210422 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210506 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210520 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210603 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210610 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210617 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210624 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210701 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210708 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210715 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210722 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210729 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210805 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210812 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210819 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210826 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210902 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210909 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210916 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210923 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20210930 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211007 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211014 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211021 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211028 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211104 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211111 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211118 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211125 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211202 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211209 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211216 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211223 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20211230 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220106 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220113 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220114 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220115 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220116 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220117 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220118 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220119 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220120 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220121 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220122 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220123 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220124 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220125 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220126 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220127 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220128 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220129 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220130 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220131 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220201 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220202 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220203 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220204 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220205 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220206 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220207 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220208 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220209 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220210 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220211 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220212 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220213 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220214 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220215 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220216 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220217 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220218 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220219 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220220 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220221 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220222 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220223 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220224 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220225 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220226 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220227 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220228 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220301 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220302 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220303 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220304 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220305 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220306 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220307 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220308 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220309 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220310 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220311 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220312 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220313 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220314 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220315 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220316 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220317 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220318 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220319 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220320 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220321 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220322 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220323 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220324 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220325 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220326 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220327 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220328 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220329 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220330 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220331 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220401 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220402 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220403 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220404 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220405 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220406 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220407 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220408 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220409 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220410 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220411 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220412 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220413 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220414 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220415 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220416 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220417 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220418 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220419 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220420 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220421 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220422 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220423 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220424 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220425 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220426 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220427 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220428 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220429 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220430 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220501 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220502 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220503 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220504 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220505 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220506 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220507 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220508 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220509 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220510 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220511 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220512 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220513 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220514 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220515 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220516 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220517 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220518 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220519 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220520 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220521 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220522 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220523 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220524 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220525 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220526 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220527 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220528 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220529 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220530 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220531 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220601 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220602 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220603 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220604 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220605 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220606 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220607 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220608 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220609 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220610 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220611 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220612 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220613 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220614 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220615 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220616 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220617 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220618 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220619 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220620 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220621 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220622 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220623 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220624 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220625 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220626 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220627 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220628 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220629 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220630 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220701 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220702 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220703 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220704 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220705 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220706 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220707 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220708 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220709 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220710 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220711 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220712 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220713 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220714 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220715 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220716 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220717 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220718 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220719 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220720 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220721 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220722 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220723 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220724 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220725 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220726 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220727 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220728 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220729 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220730 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220731 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220801 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220802 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220803 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220804 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220805 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220806 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220807 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220808 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220809 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220810 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220811 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220812 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220813 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220814 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220815 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220816 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220817 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220818 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220819 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220820 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220821 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220822 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220823 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220824 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220825 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220826 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220827 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220828 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220829 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220830 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220831 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220901 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220902 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220903 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220904 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220905 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220906 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220907 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220908 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220909 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220910 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220911 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220912 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220913 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220914 date, sort lcolor(red) lwidth(thin)) ///
(line DDPerErrDELP20220915 date, sort lcolor(red) lwidth(thin)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths percent error", size(medium) color(black)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3)) ///
subtitle("El Salvador, DELP, all updates, forecast only", size(small))

qui graph export "graph 05 El Salvador DELP C19 daily deaths percent error.pdf", replace








******
* graph 06 Daily deaths, Absolute Percent Error // <<-- modify 15

* DELP lcolor red // <<-- modify 16

twoway ///
(line DDAbPeErDELP20200417 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200424 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200501 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200509 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200517 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200524 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200531 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200607 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200614 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200621 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200628 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200704 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200718 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200723 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200801 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200815 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200829 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200912 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20200926 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20201008 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20201022 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20201105 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20201119 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20201203 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20201217 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20201231 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210114 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210128 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210211 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210225 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210311 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210325 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210408 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210422 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210506 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210520 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210603 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210610 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210617 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210624 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210701 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210708 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210715 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210722 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210729 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210805 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210812 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210819 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210826 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210902 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210909 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210916 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210923 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20210930 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211007 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211014 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211021 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211028 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211104 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211111 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211118 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211125 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211202 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211209 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211216 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211223 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20211230 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220106 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220113 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220114 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220115 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220116 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220117 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220118 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220119 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220120 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220121 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220122 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220123 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220124 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220125 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220126 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220127 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220128 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220129 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220130 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220131 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220201 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220202 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220203 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220204 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220205 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220206 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220207 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220208 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220209 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220210 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220211 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220212 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220213 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220214 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220215 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220216 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220217 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220218 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220219 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220220 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220221 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220222 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220223 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220224 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220225 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220226 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220227 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220228 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220301 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220302 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220303 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220304 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220305 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220306 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220307 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220308 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220309 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220310 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220311 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220312 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220313 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220314 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220315 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220316 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220317 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220318 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220319 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220320 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220321 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220322 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220323 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220324 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220325 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220326 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220327 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220328 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220329 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220330 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220331 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220401 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220402 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220403 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220404 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220405 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220406 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220407 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220408 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220409 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220410 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220411 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220412 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220413 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220414 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220415 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220416 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220417 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220418 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220419 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220420 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220421 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220422 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220423 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220424 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220425 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220426 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220427 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220428 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220429 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220430 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220501 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220502 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220503 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220504 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220505 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220506 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220507 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220508 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220509 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220510 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220511 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220512 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220513 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220514 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220515 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220516 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220517 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220518 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220519 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220520 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220521 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220522 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220523 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220524 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220525 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220526 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220527 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220528 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220529 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220530 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220531 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220601 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220602 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220603 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220604 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220605 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220606 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220607 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220608 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220609 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220610 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220611 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220612 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220613 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220614 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220615 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220616 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220617 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220618 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220619 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220620 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220621 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220622 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220623 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220624 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220625 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220626 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220627 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220628 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220629 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220630 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220701 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220702 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220703 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220704 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220705 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220706 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220707 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220708 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220709 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220710 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220711 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220712 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220713 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220714 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220715 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220716 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220717 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220718 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220719 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220720 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220721 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220722 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220723 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220724 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220725 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220726 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220727 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220728 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220729 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220730 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220731 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220801 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220802 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220803 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220804 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220805 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220806 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220807 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220808 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220809 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220810 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220811 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220812 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220813 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220814 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220815 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220816 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220817 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220818 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220819 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220820 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220821 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220822 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220823 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220824 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220825 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220826 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220827 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220828 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220829 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220830 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220831 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220901 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220902 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220903 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220904 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220905 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220906 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220907 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220908 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220909 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220910 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220911 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220912 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220913 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220914 date, sort lcolor(red) lwidth(thin)) ///
(line DDAbPeErDELP20220915 date, sort lcolor(red) lwidth(thin)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths absolute percent error", size(medium) color(black)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3)) ///
subtitle("El Salvador, DELP, all updates, forecast only", size(small))

qui graph export "graph 06 El Salvador DELP C19 daily deaths absolute percent error.pdf", replace











***************************************************************
* graph 07 Daily deaths, average median error 

twoway ///
(line DDErrorDELP_Mean1 date, sort lcolor(red) lwidth(medium)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths, average median error", size(medium) color(black)) /// 
subtitle("El Salvador, DELP, forecast only", size(small)) xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3))

qui graph export "graph 07 El Salvador DELP C19 daily deaths average median error.pdf", replace





*********************
* smooth median error for better viewing 

tsset date, daily   

tssmooth ma DDErrorDELP_Mean1_window = DDErrorDELP_Mean1, window(3 1 3)

tssmooth ma DDErrorDELP_Mean1_sm = DDErrorDELP_Mean1_window, weights( 1 2 3 <4> 3 2 1) replace

label var DDErrorDELP_Mean1_sm "Daily deaths DELP average median error smooth"

drop *_window

// tsset, clear

*













***************************************************************
* graph 08 Daily deaths, average median absolute error 

twoway ///
(line DDAbsErrDELP_Mean1 date, sort lcolor(red) lwidth(medium)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths, average median absolute error", size(medium) color(black)) /// 
subtitle("El Salvador, DELP, forecast only", size(small)) xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3))

qui graph export "graph 08 El Salvador DELP C19 daily deaths average median absolute error.pdf", replace






*********************
* smooth median absolute error for better viewing 

// tsset date, daily   

tssmooth ma DDAbsErrDELP_Mean1_window = DDAbsErrDELP_Mean1, window(3 1 3)

tssmooth ma DDAbsErrDELP_Mean1_sm = DDAbsErrDELP_Mean1_window, weights( 1 2 3 <4> 3 2 1) replace

label var DDAbsErrDELP_Mean1_sm "Daily deaths DELP average median absolute error smooth"

drop *_window

// tsset, clear

*











***************************************************************
* graph 09 Daily deaths, average median percent error 

twoway ///
(line DDPerErrDELP_Mean1 date, sort lcolor(red) lwidth(medium)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths, average median percent error", size(medium) color(black)) /// 
subtitle("El Salvador, DELP, forecast only", size(small)) xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3))

qui graph export "graph 09 El Salvador DELP C19 daily deaths average median percent error.pdf", replace





*********************
* smooth median percent error for better viewing 

// tsset date, daily   

tssmooth ma DDPerErrDELP_Mean1_window = DDPerErrDELP_Mean1, window(3 1 3)

tssmooth ma DDPerErrDELP_Mean1_sm = DDPerErrDELP_Mean1_window, weights( 1 2 3 <4> 3 2 1) replace

label var DDPerErrDELP_Mean1_sm "Daily deaths DELP average median percent error smooth"

drop *_window

// tsset, clear

*












***************************************************************
* graph 10 Daily deaths, average median absolute percent error

twoway ///
(line DDAbPeErDELP_Mean1 date, sort lcolor(red) lwidth(medium)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths, average median absolute percent error", size(medium) color(black)) /// 
subtitle("El Salvador, DELP, forecast only", size(small)) xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3))

qui graph export "graph 10 El Salvador DELP C19 daily deaths average median absolute percent error.pdf", replace





*********************
* smooth median absolute % error for better viewing 

// tsset date, daily   

tssmooth ma DDAbPeErDELP_Mean1_window = DDAbPeErDELP_Mean1, window(3 1 3)

tssmooth ma DDAbPeErDELP_Mean1_sm = DDAbPeErDELP_Mean1_window, weights( 1 2 3 <4> 3 2 1) replace

label var DDAbPeErDELP_Mean1_sm "Daily deaths DELP average median absolute percent error smooth"

drop *_window

tsset, clear

*








***********************************************

capture drop *2str

summ DDAbPeErDELP_Mean2, meanonly

local DDAbPeErDELP_Mean2str = string(r(mean),"%8.1f")

gen DDAbPeErDELP_Mean2str = `DDAbPeErDELP_Mean2str'
    

* graph 11 Daily deaths, Average MAPE over updates and calendar months

graph bar ///
(mean) DDAbPeErDELP_Mean2str /// 
, bar(1, fcolor(red) lcolor(red)) ///
blabel(bar, format(%30.0fc)) ytitle("Average MAPE") yscale(titlegap(2)) ///
title("C19 daily deaths average MAPE over updates and calendar months", size(medium) color(black)) ///
subtitle("El Salvador, DELP, forecast only. MAPE: Median Absolute Percent Error", size(small)) /// 
legend(off) ylabel(, labsize(small) angle(forty_five) format(%30.0fc))

qui graph export "graph 11 El Salvador DELP C19 daily deaths Average MAPE over updates and calendar months.pdf", replace










******

qui compress 

save "DELP El Salvador error.dta", replace 




******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "DELP El Salvador error data dictionary.csv", replace 
	
restore



view "log CovidLongitudinal El Salvador 2 DELP.smcl"

log close

exit, clear

