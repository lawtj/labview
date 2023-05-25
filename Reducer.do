/*Stata 14.1

Created 7/13/22


Takes the data file and runs the numbers.

*/


/*Insturction:

1. Complete the filepath for the LabVIEW data file.
2. Enter the total number of subjects defined in the first local variable.
3. Complete the filepath for the Excel analysis file.
4. Enter the local of the first Excel cell where the data will be exported.


*/



local subjects=12

local subject=1

while `subject' <= `subjects' {

clear

/*.Temporary subject for testing.

______*/


import delimited "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/____/____/Data/LabVIEW Data/Subject #`subject' Data.txt", varnames(nonames) rowrange(20) encoding(ISO-8859-1)

drop v15 v16

rename v1 sample
rename v2 comments
rename v3 date_computer
rename v4 time_computer
rename v5 etco2
rename v6 eto2
rename v7 scalco2
rename v8 rr
rename v9 masimospo2
rename v10 masimohr
rename v11 masimopi
rename v12 nellcorspo2
rename v13 nellcorhr
rename v14 nellcorpi




/*Generate Subject variable.*/
gen byte subject=`subject'
order subject,before(sample)

/*Generate an ID variable*/
gen int ID=_n
order ID,before(subject)



/*Manually destring the sample #.*/
gen byte sample_b=.
order sample_b,after(sample)

local i=1
while `i' <40 {

replace sample_b=`i' if sample=="Sample #`i'"

local i=`i'+1

}
drop sample
rename sample_b sample




/*Convert the masimo string data.*/

foreach v in masimospo2 masimohr masimopi {

capture confirm string var `v'

if _rc==0 {
gen float `v'_f=real(`v')

drop `v'
rename `v'_f `v'
}

}


/*Convert the Nellcor string data.*/

foreach v in nellcorspo2 nellcorhr nellcorpi {

capture confirm string var `v'

if _rc==0 {
replace `v'="" if `v'=="---"
replace `v'="" if `v'=="---*"
replace `v'="" if `v'=="AO"
replace `v'="" if `v'=="AS"
replace `v'="" if `v'=="MO"
replace `v'="" if `v'=="SL"
replace `v'="" if `v'=="SO"
destring `v', gen (`v'_b) ignore(*)

drop `v'
rename `v'_b `v'

}
}





/*Main data analysis loop.*/
local delay=5

summarize sample
local max=r(max)

matrix mytable = J(`max',4,.)

matrix colnames mytable="Masimo SpO2" "Nellcor SpO2" "Masimo PI" "Nellcor PI"

local i=1

while `i' <=`max' {


summarize ID if sample==`i'

if r(N) > 0 {
local start=r(max)+`delay'*2
local end=`start'+9

summarize masimospo2 in `start'/`end'
matrix mytable[`i',1] = r(mean)

summarize nellcorspo2 in `start'/`end'
matrix mytable[`i',2] = r(mean)

summarize masimopi in `start'/`end'
matrix mytable[`i',3] = r(mean)

summarize nellcorpi in `start'/`end'
matrix mytable[`i',4] = r(mean)

}

local i=`i'+1
}



putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/____/____/Analysis/___.xls", modify sheet (Subject #`subject')
putexcel J11=matrix(mytable)


local subject=`subject'+1

}




