#######第一章
libname a1 "f:\sasdata\a1";/*libname语句在逻辑库里建立一个名为a1的文件夹，并将其存放到电脑f:\sasdata\a1这个路径里面*/
data first;/*建立一个名为first的数据集，并将其存放在work这个文件夹下了，但是这个work文件夹下的数据集是临时的*/
input gender age;/*在first这个数据集中输入2个变量gender和age*/
cards;/*开始输入数据*/
1 35
2 30
;/*这四个数据代表1男35岁  2女30岁*/

data a1.first;/*first这个数据集前面加上a1.的话,first这个数据集就存放到了逻辑库a1这个文件夹下了，而且是永久的*/
input gender age;
cards;
1 35
2 30
;

/*还有一种建立永久数据库的方法*/
data "f:/sasdata/m1/second";/*这种方法通过data语句完成， data后面"f:/sasdata/m1/second";这个表示在f:/sasdata/m1这个路径中建立了一个名为second的永久数据集*/
input gender age;
cards;
1 65
2 36
2 52
;
 /*但是这种方法会在sas逻辑库里面生成一个名为Wc000001的文件名，无法自己命名

下面来说一说这两种建立永久数据集的方法在下次启动sas时怎么调用数据集
第一种是libname语句*/
libname a1 "f:/sasdata";/*先用libname语句把逻辑库里面a1这个文件夹和电脑f:/sasdata这个路径链接起来*/
proc print data=a1.first;/*这是个程序步，print data=a1.first表示输入数据，哪里的数据呢 逻辑库a1这个夹里面first这个永久数据集*/
run;

/*第二种是data语句建立的永久数据集的调用程序如下（直接可以进行程序步）*/
proc print data="f:/sasdata/m1/second";
run;

/*下面这个程序可以用来导入外部数据*/

PROC IMPORT OUT= WORK.test /*导入test这个数据集，并放入work这个逻辑库里面的临时文件，当然work换成逻辑库里面的其他夹，test就能够永久保存了*/
            DATAFILE= "F:\sasdata\test.xlsx"/*这个意思是说打算录入的test这个数据集在咱们电脑的位置了*/ 
            DBMS=EXCELCS REPLACE;
     RANGE="Sheet1$"; 
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


libname a1 "f:\sasdata\a1";/*新建永久逻辑库a1*/
proc print data=a1.first;
run;

####第二章
/*下面是数值型变量的输入格式设置*/
libname a2 "f:\sasdata\a2";/*新建逻辑库文件a2,哦永久的*/
data a2.x;
input x 2.1; /*这里的2.1表示x这个数据集的输入格式，也就是sas怎么读，sas会认为所有输入的数是2位，其中一位是小数*/  
cards;
13
2
0.1
333
;/*这个结果是从左往右读，显示为1.3 0.2 0 3.3，所以一般数值型变量不用设置输入格式*/
proc print;/*输入这行，输入的数据会弹出来*/
run;

/*知识拓展：如果不小心sas资源管理器关了，可以输入sasenv进行恢复*/

/*字符型变量的输入格式*/
/*字符输入格式是美国符号$w.  美国符号啥时候都要有，w.用来设置宽度，1个字是2宽度，sas默认宽度是8，也就是默认情况下只能读4个字*/
data gvg;
input homeplace $12.;/*输入homeplace这个变量，设置它的宽度为12*/
cards;
山西省运城市
;
proc print;
run;

data gh;
input city:$18. zone$;/*city之后冒号:
是告诉sas空格之后或者变量宽度达到就可以读下一个变量了*/
cards;
山东省蓬莱市 0536
山东省青岛市市南区 0532
;
proc print;
run;

data fgf;
input name&:$50. city&:$50.;
/*&用来解决变量有空格的问题，此时输入的两个变量之间可以打两个及以上空格*/
cards;
peter parker  山东省 蓬莱市 
ross geller  山东省 青岛市 市南区
;
proc print;
run;

data fg;
input nuj kjh prop;
format nuj 5.2 kjh comma12.1
/*kjh变量12位，保留小数点后1位，每3位显示*/ prop percent8.2;
cards;
50 10205600 0.1236
45 9580000 0.0361
;
proc print;
run;

 /*substrn提取函数*/
