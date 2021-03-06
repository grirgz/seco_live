
Ndef(~name+++\lfo1, { arg modfreq=1, modlof=1, modhif=40, lof=100, hif=1400; 
	SinOsc.kr(SinOsc.kr(modfreq).range(modlof,modhif)).range(lof,hif) 
});
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Pdef(~name +++ \pre, 
	
	~patfx.(\pharma) <>
	Sdef(~name, \mac).pbind <>
	Pbind(
	\freq, Pseq([
		Pseq([700,650],4),
		Pseq([700,650]-100,4),
	],inf) - Pseq([100,200,300]/2,inf),
	\freq, Pseq([100,50],inf),
	\freq, Pseq([650,300,100,50],inf),
	\freq, Pseq([
		1250,1300,1200,370,
		1250,1300,1200,1370,
		1250,300,1200,1370,
		1250,1300,1200,1370,
	]/4,inf),
	\rfreqtab, [ [0.1,0.5,0.5,0.1, 1.1,0.5,2,3] ] * Pseq([0.2,2,1,0.5,0.25,0.125],inf),
	\ffreq, Pseq([100,200,350,300]*3,inf),
	\ffreq, Ndef(~name+++\lfo1),
	//\sustain, 0.02,
	\adsr, [Env.adsr(0.01,0.4,0.8,0.10)],
));

// END

(
Ndef(~name+++\lfo1).controlNames.collect { arg con, x;
	[Ndef(~name+++\lfo1), con.name]
}
)

Sdef(~name, \mac, \preset, [\legato, ControlSpec(0.01,4,'exp',0,0.5)])
