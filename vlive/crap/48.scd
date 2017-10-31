
(
	~t = 1;
Ndef(\chat).put(0,{ arg freq=700, pan=0, amp=0.1;
	var sig;
	var fspread = 0.001;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig = SinOsc.ar(freq);
	sig = sig + LFSaw.ar(freq);
	sig = sig  + CombL.ar(sig, 0.2,0.1 * SinOsc.kr(1/47).range(1.01,1) * (1..8)/4,1);

	sig = sig / 68;
	sig = sig * \gatex.kr(1!8);
	sig = sig * \agate.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);

(
	~t = 1;
Ndef(\chien).put(0, { arg freq=100, pan=0, amp=0.1;
	var sig;
	var fspread = 0.00001;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	freq = EnvGen.kr(Env([1,2,1],[0.1,0.8]), Impulse.kr(1*~t)) * freq;
	sig = SinOsc.ar(freq);
	sig = sig + LFPulse.ar(freq,mul:0.2);
	sig = sig + LFSaw.ar(freq*2,mul:0.2);
	sig = sig  + CombL.ar(sig, 0.1,0.01 * SinOsc.kr(1/47).range(1.01,1) * (1..8)/4,1);

	//sig = sig * Duty.kr(1/~t * (1..8), 0, Dseq([
	//	1,0,0,1,
	//],inf));

	//sig = sig * Duty.kr(1/~t / (1..8), 0, Dseq([
	//	1,0,1,0,
	//],inf));
	//sig = sig / 48;
	sig = sig * \gatex.kr(1!8);
	sig = sig * \agate.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);


(
Ndef(\chien).put(1, \set -> Pbind(
	\freq, Pseq([100,200],inf),
	\gatex, Pseq([
		[ 0,0,0,1, 0,0,0,0, ]
		[[ 1,0,1,1, 0,0,1,1 ]],
		1-[[ 1,0,1,1, 0,0,1,1 ]],
		[ 1 ! 8 ],
	],inf),
	\agate, 1,
	\agate, Pseq([1,0,1,0],inf),
	\dur, 1/8,
));
)
(
Ndef(\chat).put(1, \set -> Pbind(
	\freq, Pseq([700,900],inf),
	\gatex, Pseq([
		[[ 1,0,1,1, 0,0,1,1 ]],
		1-[[ 1,0,1,1, 0,0,1,1 ]],
		[ 0,0,0,1, 0,0,0,0, ]
		[ 1 ! 8 ],
	],inf),
	\agate, Pseq([0,1,0,1],inf),
	\dur, 1/8,
));
)

(
Ndef(\chat).put(1, \set -> Pbind(
	\freq, Pseq([1700,900],inf),
	\gatex, Pseq([
		[[ 1,0,1,1, 0,0,1,1 ]],
		1-[[ 1,0,1,1, 0,0,1,1 ]],
		[ 0,0,0,1, 0,0,0,0, ]
		[ 1 ! 8 ],
	],inf),
	\agate, Pseq([0,1,0,1],inf),
	\dur, 1/8,
));
)

(
Ndef(\remix).put(0, { arg freq=700, pan=0, amp=0.1;
	var sig;
	var in;
	in = Ndef.ar(\chat,2) + Ndef.ar(\chien,2);
	sig = in;
	sig = sig * SinOsc.ar(freq);
	sig = DelayL.ar(sig, 1/8*~t,1/8*~t);
	sig = SelectX.ar( SinOsc.kr(1/7).range(0,1), [in, sig] );
	//sig = sig * 10;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


Ndef(\remix)[0] = { var in = Ndef.ar(\chat,2) + Ndef.ar(\chien,2);  in * SinOsc.ar(110)}
Ndef(\remix)[1] = \filter -> { arg in;  in * LFNoise1.kr(4).range(0,1).lag(0.01)}
Ndef(\remix)[2] = \filter -> { arg in;  in + FreqShift.ar(in, 0700)}

(
Tdef(\hop, {
	Ndef(\chat).play;
	Ndef(\chien).play;
	Ndef(\remix).stop;
	4.wait;
	Ndef(\remix).play;
	Ndef(\chat).stop;
	Ndef(\chien).stop;


	
}).play;
)


Ndef(\chien).clear
Ndef(\chien).stop;
Ndef(\chat).clear
Ndef(\chat).stop;
Ndef(\chat).proxyspace.quant = 1
