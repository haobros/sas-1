libname a1 "f:\sasdata\a1";/*libname������߼����ｨ��һ����Ϊa1���ļ��У��������ŵ�����f:\sasdata\a1���·������*/
data first;/*����һ����Ϊfirst�����ݼ�������������work����ļ������ˣ��������work�ļ����µ����ݼ�����ʱ��*/
input gender age;/*��first������ݼ�������2������gender��age*/
cards;/*��ʼ��������*/
1 35
2 30
;/*���ĸ����ݴ���1��35��  2Ů30��*/

data a1.first;/*first������ݼ�ǰ�����a1.�Ļ�,first������ݼ��ʹ�ŵ����߼���a1����ļ������ˣ����������õ�*/
input gender age;
cards;
1 35
2 30
;

/*����һ�ֽ����������ݿ�ķ���*/
data "f:/sasdata/m1/second";/*���ַ���ͨ��data�����ɣ� data����"f:/sasdata/m1/second";�����ʾ��f:/sasdata/m1���·���н�����һ����Ϊsecond���������ݼ�*/
input gender age;
cards;
1 65
2 36
2 52
;
 /*�������ַ�������sas�߼�����������һ����ΪWc000001���ļ������޷��Լ�����

������˵һ˵�����ֽ����������ݼ��ķ������´�����sasʱ��ô�������ݼ�
��һ����libname���*/
libname a1 "f:/sasdata";/*����libname�����߼�������a1����ļ��к͵���f:/sasdata���·����������*/
proc print data=a1.first;/*���Ǹ����򲽣�print data=a1.first��ʾ�������ݣ������������ �߼���a1���������first����������ݼ�*/
run;

/*�ڶ�����data��佨�����������ݼ��ĵ��ó������£�ֱ�ӿ��Խ��г��򲽣�*/
proc print data="f:/sasdata/m1/second";
run;

/*�����������������������ⲿ����*/

PROC IMPORT OUT= WORK.test /*����test������ݼ���������work����߼����������ʱ�ļ�����Ȼwork�����߼�������������У�test���ܹ����ñ�����*/
            DATAFILE= "F:\sasdata\test.xlsx"/*�����˼��˵����¼���test������ݼ������ǵ��Ե�λ����*/ 
            DBMS=EXCELCS REPLACE;
     RANGE="Sheet1$"; 
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


libname a1 "f:\sasdata\a1";/*�½������߼���a1*/
proc print data=a1.first;
run;
