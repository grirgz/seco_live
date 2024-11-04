
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
BufDef(\loop, s.sampleRate * 4 / ~t, 2);
BufDef(\mexico, "/home/ggz/Musique/helmut-zacharias-mexico-melody.flac");

SynthDef(\looper, { arg out=0, gate=1, bufnum;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	RecordBuf.ar(sig, bufnum: bufnum, offset: 0, recLevel: 1, preLevel: \preLevel.kr(1), run: 1, loop: 1, trigger: 1, doneAction: 0);
	sig = PlayBuf.ar(2, bufnum: bufnum, rate: 1, trigger: Delay1.ar(Impulse.ar(0)), startPos: 0, loop: 1, doneAction: 0);
	//sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
)


(
BufDef(\loop).zero;
Pdef(\looper, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pwhite(0,45),
			],inf),
			\octave, 3,
			\dur, Pwrand([1,1/2,1/4,1/8],(1..4).normalizeSum,inf),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\preLevel, 0.8,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)

(
BufDef(\loop).zero;
Pdef(\looper, 
	Ppar([
		Pbind(
			\instrument, \chaosfm2,
			\fmamp, Pseq([0.2,0.3,0.6,0.8],inf).stutter(1),
			\diff, Pwhite(0.01009,0.00001),
			\fb, Pwhite(0.76,0.75)/1.4,
			\degree, Pseq([
				Pwhite(0,25),
			],inf) + Pwrand([0,0.1,-0.1],[1,1/10,1/10].normalizeSum,inf),
			\scale, Scale.choose,
			\root, rrand(0,12),
			\octave, 3,
			\dur, Pwrand([1,1/2,1/4,1/8],(1..4).normalizeSum,inf),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\preLevel, 0.8,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)




(
BufDef(\loop).zero;
Pdef(\part2, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8 + (7/32),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\bus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[134].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\bus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1789].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\bus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[169].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,1, 0,1,0,0,0,0
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
			\out, BusDef(\bus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bus1, \audio, 2),
			//\out, BusDef(\bus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			//'delay', 0.000600001231 * Pseq([
				//~pmodenv.(Pseq([1,2,1,4,1000],inf), 7),
			//],inf).stutter(1),

			\delay, 0.000001,
				\delay, ~pmodenv.(Pseq([1,2001,4,10000,0.1,100000],inf)*0.00001, 7),
			'delay2', 0.000000543560101,
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
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\preLevel, 0.8,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
