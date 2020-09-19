*This code does optimal generation scheduling in a microgrid with AC load flow.  For considering PV generation, use renewcap2  and WD2(t,w)
set t time periods /t1*t24/
Set i buses /i1*i33/
set slack(i) /i1/
set gb(i) dispatchable generators /i2,i11,i15,i27/
set grid(i)   /i1/
Alias (i,j);
scalars sbase, vbase nominal S and V in kw and Kv
voll;
sbase=1000; vbase=12.66; voll=100;
scalar zbase;
zbase=160.2756;


Parameter windcap(i) /i12 500, i17 350/;
Parameter pvcap(i) /i18 400, i24 500/;
Parameter storage(i) /i5 100, i6 220/;
parameter qextcap(i) /i32 500/;
parameter qextprice(i)/i32  0.046/;
parameter pgridmax 'in pu'   ;
parameter bsscap(i) /i33 15000/;
parameter Ebssini(i)/i3 0/;
pgridmax=2;

$ontext
Table GenData(i,*) 'generating units characteristics'
       pmin       pmax   qmin   qmax     a      b      c      RU      RD    vg
i2     800        3000   -500   1200     0     0.154   0     1500    1500   1.00
i11    800        2000   -500   1200     0     0.157   0     1500    1500   1.02
i15    500        2500   -200   700      0     0.218   0     1000    1000   1.04
i27    500        2500   -200   700      0     0.194   0     1000    1000   1.00;

$offtext


Table GenData(i,*) 'generating units characteristics'
       pmin       pmax   qmin   qmax     a      b      c     RU     RD     d
i2     300        2500   0000   1000     0     0.154   0     500    500  0.040
i11    300        1000   0000   1000     0     0.157   0     400    400  0.044
i15    200        1000   0000   500      0     0.218   0     300    300  0.051
i27    200        1000   0000   300      0     0.194   0     300    300  0.048;


*gendata(i, 'd')=0;
* ----------------------------------------------

Table timechanges(t,*)  'time changes of wind and demand'
        wind                d         price     pv
*  t1   0                   1         0         0
   t1   0.0786666666666667  0.8      0.230      0
   t2   0.0866666666666667  0.805    0.190      0
   t3   0.117333333333333   0.810    0.140      0
   t4   0.258666666666667   0.818    0.120      0
   t5   0.361333333333333   0.830    0.120      0.02
   t6   0.566666666666667   0.910    0.130      0.1080
   t7   0.650666666666667   0.950    0.130      0.2790
   t8   0.566666666666667   0.970    0.140      0.5190
   t9   0.484               1.0      0.170      0.7424
   t10  0.548               0.98     0.220      0.9184
   t11  0.757333333333333   1.0      0.220      0.9755
   t12  0.710666666666667   0.97     0.220      0.9678
   t13  0.870666666666667   0.95     0.210      1.0000
   t14  0.932               0.90     0.220      0.9040
   t15  0.966666666666667   0.905    0.190      0.8105
   t16  1                   0.91     0.180      0.6980
   t17  0.869333333333333   0.93     0.170      0.4675
   t18  0.665333333333333   0.90     0.230      0.2520
   t19  0.656               0.94     0.210      0.0940
   t20  0.561333333333333   0.97     0.220      0.0200
   t21  0.565333333333333   1.0      0.180      0.0010
   t22  0.556               0.93     0.170      0
   t23  0.724               0.90     0.130      0
   t24  0.84                0.94     0.120      0;


Table BD(i,*) 'demands of each bus in kW'
        Pd   Qd
   i1   0    0
   i2   100  60
   i3   90   40
   i4   120  80
   i5   60   30
   i6   60   20
   i7   200  100
   i8   200  100
   i9   60   20
   i10  60   20
   i11  45   30
   i12  60   35
   i13  60   35
   i14  120  80
   i15  60   10
   i16  60   20
   i17  90   20
   i18  90   40
   i19  90   40
   i20  90   40
   i21  90   40
   i22  90   40
   i23  90   50
   i24  420  200
   i25  420  200
   i26  60   25
   i27  60   25
   i28  60   20
   i29  120  70
   i30  200  600
   i31  150  70
   i32  210  100
   i33  60   40 ;



