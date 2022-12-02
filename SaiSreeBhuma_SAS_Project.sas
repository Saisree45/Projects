/*question-1*/

data ques1;
input before  after ;
diff= before-after;
datalines;
186 188
171 177
177 176
168 169
191 196
172 172
177 165
191 190
170 166
171 180
188 181
187 172
;
run;

ods trace on;
ods output "Observed Tests"=LocationTest;
PROC UNIVARIATE DATA=ques1  CIPCTLDF(ALPHA=0.05);
VAR diff;
RUN;

data WL_test; set LocationTest;
if test="Signed Rank";
run;
title "Signed Rank Test";
proc print data = WL_test noobs;
run;

/*question-2*-to be changed- check any video*/

data Yields; input A B C D;
datalines;
8.3 9.1 10.1 7.8
9.4 9.0 10.0 8.2
9.1 8.1 9.6 8.1
9.1 8.2 9.3 7.9
9.0 8.8 9.8 7.7
8.9 8.4 9.5 8.0
8.9 8.3 9.4 8.1
;
run;

proc print data = Yields; run;

data aa1 aa2 aa3 aa4; set Yields;
group="variety A"; y=A; output aa1;
group="variety B"; y=B; output aa2;
group="variety C"; y=C; output aa3;
group="variety D"; y=D; output aa4;
run;
data W; set aa1 aa2 aa3 aa4;
keep group y;
run;
proc print data =W;run;

ods select none;
ods output "Scores"=WS;
ods output "Kruskal-Wallis Test"=W1;

proc npar1way  wilcoxon correct=yes  data = W ;
  class group;
  var y;
run;

ods select all;
proc print data =WS noobs;
format SumOfScores StdDevOfSum MeanScore 6.2;
var CLass N SUmOfScores StdDevOfSum MeanScore;
title "Scores of each Variety";
run;

proc print data=W1 noobs;
format cValue1 $6.;
var Variable ChiSquare DF Prob;
title "Kruskal-Wallis Test for means";
run; 

/*quetion3*/
proc format;

value decision 
      0='Yes'
      1='No'
		2='Uncertain';

value gender 
      0='Women'
      1='Men';
run;



data marriage;
input gender decision Count;
datalines;
0 0 125
0 1 59
0 2  21
1 0 101
1 1 79
1 2  16
 ;
run;

proc freq data=marriage;

format gender gender. decision decision.;
title "Expected counts for 2*3 table";
tables gender*decision/  nopercent norow nocol chisq expect relrisk;
weight count;
run;

/*Question4*/
   data ques4;
      input Executive $ Method $  risk @@;
      datalines;
   1 1  1.3  1 2  4.8  1 3  9.2  
   2 1  2.5  2 2  6.9  2 3  14.4  
   3 1  7.2  3 2  9.1  3 3  16.5 
   4 1  6.8  4 2  13.2  4 3  17.6  
   5 1  12.6  5 2  13.6  5 3  15.5  
   
   ;
 run;

 proc glm data=ques4;
      class Executive Method;
      model Risk = Executive Method /ss1;
   run;

proc glm data = ques4;
  class executive method;
  model risk= method executive /ss1;
  means method /deponly;
  title "Test for any pair of methods";
  contrast 'Pair of methods 1 and 2' method 1 -1 0 ;
  contrast 'Pair of methods 1 and 3' method 1 0 -1 ;
  contrast 'Pair of methods 2 and 3' method 0 1 -1 ;
run;

proc glm data = ques4;
  class method Executive;
  model risk= method Executive/ss1;
  means Executive /deponly;
  title "Test for any pair of Executives";
  contrast ' Pair of executives 1 and 2' Executive 1 -1 0 0 0;
  contrast ' Pair of executives 1 and  3' Executive 1 0 -1 0 0;
  contrast ' Pair of executives 1 and  4' Executive 1 0 0 -1 0;
  contrast ' Pair of executives 1 and  5' Executive 1 0 0 0 -1;
  contrast ' Pair of executives 2 and  3' Executive 0 1 -1 0 0;
  contrast ' Pair of executives 2 and  4' Executive 0 1 0 -1 0;
  contrast ' Pair of executives 2 and  5' Executive 0 1 0  0 -1;
  contrast ' Pair of executives 3 and  4' Executive 0 0 1 -1 0;
  contrast ' Pair of executives 3 and  5' Executive 0 0 1 0 -1 ;
  contrast ' Pair of executives 4 and  5' Executive 0 0 0 1 -1;
run;
quit;