data iden;/*新建数据集iden*/
input sfz: $18.;/*输入变量sfz，字符型，定义长度18位  */
if length(sfz)=18/*如果变量sfz长度是18*/ 
then tq=substrn(sfz,17,1);/*sfz 17位开始 提取1位*/
else tq=substrn(sfz,15,1);/*身份证 15位开始 提取1位*/
if mod(tq,2)=1/*mod函数是返回变量tq除以2的余数*/ then gender="男";
else gender="女";
if length(sfz)=18 then bir=substrn(sfz,7,8);
else bir=substrn(sfz,4,8);
cards;
142703199601083018
360533801215792
;
proc print;
run;

data iden;
input sfz:$18.;
if length(sfz)=18 then bir=substrn(sfz,7,8);
else bir=substrn(sfz,4,8);
cards;
142703199601083018
360533801215792
;
proc print;
run;

/*自定义输入格式*/
proc format;
invalue fage low-<40=30 40-<50=40 50-<60=50 60-high=60;
data age;
input id age fage.;
cards;
1 36
2 43
3 51
4 60
5 59
;
proc print;
run;

/*自定义输入和输出格式*/
proc format;
invalue $grade 1="freshman" 2="sophomore" 3="junior" 4="senior";
value fscore low-<60="不及格" 60-<80="及格" 80-high="优秀";
data grade;
input id grade: $grade20. score;
format score fscore.;
cards;
1 1 60
2 4 59
3 3 80
4 2 79
;
proc print;
run;

/*picture定义显示样式*/
proc format;
picture pft low-high="0,000,000"(prefix="￥")/*前缀为￥*/;
picture pro low-high="09.99%";
run;
data profit;
input profit prop;
format profit pft. prop pro.;
cards;
298630 16.72
365800 21.30
;
proc print;
run;

/*直接产生新变量*/
data a1;
input wt ht;
bmi=wt/(ht/100)^2;
rbmi=sqrt(bmi)/*开根号*/;
obesity=(bmi>=28);
city="北京";
date="19oct2020"d;
format date yymmdd10.;
cards;
60 170
55 166
73 161
;
proc print;
run;


/*if then else产生新变量*/
data lx;
input id lx$;
lx1=lx in ("有效","显效","痊愈");
if lx in ("有效","显效","痊愈") then lx2="有效";else lx2="无效";
cards;
1 显效
2 有效
3 无效
4 痊愈
;
proc print;
run;


/*retain语句和累加语句产生新变量*/
 data fh;
 retain count 0;/*retain指定变量count初始值为0*/
 count=count+1;
 input time;
 cards;
 23
 29
 49
 ;
 proc print;
 run;

 data fh;
 count+1;/*累加语句：变量名+格式*/
 input time;
 cards;
 23
 29
 49
 ;
 proc print;
 run;


data fsh;
input amount;
retain year 2000;
year=year+1;
total+amount;
cards;
100
200
300
;
proc print;
run;

/*利用do循环产生新变量*/
data fh;
do count=1 to 5;
input time;
output;
end;
cards;
23
29
49
64
87
;
proc print;
run;

/*length函数定义变量长度*/
data lx;
input id lx$;
length lx1$16.;/*length定义新变量的长度和类型*/
if lx="无效" then lx1="无效";
else lx1="有效+显效+痊愈";
cards;
1 显效
2 有效
3 无效
4 痊愈
;
proc print;
run;

/*@和@@符号的用法*/
data fsh;
input id age@@;
cards;
1 23 2 29 3 49 4 36
;
proc print;
run;

data score;
input gender$ n@;
do id=1 to n;
input score@@;
output;
end;
cards;
M 4 86 90 83 79
F 3 85 93 90
;
proc print;
run;


DATA aa;
input age@@;
gage=round(age-5,10)/*round函数使得age-5四舍五入到能被10整除的最接近的数*/;
cards;
29 31 39 40 55 60 64
;
proc print;
run;

data bb;
input id@@;
if mod(id,2)=1 then group="A";/*mod函数返回id/2的余数*/
else group="B";
cards;
1 2 3 4 5 6 7 8 9 10
;
proc print;
run; 