table branchdata(i,j,*)

               r             x           b      plim       stat
i1.i2         0.0922        0.0477       0      5000        1
i2.i3         0.4930        0.2511       0      5000        1
i3.i4         0.3660        0.1864       0      5000        1
i4.i5         0.3811        0.1941       0      5000        1
i5.i6         0.8190        0.7070       0      5000        1
i6.i7         0.1872        0.6188       0      5000        1
i7.i8         1.7114        1.2351       0      5000        1
i8.i9         1.0300        0.7400       0      5000        1
i9.i10        1.0400        0.7400       0      5000        1
i10.i11       0.1966        0.0650       0      5000        1
i11.i12       0.3744        0.1238       0      5000        1
i12.i13       1.4680        1.1550       0      5000        1
i13.i14       0.5416        0.7129       0      5000        1
i14.i15       0.5910        0.5260       0      5000        1
i15.i16       0.7463        0.5450       0      5000        1
i16.i17       1.2890        1.7210       0      5000        1
i17.i18       0.7320        0.5740       0      5000        1
i2.i19        0.1640        0.1565       0      5000        1
i19.i20       1.5042        1.3554       0      5000        1
i20.i21       0.4095        0.4784       0      5000        1
i21.i22       0.7089        0.9373       0      5000        1
i3.i23        0.4512        0.3083       0      5000        1
i23.i24       0.8980        0.7091       0      5000        1
i24.i25       0.8960        0.7011       0      5000        1
i6.i26        0.2030        0.1034       0      5000        1
i26.i27       0.2842        0.1447       0      5000        1
i27.i28       1.0590        0.9337       0      5000        1
i28.i29       0.8042        0.7006       0      5000        1
i29.i30       0.5075        0.2585       0      5000        1
i30.i31       0.9744        0.9630       0      5000        1
i31.i32       0.3105        0.3619       0      5000        1
i32.i33       0.3410        0.5302       0      5000        1;
$ONtext
i21.i8        2.0000        2.0000       0      3000        1
i9.i15        2.0000        2.0000       0      3000        1
i12.i22       2.0000        2.0000       0      3000        1
i18.i33       0.5000        0.5000       0      3000        1
i25.i29       0.5000        0.5000       0      3000        1;
$offtext




* conversion of branch parameters into pu

branchdata(i,j,'r')=branchdata(i,j,'r')/zbase;
branchdata(i,j,'x')=branchdata(i,j,'x')/zbase;
branchdata(i,j,'b')=branchdata(i,j,'b')/zbase;

branchdata(i,j,"r")$(branchdata(i,j,"r")=0)=branchdata(j,i,"r");
branchdata(i,j,"x")$(branchdata(i,j,"x")=0)=branchdata(j,i,"x");
branchdata(i,j,"b")$(branchdata(i,j,"b")=0)=branchdata(j,i,"b");
branchdata(i,j,"plim")$(branchdata(i,j,"plim")=0)=branchdata(j,i,"plim");
branchdata(i,j,"stat")$(branchdata(i,j,"stat")=0)=branchdata(j,i,"stat");

branchdata(i,j,"z")$(branchdata(i,j,"plim"))=sqrt(power(branchdata(i,j,"r"),2)+power(branchdata(i,j,"x"),2));
branchdata(i,j,"z")$(branchdata(i,j,"z")=0)= branchdata(j,i,"z");
branchdata(i,j,"zangle")$(branchdata(i,j,"plim") and branchdata(i,j,"r") and branchdata(i,j,"x"))=arctan(branchdata(i,j,"x")/branchdata(i,j,"r"));


branchdata(i,j, "zangle")$(branchdata(i,j,"plim") and branchdata(i,j, "x") and branchdata(i,j, "r")=0)=pi/2;
branchdata(i,j, "zangle")$(branchdata(i,j,"plim") and branchdata(i,j, "r") and branchdata(i,j, "x")=0)=0;

branchdata(i,j,"zangle")$(branchdata(i,j,"zangle")=0)= branchdata(j,i,"zangle");


