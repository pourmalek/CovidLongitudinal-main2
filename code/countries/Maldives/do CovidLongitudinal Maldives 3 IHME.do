
clear all

cd "$pathCovidLongitudinal/countries/Maldives"

capture log close 

log using "log CovidLongitudinal Maldives 3 IHME.smcl", replace

***************************************************************************
* This is "do CovidLongitudinal Maldives 3 IHME.do"

* Project: Longitudinal assessment of COVID-19 models 

* Objective: Run calculations for error measures
	* for each country ---->> Maldives <<----                                                                 
***************************************************************************


** model = IHME ** <<-- modify 1
* lcolor black

* run calculations for error - daily deaths: four error types (graphs 3 to 11), updates together


* input data files: "IHME Maldives.dta"
* output data files: "IHME Maldives error.dta" (with error measures saved)

* output data dictionary files: "IHME Maldives error data dictionary.csv"


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
* "graph 03 Maldives IHME C19 daily deaths error.pdf"
* "graph 04 Maldives IHME C19 daily deaths absolute error.pdf"
* "graph 05 Maldives IHME C19 daily deaths percent error.pdf"
* "graph 06 Maldives IHME C19 daily deaths absolute percent error.pdf"

* "graph 07 Maldives IHME C19 daily deaths average median error.pdf"
* "graph 08 Maldives IHME C19 daily deaths average median absolute error.pdf"
* "graph 09 Maldives IHME C19 daily deaths average median percent error.pdf"
* "graph 10 Maldives IHME C19 daily deaths average median absolute percent error.pdf"

* "graph 11 Maldives IHME C19 daily deaths Average MAPE over updates and calendar months.pdf"


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







use "IHME Maldives.dta", clear 


label var location_id "location id IHME"

label var deaths_data_type "deaths data type IHME"




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
20200625 ///
20200629 ///
20200707 ///
20200714 ///
20200722 ///
20200730 ///
20200806 ///
20200821 ///
20200827 ///
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



sort date


* (1) gen error TYPES by calendar months and model updates

foreach update of local list {

	* Running not quietly displays that the Stata is working and has not frozen. 

capture drop DDErrorIHME`update'
gen DDErrorIHME`update' = - (DayDeaMeSmJOHN - DayDeaMeFoIHME`update')
label var DDErrorIHME`update' "DayDeaMeFoIHME`update' error"
qui replace DDErrorIHME`update' = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDErrorIHME`update' = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDErrorIHME`update' = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives
                                                            // <<-- modify 3
capture drop DDAbsErrIHME`update'
gen DDAbsErrIHME`update' = abs(- (DayDeaMeSmJOHN - DayDeaMeFoIHME`update'))
label var DDAbsErrIHME`update' "DayDeaMeFoIHME`update' absolute error"
qui replace DDAbsErrIHME`update' = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbsErrIHME`update' = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbsErrIHME`update' = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives

capture drop DDPerErrIHME`update'
gen DDPerErrIHME`update' = (100 * (- (DayDeaMeSmJOHN - DayDeaMeFoIHME`update'))) / DayDeaMeSmJOHN
replace DDPerErrIHME`update' = 0 if DDErrorIHME`update' == 0
label var DDPerErrIHME`update' "DayDeaMeFoIHME`update' percent error"
qui replace DDPerErrIHME`update' = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDPerErrIHME`update' = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDPerErrIHME`update' = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives

capture drop DDAbPeErIHME`update'
gen DDAbPeErIHME`update' = (100 * abs(- (DayDeaMeSmJOHN - DayDeaMeFoIHME`update'))) / DayDeaMeSmJOHN
replace DDAbPeErIHME`update' = 0 if DDAbsErrIHME`update' == 0
label var DDAbPeErIHME`update' "DayDeaMeFoIHME`update' absolute percent error"
qui replace DDAbPeErIHME`update' = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbPeErIHME`update' = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbPeErIHME`update' = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives

}
*





* (2) gen MEDIAN of error types by calendar months and updates = _Med1

* Wait note: wait ...

