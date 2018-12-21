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
Vclk	clk	0	pulse	0	1	0n	50p		50p		1n	2n
VD      D   0   pulse	0	1	0n	50p		50p		50n	100n
************************ INVERTER ************************************
.SUBCKT MyInverter in	GND 	NODE	OUT

Mp31	OUT	    IN	    NODE    NODE    pmos 	    l='Lmin'  w='4*Lmin'	
Mn32	OUT     IN      GND     GND     nmos        l='Lmin'  w='2*Lmin'
CL      OUT 0  5f 
.ENDS MyInverter
**************************** TR DFF **************************************

* clkbar generator *
X00Inv   clk  0   1        clkbar1  MyInverter   
X01Inv   clkbar1  0   1    clkbar2  MyInverter  
X10Inv   clkbar2  0   1    clkbar  MyInverter   

Mp11	OUT	    clk	    D       D       pmos 	    l='Lmin'  w='4*Lmin'	
Mn32	D     clkbar    OUT     OUT     nmos        l='Lmin'  w='2*Lmin'
CL1    OUT 0  5f 

X1Inv    OUT    0    1    inv1out     MyInverter

Mp21	OUT2	    clkbar	     inv1out    inv1out      pmos 	    l='Lmin'  w='4*Lmin'	
Mn22	inv1out     clk          OUT2       OUT2         nmos        l='Lmin'  w='2*Lmin'
CL2      OUT2    0    5f 

X2Inv   OUT2    0    1    Q     MyInverter


***** Type of Analysis *****
.tran	3ns     200ns   1ns

.END