parameter connex(i,j)   connectivity matrix of the system;
connex(i,j) $ (branchdata(i,j,"plim") and branchdata(j,i,"plim"))=1;

variables realpowercost,Ebss(i,t),bsspower(i,t),vabs(i,t),vangle(i,t),pg(i,t),qg(i,t),pij(i,j,t),qij(i,j,t),operationcost,pwind(i,t),ppv(i,t),pshed(i,t),pgrid(t),qext(i,t);


Equations eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8,eq9,eq10,eq11;
eq1(i,j,t)$connex(i,j).. Pij(i,j,t)=e=((vabs(i,t)*vabs(i,t)*cos(branchdata(j,i,"zangle")))-(vabs(i,t)*vabs(j,t)*cos(Vangle(i,t)-Vangle(j,t)+branchdata(j,i,"zangle"))))/branchdata(j,i,"z");
eq2(i,j,t)$connex(i,j).. Qij(i,j,t)=e=(((vabs(i,t)*vabs(i,t)*sin(branchdata(j,i,"zangle")))-(vabs(i,t)*vabs(j,t)*sin(Vangle(i,t)-Vangle(j,t)+branchdata(j,i,"zangle"))))/branchdata(j,i,"z"))-(0.5*branchdata(i,j,"b")*vabs(i,t)*vabs(i,t));
eq3(i,t)..  -bsspower(i,t)$bsscap(i)+pgrid(t)$grid(i)+ppv(i,t)$pvcap(i)+pwind(i,t)$windcap(i)+pg(i,t)$GenData(i,'Pmax')-(timechanges(t,'d')*BD(i,'pd')/sbase)+pshed(i,t)=e=sum(j$connex(i,j), pij(i,j,t));
eq4(i,t)..  qext(i,t)$qextcap(i)+Qg(i,t)$GenData(i,'Pmax')-(timechanges(t,'d')*BD(i,'qd')/sbase)=e=sum(j$connex(i,j), qij(i,j,t));
eq5..operationcost=e=sum((i,t),Pg(i,t)*GenData(i,'b')*Sbase$GenData(i,'Pmax'))+voll*sum((i,t),Sbase*pshed(i,t))+sum(t,pgrid(t)*sbase*timechanges(t,'price'))+sum((i,t),qg(i,t)*GenData(i,'d')*Sbase$GenData(i,'Pmax'))+sum((i,t), qext(i,t)*Sbase*qextprice(i)$qextcap(i));

eq6(i,t)$(GenData(i,'Pmax') and ord(t)>1)..Pg(i,t)-Pg(i,t-1)=l=GenData(i,'RU')/Sbase;

eq7(i,t)$(GenData(i,'Pmax') and ord(t)<card(t))..Pg(i,t)-Pg(i,t+1)=l=GenData(i,'RD')/Sbase;
eq8(i)$bsscap(i).. sum(t, bsspower(i,t))=e=bsscap(i)/sbase;
eq9(i,t)$bsscap(i) ..  Ebss(i,t)=e=Ebss(i,t-1)$(ord(t)>1)+Ebssini(i) $(ord(t)=1)+(sbase*bsspower(i,t));
eq10(i,t)$bsscap(i).. Ebss(i,t)=g=0;
eq11..realpowercost=e=sum((i,t),Pg(i,t)*GenData(i,'b')*Sbase$GenData(i,'Pmax'))+sum(t,pgrid(t)*sbase*timechanges(t,'price'));

Model powerflow /eq1, eq2,eq3,eq4, eq5, eq6, eq7,eq8,eq9,eq10,eq11/;

