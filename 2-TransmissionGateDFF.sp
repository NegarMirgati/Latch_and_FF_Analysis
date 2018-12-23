* Transmission Gate - DFF *
************ Library *************
.prot
.inc '32nm_bulk.pm'
.unprot

********* Params*******
.param			Lmin=32n
+Vdd = 1V

.global	Vdd
.temp	25
****** Sources ******
Vdd	    1	0  	1
Vclk	clk	0	pulse	0	1	2n	50p		50p		2n	4n
VD      D   0   pulse	0	1	10n	50p		50p		50n	300u

************************ INVERTER ************************************
.SUBCKT MyInverter in	GND 	NODE	OUT

Mp31	OUT	    IN	    NODE    NODE    pmos 	    l='Lmin'  w='4*Lmin'	
Mn32	OUT     IN      GND     GND     nmos        l='Lmin'  w='2*Lmin'
CL      OUT     0  5f 
.ENDS MyInverter
**************************** TR DFF **************************************

* clkbar generator *
X00Inv   clk      0   1    clkbar  MyInverter   
*X01Inv   clkbar1  0   1    clkbar2  MyInverter  
*X10Inv   clkbar2  0   1    clkbar3  MyInverter 
*X11Inv   clkbar3  0   1    clkbar4  MyInverter   
*X000Inv  clkbar4  0   1    clkbar5  MyInverter  
*X001Inv  clkbar5  0   1    clkbar6  MyInverter    
*X010Inv  clkbar6  0   1    clkbar   MyInverter  

Mp11	OUT	    clk	    D       1       pmos 	    l='Lmin'  w='4*Lmin'	
Mn32	D     clkbar    OUT     0     nmos        l='Lmin'  w='2*Lmin'
CL1    OUT 0  5f 

X1Inv    OUT    0    1    inv1out     MyInverter

Mp21	OUT2	    clkbar	     inv1out    1            pmos 	    l='Lmin'  w='4*Lmin'	
Mn22	inv1out     clk          OUT2       0            nmos       l='Lmin'  w='2*Lmin'
CL2      OUT2    0    5f 

X2Inv   OUT2    0    1    Q     MyInverter


***** Type of Analysis *****
.tran	0.1ns     200ns 

.MEASURE TRAN t_clk_to_Q
+ trig V(clk) val = '0.5*Vdd'  fall = 3
+ targ V(Q) val = '0.5*Vdd'    rise = 1

.MEASURE TRAN t_rise
+ trig V(Q) val = '0.1*Vdd'  rise = 1
+ targ V(Q) val = '0.9*Vdd'  rise = 1

.MEASURE TRAN t_fall
+ trig V(Q) val = '0.9*Vdd'  fall = 1
+ targ V(Q) val = '0.1*Vdd'  fall = 1


.END