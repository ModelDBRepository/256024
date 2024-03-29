TITLE Hyperpolarization-activated current Ih
COMMENT
  Model of the Hyperpolarization-activated current Ih, also called
  the "Anomalous Rectifier".  Cationic (Na/K) channel based on 
  data from thalamic relay neurons.

  Voltage dependence: derived from the data and models given in
  Huguenard & McCormick, J Neurophysiol. 68: 1373-1383, 1992, based
  on voltage-clamp characterization of the Ih current in thalamic
  neurons by McCormick & Pape, J. Physiol. 431: 291, 1990.

  Calcium regulation: the model includes one of the features of Ih in
  thalamic neurons (and elsewhere), which is the regulation of this
  current by intracellular calcium.  Voltage-clamp experiments of 
  Ih in heart cells (Harigawa & Irisawa, J. Physiol. 409: 121, 1989)
  showed that intracellular calcium induces a shift in the voltage-
  dependent activation of the current.  This shift can be reproduced
  by assuming that calcium binds only to the open state of the 
  channel, "locking" Ih in the open configuration (see Destexhe et 
  al., Biophys J. 65: 1538-1552, 1993).  It was later found that 
  calcium does not bind directly to Ih, but cAMP binds to the open
  state of the channel, and cAMP production is stimulated by 
  calcium (Luthi and McCormick, Nat. Neurosci. 2: 634-641, 1999).
  The present model simulates such "indirect" regulation by calcium
  and is a modified version from the model given in Destexhe et al.,
  J. Neurophysiol. 76: 2049-2070, 1996.

  See also http://cns.iaf.cnrs-gif.fr

   KINETIC MODEL:

	  Normal voltage-dependent opening of Ih channels:

		c1 (closed) <-> o1 (open)	; rate cst alpha(V),beta(V)

	  Ca++ binding on second messenger

		p0 (inactive) + nca Ca <-> p1 (active)	; rate cst k1,k2

	  Binding of active messenger on the open form (nexp binding sites) :

		o1 (open) + nexp p1 <-> o2 (open)	; rate cst k3,k4


   PARAMETERS:
	It is more useful to reformulate the parameters k1,k2 into
	k2 and cac = (k2/k1)^(1/nca) = half activation calcium dependence, 
	and idem for k3,k4 into k4 and Pc = (k4/k3)^(1/nexp) = half activation
	of Ih binding (this is like dealing with tau_m and m_inf instead of
	alpha and beta in Hodgkin-Huxley equations)
	- k2:	this rate constant is the inverse of the real time constant of 
             	the binding of Ca to the 2nd messenger
	- cac:	the half activation (affinity) of the 2nd messenger;
		around 1 to 10 microM.  
	- k4:	this rate constant is the inverse of the real time constant of 
             	the binding of the 2nd messenger to Ih channels
		very low, of the order of seconds (Luthi and McCormick, 1999)
	- Pc:	the half activation (affinity) of the Ih channels for the
		2nd messenger;
	- nca:	number of binding sites of calcium on 2nd messenger; usually 4
	- nexp:	number of binding sites on Ih channels
        - ginc: augmentation of conductance associated with the Ca bound state
	        (about 2-3; see Harigawa & Hirisawa, 1989)

 Alain Destexhe, destexhe@iaf.cnrs-gif.fr

ENDCOMMENT

:INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

NEURON {
	THREADSAFE
	SUFFIX h_ca
	NONSPECIFIC_CURRENT i
	USEION ca READ cai
    RANGE gmax, i, tau, m
	:GLOBAL k2, cac, k4, Pc, nca, nexp, ginc, taum
	GLOBAL e, taumin, vhalf, s1, s2
}

UNITS {
	(molar)	= (1/liter)
	(mM)	= (millimolar)
	(mA) 	= (milliamp)
	(mV) 	= (millivolt)
	(msM)	= (ms mM)
}


PARAMETER {
	e	= -35	(mV)
	gmax= 2e-4 	(mho/cm2)
	cac	= 0.006 (mM)		: half-activation of calcium dependence
	k2	= 0.0001 (1/ms)		: inverse of time constant
	Pc	= 0.01				: half-activation of CB protein dependence
	k4	= 0.001	(1/ms)		: backward binding on Ih
	nca	= 4					: number of binding sites of ca++
	nexp = 1				: number of binding sites on Ih channels
	ginc = 2				: augmentation of conductance with Ca++
:	taum = 20	(ms)
:	shift = 0	(mV)		: shift of Ih voltage-dependence
	vhalf = -78 (mV)
	vh2 = -85	(mV)
    s1 = -13 	(mV)
    s2 = 14 	(mV)
    taumax = 1020 (ms)		: max value of tau
    taumin = 20 (ms)		: min value of tau
}


STATE {
	c1	: closed state of channel
	o1	: open state
	o2	: CB-bound open state
	p0	: resting CB
	p1	: Ca++-bound CB
}


ASSIGNED {
	v	(mV)
	cai	(mM)
	i	(mA/cm2)
:    gh	(mho/cm2)
	h_inf
	tau		(ms)
	alpha	(1/ms)
	beta	(1/ms)
	k1ca	(1/ms)
	k3p	(1/ms)
	m
	:tadj
}


BREAKPOINT {
	SOLVE ihkin METHOD sparse

	m = o1 + ginc * o2

	i = gmax * m * (v - e)
}

KINETIC ihkin {
:
:  Here k1ca and k3p are recalculated at each call to evaluate_fct
:  because Ca or p1 have to be taken at some power and this does
:  not work with the KINETIC block.
:  So the kinetics is actually equivalent to
:	c1 <-> o1
:	p0 + nca Cai <-> p1
:	o1 + nexp p1 <-> o2

	evaluate_fct(v,cai)

	~ c1 <-> o1		(alpha,beta)

	~ p0 <-> p1		(k1ca,k2)

	~ o1 <-> o2		(k3p,k4)

	CONSERVE p0 + p1 = 1
	CONSERVE c1 + o1 + o2 = 1
}





INITIAL {
:
:  Experiments of McCormick & Pape were at 36 deg.C
:  Q10 is assumed equal to 3
:
       : tadj = 3.0 ^ ((celsius-36 (degC) )/10 (degC) )

	evaluate_fct(v,cai)

	c1 = 1-h_inf
	o1 = h_inf
	o2 = 0
	p0 = 1
	p1 = 0
}


UNITSOFF
PROCEDURE evaluate_fct(v (mV), cai (mM)) {

	h_inf = 1 / ( 1 + exp((vhalf-v)/s1) )

:	tau = (taumin + taumax / ( exp((v+71.5-shift)/14.2) + exp(-(v+89-shift)/11.6) ) )
	tau = 2*taumax/( exp((vh2-v)/s2) + exp((vhalf-v)/s1) ) + taumin

	alpha = h_inf / tau
	beta  = ( 1 - h_inf ) / tau

	k1ca = k2 * (cai/cac)^nca

	k3p = k4 * (p1/Pc)^nexp

}


:
:  procedure for evaluating the activation curve of Ih
:
PROCEDURE activation(v (mV), cai (mM)) { LOCAL cc

	evaluate_fct(v,cai)

	cc = 1 / (1 + (cac/cai)^nca ) 		: equil conc of CB-protein

	:m = 1 / ( 1 + beta/alpha + (cc/Pc)^nexp )
	:m = ( 1 + ginc * (cc/Pc)^nexp ) * m
	
	m = ( 1 + ginc * (cc/Pc)^nexp ) / ( 1 + beta/alpha )
}

UNITSON


