
/// random gen osc filt pan with fm splay env


(

// other
~fm = { arg gate, freq, argname=\fma;
	var fma = argname.kr(0.1);
	if(0.5.coin) {
		fma = fma * ~envmod.(gate, freq, \fmenvamt);
	};
	~osc.(gate, freq * [1/2, 1.01, 2].choose) * fma + 1;
};
~spread = { arg gate, freq;
	var num = rrand(2,12);
	((0..num)/num - 0.5 * \fspread.kr(0.002) + 1)
};
~envmod = { arg gate, freq, argname = \envamt;
	EnvGen.ar(\envmod.kr(Env.adsr(0.1,0.1,1,0.1)),gate,doneAction:0) * argname.kr(1) + 1;
};


//// osc
~sin = { arg gate, freq;
	SinOsc.ar(freq)
};
~saw = { arg gate, freq;
	LFSaw.ar(freq)
};
~pulse = { arg gate, freq;
	Pulse.ar(freq)
};
~osc = { arg gate, freq;
	var xfreq = freq;
	var sig;
	if(0.5.coin) {
		xfreq = xfreq * ~fm.(gate, freq);
	};
	if(0.5.coin) {
		xfreq = xfreq * ~spread.(gate, freq);
	};
	sig = [~sin, ~saw, ~pulse].choose.(gate, xfreq);
	if(sig.isSequenceableCollection) {
		sig = sig.mean;
	};
	sig;
};

//// filter

~lpf = { arg in, gate, freq;
	LPF.ar(in, freq.clip(20,19000))
};
~rlpf = { arg in, gate, freq;
	RLPF.ar(in, freq.clip(20,19000), \rq.kr(0.4))
};
~hpf = { arg in, gate, freq;
	HPF.ar(in, freq.clip(20,19000))
};
~rhpf = { arg in, gate, freq;
	RHPF.ar(in, freq.clip(20,19000), \rq.kr(0.4))
};
~bpf = { arg in, gate, freq;
	BPF.ar(in, freq.clip(20,19000), \rq.kr(0.4))
};
~brf = { arg in, gate, freq;
	BRF.ar(in, freq.clip(20,19000), \rq.kr(0.4))
};
~filter = { arg in, gate, freq;
	var xfreq = freq * \cutfac.kr(1);
	var sig;
	if(0.5.coin) {
		xfreq = xfreq * [2,1/2,1.01].choose;
	};
	if(0.5.coin) {
		xfreq = xfreq * ~fm.(gate, freq, \ffma);
	};
	if(0.5.coin) {
		xfreq = xfreq * ~spread.(gate, freq);
	};
	if(0.5.coin) {
		xfreq = xfreq * ~envmod.(gate, freq, \fenvamt);
	};
	sig = [~brf, ~bpf, ~lpf, ~hpf, ~rlpf, ~rhpf].choose.(in, gate, xfreq);
	if(sig.isSequenceableCollection) {
		sig = sig.mean;
	};
	sig;
};

//// panning
//~pan = { arg in, gate, pan;
	//if(in.isSequenceableCollection) {
		//in = in.clump(2)
		
	//Pan2.ar(in, pan, 1).;
	//};
//};
~splay = { arg in, gate, pan;
	Splay.ar(in, pan, 1);
};
~panning = { arg in, gate, pan;
	[~splay].choose.(in, gate, pan);
};
~struct = { arg gate, pan, freq;
	var osc, filter, panning;
	osc = rrand(2,5).collect { arg idx;
		if(0.1.coin) {
			freq = freq * [1/2,1.01,2].choose;
		};
		~osc.(gate, freq);
	};
	filter = rrand(2,5).collect { arg idx;
		~filter.(osc.choose, gate, freq)
	};
	panning = ~panning.(filter, gate, pan);
	panning;
};

SynthDef(\synthgen1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = ~struct.(gate, pan, freq);
	sig = sig * amp;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

~osc.(1,100)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \synthgen1,
			\note, Pseq([
				0,4,3,2,
			],inf),
			\octave, 5,
			\cutfac, PmodEnv(Pseq([0.1,4],1), 8).loop,
			\dur, 1/8,
			\amp, 0.05,
			\envamt, 5,
			\fma, 0,
			\ffma, 0,
			\fenvamt, 0.1,
			\fmenvamt, 0.1,
		),
		
	])
)).play;
);
