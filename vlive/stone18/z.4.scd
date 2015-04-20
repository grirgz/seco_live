
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 40.midicps;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = \xfreq.kr(40.midicps);
	freq = freq * (1..8)/8;
	sig1 = 4-Sweep.ar(Impulse.kr(\sweepfreq.kr(4)*~t), 8) + 1;
	//freq = freq * LFSaw.kr(sig1).range(2,1);
	freq = freq * sig1;
	sig = LFSaw.ar(freq); 
	sig = CombL.ar(sig, 0.1, 1/( \combfreq.kr(40.midicps) ), \combdecay.kr( 0)) + sig;
	sig = LPF.ar(sig, \lpf.kr(1000));
	sig = sig * \vol.kr(1);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})

// END

ParamGroup(
Ndef(~name+++\fx).controlNames.collect{ arg con; Param(Ndef(\plop), con.name) }
).edit
Ndef(\plop).controlNames.collect{ arg con; Param(Ndef(\plop), con.name) }

~print_ndef_to_macros.(~name+++\fx, "~name+++\\fx")
Ndef(~name+++\fx).put(11,nil)
Ndef(~name+++\fx).put(10,nil)
Ndef(~name+++\fx).put(12,nil)
