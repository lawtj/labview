/*Stata 14.1




Table for the variance.*/


local ox=3
local rows=2*`ox'
matrix mytable = J(`rows',3,.)

matrix rownames mytable =  Between1 Within1 Between2 Within2 Between3 Within3
matrix colnames mytable =  SS DF MS

local r=1
foreach v in BiasOx1 BiasOx2 BiasOx3 {

quietly oneway `v' SubjectID
matrix mytable[`r',1] = r(mss)
matrix mytable[`r',2] = r(df_m)
matrix mytable[`r',3] = r(mss)/r(df_m)

matrix mytable[`r'+1,1] = r(rss)
matrix mytable[`r'+1,2] = r(df_r)
matrix mytable[`r'+1,3] = r(rss)/r(df_r)

local r=`r' + 2

}

matrix list mytable

putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/__/__/_.xls", modify sheet (Variances)
putexcel K3=matrix(mytable)



/*For FDA range only.*/

local ox=3
local rows=2*`ox'
matrix mytable = J(`rows',3,.)

matrix rownames mytable =  Between1 Within1 Between2 Within2 Between3 Within3
matrix colnames mytable =  SS DF MS

local r=1
foreach v in BiasOx1 BiasOx2 BiasOx3 {

quietly oneway `v' SubjectID if SatRangeFDA==1
matrix mytable[`r',1] = r(mss)
matrix mytable[`r',2] = r(df_m)
matrix mytable[`r',3] = r(mss)/r(df_m)

matrix mytable[`r'+1,1] = r(rss)
matrix mytable[`r'+1,2] = r(df_r)
matrix mytable[`r'+1,3] = r(rss)/r(df_r)

local r=`r' + 2

}

matrix list mytable

putexcel set "/Users/feiner/Documents/Files/Pulse Ox Studies/Companies/__/__/_.xls", modify sheet (Variances)
putexcel K20=matrix(mytable)
