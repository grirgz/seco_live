

/////// compander

Ndef(~name+++\fx).put(0, { arg amp=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var side = in;
	sig = in;

	sig = Compander.ar(sig, side, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));

	//sig1 = ( sig * \distamp.kr(1.2) ).clip2(1) * \dpamp.kr(1);
	sig1 = ( sig * \distamp.kr(1.2) ).softclip(1) * \dpamp.kr(1);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);

	amp = amp * \gain.kr(1);
	sig = sig * amp;
	sig;
});

// END

Ndef(~name+++\fx).edit

(
ParamGroup([ 
	Param( Ndef(~name+++\fx), \delaytab),
	Param( Ndef(~name+++\fx), \amptab),
]).edit
)

2**((0..7))/128
