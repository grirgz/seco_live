~t = 219/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1395].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1447].value,
			\legato, Pseq([
				1,0,2,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				4,0,0,0, 1,0,2,0, 
				1,0,1,0, 2,0,1,0, 
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[394].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[154].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[132].value, // 132 good hat
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2353].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1395].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1447].value,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,2,0, 1,0,1,0, 
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				4,0,0,0, 1,0,2,0, 
				1,0,1,0, 2,0,1,0, 
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[394].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);



ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-2PI2-D88V", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 1,
	'fb', 0.00023201614956307,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 19.121088211933,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);



(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
SynthDef(\nappy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var cfreq = freq * \chord.kr(1!4);
	var num = 4 * 2 * 5;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var amps;
	//freq.poll(label:"freq");
	lfo1 = SinOsc.kr(0.1) * 0.001 * \lfo1range.kr(1);
	lfo3 = LFNoise1.kr(0.1!num).range(0.3,3); 
	lfo5 = LFNoise1.kr(0.1!num).range(0.3,0.7); 
	lfo2 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1, timeScale: lfo3, levelScale: lfo5);
	lfo4 = EnvGen.kr(Env([1,2,1],[0.7,0.8]), 1, timeScale: lfo3);
	cfreq = cfreq *.x [1 - lfo1,1 + lfo1] * [ [1/2,1,2,7,9] ];
	amps = [0.6,1,0.6,0.1,0.1];
	cfreq.debug("cfreq");
	sig = SelectX.ar( LFNoise1.kr(1/2!num).range(0.0,1.0) ,[
		SinOsc.ar(cfreq) * amps,
		LFSaw.ar(cfreq) * amps,
	].collect(_.flatten)) * 5;
	sig.debug("sig");
	//sig = sig * ( SinOsc.ar(freq/2 * ( SinOsc.ar(freq/4 + Rand(0.0,1!sig.size)) * 0.71 + 1 )) * 0.7 + 1 );
	sig = sig * sig.fold( ( SinOsc.kr(0.11) * 0.1 + 1 ).neg, ( SinOsc.kr(0.3) * 1 + 1 ) );
	//sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).poll, \rq.kr(0.5) * lfo4);
	sig = RLPF.ar(sig, ( \lpf.kr(10001.1) * lfo2 ).clip(10,20000), \rq.kr(0.5) * lfo4);
	sig = HPF.ar(sig,\hpf.kr(30));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Psched(16,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		)),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);


(1..10)[[0,3,1]]

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/4 * ~t / Pkey(\st),
			\speed, 1/2,
			\pos, Pseg(Pseq([
				0, 1,
			],1),4).loop / Pkey(\st),
			//\pos, 0,
			\dur, 1/1,
			\gain, 1/2,
		),
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[154].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[132].value, // 132 good hat
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[2353].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	]),

	Ppar([
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1497].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[320].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		Psched(0,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[320].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1497].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		)),
		
	])
		
	])
)).play;
);



/////////////:


def foo(s):
    def foo_helper(level=0):
        try:
            token = next(tokens)
        except StopIteration:
            if level != 0:
                raise Exception('missing closing paren')
            else:
                return []
        if token == ')':
            if level == 0:
                raise Exception('missing opening paren')
            else:
                return []
        elif token == '(':
            return [foo_helper(level+1)] + foo_helper(level)
        else:
            return [token] + foo_helper(level)
    tokens = iter(s)
    return foo_helper()

(
~foo = { arg s;
	var tokens;
	var foo_helper = { arg level = 0;
		var token = tokens.next;
		if(token.isNil) {
			if(level != 0) {
				"missing opening paren".throw;
			} {
				[]
			};
		} {
			if(token == $) ) {
				if(level == 0) {
					"missing opening paren".throw;
				} {
					[]
				};
			} {
				if(token == $( ) {
					[foo_helper.(level+1)] ++ foo_helper.(level);
				} {
					[token] ++ foo_helper.(level)
				};
			};
		};
	};
	tokens = s.iter;
	foo_helper.()
};
~foo.("(bla (haha) ii)")
)
"kjkj".as(Array).asStream.next.dump
"kjkj".iter.next.dump

