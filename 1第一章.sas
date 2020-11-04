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
