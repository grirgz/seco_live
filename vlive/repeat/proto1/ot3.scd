
(
Pdef(\otkick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 30], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 2, 4.8,0], [0.015, 0.49,1.4], [-4, -5]) ],
	],inf),
	\distmix, 1,
	\distamp, 1,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pser([
			1,0,0,0,
		],12),
		1,0,1,1,
		Pser([
			1,0,0,0,
		],12),
		1,1,1,0,
		Pser([
			1,0,0,0,
		],12),
		1,1,0,1,
	],inf).coin.not,
	\amp, 0.15,
	\amp, Pkey(\amp) * Pseq([
		1,1,1,1,
	],inf),
));
);

(
Pdef(\otkick2, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		1,0,0.5,0,
		1,0.5,0.1,0,
	],inf).coin.not,
	\amp, 0.15,
	\amp, Pkey(\amp) * Pseq([
		1,0.5,0.61,0.5,
		0.7,0.7,0.6,0.5,
	],inf),
));
)


(
SynthDef(\flute, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var bandfac;
	sig1 = LFSaw.ar(freq);
	//sig1 = sig1.lag(1/freq);
	sig1 = LPF.ar(sig1, freq/2);

	sig2 = LFSaw.ar(freq+[1,0]*(2 + SinOsc.ar(1.6, mul:[1,1]/100)));
	sig2 = LPF.ar(sig2, freq * 2);
	sig2 = sig2 * 4;

	sig3 = WhiteNoise.ar(1);
	sig3 = sig3 * EnvGen.kr(Env([0,1,0.52,0.5],[0.01,0.1,3.8,0.2],[1]), 1);
	bandfac = 1;
	sig3 = LPF.ar(sig3, freq*bandfac + 300);
	sig3 = HPF.ar(sig3, freq/bandfac);
	sig3 = sig3 * 4;

	sig4 = sig1 + sig3;
	sig4 = CombC.ar(sig4, 0.1, 1/( freq*2 ), 0.101) + sig4;

	sig = sig4 + sig2;

	//sig = FreeVerb1.ar(sig)

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig.debug("sig");
	//sig = Pan2.ar(sig, [-1,1], amp).flop;
	sig = Splay.ar(sig, 0.01, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\flutebass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var bandfac;
	sig1 = LFSaw.ar(freq);
	//sig1 = sig1.lag(1/freq);
	sig1 = LPF.ar(sig1, freq*[1,2]).mean;

	sig2 = LFSaw.ar(freq+[1,0]*(2 + SinOsc.ar(1.6, mul:[1,1]/100)));
	sig2 = sig2 + LFCub.ar(freq* [1,1/2,2]);
	//sig2 = sig2.tanh;
	sig2 = LPF.ar(sig2, freq * 2);
	sig2 = sig2 * 4;

	sig3 = WhiteNoise.ar(1);
	sig3 = sig3 * EnvGen.kr(Env([0,1,0.52,0.5],[0.01,0.1,3.8,0.2],[1]), 1);
	bandfac = 1;
	sig3 = LPF.ar(sig3, freq*bandfac + 300);
	sig3 = HPF.ar(sig3, freq/bandfac);
	sig3 = sig3 * 4;

	sig4 = sig1 + sig3;
	sig4 = CombC.ar(sig4, 0.1, 1/( freq*2 ), 0.101) + sig4;

	sig = sig4 + sig2;

	//sig = FreeVerb1.ar(sig)

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig.debug("sig");
	//sig = Pan2.ar(sig, [-1,1], amp).flop;
	sig = Splay.ar(sig, 0.01, amp, pan);
	Out.ar(out, sig);
}).add;
);
BusDef(\bus1, \audio, 2)
(
Pdef(\flute, Pbind(
	\instrument, \flute,
	\degree, Pseq([0,2,[1,4],1,Ptuple([Prand([-1,0,5]),2]),3,Prand([1,2,5,-3],2)],inf),
	\scale, Scale.gong,
	\legato, Pseq([0.5,Prand([0.1,1,0.5,0.3],3)],inf),
	\out, Ndef(\verb).get(\inbus),
	\dur, Pseq([1,1/4, 1/2,1/8],inf),
	\amp, 0.1
)).play;
);

(
Pdef(\flute, Pbind(
	\instrument, \flute,
	\degree, Pseq([0,2,[1,4],1,Ptuple([Prand([-1,0,5]),2]),3,Prand([1,2,5,-3],2)],inf),
	\scale, Scale.dorian,
	\legato, Pseq([0.5,Prand([0.1,1,0.5,0.3],3)],inf),
	\out, Ndef(\verb).get(\inbus),
	\dur, Pseq([1,1/4, 1/2,1/8],inf),
	\amp, 0.1
)).play;
);

