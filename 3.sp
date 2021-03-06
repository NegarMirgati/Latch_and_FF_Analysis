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
Vclk	clk	 0	pulse	0	1	1n	50p		50p		2n	4n
Vdata   data 0  pulse	0	1	0n	50p		50p		20n	300u

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
.tran	3ns     50ns 

.MEASURE TRAN t_rise
+ trig V(Q) val = '0.1'  rise = 1
+ targ V(Q) val = '0.9'  rise = 1

.MEASURE TRAN t_fall
+ trig V(Q) val = '0.9'  fall = 2
+ targ V(Q) val = '0.1'  fall = 2

.MEASURE TRAN t_clk_to_Q
+ trig V(clk) val = '0.5*Vdd'  rise = 6
+ targ V(Q) val = '0.5*Vdd'    fall = 1

.MEASURE TRAN t_setup
+ trig V(data) val = '0.5*Vdd'     fall = 1
+ targ V(nand1out) val = '0.5*Vdd' fall = 1


.END
