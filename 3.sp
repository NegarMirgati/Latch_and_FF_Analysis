* 3- Flip Flop - CA4 *
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
Vclk	clk	 0	pulse	0	1	0n	50p		50p		10n	30n
Vdata   data 0  pulse	0	1	0n	50p		50p		50n	100n

**************************** NAND2 GATE ****************************

.SUBCKT MyNand inA inB GND NODE AOUT
Mp11     AOUT     inB     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp12     AOUT     inA     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'

Mn13     AOUT     inA     mid     GND     nmos    l ='Lmin'    w ='2*Lmin'
Mn14     mid      inB     GND     GND     nmos    l ='Lmin'    w ='2*Lmin'
CL      AOUT  0  5f 
.ENDS MyNand

**************************** NAND3 GATE ****************************

.SUBCKT MyNand3 inA inB  inC GND NODE AOUT
Mp21     AOUT     inA     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp22     AOUT     inB     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp23     AOUT     inC     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'

Mn24     AOUT     inA     mid     GND     nmos    l ='Lmin'    w ='2*Lmin'
Mn25     mid      inB     mid2    GND     nmos    l ='Lmin'    w ='2*Lmin'
Mn26     mid2     inC     GND     GND     nmos    l ='Lmin'    w ='2*Lmin'
CL      AOUT 0  5f 
.ENDS MyNand3

***************************************************************************
Xnand1    nand4out    nand2out    0    1    nand1out    MyNand
Xnand2    nand1out    clk        0    1    nand2out     MyNand
Xnand3    nand2out    clk        nand4out   0          1    nand3out    MyNand3
Xnand4    nand3out    data       0    1    nand4out     MyNand
Xnand5    nand2out    Qbar       0    1    Q            MyNand
Xnand6    Q          nand3out    0    1    Qbar         MyNand

***** Type of Analysis *****
.tran	3ns     200ns   1ns

.MEASURE TRAN t_rise
+ trig V(Q) val = '0.1'  rise = 1
+ targ V(Q) val = '0.9'  rise = 1

.MEASURE TRAN t_fall
+ trig V(Q) val = '0.9'  fall = 2
+ targ V(Q) val = '0.1'  fall = 2

.MEASURE highest_freq param = '1 /(t_rise + t_fall)'


.END
