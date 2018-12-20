* SRLatch - CMOS Logic *
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
Vs      s    0	pulse	0	1	0n	0p		0p		50n	100n  
Vr      r    0	DC      0
Vclk	clk	 0	pulse	0	1	0n	0p		0p		2n	4n

**************************** NAND GATE ****************************

.SUBCKT MyNand inA inB GND NODE AOUT
Mp21     AOUT     inB     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp22     AOUT     inA     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mn23     AOUT     inA     mid     mid     nmos    l ='Lmin'    w ='2*Lmin'
Mn24     mid      inB     GND     GND     nmos    l ='Lmin'    w ='2*Lmin'
.ENDS MyNand

************************ INVERTER ************************************
.SUBCKT MyInverter in	GND 	NODE	OUT

Mp31	OUT	    IN	    NODE    NODE    pmos 	    l='Lmin'  w='4*Lmin'	
Mn32	OUT     IN      GND     GND     nmos        l='Lmin'  w='2*Lmin'

CL    OUT 0  5f 
.ENDS MyInverter

**********************AND GATE ************************************
.SUBCKT    MyAnd     GND    VDD     A       B         andout
X1And        A       B      GND    VDD     nandout     MyNand
X2Inv        nandout  GND   VDD    andout             MyInverter
CL    andout   0    10f 
.ENDS MyAnd

**************************** NOR Gate ****************************** 
.SUBCKT    MyNor     GND    VDD     A       B       out

Mp11   mid    A    VDD    VDD    pmos    w='12*Lmin'    L=Lmin
Mp12   out    B    mid    mid    pmos    w='12*Lmin'    L=Lmin 
Mn13   out    B    GND    GND    nmos    w='2*Lmin'     L=Lmin
Mn14   out    A    GND    GND    nmos    w='2*Lmin'     L=Lmin 
CL out 0  10f 

.ENDS MyNor
*************************** SRLatch *********************************

X1    0    1    s   clk  out1    MyAnd
X2    0    1    clk   r  out2    MyAnd
X3    0    1    out1    Q      Qbar    MyNor
X4    0    1    out2    Qbar    Q      MyNor


***** Type of Analysis *****
.tran	3ns     500ns   1ns


.END
