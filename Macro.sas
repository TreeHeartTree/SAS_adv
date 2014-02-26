/*SYMPUT function*/
%let crsnum=3;
data revenue;
	set sasuser.all end=final;
	where course_number=&crsnum;
	total+1;
	if paid="Y" then paidup+1;
	if final then do;
		call symput('numpaid', paidup);
		call symput('numstu', total);
		call symput('crsname', course_title);
	end;
run;
proc print data=revenue noobs;
	var student_name student_company paid;
	title "fees status for &crsname (#&crsnum)";
	footnote "note: &numpaid out of &numstu students";
run;

/*SYMPUTX function*/
%let crsnum=3;
data revenue;
	set sasuser.all end=final;
	where course_number=&crsnum;
	total+1;
	if paid="Y" then paidup+1;
	if final then do;
		call symputx('crsname', course_title);
		call symputx('date', put(begin_date, mmddyy10.));
		call symputx('due', put(fee*(total-paidup), dollar8.));
	end;
run;

proc print data=revenue;
	var student_name student_company paid;
	title "fee status for &crsname (#&crsnum) held &date";
	footnote "&due in unpaid fees";
run;

/**/
%let crsnum=3;
data revenue;
	set sasuser.all end=final;
	where course_number=&crsnum;
	total+1;
	if paid="Y" then paidup+1;
	if final then do;
		call symput('numpaid', trim(left(paidup)));
		call symput('numstu', trim(left(total)));
		call symput('crsname', trim(left(course_title)));
	end;
run;

proc print data=revenue;
	var student_name student_company paid;
	title "fee status for &crsname (#&crsnum)";
	footnote "Note: &numpaid Paid out of &numstu Students";
run;

/*SYMGET function*/
options symbolgen;
data _null_;
	set sasuser.schedule;
	call symput(’teach’||left(course_number), trim(teacher));
run;

data teachers;
	set sasuser.register;
	length teacher $20;
	teacher=symget('teach'||left(course_number));
run;

proc print data=teachers;
	var student_name course_number teacher;
	title "teacher for each register student";
run;
/**/
proc sql noprint;
	select count(*) into :numrows
		from sasuser.schedule
		where year(begin_date)=2002;
	%let numrows=&numrows;
	%put there are &numrows courses in 2002;
	select course_code, location, begin_date format=mmddyy10.
		into :crsid1-crsid&numrows,
			 :place1-place&numrows,
			 :date1-date&numrows
		from sasuser.schedule
		where year(begin_date)=2002;
		order by begin_date;
	put _user_;
quit;
 
