
/*Loops through all oximters.*/

/*

1.  Enter the number of oximeters in the local "ox"
2.  Enter the number of subjects.
3.  Delete the extra Bias variables.
4.  Need to modify the file path, but the sheet should be correct.

*/







/*Pooled devices.*/

local subjects=12


reshape long BiasOx, i(ID) j(Device)

matrix mytable = J(`subjects',3,.)

matrix rownames mytable =  1 2 3 4 5 6 7 8 9 10 11 12 
matrix colnames mytable =  "Bias" "SD" "2SD"

local r=1

while `r'<=`subjects' {
quietly summarize BiasOx if SatRangeFDA==1 & SubjectID==`r'

local m = r(mean)
local sd=r(sd)

matrix mytable[`r',1] = `m'

matrix mytable[`r',2] = `m'+`sd'

matrix mytable[`r',3] = `m'+1.96*`sd'


local r=`r'+1

}



reshape wide BiasOx, i(ID) j(Device)

foreach v in  BiasOx4 BiasOx3 BiasOx2 BiasOx1 {

order `v',after(SpO2_4_calc)


}

matrix a=mytable[1..12,1]
matrix b=mytable[1..12,2]
matrix c=mytable[1..12,3]

putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/______/________/Analysis/______.xls", modify sheet (Individual)

putexcel D41=matrix(a)
putexcel G41=matrix(b)
putexcel M41=matrix(c)


