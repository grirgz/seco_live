

(
//Ndef(~name+++\freq, { Duty.ar(1,0,Dseq([100,200,120,150],inf)) });
Ndef(~name+++\freq, { 
	Duty.ar(1,0,Dseq([
		150,160,260,200,
		150,160,260*2,400,
	],inf))
	*
	Duty.ar(1/2,0,Dseq([
		1,1,1,2,
		4,1,1,1,
		1/2,1,1,1,
	],inf))

});
Ndef(~name+++\lfo1, { 
	var freq = Duty.ar(1/2,0,Dseq([
		4,1,8,6,
		8,16,2,4,
	],inf));
	SinOsc.ar(freq);
});
Ndef(~name+++\lfo2, { 
	var freq = Duty.ar(1/2,0,Dseq([
		4,1,8,6,
		8,16,2,4,
	],inf));
	SinOsc.ar(freq/8);
});

Veco.do { arg name;

	Ndef(name+++\fx).put(0, \qsetsrc -> Pbind(

		\source, Pseq([
			{
				var sig; 
				var bufsig;
				var mod;
				var phase;
				var bufnum;
				var freq = Ndef.ar(name+++\freq);
				phase = SinOsc.ar(Ndef.ar(name+++\freq).lag(0.414)).range(0,1) * Ndef.ar(name+++\lfo2).range(0,10) * 0.001 + 0.2;
				bufnum = BufDef(\oeuf);
				sig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1) ;
				//sig = RLPF.ar(sig, Ndef.ar(name+++\lfo2).range([5000,100],[1000,5000]),[0.5,0.1]);
				//sig = SinOsc.ar(Ndef.ar(name+++\freq).lag(0.414) * [1/4,1,1/2,2] , sig * Ndef.ar(name+++\lfo1).range(0,10));
				//sig = SinOsc.ar(Ndef.ar(name+++\freq).lag(0.414) * [1/4,1,1/2,2] , sig * Ndef.ar(name+++\lfo1).range(0,10));
				sig = SinOsc.ar(freq.lag(0.114) * [1/4,1,1/2,2] + (sig * freq.lag(0.1) * Ndef.ar(name+++\lfo1).range(0,0.81)));
				sig = sig * 1;
				sig = (sig*10 * Ndef.ar(name+++\lfo1).range(0,100)).distort / 13;
				//sig = Pan2.ar(sig, 0, 0.1);
				sig = Splay.ar(sig, 0.8, 0.4, 0);
				"======1".debug;
				//sig.flop;
				sig;
			},
			{
				var sig; 
				var mod;
				sig = LFCub.ar(Ndef.ar(name+++\freq).lag(0.14) * [1,1.01,2,4,0.5]);
				mod = sig * Ndef.ar(name+++\lfo1).range(0,Ndef.ar(name+++\lfo2).range(0,10));
				sig = SinOsc.ar(Ndef.ar(name+++\freq).lag(0.014) * [1/4,1,1/2,2], mod);
				sig = sig;
				sig = sig / 4;
				//sig = Pan2.ar(sig, 0, 0.1);
				sig = Splay.ar(sig, 0.8, 0.4, 0);
				"======1".debug;
				//sig.flop;
				sig;
			},

		],inf),
		\dur, Pseq([2],inf),
	));

	Ndef(name+++\fx).put(100, nil);
	Ndef(name+++\fx).put(101, nil);

};

);

(
	Ndef(~name+++\fx).quant = Pdef.defaultQuant;
	Ndef(~name+++\freq).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
);

// END
(
Ndef(~name+++\freq, { 
	Duty.ar(1,0,Dseq([
		150,160,260,200,
		150,160,260*2,400,
	],inf))
	*
	Duty.ar(1/2,0,Dseq([
		1,1,1,2,
		4,1,1,1,
		1/2,1,1,1,
	],inf))

});
)

	Ndef(~name+++\fx).fadeTime = 0.8;
	Ndef(~name+++\fx).fadeTime 
	Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant 
Ndef(~name+++\fx).isPlaying

Ndef(~name+++\freq, { XLine.ar(10,8000,5)});
Ndef(~name+++\freq, { XLine.ar(10000,80,5)});
Ndef(~name+++\freq, { SinOsc.ar(1/4).range(40,100)});
Ndef(~name+++\freq, { SinOsc.ar(2).range(40,100)});
Ndef(~name+++\freq, { SinOsc.ar(4).range(40,400) * [1,2,4]});
	Ndef(~name+++\freq).quant = 1
Ndef(~name+++\freq, { Duty.ar(1,0,Dseq([100,500,80,50],inf)) });
Ndef(~name+++\freq, { Duty.ar(1,0,Dseq([100,200,120,150],inf)) });


(
Ndef(\aa, { SinOsc.ar(100)!2 });
Ndef(\aa).play;
)
