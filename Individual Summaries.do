
/*Loops through all oximters.*/

/*

1.  Enter the number of oximeters in the local "ox"
2.  Delete the extra Bias variables.
3.  Since this is being put in Excel, it won't put in the rownames anyway.
4.  Need to modify the file path, but the sheet should be correct.

*/


do "/Users/feiner/Documents/Files/Pulse Ox Studies/Miscellaneous/Stata Do Files/Programs RMS"


/*Single Device.*/

/*Instruction:
1.  Enter the total number of subjects.*/

local subjects=12

matrix mytable = J(`subjects',2,.)

matrix rownames mytable =  1 2 3 4 5 6 7 8 9 10 11 12 
matrix colnames mytable =  "Bias" "Arms"

local r=1

while `r'<=`subjects' {
quietly summarize BiasOx1 if SatRangeFDA==1 & SubjectID==`r'

local m = r(mean)
matrix mytable[`r',1] = `m'


quietly myrmsif3 BiasOx1 SatRangeFDA 1 SubjectID `r'
matrix mytable[`r',2] = r(rms)

local r=`r'+1

}


putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/_________/_________/Analysis/_________.xls", modify sheet (Individual)
putexcel M4=matrix(mytable)




/*Loop with all devices.*/


local subjects=12
local devices=4

matrix mytable = J(`subjects',2*`devices',.)

matrix rownames mytable =  1 2 3 4 5 6 7 8 9 10 11 12 
matrix colnames mytable =  "Bias" "Arms"


local c=0

foreach v in BiasOx1 BiasOx2 BiasOx3 BiasOx4 {

local r=1

while `r'<=`subjects' {
quietly summarize `v' if SatRangeFDA==1 & SubjectID==`r'

local m = r(mean)
matrix mytable[`r',2*`c'+1] = `m'


quietly myrmsif3 `v' SatRangeFDA 1 SubjectID `r'
matrix mytable[`r',2*`c'+2] = r(rms)

local r=`r'+1

}

local c=`c'+1

}


putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/_________/_______/Analysis/_______.xls", modify sheet (Individual)
putexcel M4=matrix(mytable)






/*Pooled Summary.*/

reshape long BiasOx, i(ID) j(Device)

/*This allows a conditional statement in one place, which might allow pooling of just a couple of oximeter.*/
gen tempBias=BiasOx if Device <=2
gen byte tempBiasm=.
replace tempBiasm=1 if Device <=2 & BiasOx==. 


matrix mytable = J(12,2,.)

matrix rownames mytable =  1 2 3 4 5 6 7 8 9 10 11 12 
matrix colnames mytable =  "Bias" "Arms"

local r=1

while `r'<=12 {
quietly summarize tempBias if SatRangeFDA==1 & SubjectID==`r'

local m = r(mean)
matrix mytable[`r',1] = `m'


quietly myrmsif3 tempBias SatRangeFDA 1 SubjectID `r'
matrix mytable[`r',2] = r(rms)

local r=`r'+1

}


putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/_________/_______/Analysis/_______.xls", modify sheet (Individual)
putexcel M4=matrix(mytable)

drop tempBias
drop tempBiasm

reshape wide BiasOx, i(ID) j(Device)


foreach v in  BiasOx5 BiasOx4 BiasOx3 BiasOx2 BiasOx1 {

order `v',after(Comments)

}




/*For heart rates.*/


/*HR bias which is everything, since the SpO2 biases are restricted to the FDA range.*/

local subjects=12
local devices=1

matrix mytable = J(`subjects',2*`devices',.)

matrix rownames mytable =  1 2 3 4 5 6 7 8 9 10 11 12 
matrix colnames mytable =  "Bias" "Arms"


local c=0

foreach v in HR_Bias {

local r=1

while `r'<=`subjects' {
quietly summarize `v' if  SubjectID==`r'

local m = r(mean)
matrix mytable[`r',2*`c'+1] = `m'


quietly myrmsif `v'  SubjectID `r'
matrix mytable[`r',2*`c'+2] = r(rms)

local r=`r'+1

}

local c=`c'+1

}


putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/_________/_______/Analysis/_______.xls", modify sheet (Individual)
putexcel M4=matrix(mytable)

