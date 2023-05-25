/*Stata 14.1


Modified 1-29-18.
6-4-20
*/


/*Generate an ID variable*/
gen int ID=_n
order ID,before(Subject)


/*Create Numerical Subject Data; need to adjust by whether there is a "#" and by the number of subjects*/
gen int SubjectID=.
local i = 1
while `i' < 13 {
replace SubjectID=`i' if Subject=="Subject #`i'"
local i = `i' + 1
}
order SubjectID,after(Subject)



/*SaO2 Adjustment.*/
gen SaO2Calc=round(Hemoximeter,.1)
replace SaO2Calc=100 if Hemoximeter>100
replace SaO2Calc=. if Hemoximeter==0 | Hemoximeter==.
order SaO2Calc,after(Comments)


/*Create Sat Range Variable*/

gen byte SatRange=3 if SaO2Calc>= 90
replace SatRange=0 if SaO2Calc < 70
replace SatRange=1 if SaO2Calc < 80 & SaO2Calc >= 70
replace SatRange=2 if SaO2Calc < 90 & SaO2Calc >= 80
replace SatRange=. if SaO2Calc==.

label define Sat 0 "<70" 1 "70-80" 2 "80-90" 3 "90-100"
label values SatRange Sat
order SatRange,after(SaO2Calc)

gen byte SatRangeFDA=.
replace SatRangeFDA=0 if SaO2Calc < 70
replace SatRangeFDA=1 if SaO2Calc >= 70
replace SatRangeFDA=. if SaO2Calc==.

label define FDASat 0 "<70" 1 "70-100"
label values SatRangeFDA FDASat
order SatRangeFDA,after(SatRange)


/*Gender.*/

gen byte gender_b=.
replace gender_b=0 if Gender=="Female"
replace gender_b=1 if Gender=="Male"
label define gender 0 "Female" 1 "Male"
label values gender_b gender
order gender_b, after(Gender)


/*3 leve skin color.*/
gen byte skin_3=.
replace skin_3=0 if Skin=="Light"
replace skin_3=1 if Skin=="Medium"
replace skin_3=2 if Skin=="Dark"
label define skin 0 "Light" 1 "Medium" 2 "Dark"
label values skin_3 skin
order skin_3,after(Skin)




/*Fix blank pulse ox and hemoximeter data.*/

gen double SpO2_1_calc=SpO2_1 if SpO2_1 !=0
label variable SpO2_1_calc "______"

gen double SpO2_2_calc=SpO2_2 if SpO2_2 !=0
label variable SpO2_2_calc "______"

gen double SpO2_3_calc=SpO2_3 if SpO2_3 !=0
label variable SpO2_3_calc "______"

gen double SpO2_4_calc=SpO2_4 if SpO2_4 !=0
label variable SpO2_4_calc "______"

gen double SpO2_5_calc=SpO2_5 if SpO2_5 !=0
label variable SpO2_5_calc "______"

gen double SpO2_6_calc=SpO2_6 if SpO2_6 !=0
label variable SpO2_6_calc "______"

gen double SpO2_7_calc=SpO2_7 if SpO2_7 !=0
label variable SpO2_7_calc "______"

gen double SpO2_8_calc=SpO2_8 if SpO2_8 !=0
label variable SpO2_8_calc "______"

gen double SpO2_9_calc=SpO2_9 if SpO2_9 !=0
label variable SpO2_9_calc "______"




/*Generate the biases.*/

gen double BiasOx1=round(SpO2_1_calc-SaO2Calc,.1)
label variable BiasOx1 "PulseOx1 Bias"

gen double BiasOx2=round(SpO2_2_calc-SaO2Calc,.1)
label variable BiasOx2 "PulseOx2 Bias"

gen double BiasOx3=round(SpO2_3_calc-SaO2Calc,.1)
label variable BiasOx3 "PulseOx3 Bias"

gen double BiasOx4=round(SpO2_4_calc-SaO2Calc,.1)
label variable BiasOx4 "PulseOx4 Bias"

gen double BiasOx5=round(SpO2_5_calc-SaO2Calc,.1)
label variable BiasOx5 "PulseOx5 Bias"

gen double BiasOx6=round(SpO2_6_calc-SaO2Calc,.1)
label variable BiasOx6 "PulseOx6 Bias"

gen double BiasOx7=round(SpO2_7_calc-SaO2Calc,.1)
label variable BiasOx7 "PulseOx7 Bias"

gen double BiasOx8=round(SpO2_8_calc-SaO2Calc,.1)
label variable BiasOx8 "PulseOx8 Bias"

gen double BiasOx9=round(SpO2_9_calc-SaO2Calc,.1)
label variable BiasOx9 "PulseOx9 Bias"