data iden;
input iden: $18.;
if length(iden)=18 then gen=substrn(iden,17,1)
 /*提取字符，从17位开始提取1位*/;
else gen=substrn(iden,15,1);
if mod(gen,2)=1 then sex="男";
else sex="女";
cards;
360A53319720613591X
360533801215792
360533198208254533
360533851009261
;
PROC print;
run;

/*查找变量中的字符*/
data book;
input book:&$100.;
sas=find(book,"sas","i");/*在变量book中查找完整sas，忽略大小写*/
if sas>0 then class="SAS书";
else class="其他";
cards;
Survival Analysis Using SAS
Matlab程序分析
Spss数据分析
SAS应用分析
The Little SAS Book
;
proc print;
run;

/*将字母和数字分开提取*/
 data computer;
 input type$@@;
 alpha=anyalpha(type);/*返回变量type第一个字母的位置*/
 digit=anydigit(type);/*返回第一个数字的位置*/
 xl=substrn(type,alpha,digit-alpha);/*提取变量type中的字母*/
 xh=substrn(type,digit,length(type)-digit+1);/*提取变量type中的数字*/
 cards;
 TP340 KS320 B3510 C560 H430
 ;
 PROC PRINT;
 run;

 /*替换变量中的字符：tranwrd(变量,查找值,替换值)*/
 data lx;
 input id lx$;
 lx1=tranwrd(lx,"显效","有效");
 lx1=tranwrd(lx1,"痊愈","有效");
 cards;
 1 显效
 2 有效
 3 无效
 4 痊愈
 ;
 proc print;
 run;

 /*compress函数 去除变量中的字符*/
 /*compress(变量,"欲去除的变量","修饰符")*/
 data computer;
 input type$@@;
 xh=compress(type,"","d");/*去除type中的所有数字*/
 bh=compress(type,"","a");/*去除type中的所有字母*/
 cards;
 TP340 KS320 B3510 C560 H340
 ;
 PROC PRINT;
 RUN;

 data phone;
 input phone:&$300.;
 phone1=compress(phone,"(-) ");/*去除phone中的（-） 四个字符*/
 phone2=compress(phone,"","kd");/*保留变量phone的数字*/
 cards;
 (01067658925)
 010-67665632
 010 67685621
 ;
 proc print;
 run;

 /*变量的合并*/
 /*cats(变量1,变量2,....)*/
 /*catx（"分隔符",变量1,变量2,...）*/
data code;
input city$ county$;
prov="37";
code1=cats(prov,city,county);
code2=catx("-",prov,city,county);
cards;
05 02
03 21
06 13
06 85
;
proc print;
run;

/*清点变量中字符*/
/*count(变量,欲清点的字符,"i")*/
data cloth;
input pj&:$20.;
beauty=count(pj,"漂亮");
cards;
裙子很漂亮，穿起来有仙女的感觉
裙子很喜欢，很漂亮，不知道面料牢固不牢固
裙子很漂亮
裙子很飘逸
面料柔软舒适。很飘逸
很漂亮，超喜欢这个颜色
质量一般，没有想象中的那么好
很大方，不足之处是，透气性不是非常好
;
proc print;
run;


data ques;
do id=1 to 4;
input (y1-y10) ($);/*输入变量y1-y10，均为字符型，后面都加上$*/
y=cats(of y1-y10);/*合并变量y1-y10为y*/
cy=count(y,"y","i");/*查找y的个数*/
cn=count(y,"n","i");/*查找n的个数*/
output;
end;
cards;
y y n y n y n y n n
y n y y n y y y n y
n y n y y y n y y n
n n y y y y n y n y
;
proc print;
run;

/*函数missing查找变量中的缺失值*/
data baseline;
do id=1 to 4;
input gender$ age;
mgender=missing(gender);/*判断gender是否有缺失*/
mage=missing(age);/*判断age是否有缺失*/
output;
end;
cards;
f 60
m 59
f .
. 48
;
proc print;
run;

