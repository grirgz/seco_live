
(
Ndef(~name+++\lfo1, { LFTri.kr(1/8*~t) * 0.0002 + \pos.kr(0.2) });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { LFNoise2.kr(1*8*~t).exprange(0.01,0.007) * \noiseamp.kr(1) + \noise.kr(0) });
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo3, { LFTri.kr(1/20*~t) * 0.02 + \pos.kr(0.000002) });
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;

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
	\delaymix, 1,
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
		[  Env([80,1570,45,215],[0.31,0.2,0.1]/~t) ],
		[  Env([80,1570,45,45],[0.31,1,1]/2/~t) ],
		[  Env([80,1570,45,415],[0.31,1,1]/~t) ],
		[  Env([80,1570/2,45*2,215*4],[0.31,0.2,0.1]/~t) ],
	],inf).stutter(8),
	\randenv, Pseq([
		[  Env([0,0,4],[2.1,2.8]/~t) ],
		[  Env([12,11,4],[2.1,2.8]/~t) ],
	],inf).stutter(8),
	\gdur, 0.01,
	\gdur, Ndef(~name+++\lfo2),
	\dur, 1,
	\amp, 5,
	\pan, Pseq([0,1,-1,0],inf).stutter(8) * 0.5,
	\delayl, 0.0101,
	\delayr, 0.0001,
	\delayl, Ndef(~name+++\lfo3),
	\bufnum, BufDef.mono(\march),
	\bufnum, BufDef.mono(\table),
));
Pdef(~name+++\macro).setBusMode(\rate, \lpf,\hpf,\ratefac, \freqshift);
Pdef(~name+++\macro).asRack.map_midi;
~set_macro.(\k6, Ndef(~name+++\lfo1), \pos, \unipolar);
~set_macro.(\k7, Ndef(~name+++\lfo2), \noiseamp, \amp);
~set_macro.(\k8, Ndef(~name+++\lfo2), \noise, \amp);
);


// END

~midi.(\k1, 0, ControlSpec(0,1,\lin,0,1)).valpattern.asStream.nextN(10)
