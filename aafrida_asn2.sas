*1. To create a temporary SAS data file that includes
all the years and variables in the above data files (i.e. import the files, append and merge as needed);

*read the dta file. Importing gss_78_84 as stata file;
PROC IMPORT OUT= WORK.GSS_78_84 
            DATAFILE= "P:\QAC\qac157\STUDENTS\mkaparakis\Assignments\asgn2\GSS_78_84.dta"
            DBMS=STATA REPLACE;
RUN;

* read the csv file;
PROC IMPORT OUT= WORK.GSS_94 
            DATAFILE= "P:\QAC\qac157\STUDENTS\mkaparakis\Assignments\asgn2\GSS_94.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

* read the excel as csv since excel isn't working;
PROC IMPORT OUT= WORK.GSS_04
            DATAFILE= "P:\QAC\qac157\STUDENTS\mkaparakis\Assignments\asgn2\GSS_04.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

* read a tab delimited file;
PROC IMPORT OUT= WORK.GSS_12_tab 
            DATAFILE= "P:\QAC\qac157\STUDENTS\mkaparakis\Assignments\asgn2\GSS_12_tab.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=5; 
RUN;

* read unformatted ascii  data;  
data GSS_12_unformatted;
	infile "P:\QAC\qac157\STUDENTS\mkaparakis\Assignments\asgn2\GSS_12_unformatted.txt" firstobs=1;
	input CASEID YEAR ID GUN GUNAGE GUNNUM OWNGUN SHOTGUN ROWNGUN GUNNER HGUNLAW HGUNCRIM GUNSALES GUNSDRUG SEMIGUNS GUNS911 OTHGUNS GUNSDRNK;
run;


Proc sort data=GSS_12_tab; by id;  * sorting gss_12_tab based on id;
Proc sort data=GSS_12_unformatted; by id; * sorting gss_12_unformatted based on id ;

Data addvariables; merge GSS_12_tab GSS_12_unformatted; by id; * merging gss_12_tab and gss_12_ubformatted by id in file addvariables;

data temp1;set addvariables; * duplicating addvariables in a new file temp1;
proc append base=temp1 data=gss_04; * appending gss_04 to temp1;
proc append base=temp1 data=gss_94; * appending gss_94 to temp1;
proc append base=temp1 data=gss_78_84; * appending gss_78_84 to temp1;

run;



*2. Account for missing observations for the following variables: TVHOURS, NEWS, PISTOL,RIFLE, DEGREE;
Data temp1;
    set temp1;

if tvhours=-1 or tvhours>=98 then tvhours=.; * for tvhours is -1 or tvhours is greater than 98,
it sets tvhours as missing variable. Same for pistol, news, and rifle variables for those values;
if pistol=0 or pistol>=8 then pistol=.;
if news= 0 or news >= 8 then news=.;
if rifle = 0 or rifle >= 8 then rifle=.;
if degree >= 7 then degree=.; * for values of degre greater than 7, set degree as missing variable for those values;

*3. To account for missing observations someone used the statements listed in the following two pages. 
I know you can you can do the same work with fewer lines of code. Please re-write their program and 
account for missing observations for GUN GUNAGE GUNNUM OWNGUN SHOTGUN ROWNGUN GUNNER HGUNLAW HGUNCRIM 
GUNSALES GUNSDRUG SEMIGUNS GUNS911 OTHGUNS GUNSDRNK;

array quick(*) GUN GUNAGE GUNNUM OWNGUN SHOTGUN ROWNGUN GUNNER HGUNLAW HGUNCRIM GUNSALES GUNSDRUG 
SEMIGUNS GUNS911 OTHGUNS GUNSDRNK;* declaring an array with all the elements in it;
do i=1 to dim(quick); * run a do loop for i=1 to all elements of the array;
if quick(i) eq 0 or quick(i)>=8 then quick(i)=.; * for all the elements of the array, if it's equals 0 or greater than
equals to 8, then set that elements as missing variables for those values;
end;

run;

*4. Use appropriate summary statistics to explore how gun ownership may have changed overtime.;
proc sort data=temp1; by year;*sort temp1 based on the id column;
proc freq data=temp1;*calling the procedure freq since owngun is a categorical variable;
table owngun ;
by year;
run;


*5. Create an appropriate graph to show changes of gun ownership for different education levels over time.;
*new way of doing owngun;
proc freq DATA=WORK.temp1;
	*tables degree *  owngun/ plots=freqplot(type=dotplot scale=percent); 
	tables degree *  owngun/out=b  chisq outpct plots=freqplot(scale=percent);
by year;
	output  out=b1 chisq ; ** NOTE: different than out= in tables statement;
	run;




*old way of doing owngun;
proc sort data = temp1; *sorts temp1 data file by owngun and year;
by owngun year;

proc freq data = temp1;
by owngun year;
tables degree / out = FreqOut; *creates a table and a new dataset freqout;
run;

proc sgpanel data=FreqOut;
title "gun ownership for different education level overtime"; *titles te graph with the mentioned name;
panelby year; *creates four different graphs by paneling them;
vbar owngun / response=Percent group = degree groupdisplay=cluster;* group display is how the data will be represented;
run; 

/*new code for assgn 3;
proc freq DATA=WORK.a;
	*tables degree *  abany/ plots=freqplot(type=dotplot scale=percent); 
	tables degree *  abany/out=b  chisq outpct plots=freqplot(scale=percent);
by year;
	output  out=b1 chisq ; ** NOTE: different than out= in tables statement;
	run;