(1..30).next


(
Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	sig = sig * \gain.kr(1);
	//sig = sig * ( LFSaw.kr( LFNoise0.kr(1).unipolar * 5600 ) * 1 + 1 );
}).play(BusDef(\soundin, \audio, 2).index, 2);
);
Ndef(\soundin).play(0,2)
Ndef(\soundin).edit;


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 160;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = ExpRand(10,19000!num);
	sig = SinOsc.ar(freq).mean*40*2 * LFNoise1.kr(1/2!num).range(0.0,1.0);
	sig = BPF.ar(sig, LFNoise1.kr(ExpRand(0.01,2!num)).exprange(10,1900), LFNoise1.kr(1/2!num).range(0.1,1.0) );
	pan = pan + LFNoise1.kr(1/2!sig.size).range(-1.0,1.0);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
Ndef(\zed).play(BusDef(\sendbus1,\audio).index)

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 160;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = EnvGen.kr(Env([0,2,0],[0.1,0.8]/22), Dust.kr( Line.kr(0.1,10,20)!num));
	freq = ExpRand(10,19000!num);
	sig = SinOsc.ar(freq * (sig1+1)).mean*40*2 * LFNoise1.kr(1/2!num).range(0.0,1.0);
	sig = BPF.ar(sig, LFNoise1.kr(ExpRand(0.01,2!num)).exprange(10,1900), LFNoise1.kr(1/2!num).range(0.1,1.0) );
	pan = pan + LFNoise1.kr(1/2!sig.size).range(-1.0,1.0);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 160;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ramp;
	ramp = DelayL.kr(Line.kr(0.01,1,2), (1..20)*2, (1..20)*2);
	sig1 = EnvGen.kr(Env([0,2,0],[0.1,0.8]/22), Dust.kr( ramp[0]!num));
	freq = ExpRand(10,19000!num);
	sig = SinOsc.ar(freq * (sig1+1)) * SelectX.kr(ramp[2], [1,LFNoise1.kr(1/2!num).range(0.0,1.5)]);
	sig1 = BPF.ar(sig.mean*50, LFNoise1.kr(ExpRand(0.01,2!num)).exprange(10,1900), LFNoise1.kr(1/2!num).range(0.1,1.0) );
	sig = SelectX.ar(ramp[5].poll, [sig*2, sig1]);
	pan = pan + SelectX.kr(ramp[3], [0,LFNoise1.kr(1/2!sig.size).range(-1.0,1.0)]);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\drone1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 160;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ramp, ramp2;
	ramp = DelayL.kr(Line.kr(0.01,1,2), (1..20)*2, (1..20)*2);
	ramp2 = EnvGen.kr(Env([1,1,0.7],[0.01,0.8]*8/~t), Impulse.kr(1/4*~t));
	sig1 = EnvGen.kr(Env([0,2,0],[0.1,0.8]/22), Dust.kr( ramp[0]!num));
	freq = ExpRand(10,19000!num);
	sig = SinOsc.ar(freq * (sig1+1) * ramp2) * SelectX.kr(ramp[2], [1,LFNoise1.kr(1/2!num).range(0.0,1.5)]);
	sig1 = BPF.ar(sig.mean*50, LFNoise1.kr(ExpRand(0.01,2!num)).exprange(10,1900), LFNoise1.kr(1/2!num).range(0.1,1.0) );
	sig = SelectX.ar(ramp[5].poll, [sig*2, sig1]);
	pan = pan + SelectX.kr(ramp[3], [0,LFNoise1.kr(1/2!sig.size).range(-1.0,1.0)]);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