(
Pdef(\flute, Pbind(
	\instrument, \flutebass,
	\degree, Pseq([0,2,[1,4],1,Ptuple([Prand([-1,0,5]),2]),3,Prand([1,2,5,-3],2)],inf),
	\scale, Scale.dorian,
	\legato, Pseq([0.5,Prand([0.1,1,0.5,0.3],3)],inf),
	\octave, 3,
	\out, Ndef(\verb).get(\inbus),
	\dur, Pseq([1,1/4, 1/2,1/8],inf),
	\amp, 0.1
)).play;
);

// END

Ndef(\verb).play
Scale.names

	(
	Ndef(\verb, { 
		var in = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
		FreeVerb2.ar(in[0], in[1], \mix.kr(0.51), \room.kr(0.2), \damp.kr(1)); 
	}).play
	)

	(
	Ndef(\verb, { 
		var in = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var sig = [in];
		//FreeVerb2.ar(in[0], in[1], \mix.kr(0.51), \room.kr(0.2), \damp.kr(1)); 
		sig = sig + Fb { arg fb;
			var isig;
			isig = ( fb * \fb.kr(0.9) ) + sig;

			isig = AllpassC.ar(sig, 0.1, 1/( [1,3] + 100 ), 0.05) + isig;
			//isig = AllpassC.ar(sig, 0.1, 1/( [1,3,6,7,11] + 2000 ), 0.45) + isig;
			( [1,3,6,7,11,34,1233] + 10 ).do { arg del;
				isig = AllpassC.ar(sig, 0.1, 1/del, 0.00) + isig;
			};
		
			isig = Limiter.ar(isig);
			isig;
		};
		sig = sig.mean.debug("sig");
		sig = LPF.ar(sig, 2700);
		sig = sig / 3;
		sig = SelectX.ar(\mix.kr(1.0), [in, sig] );
	})
	)


	Ndef(\verb).set(\inbus, BusDef(\sendbus1, \audio,2))
(
Ndef(\verb, {	
	var input, output, delrd, sig, deltimes;
	var in;
	
	// Choose which sort of input you want by (un)commenting these lines:
	input = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
	//input = SoundIn.ar([0,1]); // TAKE CARE of feedback - use headphones
	//input = Dust2.ar([0.1, 0.01]); // Occasional clicks
	
	// Read our 4-channel delayed signals back from the feedback loop
	delrd = LocalIn.ar(4);
	
	// This will be our eventual output, which will also be recirculated
	output = input + delrd[[0,1]];
	
	sig = output ++ delrd[[2,3]];
	// Cross-fertilise the four delay lines with each other:
	sig = ([ [1,  1,  1,  1],
	         [1, -1,  1, -1],
	         [1,  1, -1, -1],
	         [1, -1, -1,  1]] * sig);
			 sig.debug("sig&");
	//sig[0][1] = ( sig[0][1]* LFNoise1.kr(1/4).range(0,7) ).tanh / 2;
	//sig[0][1] = ( LPF.ar(sig[0][1],1000));
	//sig[1][3] = ( sig[1][3]* LFNoise1.kr(1/2).range(0,7) ).tanh / 2;
	//sig[1][3] = ( LPF.ar(sig[1][3],1000));
	//[ [1,3], [0,1], [2,0] ].do { arg mm, idx;
	//	var x, y;
	//	#x, y = mm;

	//	sig[x][y] = ( BPF.ar(sig[x][y].tanh, SinOsc.kr(1/( 33+( idx*2 ) )).exprange(100,10000)) * 1.4);
	//};
	//sig[1][3] = ( BPF.ar(sig[1][3], SinOsc.kr(1/3).exprange(100,10000)));
	sig = sig.sum;
	// Attenutate the delayed signals so they decay:
	sig = sig * [0.4, 0.37, 0.333, 0.3] * 1.2;
	//sig = sig.tanh;
	sig.debug("sig");
	
	// Here we give delay times in milliseconds, convert to seconds,
	// then compensate with ControlDur for the one-block delay 
	// which is always introduced when using the LocalIn/Out fdbk loop
	//deltimes = [101, 143, 165, 177 + SinOsc.kr(1/1).range(0,10)] * 0.001 - ControlDur.ir;
	deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
	
	//sig = LPF.ar(sig, 600) + BPF.ar(sig, [1000,6000,12300, 4000,7000,15000,10000],1,mul:1.1).mean;
	sig.debug("sigx");

	// Apply the delays and send the signals into the feedback loop
	LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
	
	output = output / 4;
	// Now let's hear it:

	//output = LPF.ar(output, 2000);
	//output = BPF.ar(output, 2000, 2);
	//output = output + DelayC.ar(input, 0.5, 0.5/40, mul:0.4);
	//output = output + DelayC.ar(input, 0.5, 0.5/50, mul:0.4);
	//output = AllpassC.ar(output, 0.1, 1/1234, 0.1, mul:2) + output;
	//output = AllpassC.ar(output, 0.1, 1/125, 0) + output;
	output = Limiter.ar(output);
	
}).play
)

