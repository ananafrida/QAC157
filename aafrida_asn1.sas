*1. import family63A_tab.txt (tab delimited data) as a temporary SAS dataset;
PROC IMPORT OUT= WORK.A
            DATAFILE= "P:\QAC\qac157\STUDENTS\mkaparakis\Assignments\asgn1\family63A_tab.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

/*2. import family63B_ unformatted.txt [ variable names: id fs edu age exp m race region] as a temporary SAS dataset*/
data B;
	infile "P:\QAC\qac157\STUDENTS\mkaparakis\Assignments\asgn1\family63B_unformatted.txt" firstobs=1;
	input id fs edu age exp m race region ;
run;

/*3. import family63C.xls as a temporary SAS dataset (import family63C.csv if the excel importing problems persist)*/
PROC IMPORT OUT= WORK.family63c 
            DATAFILE= "P:\QAC\qac157\STUDENTS\mkaparakis\Assignments\asgn1\family63C.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
	 DATAROW=2;
RUN;

/*4. Merge, append as appropriate to create a data file with all observation and variables that you can use to complete the following tasks*/
data temp1;set A B;
proc sort ; by id;

proc sort data=family63c; by id;

Data all; merge temp1 family63c; by id;
run;


/*5. create regional dummies (south=1 if region=3, zero otherwise)
(northcentral=1 if region=2, zero otherwise)
(west=1 if region=4, zero otherwise)*/
data all_region; 
set all;
if region=3 then south=1;
else south=0;
if region=2 then northcentral=1;
else northcentral=0;
if region=4 then west=1;
else west=0;
run;

/*6. Calculate appropriate descriptive statistics to summarize the following variables: E, region*/
proc means data=WORK.all_region;
    var E;
proc freq data=WORK.all_region;
    tables region;
run;

/*7. Calculate appropriate descriptive statistics to compare E across regions*/
proc means data=WORK.all_region;
    class region;
    var E;
run;

/*8. (bonus max 5 pts) Create a bar chart that shows the average value of E for the four regions.*/
proc gchart data=WORK.all_region;
	vbar region /discrete sumvar=E type=mean;
	run;
