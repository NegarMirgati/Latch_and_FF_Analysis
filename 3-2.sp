* 3- CA4 *
************ Library *************
.prot
.inc '32nm_bulk.pm'
.unprot

********* Params*******
.param			Lmin=32n
+Vdd = 1V

.global	Vdd
****** Sources ******
Vdd	    1	0  	1
Vb      b   0   dc  0
VbBar   bBar 0  dc  1
Vclk	clk	 0	pulse	0	1	0n  50p		50p		2n	4n
Vdata   data 0  pulse	0	1	2n	50p		50p		1n	2n

************************ INVERTER ************************************
.SUBCKT MyInverter in	GND 	NODE	OUT

Mp31	OUT	    IN	    NODE    NODE    pmos 	    l='Lmin'  w='4*Lmin'	
Mn32	OUT     IN      GND     GND     nmos        l='Lmin'  w='2*Lmin'
CL      OUT 0  10f 
.ENDS MyInverter

**************************** NAND2 GATE ****************************

.SUBCKT MyNand inA inB GND NODE AOUT
Mp11     AOUT     inB     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp12     AOUT     inA     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mn13     AOUT     inA     mid     mid     nmos    l ='Lmin'    w ='2*Lmin'
Mn14     mid      inB     GND     GND     nmos    l ='Lmin'    w ='2*Lmin'
CL      AOUT  0  5f 
.ENDS MyNand

**************************** NAND3 GATE ****************************

.SUBCKT MyNand3 inA inB  inC GND NODE AOUT
Mp21     AOUT     inA     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp22     AOUT     inB     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp23     AOUT     inC     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'

Mn24     AOUT     inA     mid     mid     nmos    l ='Lmin'    w ='2*Lmin'
Mn25     mid      inB     mid2    mid2    nmos    l ='Lmin'    w ='2*Lmin'
Mn26     mid2     inC     GND     GND     nmos    l ='Lmin'    w ='2*Lmin'
CL      AOUT 0  5f 
.ENDS MyNand3

************************ Combinational Circuit ***********************

.SUBCKT MyCombinational inA inABar inB inBBar GND NODE AOUT
Mp11     mid1     inA     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp12     mid1     inB     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp13     AOUT     inBBar  mid1    mid1    pmos    l ='Lmin'    w ='2*Lmin'
Mp14     AOUT     inABar  mid1    mid1    pmos    l ='Lmin'    w ='2*Lmin'

Mn15    AOUT     inA      mid2    mid2    nmos    l ='Lmin'    w ='2*Lmin'
Mn16    AOUT     inABar   mid3    mid3    nmos    l ='Lmin'    w ='2*Lmin'
Mn17    mid2     inB      GND     GND     nmos    l ='Lmin'    w ='2*Lmin'
Mn18    mid3     inBBar   GND     GND     nmos    l ='Lmin'    w ='2*Lmin'
.ENDS MyCombinational

*****************************Flip Flop***********************************
.SUBCKT MyFF data clk GND VDD Q Qbar
Xnand1    nand4out    nand2out   GND    VDD    nand1out    MyNand
Xnand2    nand1out    clk        GND    VDD    nand2out     MyNand
Xnand3    nand2out    clk        nand4out   GND          VDD    nand3out    MyNand3
Xnand4    nand3out    data       GND    VDD    nand4out     MyNand
Xnand5    nand2out    Qbar       GND    VDD    Q            MyNand
Xnand6    Q          nand3out    GND    VDD    Qbar         MyNand
.ENDS MyFF

***************************************************************************

XFF0    data    clk   0    1    a     Qbar   MyFF
Xinv0    a        0    1    aBar              MyInverter
XComb   a       aBar   b   bBar 0      1      f   MyCombinational
CL      f       0      10f

Xinv1    f               0    1    combOut1             MyInverter
Xinv2    combOut1        0    1    combOut2             MyInverter
Xinv3    combOut2        0    1    combOut3             MyInverter
Xinv4    combOut3        0    1    combOut              MyInverter

XFF1    combOut  clk  0    1    out    outbar          MyFF

***** Type of Analysis *****
.tran	3ns     200ns   1ns

.MEASURE TRAN t_rise
+ trig V(out) val = '0.1*Vdd'  rise = 2
+ targ V(out) val = '0.9*Vdd'  rise = 2

.MEASURE TRAN t_fall
+ trig V(out) val = '0.9*Vdd'  fall = 2
+ targ V(out) val = '0.1*Vdd'  fall = 2

.MEASURE TRAN max_frequency param = '1 / (t_fall + t_rise)'


.END