Ndef(\drone1).quant = 1;
Ndef(\drone1).play(BusDef(\comp,\audio).index);

(
SynthDef(\drone1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 160;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ramp, ramp2;
	ramp = DelayL.kr(Line.kr(0.01,1,2), (1..20)*2, (1..20)*2*\delayfac.kr(1));
	ramp2 = EnvGen.kr(Env([1,1,0.7],[0.01,0.9]), Impulse.kr(\freqramp.kr(1/4*~t)), timeScale:\timeScale.kr(8/~t));
	sig1 = EnvGen.kr(Env([0,2,0],[0.1,0.8]/22), Dust.kr( ramp[0]!num));
	freq = ExpRand(10,19000!num);
	sig = SinOsc.ar(freq * (sig1+1) * ramp2) * SelectX.kr(ramp[2], [1,LFNoise1.kr(1/2!num).range(0.0,1.5)]);
	sig1 = BPF.ar(sig.mean*50, LFNoise1.kr(ExpRand(0.01,2!num)).exprange(10,1900), LFNoise1.kr(1/2!num).range(0.1,1.0) );
	sig = SelectX.ar(ramp[5], [sig*2, sig1]);
	pan = pan + SelectX.kr(ramp[3], [0,LFNoise1.kr(1/2!sig.size).range(-1.0,1.0)]);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, Pwhite(0.1,0.3),
			\pos, 1 + Pwhite(0,0.2),
			\sustain, 0.1/7,
			\gain, 1/2,
		)!4)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, Pwhite(0.1,0.3),
			\pos, 1 + Pwhite(0,0.2),
			\sustain, 0.1/7,
			\gain, 1/2,
			\out, BusDef(\sendbus1, \audio),
		)!4),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 58, 51], [0.035, 1.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.5, 0.3,2) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.152,
			//\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[111].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


Ndef(\rdn).put(101, \pset -> Pbind(
	\delay1, 
))
Ndef(\rdn).set(\delay2, Ndef(\lfo1, { LFSaw.ar(1/8/2*~t).exprange(0.00001,1)  }).quant =2)

/////////////////////////////////////////////////////////////////////Ypp
/////////////////////////////////////////////////////////////////////Ypp
/////////////////////////////////////////////////////////////////////Ypp