pg.lo(i,t)=gendata(i,"pmin")/sbase; pg.up(i,t)=gendata(i,"pmax")/sbase; qg.lo(i,t)=gendata(i,"qmin")/sbase;qg.up(i,t)=gendata(i,"qmax")/sbase;
pshed.lo(i,t)=0;  pshed.up(i,t)=timechanges(t,'d')*BD(i,'pd')/sbase;
*qshed.lo(i,t)=0;  qshed.up(i,t)=timechanges(t,'d')*BD(i,'qd')/sbase;
vangle.up(i,t)=pi/2; vangle.lo(i,t)=-pi/2; vangle.l(i,t)=0; vangle.fx(slack,t)=0;
vabs.up(i,t)=19.1; vabs.lo(i,t)=0.9; vabs.l(i,t)=1;
pwind.lo(i,t)=0; pwind.up(i,t)=windcap(i)*timechanges(t,'wind')/sbase;  ppv.lo(i,t)=0; ppv.up(i,t)=pvcap(i)*timechanges(t,'pv')/sbase;
pgrid.lo(t)=-pgridmax;  pgrid.up(t)=pgridmax; qext.up(i,t)=qextcap(i)/sbase; qext.lo(i,t)=0;

pij.lo(i,j,t)$connex(i,j)=-branchdata(i,j,"plim")/sbase;   pij.up(i,j,t)$connex(i,j)=branchdata(i,j,"plim")/sbase;
qij.lo(i,j,t)$connex(i,j)=-branchdata(i,j,"plim")/sbase;   qij.up(i,j,t)$connex(i,j)=branchdata(i,j,"plim")/sbase;
bsspower.lo(i,t)=-2;  bsspower.up(i,t)=2;

*pgrid.fx(t)=0;
*bsspower.fx(i,t)=0;
*qext.fx(i,t)=0;
*qshed.fx(i,t)=0;
*pgrid.fx(t)=0;
*option nlp=knitro;

*option nlp=conopt;


Solve powerflow using nlp minimising operationcost


$ontext

Parameter report(t,i,*), report2(i,t), report3(i,t), lmp(i,t),report4(t,*),report5(i,t),report6(i,t),report7(i,t);


report(t,i,'voltage')=Vabs.l(i,t);
report(t,i,'Voltageangle')= Vangle.l(i,t);
report(t,i,'Pg')= Pg.l(i,t)*Sbase;
report(t,i,'Gg')= Qg.l(i,t)*Sbase;
report(t,i,'Pgmarginal')= Pg.m(i,t)*Sbase;
report(t,i,'Ggmarginal')= Qg.m(i,t)*Sbase;
report(t,i,'bsspower')=bsspower.l(i,t);
report(t,i,'pwind')=pwind.l(i,t);
report(t,i,'ppv')=ppv.l(i,t);
report(t,i,'pshed')=pshed.l(i,t);
*report(t,'pgrid')=pgrid.l(t);
report(t,i,'qext')=qext.l(i,t);
report(t,i,'Ebss')=Ebss.l(i,t);

report(t,i,'LMP_P')=eq3.m(i,t)/Sbase;
report(t,i,'LMP_Q')=eq4.m(i,t)/Sbase;
report2(i,t)= Pg.l(i,t);
report3(i,t)= Qg.l(i,t);
report4(t,'pgrid')=pgrid.l(t);

report5(i,t)=eq3.m(i,t)/Sbase;
report6(i,t)=eq4.m(i,t)/Sbase;
report7(i,t)=Vabs.l(i,t);

display report;

$ifI %system.fileSys%==Unix $exit
$call MSAppAvail Excel
$ifThen not errorLevel 1
   execute_unload "results.gdx" report
   execute 'gdxxrw.exe results.gdx Par=report rng=classic!'
   execute_unload "results.gdx" report2
   execute 'gdxxrw.exe results.gdx Par=report2 rng=classic2!'
   execute_unload "results.gdx" report3
   execute 'gdxxrw.exe results.gdx Par=report3 rng=classic3!'

execute_unload "results.gdx" report4
   execute 'gdxxrw.exe results.gdx Par=report4 rng=classic4!'


execute_unload "results.gdx" report5
   execute 'gdxxrw.exe results.gdx Par=report5 rng=classic5!'
   execute_unload "results.gdx" report6
   execute 'gdxxrw.exe results.gdx Par=report6 rng=classic6!'


 execute_unload "results.gdx" report7
   execute 'gdxxrw.exe results.gdx Par=report7 rng=classic7!'



$endIf



$offtext
