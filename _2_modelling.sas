/*
LADOWANIE DANYCH I GENEROWANIE PODSTAWOWYCH INFORMACJI NA TEMAT DANYCH
*/
proc import file='\google_app_store\log_google.csv'
out=abc.log_google
dmbs=csv
;
run;

data google;
set abc.log_google;
run;

proc means data=google nmiss N min max mean std; 
var _ALL_;
output out=proc_means;
run;

/*ocena czestotliwosci brakow danych*/
data miss_flag;
set google;
if Rating =.  then Rating_flag =1; else Rating_flag =0;
run;
proc freq data=miss_flag;
tables Rating_flag;
run;

proc mi data=google nimpute=0;
var _ALL_;
run;

/*
IMPUTACJA WIELOKROTNA
*/

ods pdf file='\google_app_store\wyniki.pdf';
/* Wypelnianie danych
SEED zapewnia reprodukcje danych wyników*/
proc mi data=google nimpute=100 seed=123 out=abc.google_fcs;
class Rating Free;
fcs logistic(Rating) nbiter=200;
var _ALL_;
run;

/*budowanie uogólnionych modeli liniowych dla kazdego stworzonego modelu*/
proc genmod data=abc.google_fcs;
class Rating Free;
model Rating = Installs Reviews Free / dist=poisson ;
by _imputation_;
ods output ParameterEstimates=abc.genmod_fcs;
run;

/*analiza parametrów */
PROC MIANALYZE parms(classvar=level)=abc.genmod_fcs;
class Free;
MODELEFFECTS INTERCEPT Installs Reviews Free;
RUN;
ods pdf close;

ods pdf file='\google_app_store\wyniki_no_missings.pdf';


/*MODEL NA ZBIORZE PO USUNIECIU MISSINGOW*/
proc import file='\google_app_store\log_google_no_missings.csv'
out=abc.log_google_no_missings
dmbs=csv
;
run;

data google_dropna;
set abc.log_google_no_missings;
run;

proc genmod data=google_dropna; 
class Rating Free;
model Rating = Installs Reviews Free / dist=poisson ;
run;
ods pdf close;


ods pdf file='\google_app_store\wyniki_mediana.pdf';

/*MODEL Z IMPUTOWANA MEDIANA*/
proc import file='\google_app_store\log_google_median.csv'
out=abc.log_google_median
dmbs=csv
;
run;

data google_median;
set abc.log_google_median;
run;

proc genmod data=google_median; 
class Rating Free;
model Rating = Installs Reviews Free / dist=poisson ;
run;

ods pdf close;
