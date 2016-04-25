%INCLUDE "taxcalc.sas";
proc import datafile="compare-in.csv" out=indata dbms=csv; getnames=yes;
run;
data outdata;
set indata;
%INIT;
_puf = 0; * the setting of _puf to one in INIT macro may need to be skipped;
_numxtr = numextra; * rename number of taxpayers who are age 65+;
* set _agep and _ages using value of numextra;
_agep = 50;
_ages = 50;
if numextra ge 1 then _agep = 70;
if numextra ge 2 then _ages = 70;
e19400 = e19200; * rename non-AMT-preferred deductions because _puf is zero;
e32700 = e32800; * rename childcare expenses because _puf is zero;
e32880 = e00200p; * rename taxpayer earnings for childcare credit logic;
e32890 = e00200s; * rename spouse earnings for childcare credit logic;
%COMP;
_nbertax = _nbertax + c07200; * ignore Sch.R credit not in Tax-Calculator;
keep RECID c00100 c02500 c04600 c04470 c04800 c05200 c05800
     c07180 c07220 c09600 c11070 c21040 c59660 _nbertax;
proc export data=outdata outfile="compare-out.csv" dbms=csv replace;
run;