foreach update of local list {
		
capture drop DDErrorIHME`update'_Med1
bysort yearmonth : egen DDErrorIHME`update'_Med1 = median(DDErrorIHME`update')
label var DDErrorIHME`update'_Med1 "DayDeaIHME median error by calendar months and updates"
qui replace DDErrorIHME`update'_Med1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDErrorIHME`update'_Med1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDErrorIHME`update'_Med1 = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives

capture drop DDAbsErrIHME`update'_Med1
bysort yearmonth : egen DDAbsErrIHME`update'_Med1 = median(DDAbsErrIHME`update')
label var DDAbsErrIHME`update'_Med1 "DayDeaIHME median absolute error by calendar months and updates"
qui replace DDAbsErrIHME`update'_Med1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbsErrIHME`update'_Med1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbsErrIHME`update'_Med1 = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives

capture drop DDPerErrIHME`update'_Med1
bysort yearmonth : egen DDPerErrIHME`update'_Med1 = median(DDPerErrIHME`update')
label var DDPerErrIHME`update'_Med1 "DayDeaIHME median % error by calendar months and updates"
qui replace DDPerErrIHME`update'_Med1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDPerErrIHME`update'_Med1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDPerErrIHME`update'_Med1 = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives

capture drop DDAbPeErIHME`update'_Med1
bysort yearmonth : egen DDAbPeErIHME`update'_Med1 = median(DDAbPeErIHME`update')
label var DDAbPeErIHME`update'_Med1 "DayDeaIHME median absolute % error by calendar months and updates" 
qui replace DDAbPeErIHME`update'_Med1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbPeErIHME`update'_Med1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbPeErIHME`update'_Med1 = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives

}
*



 
* (3) gen AVERAGE over updates of MEDIAN of error types by calendar months = _Mean1

* Wait note: wait ...



* gen DDErrorIHME_Mean1 // gen AVERAGE over updates of MEDIAN of error types by calendar months

 // <<-- modify 4
 
order DDErrorIHME20200625_Med1
order DDErrorIHME20200629_Med1
order DDErrorIHME20200707_Med1
order DDErrorIHME20200714_Med1
order DDErrorIHME20200722_Med1
order DDErrorIHME20200730_Med1
order DDErrorIHME20200806_Med1
order DDErrorIHME20200821_Med1
order DDErrorIHME20200827_Med1
order DDErrorIHME20200903_Med1
order DDErrorIHME20200911_Med1
order DDErrorIHME20200918_Med1
order DDErrorIHME20200924_Med1
order DDErrorIHME20201002_Med1
order DDErrorIHME20201009_Med1
order DDErrorIHME20201015_Med1
order DDErrorIHME20201022_Med1
order DDErrorIHME20201029_Med1
order DDErrorIHME20201112_Med1
order DDErrorIHME20201119_Med1
order DDErrorIHME20201203_Med1
order DDErrorIHME20201210_Med1
order DDErrorIHME20201217_Med1
order DDErrorIHME20201223_Med1
order DDErrorIHME20210115_Med1
order DDErrorIHME20210122_Med1
order DDErrorIHME20210128_Med1
order DDErrorIHME20210204_Med1
order DDErrorIHME20210212_Med1
order DDErrorIHME20210220_Med1
order DDErrorIHME20210225_Med1
order DDErrorIHME20210306_Med1
order DDErrorIHME20210311_Med1
order DDErrorIHME20210317_Med1
order DDErrorIHME20210325_Med1
order DDErrorIHME20210401_Med1
order DDErrorIHME20210409_Med1
order DDErrorIHME20210416_Med1
order DDErrorIHME20210423_Med1
order DDErrorIHME20210506_Med1
order DDErrorIHME20210514_Med1
order DDErrorIHME20210521_Med1
order DDErrorIHME20210528_Med1
order DDErrorIHME20210604_Med1
order DDErrorIHME20210610_Med1
order DDErrorIHME20210618_Med1
order DDErrorIHME20210625_Med1
order DDErrorIHME20210702_Med1
order DDErrorIHME20210715_Med1
order DDErrorIHME20210723_Med1
order DDErrorIHME20210730_Med1
order DDErrorIHME20210806_Med1
order DDErrorIHME20210820_Med1
order DDErrorIHME20210826_Med1
order DDErrorIHME20210902_Med1
order DDErrorIHME20210910_Med1
order DDErrorIHME20210916_Med1
order DDErrorIHME20210923_Med1
order DDErrorIHME20210930_Med1
order DDErrorIHME20211015_Med1
order DDErrorIHME20211021_Med1
order DDErrorIHME20211104_Med1
order DDErrorIHME20211119_Med1
order DDErrorIHME20211221_Med1
order DDErrorIHME20220108_Med1
order DDErrorIHME20220114_Med1
order DDErrorIHME20220121_Med1
order DDErrorIHME20220204_Med1
order DDErrorIHME20220218_Med1
order DDErrorIHME20220321_Med1
order DDErrorIHME20220408_Med1
order DDErrorIHME20220506_Med1
order DDErrorIHME20220610_Med1
order DDErrorIHME20220719_Med1
order DDErrorIHME20220912_Med1
order DDErrorIHME20221024_Med1
order DDErrorIHME20221118_Med1
order DDErrorIHME20221216_Med1

		
capture drop DDErrorIHME_Mean1 // "DDErrorIHME mean over updates of median error by calendar months"
egen DDErrorIHME_Mean1 = rowmean(DDErrorIHME20221216_Med1-DDErrorIHME20200625_Med1) // <<-- modify 5
label var DDErrorIHME_Mean1 "DDErrorIHME mean over updates of median error by calendar months"
qui replace DDErrorIHME_Mean1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDErrorIHME_Mean1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDErrorIHME_Mean1 = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives






* gen DDAbsErrIHME_Mean1 // gen AVERAGE over updates of MEDIAN of error types by calendar months

 // <<-- modify 6
 
order DDAbsErrIHME20200625_Med1
order DDAbsErrIHME20200629_Med1
order DDAbsErrIHME20200707_Med1
order DDAbsErrIHME20200714_Med1
order DDAbsErrIHME20200722_Med1
order DDAbsErrIHME20200730_Med1
order DDAbsErrIHME20200806_Med1
order DDAbsErrIHME20200821_Med1
order DDAbsErrIHME20200827_Med1
order DDAbsErrIHME20200903_Med1
order DDAbsErrIHME20200911_Med1
order DDAbsErrIHME20200918_Med1
order DDAbsErrIHME20200924_Med1
order DDAbsErrIHME20201002_Med1
order DDAbsErrIHME20201009_Med1
order DDAbsErrIHME20201015_Med1
order DDAbsErrIHME20201022_Med1
order DDAbsErrIHME20201029_Med1
order DDAbsErrIHME20201112_Med1
order DDAbsErrIHME20201119_Med1
order DDAbsErrIHME20201203_Med1
order DDAbsErrIHME20201210_Med1
order DDAbsErrIHME20201217_Med1
order DDAbsErrIHME20201223_Med1
order DDAbsErrIHME20210115_Med1
order DDAbsErrIHME20210122_Med1
order DDAbsErrIHME20210128_Med1
order DDAbsErrIHME20210204_Med1
order DDAbsErrIHME20210212_Med1
order DDAbsErrIHME20210220_Med1
order DDAbsErrIHME20210225_Med1
order DDAbsErrIHME20210306_Med1
order DDAbsErrIHME20210311_Med1
order DDAbsErrIHME20210317_Med1
order DDAbsErrIHME20210325_Med1
order DDAbsErrIHME20210401_Med1
order DDAbsErrIHME20210409_Med1
order DDAbsErrIHME20210416_Med1
order DDAbsErrIHME20210423_Med1
order DDAbsErrIHME20210506_Med1
order DDAbsErrIHME20210514_Med1
order DDAbsErrIHME20210521_Med1
order DDAbsErrIHME20210528_Med1
order DDAbsErrIHME20210604_Med1
order DDAbsErrIHME20210610_Med1
order DDAbsErrIHME20210618_Med1
order DDAbsErrIHME20210625_Med1
order DDAbsErrIHME20210702_Med1
order DDAbsErrIHME20210715_Med1
order DDAbsErrIHME20210723_Med1
order DDAbsErrIHME20210730_Med1
order DDAbsErrIHME20210806_Med1
order DDAbsErrIHME20210820_Med1
order DDAbsErrIHME20210826_Med1
order DDAbsErrIHME20210902_Med1
order DDAbsErrIHME20210910_Med1
order DDAbsErrIHME20210916_Med1
order DDAbsErrIHME20210923_Med1
order DDAbsErrIHME20210930_Med1
order DDAbsErrIHME20211015_Med1
order DDAbsErrIHME20211021_Med1
order DDAbsErrIHME20211104_Med1
order DDAbsErrIHME20211119_Med1
order DDAbsErrIHME20211221_Med1
order DDAbsErrIHME20220108_Med1
order DDAbsErrIHME20220114_Med1
order DDAbsErrIHME20220121_Med1
order DDAbsErrIHME20220204_Med1
order DDAbsErrIHME20220218_Med1
order DDAbsErrIHME20220321_Med1
order DDAbsErrIHME20220408_Med1
order DDAbsErrIHME20220506_Med1
order DDAbsErrIHME20220610_Med1
order DDAbsErrIHME20220719_Med1
order DDAbsErrIHME20220912_Med1
order DDAbsErrIHME20221024_Med1
order DDAbsErrIHME20221118_Med1
order DDAbsErrIHME20221216_Med1


capture drop DDAbsErrIHME_Mean1 // "DDAbsErrIHME mean over updates of median absolute error by calendar months"
egen DDAbsErrIHME_Mean1 = rowmean(DDAbsErrIHME20221216_Med1-DDAbsErrIHME20200625_Med1) // <<-- modify 7
label var DDAbsErrIHME_Mean1 "DDAbsErrIHME mean over updates of median absolute error by calendar months"
qui replace DDAbsErrIHME_Mean1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbsErrIHME_Mean1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbsErrIHME_Mean1 = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives







* gen DDPerErrIHME_Mean1 // gen AVERAGE over updates of MEDIAN of error types by calendar months

// <<-- modify 8

order DDPerErrIHME20200625_Med1
order DDPerErrIHME20200629_Med1
order DDPerErrIHME20200707_Med1
order DDPerErrIHME20200714_Med1
order DDPerErrIHME20200722_Med1
order DDPerErrIHME20200730_Med1
order DDPerErrIHME20200806_Med1
order DDPerErrIHME20200821_Med1
order DDPerErrIHME20200827_Med1
order DDPerErrIHME20200903_Med1
order DDPerErrIHME20200911_Med1
order DDPerErrIHME20200918_Med1
order DDPerErrIHME20200924_Med1
order DDPerErrIHME20201002_Med1
order DDPerErrIHME20201009_Med1
order DDPerErrIHME20201015_Med1
order DDPerErrIHME20201022_Med1
order DDPerErrIHME20201029_Med1
order DDPerErrIHME20201112_Med1
order DDPerErrIHME20201119_Med1
order DDPerErrIHME20201203_Med1
order DDPerErrIHME20201210_Med1
order DDPerErrIHME20201217_Med1
order DDPerErrIHME20201223_Med1
order DDPerErrIHME20210115_Med1
order DDPerErrIHME20210122_Med1
order DDPerErrIHME20210128_Med1
order DDPerErrIHME20210204_Med1
order DDPerErrIHME20210212_Med1
order DDPerErrIHME20210220_Med1
order DDPerErrIHME20210225_Med1
order DDPerErrIHME20210306_Med1
order DDPerErrIHME20210311_Med1
order DDPerErrIHME20210317_Med1
order DDPerErrIHME20210325_Med1
order DDPerErrIHME20210401_Med1
order DDPerErrIHME20210409_Med1
order DDPerErrIHME20210416_Med1
order DDPerErrIHME20210423_Med1
order DDPerErrIHME20210506_Med1
order DDPerErrIHME20210514_Med1
order DDPerErrIHME20210521_Med1
order DDPerErrIHME20210528_Med1
order DDPerErrIHME20210604_Med1
order DDPerErrIHME20210610_Med1
order DDPerErrIHME20210618_Med1
order DDPerErrIHME20210625_Med1
order DDPerErrIHME20210702_Med1
order DDPerErrIHME20210715_Med1
order DDPerErrIHME20210723_Med1
order DDPerErrIHME20210730_Med1
order DDPerErrIHME20210806_Med1
order DDPerErrIHME20210820_Med1
order DDPerErrIHME20210826_Med1
order DDPerErrIHME20210902_Med1
order DDPerErrIHME20210910_Med1
order DDPerErrIHME20210916_Med1
order DDPerErrIHME20210923_Med1
order DDPerErrIHME20210930_Med1
order DDPerErrIHME20211015_Med1
order DDPerErrIHME20211021_Med1
order DDPerErrIHME20211104_Med1
order DDPerErrIHME20211119_Med1
order DDPerErrIHME20211221_Med1
order DDPerErrIHME20220108_Med1
order DDPerErrIHME20220114_Med1
order DDPerErrIHME20220121_Med1
order DDPerErrIHME20220204_Med1
order DDPerErrIHME20220218_Med1
order DDPerErrIHME20220321_Med1
order DDPerErrIHME20220408_Med1
order DDPerErrIHME20220506_Med1
order DDPerErrIHME20220610_Med1
order DDPerErrIHME20220719_Med1
order DDPerErrIHME20220912_Med1
order DDPerErrIHME20221024_Med1
order DDPerErrIHME20221118_Med1
order DDPerErrIHME20221216_Med1
		

capture drop DDPerErrIHME_Mean1 // "DDPerErrIHME mean over updates of median % error by calendar months"
egen DDPerErrIHME_Mean1 = rowmean(DDPerErrIHME20221216_Med1-DDPerErrIHME20200625_Med1) // <<-- modify 9
label var DDPerErrIHME_Mean1 "DDPerErrIHME mean over updates of median % error by calendar months"
qui replace DDPerErrIHME_Mean1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDPerErrIHME_Mean1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDPerErrIHME_Mean1 = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives








* gen DDAbPeErIHME_Mean1 // gen AVERAGE over updates of MEDIAN of error types by calendar months

 // <<-- modify 10
 
order DDAbPeErIHME20200625_Med1
order DDAbPeErIHME20200629_Med1
order DDAbPeErIHME20200707_Med1
order DDAbPeErIHME20200714_Med1
order DDAbPeErIHME20200722_Med1
order DDAbPeErIHME20200730_Med1
order DDAbPeErIHME20200806_Med1
order DDAbPeErIHME20200821_Med1
order DDAbPeErIHME20200827_Med1
order DDAbPeErIHME20200903_Med1
order DDAbPeErIHME20200911_Med1
order DDAbPeErIHME20200918_Med1
order DDAbPeErIHME20200924_Med1
order DDAbPeErIHME20201002_Med1
order DDAbPeErIHME20201009_Med1
order DDAbPeErIHME20201015_Med1
order DDAbPeErIHME20201022_Med1
order DDAbPeErIHME20201029_Med1
order DDAbPeErIHME20201112_Med1
order DDAbPeErIHME20201119_Med1
order DDAbPeErIHME20201203_Med1
order DDAbPeErIHME20201210_Med1
order DDAbPeErIHME20201217_Med1
order DDAbPeErIHME20201223_Med1
order DDAbPeErIHME20210115_Med1
order DDAbPeErIHME20210122_Med1
order DDAbPeErIHME20210128_Med1
order DDAbPeErIHME20210204_Med1
order DDAbPeErIHME20210212_Med1
order DDAbPeErIHME20210220_Med1
order DDAbPeErIHME20210225_Med1
order DDAbPeErIHME20210306_Med1
order DDAbPeErIHME20210311_Med1
order DDAbPeErIHME20210317_Med1
order DDAbPeErIHME20210325_Med1
order DDAbPeErIHME20210401_Med1
order DDAbPeErIHME20210409_Med1
order DDAbPeErIHME20210416_Med1
order DDAbPeErIHME20210423_Med1
order DDAbPeErIHME20210506_Med1
order DDAbPeErIHME20210514_Med1
order DDAbPeErIHME20210521_Med1
order DDAbPeErIHME20210528_Med1
order DDAbPeErIHME20210604_Med1
order DDAbPeErIHME20210610_Med1
order DDAbPeErIHME20210618_Med1
order DDAbPeErIHME20210625_Med1
order DDAbPeErIHME20210702_Med1
order DDAbPeErIHME20210715_Med1
order DDAbPeErIHME20210723_Med1
order DDAbPeErIHME20210730_Med1
order DDAbPeErIHME20210806_Med1
order DDAbPeErIHME20210820_Med1
order DDAbPeErIHME20210826_Med1
order DDAbPeErIHME20210902_Med1
order DDAbPeErIHME20210910_Med1
order DDAbPeErIHME20210916_Med1
order DDAbPeErIHME20210923_Med1
order DDAbPeErIHME20210930_Med1
order DDAbPeErIHME20211015_Med1
order DDAbPeErIHME20211021_Med1
order DDAbPeErIHME20211104_Med1
order DDAbPeErIHME20211119_Med1
order DDAbPeErIHME20211221_Med1
order DDAbPeErIHME20220108_Med1
order DDAbPeErIHME20220114_Med1
order DDAbPeErIHME20220121_Med1
order DDAbPeErIHME20220204_Med1
order DDAbPeErIHME20220218_Med1
order DDAbPeErIHME20220321_Med1
order DDAbPeErIHME20220408_Med1
order DDAbPeErIHME20220506_Med1
order DDAbPeErIHME20220610_Med1
order DDAbPeErIHME20220719_Med1
order DDAbPeErIHME20220912_Med1
order DDAbPeErIHME20221024_Med1
order DDAbPeErIHME20221118_Med1
order DDAbPeErIHME20221216_Med1

capture drop DDAbPeErIHME_Mean1 // "DDAbPeErIHME mean over updates of median absolute % error by calendar months"
egen DDAbPeErIHME_Mean1 = rowmean(DDAbPeErIHME20221216_Med1-DDAbPeErIHME20200625_Med1) // <<-- modify 11
label var DDAbPeErIHME_Mean1 "DDAbPeErIHME mean over updates of median absolute % error by calendar months"
qui replace DDAbPeErIHME_Mean1 = . if DayDeaMeSmJOHN == . // before location was added to the estimates for the country
qui replace DDAbPeErIHME_Mean1 = . if date == td(01jan2023) // 01jan2023 is not included in this study
qui replace DDAbPeErIHME_Mean1 = . if date < td(25jun2020) // 25jun2020 is the earliest date of IHME forecasts for Maldives


 
 
 
 




* (4) gen AVERAGE over calendar months of _Mean1  = _Mean2

* Wait note: wait ...

		
egen DDErrorIHME_Mean2 = mean(DDErrorIHME_Mean1) // get mean for all calendar months of _Mean1
label var DDErrorIHME_Mean2 "DDErrorIHME Mean over calendar months of median error over updates"

egen DDAbsErrIHME_Mean2 = mean(DDAbsErrIHME_Mean1) // get mean for all calendar months of _Mean1
label var DDAbsErrIHME_Mean2 "DDAbsErrIHME Mean over calendar months of median absolute error over updates"

egen DDPerErrIHME_Mean2 = mean(DDPerErrIHME_Mean1) // get mean for all calendar months of _Mean1
label var DDPerErrIHME_Mean2 "DDPerErrIHME Mean over calendar months of median % error over updates"

egen DDAbPeErIHME_Mean2 = mean(DDAbPeErIHME_Mean1) // get mean for all calendar months of _Mean1
label var DDAbPeErIHME_Mean2 "DDAbPeErIHME Mean over calendar months of median absolute % error over updates"





drop if date < td(01jan2020)

drop if date > td(01jan2023)


qui compress




******
* graph 03 Daily deaths, Error // <<-- modify 12

twoway ///
(line DDErrorIHME20200625 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200629 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200707 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200714 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200722 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200730 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200806 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200821 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200827 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200903 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200911 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200918 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20200924 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201002 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201009 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201015 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201022 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201029 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201112 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201119 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201203 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201210 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201217 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20201223 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210115 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210122 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210128 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210204 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210212 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210220 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210225 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210306 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210311 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210317 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210325 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210401 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210409 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210416 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210423 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210506 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210514 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210521 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210528 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210604 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210610 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210618 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210625 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210702 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210715 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210723 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210730 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210806 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210820 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210826 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210902 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210910 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210916 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210923 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20210930 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20211015 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20211021 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20211104 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20211119 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20211221 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220108 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220114 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220121 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220204 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220218 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220321 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220408 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220506 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220610 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220719 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20220912 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20221024 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20221118 date, sort lcolor(black) lwidth(thin)) ///
(line DDErrorIHME20221216 date, sort lcolor(black) lwidth(thin)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths error", size(medium) color(black)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3)) ///
subtitle("Maldives, IHME, all updates, forecast only", size(small)) 

qui graph export "graph 03 Maldives IHME C19 daily deaths error.pdf", replace





******
* graph 04 Daily deaths, Absolute Error // <<-- modify 13

twoway ///
(line DDAbsErrIHME20200625 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200629 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200707 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200714 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200722 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200730 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200806 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200821 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200827 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200903 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200911 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200918 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20200924 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201002 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201009 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201015 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201022 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201029 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201112 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201119 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201203 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201210 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201217 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20201223 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210115 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210122 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210128 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210204 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210212 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210220 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210225 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210306 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210311 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210317 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210325 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210401 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210409 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210416 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210423 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210506 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210514 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210521 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210528 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210604 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210610 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210618 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210625 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210702 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210715 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210723 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210730 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210806 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210820 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210826 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210902 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210910 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210916 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210923 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20210930 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20211015 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20211021 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20211104 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20211119 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20211221 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220108 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220114 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220121 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220204 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220218 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220321 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220408 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220506 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220610 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220719 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20220912 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20221024 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20221118 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbsErrIHME20221216 date, sort lcolor(black) lwidth(thin)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths absolute error", size(medium) color(black)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3)) ///
subtitle("Maldives, IHME, all updates, forecast only", size(small))

qui graph export "graph 04 Maldives IHME C19 daily deaths absolute error.pdf", replace








******
* graph 05 Daily deaths, Percent Error <<-- modify 14

twoway ///
(line DDPerErrIHME20200625 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200629 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200707 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200714 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200722 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200730 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200806 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200821 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200827 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200903 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200911 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200918 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20200924 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201002 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201009 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201015 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201022 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201029 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201112 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201119 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201203 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201210 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201217 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20201223 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210115 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210122 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210128 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210204 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210212 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210220 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210225 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210306 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210311 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210317 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210325 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210401 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210409 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210416 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210423 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210506 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210514 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210521 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210528 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210604 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210610 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210618 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210625 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210702 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210715 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210723 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210730 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210806 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210820 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210826 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210902 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210910 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210916 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210923 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20210930 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20211015 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20211021 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20211104 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20211119 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20211221 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220108 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220114 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220121 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220204 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220218 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220321 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220408 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220506 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220610 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220719 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20220912 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20221024 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20221118 date, sort lcolor(black) lwidth(thin)) ///
(line DDPerErrIHME20221216 date, sort lcolor(black) lwidth(thin)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths percent error", size(medium) color(black)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3)) ///
subtitle("Maldives, IHME, all updates, forecast only", size(small))

qui graph export "graph 05 Maldives IHME C19 daily deaths percent error.pdf", replace








******
* graph 06 Daily deaths, Absolute Percent Error // <<-- modify 15

* IHME lcolor black // <<-- modify 16

twoway ///
(line DDAbPeErIHME20200625 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200629 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200707 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200714 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200722 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200730 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200806 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200821 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200827 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200903 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200911 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200918 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20200924 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201002 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201009 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201015 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201022 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201029 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201112 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201119 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201203 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201210 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201217 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20201223 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210115 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210122 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210128 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210204 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210212 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210220 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210225 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210306 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210311 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210317 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210325 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210401 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210409 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210416 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210423 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210506 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210514 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210521 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210528 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210604 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210610 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210618 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210625 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210702 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210715 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210723 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210730 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210806 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210820 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210826 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210902 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210910 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210916 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210923 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20210930 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20211015 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20211021 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20211104 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20211119 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20211221 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220108 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220114 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220121 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220204 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220218 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220321 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220408 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220506 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220610 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220719 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20220912 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20221024 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20221118 date, sort lcolor(black) lwidth(thin)) ///
(line DDAbPeErIHME20221216 date, sort lcolor(black) lwidth(thin)) ///
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths absolute percent error", size(medium) color(black)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3)) ///
subtitle("Maldives, IHME, all updates, forecast only", size(small))

qui graph export "graph 06 Maldives IHME C19 daily deaths absolute percent error.pdf", replace











***************************************************************
* graph 07 Daily deaths, average median error 

twoway ///
(line DDErrorIHME_Mean1 date, sort lcolor(black) lwidth(medium)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.1fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths, average median error", size(medium) color(black)) /// 
subtitle("Maldives, IHME, forecast only", size(small)) xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3))

qui graph export "graph 07 Maldives IHME C19 daily deaths average median error.pdf", replace





*********************
* smooth median error for better viewing 

tsset date, daily   

tssmooth ma DDErrorIHME_Mean1_window = DDErrorIHME_Mean1, window(3 1 3)

tssmooth ma DDErrorIHME_Mean1_sm = DDErrorIHME_Mean1_window, weights( 1 2 3 <4> 3 2 1) replace

label var DDErrorIHME_Mean1_sm "Daily deaths IHME average median error smooth"

drop *_window

// tsset, clear

*













***************************************************************
* graph 08 Daily deaths, average median absolute error 

twoway ///
(line DDAbsErrIHME_Mean1 date, sort lcolor(black) lwidth(medium)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths, average median absolute error", size(medium) color(black)) /// 
subtitle("Maldives, IHME, forecast only", size(small)) xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3))

qui graph export "graph 08 Maldives IHME C19 daily deaths average median absolute error.pdf", replace






*********************
* smooth median absolute error for better viewing 

// tsset date, daily   

tssmooth ma DDAbsErrIHME_Mean1_window = DDAbsErrIHME_Mean1, window(3 1 3)

tssmooth ma DDAbsErrIHME_Mean1_sm = DDAbsErrIHME_Mean1_window, weights( 1 2 3 <4> 3 2 1) replace

label var DDAbsErrIHME_Mean1_sm "Daily deaths IHME average median absolute error smooth"

drop *_window

// tsset, clear

*











***************************************************************
* graph 09 Daily deaths, average median percent error 

twoway ///
(line DDPerErrIHME_Mean1 date, sort lcolor(black) lwidth(medium)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths, average median percent error", size(medium) color(black)) /// 
subtitle("Maldives, IHME, forecast only", size(small)) xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3))

qui graph export "graph 09 Maldives IHME C19 daily deaths average median percent error.pdf", replace





*********************
* smooth median percent error for better viewing 

// tsset date, daily   

tssmooth ma DDPerErrIHME_Mean1_window = DDPerErrIHME_Mean1, window(3 1 3)

tssmooth ma DDPerErrIHME_Mean1_sm = DDPerErrIHME_Mean1_window, weights( 1 2 3 <4> 3 2 1) replace

label var DDPerErrIHME_Mean1_sm "Daily deaths IHME average median percent error smooth"

drop *_window

// tsset, clear

*












***************************************************************
* graph 10 Daily deaths, average median absolute percent error

twoway ///
(line DDAbPeErIHME_Mean1 date, sort lcolor(black) lwidth(medium)) /// 
if date >= td(01jan2020) & date <= td(01jan2023) ///
, xtitle(Date) xlabel(#12, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, labsize(small) angle(forty_five) format(%30.0fc)) ///
ytitle(Daily deaths error measure) title("C19 daily deaths, average median absolute percent error", size(medium) color(black)) /// 
subtitle("Maldives, IHME, forecast only", size(small)) xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) ///
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(off) yscale(titlegap(3))

qui graph export "graph 10 Maldives IHME C19 daily deaths average median absolute percent error.pdf", replace





*********************
* smooth median absolute % error for better viewing 

// tsset date, daily   

tssmooth ma DDAbPeErIHME_Mean1_window = DDAbPeErIHME_Mean1, window(3 1 3)

tssmooth ma DDAbPeErIHME_Mean1_sm = DDAbPeErIHME_Mean1_window, weights( 1 2 3 <4> 3 2 1) replace

label var DDAbPeErIHME_Mean1_sm "Daily deaths IHME average median absolute percent error smooth"

drop *_window

tsset, clear

*






***********************************************

capture drop *2str

summ DDAbPeErIHME_Mean2, meanonly

local DDAbPeErIHME_Mean2str = string(r(mean),"%8.1f")

gen DDAbPeErIHME_Mean2str = `DDAbPeErIHME_Mean2str'

label var DDAbPeErIHME_Mean2str "DDAbPeErIHME Mean over calendar months of median absolute % error over updates string"
    

* graph 11 Daily deaths, Average MAPE over updates and calendar months

graph bar ///
(mean) DDAbPeErIHME_Mean2str /// 
, bar(1, fcolor(black) lcolor(black)) ///
blabel(bar, format(%30.0fc)) ytitle("Average MAPE") yscale(titlegap(2)) ///
title("C19 daily deaths average MAPE over updates and calendar months", size(medium) color(black)) ///
subtitle("Maldives, IHME, forecast only. MAPE: Median Absolute Percent Error", size(small)) /// 
legend(off) ylabel(, labsize(small) angle(forty_five) format(%30.0fc))

qui graph export "graph 11 Maldives IHME C19 daily deaths Average MAPE over updates and calendar months.pdf", replace










******

qui compress 

save "IHME Maldives error.dta", replace 




******

* create data dictionary

preserve

    describe, replace
	
    export delimited name varlab using "IHME Maldives error data dictionary.csv", replace 
	
restore




view "log CovidLongitudinal Maldives 3 IHME.smcl"

log close

exit, clear

