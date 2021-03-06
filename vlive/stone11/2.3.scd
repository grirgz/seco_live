(

// xTAGS: ndef, drone, rhytmed, complex
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var nfreq;
	var lim;
	freq = MouseX.kr(50,18700);
	nfreq = MouseY.kr(50,18700);
	freq = \freq.kr(0200).lag(0.1);
	freq = freq * [1,1.012,1/4,2.012,1/2,1.015];
	nfreq = 200;
	freq = freq * [1,1];
	freq = freq * EnvGen.kr(Env([1,4,1],[1.1,1.4]), \fxtrig.tr(0));
	freq = freq * \xfreq.kr(1).lag(0.5);
	sig = LFSaw.ar(freq + 1 * SinOsc.ar(\kfmfreq.kr(100) * \xfmfreq.kr(1) * LFNoise1.kr(1/7).range(0,1),mul:2 * \kfmamp.kr(1) * \xfmamp.kr(1) * LFNoise1.kr(1/9).range(0,2)) );
	sig = SinOsc.ar(freq) + sig;
	sig = sig * \pregain.kr(1);
	lim = 0.5 * SinOsc.kr(1/11 * [1,1.23,1.154,1.1324,1.324]).range(0,2);
	lim = lim + ( LFPulse.ar(8/1 * [1,1/12] * ~t, 0.0, 0.1) * LFNoise1.ar(1/7).range(0,1));
	lim = lim * \lim.kr(1);
 	sig = 
		0
		//+ ( (sig.abs < 0.5) * tanh(0-sig) )
		+ ( (sig.abs > lim) * sig * sin(sig.abs/100) * 200 )
		+ ( (sig.abs <= lim) * sig )
		;
		 
	//sig = HPF.ar(sig, 800);
	//sig = sig / 3;
	sig = Limiter.ar(sig);
	sig = HPF.ar(sig,100);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\freq, Pseq([100,200,700,350],inf),
	\fxtrig, 0,
	\dur, 4,
));
)

// END

~set_macro.(\k1, Ndef(~name+++\fx), \pregain, ControlSpec(0.01,4,\exp,0,1));
~set_macro.(\k2, Ndef(~name+++\fx), \lim, ControlSpec(0.01,4,\exp,0,1));
~set_macro.(\k3, Ndef(~name+++\fx), \kfmfreq, \freq);
~set_macro.(\k4, Ndef(~name+++\fx), \kfmamp, ControlSpec(0,100,\lin,0,1));

Ndef(\bla).proxyspace.instVarPut(\quant, 8)
Ndef(\bla).instVarPut(\quant, 8)
Ndef(\bla).proxyspace.class
ProxySpace
Ndef.defaultQuant = 8

Ndef(\bla).quant = nil
Ndef(\bla).quant
Ndef(\bla).quant = 1
Ndef(\bla, { SinOsc.ar(150)!2/4 }).play
Ndef(\bla, { SinOsc.ar(100)!2/4 })
Ndef(\bla, { SinOsc.ar(120)!2/4 })
Ndef(\blax, { LFPulse.ar(120)!2/4 }).play
Ndef(\blax, { LFPulse.ar(170)!2/4 }).play
Ndef(\bla)
Ndef(\blax).quant
1.nextTimeOnGrid(1)