/*与日期和时间有关的函数*/
/*日期的合并与差值*/
/*合并:mdy（月，日，年）*/
/*差值：yrdif(开始日期，结束日期，"计算依据")
        datdif(开始日期,结束日期,"计算依据")*/
data date;
input year1$ month1$ day1$ year2$ month2$ day2$;
date1=mdy(month1,day1,year1);
date2=mdy(month2,day2,year2);
format date1 date2 yymmdd10.;
ydif=yrdif(date1,date2,"actual");/*计算以年为单位的日期差值*/
ddif=datdif(date1,date2,"actual");/*计算以日为单位的日期差值*/
cards;
2013 05 21 2014 03 11
2013 03 10 2014 01 22
2013 06 05 2014 05 06
2013 07 08 2014 04 13
;
proc print;
run;

/*日期的提取*/
data dt;
input dt:ymddttm30.;
date=datepart(dt);/*提取日期部分*/
time=timepart(dt);/*提取时间部分*/
month=month(date);/*提取月份*/
hour=hour(time);/*提取小时*/
format dt datetime30. date yymmdd10. time time12.;
cards;
2009/6/26:11:20:00
2009/5/5:19:30:00
2009/9/12:13:20:00
;
proc print;
run;

/*与变量类型转换有关的函数*/
/*1.input函数:字符型转数值型*/
/*input(变量，输入格式)*/
data date;
input year1$ month1$ day1$ year2$ month2$ day2$;
date1=catx("/",year1,month1,day1);
date2=catx("/",year2,month2,day2);
d1=input(date1,yymmdd10.);/*将date1转换为日期型*/
d2=input(date2,yymmdd10.);
dif=d2-d1;
cards;
2013 05 21 2014 03 11
2013 03 10 2014 01 22
2013 06 05 2014 05 06
2013 07 08 2014 04 13
;
proc print;
run;

data date;
input year1$ month1$ day1$ year2$ month2$ day2$;
date1=cats(year1,month1,day1);
date2=cats(year2,month2,day2);
d1=input(date1,yymmdd10.);
d2=input(date2,yymmdd10.);
d3=input(date1,8.);/*将date1转换成数值型*/
d4=input(date2,8.);
dif1=d1-d2;
dif2=d4-d3;
cards;
2013 05 21 2014 03 11
;
proc print;
run;

/*put函数：数值型转字符型*/
/*put(变量，输出格式)*/
proc format;
invalue fage low-<40=30 40-<50=40 
                  50-<60=50 60-high=60;
data age;
do id=1 to 5;
input age fage.;
output;
end;
cards;
36
43
51
60
59
;
proc print;
run;

proc format;
value fage low-<40=30 40-<50=40 50-<60=50 60-high=60;
data age;
do id=1 to 5;
input age@@;
ageg=put(age,fage.);/*将age格式转换成fage这个格式*/ 
output;
end;
cards;
36 43 51 60 59 
;
proc print;
run;
 
data telephone;
p=cdf("poisson",1,5);/*计算均值为5的poisson分布中，出现次数<=1的概率*/
                     /*前提是计数资料*/
proc print;
run;

data telephone;
p=cdf("normal",30,60,10);/*均数为60，标准差为10的正态分布中，<=30的 概率*/
proc print;
run;

/*lag和dif函数*/
data  dm;
do year=2008 to 2013;
input profit;
plag=lag(profit);/*返回变量profit的前一个记录*/
pdif=dif(profit);/*返回变量profit当前记录与前一个记录的比值*/
pratio=profit/plag;
output;
end;
cards;
989
1002
1023
1022
1065
1112
;
proc print;
run;

###第三章
/*数据的清洗和加工：数据合并，比较，缺失值的查询和填补，
查找重复值和异常值，生成数据子集，产生新变量*/

/*set函数进行纵向合并*/
data ab1;
set sasuser.a1 sasuser.b1;/*纵向合并a1&b1*/
proc print;
run;

data ab1;
set sasuser.a1 sasuser.b1(rename=(ht=height wt=weight)); 
                          /*将数据集b1中的变量ht、wt重新命名*/ 
proc print;
run; 

 data ab2;
 set sasuser.a2(in=a) sasuser.b2(in=b);
 proc print;
 run; 

 /*merge语句进行横向合并*/
