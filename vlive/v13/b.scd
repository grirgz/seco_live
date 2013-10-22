~name = 'b';

(
SynthDef(~name, { |out = 0, freq = 440, freq2=660, freq3=528, cutoff = 500, amp = 0.2, gate=1, spread=0.88, pan=0, ffreq=100, dist=40|

	var snd;
	var snd1, snd2;

	freq = freq;

	snd = Saw.ar([freq, freq+1, freq-1, freq2, freq3] * [0.99,1])*0.1;

	snd = snd + VarSaw.ar(0.99*[freq, freq+1, freq-1, freq2, freq3, freq2+1, freq3+1],0, LFTri.kr([7.01,4.13,14]).range(0.00,0.02))*0.1;


	snd = Mix(snd);
	//snd = snd *80;
	snd = RLPF.ar(snd, SinOsc.kr([0.1,0.2,0.01]) * [0.170,0.40,0.480,0.40] + [1,1,1,1] * ffreq , SinOsc.ar(0.1,1.5*pi)+1.45)/3;
	//snd = Mix(snd);
	snd1 = snd * 1;
	snd2 = snd * dist;
	snd2 = snd2.distort + snd2.tanh;
	snd2 = snd2 / dist * 3;
	snd = SelectX.ar(0.4, [snd1, snd2]);
	snd = snd * 70;

	snd = FreeVerb.ar(snd, 0.11,1,0.1)*2;
	snd = MoogFF.ar(snd, SinOsc.kr([0.1,0.18], 0.5)*0.8+1 * cutoff, 3, 0);


	snd = snd * EnvGen.ar(Env.adsr(0.4, 0.01,0.8,0.84), gate, doneAction:2);
	//snd = [snd , AllpassC.ar(snd, 0.10, 0.05+SinOsc.ar(1.11).range(0,0.045), 0.3)];
	snd = AllpassC.ar(snd, 0.10, 0.05+SinOsc.ar([0.01,0.11]).range(0,0.045), 0.01);
	snd = snd * amp;
	snd = Splay.ar(snd, spread, amp, pan);
	Out.ar(out, snd);

}).add;
);

~newfx.(\fx);

	
(
Ndef(~name+++\fx, {
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	//sig = sig * SinOsc.ar(4*t).range(0,1);
	sig = sig * LFCub.ar(4*t).range(0,1);
	sig;
});
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0,4,0,3,1],inf),
	\root, -4,
	\freq2, Pkey(\freq)*(3/2) / 2,
	\freq3, Pkey(\freq)*(5/6) / 2,
	\legato, 1,
	\cutoff, 4500,
	\out, BusDef(~name+++\fx),
	\dur, 4,
	\amp, 0.2 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END


(
SynthDef(~name, { |out = 0, freq = 440, freq2=660, freq3=528, cutoff = 500, amp = 0.2, gate=1|

	var snd;

	freq = freq + SinOsc.kr(freq*1/2, 0, freq/2, 0);

	snd = Saw.ar([freq, freq+1, freq-1, freq2, freq3] * [0.99,1])*0.1;

	snd = snd + VarSaw.ar(0.99*[freq, freq+1, freq-1, freq2, freq3, freq2+1, freq3+1],0, LFTri.kr(7.13).range(0.00,0.1))*0.1;


	snd = Mix(snd);
	snd = FreeVerb.ar(snd, 0.51,10,0.1)*2;
	snd = snd *8;
	snd = RLPF.ar(snd, SinOsc.kr([0.1,4.2], 0, [1700,480], [4000,700,5000])/[20.51,20], SinOsc.ar(0.1,1.5*pi)+1.05)/3;
	snd = Mix(snd);

	snd = MoogFF.ar(snd, SinOsc.kr(1.18, 0.5)*0.4+1 * cutoff, 3, 0);

	snd = snd * EnvGen.ar(Env.adsr(0.1, 0.01,0.8,0.84), gate, doneAction:2);

	snd = [snd , AllpassC.ar(snd, 0.15, 0.05+SinOsc.ar(0.11).range(0,0.045), 0.3)];
	snd = snd * amp;
	Out.ar(out, snd);

}).add;
)


(
SynthDef(~name, { |out = 0, freq = 440, freq2=660, freq3=528, cutoff = 500, amp = 0.2, gate=1, spread=0.18, pan=0, ffreq=100, dist=40|

	var snd;
	var snd1, snd2;

	freq = freq;

	snd = Saw.ar([freq, freq+1, freq-1, freq2, freq3] * [0.99,1])*0.1;

	snd = snd + VarSaw.ar(0.99*[freq, freq+1, freq-1, freq2, freq3, freq2+1, freq3+1],0, LFTri.kr([7.01,4.13,14]).range(0.00,0.02))*0.1;


	snd = Mix(snd);
	//snd = snd *80;
	snd = RLPF.ar(snd, SinOsc.kr([0.1,0.2,0.01]) * [0.170,0.40,0.480,0.40] + [1,1,1,2] * ffreq , SinOsc.ar(0.1,1.5*pi)+1.45)/3;
	//snd = Mix(snd);
	snd1 = snd * 1;
	snd2 = snd * dist;
	snd2 = snd2.distort + snd2.tanh;
	snd2 = snd2 / dist * 3;
	snd = SelectX.ar(0.1, [snd1, snd2]);
	snd = snd * 70;

	snd = MoogFF.ar(snd, SinOsc.kr(0.18, 0.5)*0.8+1 * cutoff, 3, 0);

	snd = FreeVerb.ar(snd, 0.91,1,0.1)*2;

	snd = snd * EnvGen.ar(Env.adsr(0.4, 0.01,0.8,0.84), gate, doneAction:2);
	//snd = [snd , AllpassC.ar(snd, 0.10, 0.05+SinOsc.ar(1.11).range(0,0.045), 0.3)];
	//snd = AllpassC.ar(snd, 0.10, 0.05+SinOsc.ar([0.01,0.11]).range(0,0.045), 0.01);
	snd = snd * amp;
	snd = Splay.ar(snd, spread, amp, pan);
	Out.ar(out, snd);

}).add;
)