(
Ndef(\verb, {	
	var input, output, delrd, sig, deltimes;
	var in;
	
	// Choose which sort of input you want by (un)commenting these lines:
	input = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
	//input = SoundIn.ar([0,1]); // TAKE CARE of feedback - use headphones
	//input = Dust2.ar([0.1, 0.01]); // Occasional clicks
	
	// Read our 4-channel delayed signals back from the feedback loop
	delrd = LocalIn.ar(4) *2;
	
	// This will be our eventual output, which will also be recirculated
	output = input + delrd[[0,1]];
	
	sig = output ++ delrd[[2,3]];
	// Cross-fertilise the four delay lines with each other:
	sig = ([ [1,  1,  1,  1],
	         [1, -1,  1, -1],
	         [1,  1, -1, -1],
	         [1, -1, -1,  1]] * sig);
			 sig.debug("sig&");
	//sig[0][1] = ( sig[0][1]* LFNoise1.kr(1/4).range(0,7) ).tanh / 2;
	//sig[0][1] = ( LPF.ar(sig[0][1],1000));
	//sig[1][3] = ( sig[1][3]* LFNoise1.kr(1/2).range(0,7) ).tanh / 2;
	//sig[1][3] = ( LPF.ar(sig[1][3],1000));
	//[ [1,3], [0,1], [2,0] ].do { arg mm, idx;
	//	var x, y;
	//	#x, y = mm;

	//	sig[x][y] = ( BPF.ar(sig[x][y].tanh, SinOsc.kr(1/( 33+( idx*2 ) )).exprange(100,10000)) * 1.4);
	//};
	//sig[1][3] = ( BPF.ar(sig[1][3], SinOsc.kr(1/3).exprange(100,10000)));
	sig = sig.sum;
	// Attenutate the delayed signals so they decay:
	sig = sig * [0.4, 0.37, 0.333, 0.3] * 1 * 1;
	//sig = sig * ( SelectX.ar( 0.1, [1/(0.1+Amplitude.ar(sig).lag(1.2) ).poll  , DC.ar(1) ]));
	//sig = sig.tanh / 6.7;
	sig = LPF.ar(sig, 2000);
	//sig = Limiter.ar(sig, 0.4);
	//sig = sig.tanh;
	sig.debug("sig");
	
	// Here we give delay times in milliseconds, convert to seconds,
	// then compensate with ControlDur for the one-block delay 
	// which is always introduced when using the LocalIn/Out fdbk loop
	//deltimes = [101, 143, 165, 177 + SinOsc.kr(1/1).range(0,10)] * 0.001 - ControlDur.ir;
	deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
	288**2
	
	//sig = LPF.ar(sig, 600) + BPF.ar(sig, [1000,6000,12300, 4000,7000,15000,10000],1,mul:1.1).mean;
	sig.debug("sigx");

	// Apply the delays and send the signals into the feedback loop
	LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
	
	output = output / 4;
	// Now let's hear it:

	//output = LPF.ar(output, 2000);
	//output = BPF.ar(output, 2000, 2);
	//output = output + DelayC.ar(input, 0.5, 0.5/40, mul:0.4);
	//output = output + DelayC.ar(input, 0.5, 0.5/50, mul:0.4);
	//output = AllpassC.ar(output, 0.1, 1/1234, 0.1, mul:2) + output;
	//output = AllpassC.ar(output, 0.1, 1/125, 0) + output;
	output = Limiter.ar(output);
	
}).play
)


Pdef(\otkick).play
Pdef(\otkick).play
Pdef(\otkick).get(\out)
TrackDef(\ot).childAt(0).mixer.inbus
TrackDef(\ot).childAt(0).mixer.proxy.play
TrackDef(\ot).childAt(0).mixer.define_mixer
Pdef(\kick).play
Pdef(\otkick).clear
Document.current.name.postln;

 //SCVim.updateHelpCache;