data ab;
merge ab1 ab2;/*横向合并数据集ab1和ab2*/
by id;
drop a2 b2;
proc print;
run;

data sasuser.xb;
set ab;
if id=4 then time="16jun2012"d;
proc print;
run;

/*数据比较*/
proc compare base=ab compare=cd nosummary transpose;
by id;
id id;
run;

/*查找和删除重复值*/
/*两个数据集先进行排序*/
proc sort data=ab1;
by id;
proc sort data=ab2;
by id;
run;
/*然后进行横向合并合并*/
data ab;
merge ab1 ab2;
by id;
proc print;
run;
/*查找重复值*/
proc sort data=ab nouniquekey out=rep;
by name gender;/*输出重复值，指定age和gender都一样算重复*/
proc print data=rep;
run;

proc sort data=ab nodupkey out=norep;
by name gender;/*删除重复值，指定age和gender都一样算重复*/
proc print data=norep;
run;

/*first.变量和last.变量*/
data patients;
input id gender age time yymmdd10. sbp;
cards;
1 1 51 2010/01/12 150
1 1 51 2010/02/12 147
1 1 51 2010/01/14 142
2 2 59 2010/01/09 163
2 2 59 2010/02/10 162
2 2 59 2010/03/17 160
2 2 59 2010/04/16 151
;
proc sort;
by id time;/*通过id和time升序排序*/
data patients;
set patients;
by id;
retain firstsbp;
if first.id then firstsbp=sbp;
difsbp=sbp-firstsbp;
if not first.id;
proc print;
run;

/*查找缺失值  数组*/
data missing;
set sasuser.xb;
array cha(1) name;
if missing(cha(1)) then output;
array num(10) gender age height weight time y1-y5;
/*建立数组num(10),num(1)-num(10)分别代表10个变量*/
do i=1 to 10;
if missing(num(i)) then output;
end;
proc print;
run;
proc sort data=missing out=missing nodupkey;
by id;
proc print ;
run;


/*查找缺失值的万能程序*/
data missing1;
set sasuser.xb;
array cha(*) _character_;
/*数组cha(*)*号让sas自己判断数据集里有多少字符型变量*/
do i=1 to dim(cha);
/*dim函数指定循环次数为数组cha里面的元素geshu*/
if missing(cha(i)) then output;
end;
array num(*) _numeric_;
/*数组num(*)*号让sas自己判断数据集里有多少数值型变量*/
do i=1 to dim(num);
if missing(num(i)) then output;
end;
proc sort data=missing1 nodupkey;
by id;
proc print;
run;


/*查找异常值*/
data outliney1;
set sasuser.xb;
if (y5 not in(1,2,3,4,5,.));
proc print;
run;

data outliney2;
set sasuser.xb;
where (y5 not in(1,2,3,4,5,.));
proc print;
run;

/*只能用if,不能用where的场合*/
/*自动变量*/
data outliney3;
set sasuser.xb;
if _n_=7;
proc print;
run;
/*条件变量是产生的新变量*/
data outliney4;
set sasuser.xb;
if age<30 then aage=1;
          else aage=2;
if aage=1;
proc print;
run;

data height;;
set sasuser.Xb;
where (height not between 150 and 200) and (height is not missing);
proc print;
run;

data outliney5;
set sasuser.xb;
proc print;
where y5 not in(1,2,3,4,5,.);
run;

/*查找异常值的万能程序*/
%let data=sasuser.xb;/*此处为自己的数据集*/ 
%let id=id;/*此处为数据集中表示id号的变量*/
%macro outline(var=,low=,high=);
data outline;
set &data.(keep=&id. &var.);
length variable $20. reason $20.;
variable="&var.";
value=&var.;
if &var.<&low. and not missing(&var.) then do;
reason="过低";
output;
end;
else if &var.>&high. and not missing(&var.) then do;
reason="过高";
output;
end;
drop &var.;
proc append base=outliner1 data=outline;
run;
%mend outline;
%outline(var=height,low=150,high=200);/*此处添加需要查找的变量及其正常范围*/
%outline(var=weight,low=40,high=100);
%outline(var=y1,low=1,high=5);
%outline(var=y2,low=1,high=5);
%outline(var=y3,low=1,high=5);
%outline(var=y4,low=1,high=5);
%outline(var=y5,low=1,high=5);
proc print data=outliner1;
run;



