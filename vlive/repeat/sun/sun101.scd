
/////////////////////////////////////////// feynman trance
// from suft25

(
SynthDef(\longway, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01;
	var sig;
	var spread =1;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*0.2) * 1 + 1 )) * ( SinOsc.ar(freq * 0.2) * 1 + 1 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.1),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				\dur, 1,
				\amp, 0.1,
			),
			//Pbind(
				//\instrument, \playersec_looper,
				//\bufnum, BufDef('voices/feynman.flac'),
				//\trigfreq, 8*~t,
				//\legato, 1,
				//\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				//\dur, 1,
				//\gain, 1/2,
			////	\out, BusDef(\smpsendbus1, \audio),
			//),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),

		//Pbind(\out, BusDef(\drums1, \audio)) <>
		//Ppar([
			//Pbind(
				//\instrument, \snapkickx,
				//\dur, 1/8,
				//\isRest, Pseq([
					//1,0,1,0, 
					//1,0,1,0, 
					//1,0,1,0, 
					//1,0,1,0, 
				//],inf).coin.not,
				//\amp, 0.1,
			//),
			//PatKitDef(\ksh2b).asPattern(Pbind(
				//\kitIndex, 5,
				//\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 1,0,0,0,
					//0,1,0,0, 0,0,0,0,

					//0,0,0,0, 1,0,0,1,
					//0,1,0,0, 0,1,0,1,
					//0,0,0,0, 0,1,0,0,
					//0,1,0,0, 1,0,1,0,

					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 1,0,0,0,
					//0,1,0,0, 1,0,0,0,

					//0,0,0,0, 1,0,1,0,
					//0,1,1,0, 1,0,1,1,
					//0,1,0,1, 1,0,1,0,
					//0,1,0,0, 1,0,1,0,
				//],inf).coin.not,
				//\gain, 0.2,
				//\gain, Pkey(\gain) * Pseq([
					////Pseq([
						////1,1/3,1/2,1/3,
					////],2*4),
					//Pseq([
						//1,2/3,1/2,2/3,
					//],2*4),
				//],inf),
				//\speed, Pwhite(1,1.01),
				//\sustain, 0.1 * Pseq([
					//1,3/5,4/5,3/5,
					//2,3/5,4/5,3/5,
				//],inf),
				//\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			//)),
			//Pbind(
				//\instrument, \phyhat3,
				//\isRest, Pseq([
					//1,0,0,1, 1,0,1,0, 1,0,0,0, 1,0,1,1,
					//1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					//1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				//],inf).coin.not,
				//\sustain, 0.05,
				//\fac1,0.2,
				//\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
				//\amp, 0.01 * Pseq([1,0.7],inf),
			//),
		//]),

		//Pmono( \rdncleandist_fulllight,
			//\inbus, BusDef(\drums1, \audio, 2),
			//\addAction, \addToTail,
			//'wet10', 1.0,
			//'mix', 0.55714285714286,
			//'gain', 0.7344889782792,
			//'fb', 0.0002099467303085,
			//'delay', 0.0000600001231 * Pseq([
				//1,
			//],inf).stutter(1),
			//'delay2', 0.0000543560101,
			//'distamp', 1.361836201538,
			//'prelpf', 8900,
			//'prehpf', 17,
			//'lpf', 9900,
			//'hpf', 17,
			//'fbdistamp', 4.5388371966577,
			//'fbdistmix', 0.98176470588235,
			//'postlpf', 19900,
			//'posthpf', 17,
			//\bpmix, 0,
			//'wetamp', 0.20503372119697,
			//'indelay', 0.04,
			//'wet20', 1.0,
			//'mamp', 1,
			//\dur, 1,
		//),
		//Pmono( \rdncleandist_fulllight,
			//\inbus, BusDef(\drums1, \audio, 2),
			//\addAction, \addToTail,
			//'wet10', 1.0,
			//'mix', 0.25714285714286,
			//'gain', 0.9344889782792,
			//'fb', 0.0002099467303085,
			//'delay', 0.000200001231 * Pseq([
				//1,
			//],inf).stutter(1),
			//'delay2', 0.0000543560101,
			//'distamp', 1.361836201538,
			//'prelpf', 19900,
			//'prehpf', 917,
			//'lpf', 19900,
			//'hpf', 117,
			//'fbdistamp', 4.5388371966577,
			//'fbdistmix', 0.98176470588235,
			//'postlpf', 19900,
			//'posthpf', 170,
			//\bpmix, 0,
			//'wetamp', 0.20503372119697,
			//'indelay', 0.04,
			//'wet20', 1.0,
			//'mamp', 1,
			//\dur, 1,
		//),
		//Pmono( \rdncleandist_fulllight,
			//\inbus, BusDef(\drums1, \audio, 2),
			//\addAction, \addToTail,
			//'wet10', 1.0,
			//'mix', 0.25714285714286,
			//'gain', 0.9344889782792,
			//'fb', 0.0002099467303085,
			//'delay', 0.000200001231 * Pseq([
				//1,1.3,1/2,
			//],inf).stutter(1),
			//'delay2', 0.1000543560101,
			//'distamp', 2.361836201538,
			//'prelpf', 19900,
			//'prehpf', 13917,
			//'lpf', 19900,
			//'hpf', 117,
			//'fbdistamp', 4.5388371966577,
			//'fbdistmix', 0.98176470588235,
			//'postlpf', 19900,
			//'posthpf', 170,
			//\bpmix, 0,
			//'wetamp', 0.20503372119697,
			//'indelay', 0.04,
			//'wet20', 1.0,
			//'mamp', 1,
			//\dur, 1/4,
		//),
	])
)).play;
)


(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 400*~t,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
			//	\out, BusDef(\smpsendbus1, \audio),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),

		Pbind(\out, BusDef(\drums1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,1,0,1,
					0,0,0,0, 0,1,0,0,
					0,1,0,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,

					0,0,0,0, 1,0,1,0,
					0,1,1,0, 1,0,1,1,
					0,1,0,1, 1,0,1,0,
					0,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					//Pseq([
						//1,1/3,1/2,1/3,
					//],2*4),
					Pseq([
						1,2/3,1/2,2/3,
					],2*4),
				],inf),
				\speed, Pwhite(1,1.01),
				\sustain, 0.1 * Pseq([
					1,3/5,4/5,3/5,
					2,3/5,4/5,3/5,
				],inf),
				\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0, 1,0,0,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.2,
				\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

	])
)).play;
)

////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				//\fspread, 1/Pkey(\freq) * 2,
				\fspread, 0.001,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/2,
				\amp, 0.1,
			),
	])
)).play;
);

(
SynthDef(\longfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8, fspread=0.01;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*\fmf.kr(0.2)) * \fma.kr(1) + 1 )) * ( SinOsc.ar(freq * \fmf2.kr(0.2)) * \fma2.kr(1) + 1 );
	sig = sig + SinOsc.ar(freq * SinOsc.ar(freq*1/2,mul:0.2) ); 
	sig = sig * 0.5;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind(
				\instrument, \longfm,
				\note, Pseq([
					//18,0,7,8
					0,4,7
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				//\fspread, 0.0001,
				\fmf, 1.2,
				\fmf2, 0.2,
				\fmf2, PmodEnv(Pseq([0.1,1],1), 8).loop,
				\fmf, PmodEnv(1-Pseq([0.1,1],1), 8).loop,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\legato, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \default,
				\note, Pseq([
					0,7,
				],inf),
				\dur, 1,
				\amp, 0.1,
			),
	])
)).play;
);
