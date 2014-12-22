
(
Ndef(~name+++\lfo1, { LFTri.kr(1/8*~t) * 0.0002 +0.2 });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { LFNoise2.kr(1*8*~t).exprange(0.01,0.07) });
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Pdef(~name+++\pre, 
	~dPdef.(~name+++\macro, 
		\rate, 	ControlSpec(0,401,\lin,0,1),
		\ratefac, 	ControlSpec(0.001,4,\exp,0,1),
		\lpf, 	\freq.asSpec,
		\hpf, 	\freq.asSpec,
		\freqshift, 	\freqshift.asSpec,
	) <>
	
	Pbind(
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\randlow, 0.0001,
	\randhi, 0.00001,
	\pitch_stretch, 4/1,
	\pos, 0.45732882889595,
	\pos, Ndef(~name+++\lfo1),
	\freqshift, -700,
	\legato, 8,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
	],inf),
	\rate, 178,
	//\rate, 400 * ~midi.(\k1, 0, ControlSpec(0,1,\lin,0,1)).valpattern,
	\rateenv, Pseq([
		[  Env([480,570,405,485],[1,1,1]/~t) ],
	],inf).stutter(8),
	\randenv, Pseq([
		[  Env([0,100,4000],[2.1,2.8]/~t) ],
		[  Env([1200,1100,400],[2.1,2.8]/~t) ],
	],inf).stutter(8),
	\gdur, 0.01,
	\gdur, Ndef(~name+++\lfo2),
	\dur, 1,
	\amp, 9,
	\bufnum, BufDef.mono(\march),
	\bufnum, BufDef.mono(\table),
));
Pdef(~name+++\macro).setBusMode(\rate, \lpf,\hpf,\ratefac);
Pdef(~name+++\macro).asRack.map_midi;
);


// END

~midi.(\k1, 0, ControlSpec(0,1,\lin,0,1)).valpattern.asStream.nextN(10)
