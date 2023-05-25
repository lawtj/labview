/*Stata. 14.1

Modified 2-1-20*/


/*Loops through all oximters.*/

/*

1.  Enter the number of oximeters in the local "ox"
2.  Delete the extra Bias variables.
3.  Since this is being put in Excel, it won't put in the rownames anyway.
4.  Need to modify the file path, but the sheet should be correct.

*/


do "/Users/feiner/Documents/Files/Pulse Ox Studies/Miscellaneous/Stata Do Files/Programs/Programs Run"

local ox=9
local rows=`ox'*15-2
matrix mytable = J(`rows',6,.)
local i = 0
local t = 0
gen double temp_SpO2=.

matrix rownames mytable =  count missing mean SD SEM CI lowerLOA upperLOA maximum minimum Arms "Bias Regression" "SpO2 Regression"
matrix colnames mytable =  "<70" "70-80" "80-90" "90-100" "70-100" "All"

foreach v in BiasOx1 BiasOx2 BiasOx3 BiasOx4 BiasOx5 BiasOx6 BiasOx7 BiasOx8 BiasOx9  {

replace temp_SpO2=`v' + SaO2Calc

while `i'<5 {

quietly summarize `v' if SatRange==`i'

local m = r(mean)
matrix mytable[1 + `t',`i'+ 1] = r(N)
matrix mytable[3 + `t',`i'+ 1] = `m'
matrix mytable[4 + `t',`i'+ 1] = r(sd)
matrix mytable[5 + `t',`i'+ 1] = r(sd)/sqrt(r(N))
matrix mytable[9 + `t',`i'+ 1] = r(max)
matrix mytable[10 + `t',`i'+ 1] = r(min)

quietly ci means `v' if SatRange==`i'
matrix mytable[6 + `t',`i'+ 1] = r(ub)-r(mean)

quietly tab SatRange if `v'==. & SatRange==`i'
matrix mytable[2 + `t',`i'+ 1] = r(N)

quietly myrmsif `v' SatRange `i'
matrix mytable[11 + `t',`i'+ 1] = r(rms)
quietly mysdif `v' SubjectID SatRange `i'
local ll = `m' - 1.96 * r(sd)
matrix mytable[7 + `t',`i'+ 1] = `ll'
local ul = `m' + 1.96 * r(sd)
matrix mytable[8 + `t',`i'+ 1] = `ul'


local i = `i' + 1
}

quietly summarize `v' if SatRangeFDA==1

local m = r(mean)
matrix mytable[1 + `t',5] = r(N)
matrix mytable[3 + `t',5] = `m'
matrix mytable[4 + `t',5] = r(sd)
matrix mytable[5 + `t',5] = r(sd)/sqrt(r(N))
matrix mytable[9 + `t',5] = r(max)
matrix mytable[10 + `t',5] = r(min)

quietly ci means `v' if SatRangeFDA==1
matrix mytable[6 + `t',5] = r(ub)-r(mean)

quietly tab SatRangeFDA if `v'==. & SatRangeFDA==1
matrix mytable[2 + `t',5] = r(N)

quietly myrmsif `v' SatRangeFDA 1
matrix mytable[11 + `t',5] = r(rms)
quietly mysdif  `v' SubjectID SatRangeFDA 1
local ll = `m' - 1.96 * r(sd)
matrix mytable[7 + `t',5] = `ll'
local ul = `m' + 1.96 * r(sd)
matrix mytable[8 + `t',5] = `ul'



quietly summarize `v'

local m = r(mean)
matrix mytable[1 + `t',6] = r(N)
matrix mytable[3 + `t',6] = `m'
matrix mytable[4 + `t',6] = r(sd)
matrix mytable[5 + `t',6] = r(sd)/sqrt(r(N))
matrix mytable[9 + `t',6] = r(max)
matrix mytable[10 + `t',6] = r(min)

quietly ci means `v'
matrix mytable[6 + `t',6] = r(ub)-r(mean)

quietly tab `v' if `v'==. & SaO2Calc !=.,m
matrix mytable[2 + `t',6] = r(N)

quietly myrms `v'
matrix mytable[11 + `t',6] = r(rms)
quietly mysd `v' SubjectID
local ll = `m' - 1.96 * r(sd)
matrix mytable[7 + `t',6] = `ll'
local ul = `m' + 1.96 * r(sd)
matrix mytable[8 + `t',6] = `ul'

regress `v' SaO2Calc if SaO2Calc>=70
matrix results=r(table)
matrix mytable[12 + `t' ,1] =results[1,2]
matrix mytable[12 + `t' ,2] =results[1,1]
matrix mytable[12 + `t' ,3] =e(r2)
matrix mytable[12 + `t' ,4] =results[4,1]

regress temp_SpO2 SaO2Calc if SaO2Calc>=70
matrix results=r(table)
matrix mytable[13 + `t' ,1] =results[1,2]
matrix mytable[13 + `t' ,2] =results[1,1]
matrix mytable[13 + `t' ,3] =e(r2)
matrix mytable[13 + `t' ,4] =results[4,1]

local i = 0
local t = `t' + 15

}

drop temp_SpO2

matrix list mytable

putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/_____/______/Analysis/____.xls", modify sheet (SpO2 Tables)
putexcel T10=matrix(mytable)