/*填补缺失值*/
/*第一步产生填补结果数据集*/
data xb9;
set sasuser.xb;
if id=9 then delete;/*删除id=9这条观测*/
run;
proc mi data=xb9 out=nomissing round=1 1 1/*3个变量填补保留整数*/
                 minimum=150 1 1/*3个变量分别指定最小值*/
                maximum=200 5 5;/*3个变量分别指定最大值*/
mcmc;/*利用蒙特卡罗默认产生5次填补结果*/
var height y2 y4;/*填补缺失值的变量*/
run;
proc print data=nomissing;
run;
/*第二步；将填补结果数据集更新到需填补的数据集*/
proc univariate data=nomissing noprint;
class id;
var height y2 y4;
output out=nm mean=height y2 y4;
proc print data=nm;
run;/*这5行产生height,y2,y4的5次填补的均值，输出到数据集nm*/
data newxb;
update xb9 nm;/*利用update语句将数据集nm的均值更新到数据集xb9里面*/
by id;
height=round(height,1);/*利用round函数将3个变量保留为整数*/
y2=round(y2,1);
y4=round(y4,1);
proc print data=newxb;
run;

###5第五章sas与表格展示
libname sas4 "f:/03软件学习/sasproc/04第四章数据集";
proc format;
value bdfmt 0="偏瘦" 1="正常" 2="偏胖" 3="肥胖" 4="重度肥胖";
run;
data bmi;
set sas4.fbg;
bmi=weight/(height/100)**2;
if bmi<18.5 then bd=0;
else if bmi<24 then bd=1;
else if bmi<27 then bd=2;
else if bmi<30 then bd=3;
else bd=4;
format bd bdfmt.;
proc print data=bmi;
run; 

/*表格制作*/
proc tabulate data=bmi;
class gender age bd;/*分类变量*/
table gender*age,bd*(n rowpctn)/nocellmerge;
/*交叉：* 列联表：，并列：空格*//*nocellmerge取消单元格合并*/
label gender="性别" age="年龄" bd="体型";/*为变量添加标签*/
keylabel n="例数" rowpctn="百分比";/*为关键词加标签*/
run;
/*不显示变量名*/
proc tabulate data=bmi;
class gender age bd;
table gender=""*age="",bd*(n rowpctn)/box="性别 年龄";
/*gender=""和age=""不显示变量名 box=""左上角显示为*/
keylabel n="例数" rowpctn="百分比";
run;
/*修改缺失值的显示方式*/
proc tabulate data=bmi;
class gender age bd;
table gender=""*age="",bd*(n rowpctn)/
box="性别 年龄" misstext="ND";/*将缺失值显示为ND*/
keylabel n="例数" rowpctn="百分比";
run;
/*增加合计项*/
proc tabulate data=bmi;
class gender age bd;
table (gender="" all)*age="",(bd all)*(n rowpctn)
/box="性别 年龄" misstext="ND";/*all增加合计项*/
label bd="体型" all="全部";
keylabel n="例数" rowpctn="百分比";
run;
/*修改表中数据的显示形式*/
proc format;
picture pct low-high="000.00%";/*定义pct格式为带%，两位小数点*/
proc tabulate data=bmi;
class gender age bd;
table (gender="" all)*age="",(bd all)*(n*f=5.1 rowpctn*f=pct.)/
box="性别 年龄";/* *f="输出格式"*/
label bd="体型";
keylabel n="例数" rowpctn="百分比";
run;

/*生成定量资料的描述表*/
proc tabulate data=bmi;
class gender bd;
var fbg;
table (gender="" all)*bd="",fbg*(n mean median std qrange)
        /printmiss misstext="NA"; /*增加fbg的5个统计量,显示缺失的类别*/ 
label fbg="血糖";
keylabel n="例数" mean="均数" median="中位数" 
         std="标准差" qrange="四分位数间距";
run;