~t = 132/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 58, 51], [0.035, 1.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.5, 0.3,2) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[111].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			//\dur, Pswitch1(
				//[
					//Pwhite(0.1,0.3),
					//1,
				//], 
				//Pstep([0,1],2,inf),
			//).trace,
			\speed, 2,
			\isRest, Pstep(Pseq([
				0,0,1,1, 0,0,1,0,
				0,1,1,0,
			],inf),1/2).coin.not,
		)<>
		Ppar(Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, Pwhite(0.1,0.3),
			\pos, 1 + Pwhite(0,0.2),
			\sustain, 0.1/7,
			\gain, 1/8,
		)!4),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\speed, 2,
			\dur, 2,
			\pos, 1 + Pwhite(0,0.2),
			\gain, 1/8,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
		),
		Pmono(\drone1,
			\freq, 200,
			\dur, 1,
			\amp, 0.3,
			\delayfac, 0,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\comp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\hpf, 820,
			\mix, Ndef(\amplitude, { ( Amplitude.kr(InFeedback.ar(BusDef(\sideinbus)))+0.91 ).lag(0.01).poll }),
			\gain,1,
			\dur, 1/8,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\isRest, true,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			//\dur, Pswitch1(
				//[
					//Pwhite(0.1,0.3),
					//1,
				//], 
				//Pstep([0,1],2,inf),
			//).trace,
			\speed, 2,
			\isRest, Pstep(Pseq([
				0,0,1,1, 0,0,1,0,
				0,1,1,0,
			],inf),1/2).coin.not,
		)<>
		Ppar(Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, Pwhite(0.1,0.3),
			\pos, 1 + Pwhite(0,0.2),
			\sustain, 0.1/7,
			\gain, 1/8,
		)!4),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\speed, 2,
			\dur, 2,
			\pos, 1 + Pwhite(0,0.2),
			\gain, 1/8,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 58, 51], [0.035, 1.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.5, 0.3,2) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\drone1,
			\freq, 200,
			\dur, 1,
			\amp, 0.3 * Pstep(Pseq([
				1,1,1,1,
				0,0,1,1,
			],inf),1),
			\delayfac, 0,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\comp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\hpf, 820,
			\mix, Ndef(\amplitude, { ( Amplitude.kr(InFeedback.ar(BusDef(\sideinbus)))+0.91 ).lag(0.01).poll }),
			\gain,1,
			\dur, 1/8,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[111].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/4 * ~t / Pkey(\st),
			\speed, 1/2,
			\pos, 
			Pseq([
				Pseg(Pseq([
					0,1,
				],1),4),
				Pseg(Pseq([
					0,1,
				],1),4),
				Pseg(Pseq([
					0,0.25,0.5,0,1
				],1),1),
				Pseg(Pseq([
					0,1,
				],1),4),
			],inf) / Pkey(\st),
			//\pos, 0,
			\dur, 1/8,
			\gain, 1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[995].value,
			\isRest, Pseq([
				1,1, 1,1, 1,1,
				1,1, 1,1, 1,1,
				1,1, 1,1, 1,1,
				1,1, 1,1, 1,1,

				1,1, 1,1, 1,1,
				1,1, 1,1, 1,1,
				0,0,0, 0,0,0,
				1,1, 1,1, 1,1,
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \stepwave,
			\freq, 200,
			\dur, 1/6,
			\legato, Pseq([
				1,1,1,1, 1,3,0,0,
				1,2,0,1, 1,1,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
		),
		
	])
)).play;
);




(
SynthDef(\stepwave, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.kr(1/3*~t * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1)) * 1 + 1 ) );
	sig = RLPF.ar(sig, \lpfr.kr(1.8) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\stepwave, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,0.2,1],[0.01,0.2]), 1);
	sig = LFSaw.ar(freq * env1 * ( SinOsc.kr(1/3*~t * ((0..7)/7 - 0.5 * \fspread.kr(0.001) + 1)) * 1 + 1 ) );
	sig = RLPF.ar(sig, \lpfr.kr(1.8) * freq  * EnvGen.kr(Env([4,0.1,4],[0.01,0.8]), 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			//\dur, Pswitch1(
				//[
					//Pwhite(0.1,0.3),
					//1,
				//], 
				//Pstep([0,1],2,inf),
			//).trace,
			\speed, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\isRest, Pstep(Pseq([
				0,0,1,1, 0,0,1,0,
				0,1,1,0,
			],inf),1/2).coin.not,
		)<>
		Ppar(Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, Pwhite(0.1,0.3),
			\pos, 1 + Pwhite(0,0.2),
			\sustain, 0.1/7,
			\gain, 1/8,
		)!4),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\speed, 2,
			\dur, 2,
			\pos, 1 + Pwhite(0,0.2),
			\gain, 1/8,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 58, 51], [0.035, 1.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.5, 0.3,2) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\drone1,
			\freq, 900,
			\dur, 1,
			\timeScale, 1/2/~t,
			\amp, 0.3 * Pstep(Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf),1),
			\delayfac, 0,
			\out, BusDef(\comp, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \drone1,
			\legato, Pseq([
				6,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
				6,0,0,0, 0,0,6,0,
				0,0,0,0, 4,0,0,0,
			],inf)*0.99,
			\timeScale, 1/2/~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\comp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\hpf, 820,
			\mix, Ndef(\amplitude, { ( Amplitude.kr(InFeedback.ar(BusDef(\sideinbus)))+0.91 ).lag(0.01).poll }),
			\gain,1,
			\dur, 1/8,
		),
		
	])
)).play;
);