/*制作描述多变量的统计表*/
proc tabulate data=bmi;
class age bd gender;/*分类变量*/
var height weight bmi fbg;/*分析变量*/
table (height weight bmi fbg)*(n mean std) (age bd)*(n colpctn),gender/
                             nocellmerge misstext="--";
label height="身高" weight="体重" bmi="BMI" fbg="血糖" 
      age="年龄" bd="体型" gender="性别";/*设置变量标签*/
keylabel n="例数" mean="均数" std="标准差" colpctn="百分比(%)";
         /*设置关键词选项标签*/
run;

/*制作三线表*/
proc tabulate data=bmi formchar=" ----------" noseps;
class bd gender;
var fbg;
table fbg*(n mean std) bd*(n colpctn),gender/misstext="--";
label bd="体型" gender="性别" fbg="血糖";
keylabel n="例数" mean="均数" std="标准差" colpctn="百分比";
run;

proc tabulate data=bmi formchar=" ---------" noseps;
class bd gender;
var fbg;
table fbg*(n mean std) bd*(n colpctn),gender/misstext="--" 
              incent=3 rts=12; 
label fbg="血糖" bd="体型" gender="性别";
keylabel n="例数" mean="均数" std="标准差" colpctn="百分比";
run;
 
/*proc report用法*/
proc report data=bmi nowd/*结果只显示在输出窗口*/
                 headline;/*在表头下加根线*/
column gender age fbg bmi;/*指定结果显示的四个变量*/
define gender/width=10;/*指定gender列宽度为10*/
define age/width=10;/*指定age列宽度为10*/
define fbg/format=6.1;/*指定fbg输出格式为6.1*/
define bmi/format=6.2;/*指定bmi输出格式为6.2*/
where bmi>=27;
run;

/*分性别，年龄显示*/
proc report data=bmi nowd headline;
column gender age fbg bmi;
define gender/width=10 order;/*分性别显示*/
define age/width=10 order;/*分年龄显示*/
define fbg/format=6.1;
define bmi/format=6.2;
where bmi>=27;
run;
/*设置行背景颜色*/
proc report data=bmi nowd headline;
column gender age fbg bmi;
define gender/width=10 order;
define age/width=10 order;
define fbg/format=6.1 display;
define bmi/format=6.2 display;
compute fbg;
if fbg>=10 then
call define(_row_,"style", "style=[backgroundcolor=green color=yellow]");
             /*起作用的范围是整行，背景颜色是绿色，字体颜色为黄色*/
endcomp;
where bmi>=27;
run;

proc report data=bmi nowd headline;
column gender age fbg bmi;
define gender/width=10 order;
define age/width=10 order;
define fbg/format=6.1 display;
define bmi/format=6.2 display;
compute fbg;
if fbg>=10 then
call define(_col_,"style", "style=[backgroundcolor=green color=yellow]");
             /*起作用的范围是整列，背景颜色是绿色，字体颜色为黄色*/
endcomp;
where bmi>=27;
run;


/*proc repot产生新字符变量*/
proc report data=bmi nowd headline;
column gender age fbg bmi diagnosis;/*指定输出显示5个变量*/
define gender/width=10 order;
define age/width=10 order;
define fbg/format=6.1 display;
define bmi/format=6.2 display;
define diagnosis/computed;
where bmi>=27;
compute diagnosis/char length=16;
if fbg>=9 then diagnosis="高度怀疑糖尿病";
else diagnosis="";/*利用if语句生成diagnosis的值*/
endcomp;
run;

/*compute结合line生成描述性文字*/
proc sort data=bmi;
by gender;
run;
proc report data=bmi nowd headline;
column gender age fbg bmi bmi=bmin;
define gender/width=10 order;
define age/width=10 order;
define fbg/format=6.1 display;
define bmi/format=6.2 display;
define bmin/ noprint n;/*指定bmin为例数，并不让他显示*/
where bmi>=27;
by gender;/*按gender分别男和女两个表*/
compute after;/*再表格下方添加一行文字说明，显示“bmi>=27的例数”*/
line "bmi>=27的例数为" bmin;/*后面的bmin是bmi的统计量n*/
endcomp;
run;
