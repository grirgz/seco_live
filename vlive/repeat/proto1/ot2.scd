
(
Ndef(\snow, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var size = 100;
	var trig = Impulse.kr({ rrand(1/100,100.0) } ! size * \density.kr(1));
	sig = SinGrain.ar(trig,0.1, { exprand(100.0,16000) } ! size * \tone.kr(1)) * ( { rrand(0.01,1) } ! size );
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\snow, { arg freq=200, pan=0, amp=0.1, speed=1;
	var sig;
	var size = 100;
	var trig = Impulse.kr({ rrand(1/100,100.0) } ! size * \density.kr(1));
	sig = SinGrain.ar(trig,0.1, { exprand(100.0,16000) } ! size * \tone.kr(1)) * ( { rrand(0.01,1) } ! size );
	sig = sig.collect({ arg sig, x;
		sig = sig.fold2( SinOsc.kr(1/23 * ( x+1 ) * speed).range(0.01,8) ) * 4;
		sig = sig * SinOsc.kr(1/26 * ( x+1 ) * speed).range(0.01,1);
	});
	sig = Pan2.ar(sig, ( { rrand(-1.0,1) } ! size ), amp).mean;
}).play;
);

(
Ndef(\snow, { arg freq=200, pan=0, amp=0.1, speed=1;
	var sig;
	var size = 20;
	var trig = Impulse.ar({ rrand(1/1,15.0) } ! size * \density.kr(1));
	sig = { WhiteNoise.ar } ! size;
	sig = sig.collect({ arg sig, x;
		var bpfreq = exprand(50.0,16000) * \tone.kr(1);
		var bpfrq = 0.1 * SinOsc.ar(( x+1 ) * 1/153 * speed).exprange(0.1,4) * \blur.kr(1);
		sig = BPF.ar(sig,  bpfreq, bpfrq) * 34;
		sig = BPF.ar(sig,  bpfreq, bpfrq) * 4;
		sig = sig * EnvGen.ar(Env([0,1,0],[0.1,0.8]), trig[x]);
		//sig = sig.fold2( LFNoise0.kr(1/23 * ( x+1 ) * speed).range(0.01,8) ) * 4;
		sig = sig * SinOsc.ar(1/700 * ( x+1 ) * speed).range(0.01,1);
	});
	sig = Pan2.ar(sig, ( { rrand(-1.0,1) } ! size * SinOsc.ar(1/132 * (1..size) * speed).range(0,1) ), amp).mean;
}).play;
);
Ndef(\snow).fadeTime = 16;
Ndef(\snow).edit;

(1..10).size
( { rrand(-1.0,1) } ! size * SinOsc.kr(1/132 * (1..size) * speed).range(0,1) )
1

[1,2] * [1,2]

(
Ndef(\snow, { arg freq=200, pan=0, amp=0.1, speed=1;
	var sig;
	var size = 20;
	var trig = Impulse.ar({ rrand(1/1,15.0) } ! size * \density.kr(1));
	//sig = SinGrain.ar(trig,0.1, { exprand(50.0,16000) } ! size * \tone.kr(1)) * ( { rrand(0.01,1) } ! size );
	sig = { WhiteNoise.ar } ! size;
	sig = sig.collect({ arg sig, x;
		var bpfreq = exprand(50.0,16000) * \tone.kr(1);
		var bpfrq = 0.1 * SinOsc.ar(( x+1 ) * 1/153 * speed).exprange(0.1,4) * \blur.kr(1);
		sig = BPF.ar(sig,  bpfreq, bpfrq) * 34;
		sig = BPF.ar(sig,  bpfreq, bpfrq) * 4;
		sig = sig * EnvGen.ar(Env([0,1,0],[0.1,0.8]), trig[x]);
		//sig = sig.fold2( LFNoise0.kr(1/23 * ( x+1 ) * speed).range(0.01,8) ) * 4;
		sig = sig * SinOsc.ar(1/700 * ( x+1 ) * speed).range(0.01,1);
	});
	sig = Pan2.ar(sig, ( { rrand(-1.0,1) } ! size * SinOsc.ar(1/132 * (1..size) * speed).range(0,1) ), amp).mean;
}).play;
);


(
SynthDef(\soufle, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var size = 10;
	var col = (1..size);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = size.collect { arg x;
		var xx = x+1;
		//sig = SinOsc.ar(exprand(100.0,13000));
		sig = WhiteNoise.ar;
		env1 = EnvGen.kr(Env([size-x/size+0.01,x/size+0.01,1],[0.1,0.8]), 1);
		sig = BPF.ar(sig, exprand(100.0,13000) * (rrand(-1,1) * \tone.kr(0) + 1), rrand(0.01,0.1) * env1) * 7;
		sig = sig * EnvGen.kr(Env([1,0,1,0],[0.1/(x),0.01,0.1 +(x/10)]), 1);
		sig;
	};
	sig = sig * 2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.4,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\soufle, Pbind(
	\instrument, \soufle,
	\degree, Pseq([0],inf),
	\legato, Prand([0.1,1.8],inf),
	\legato, 5,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\out, BusDef(\bus1),
	\amp, 0.3
)).play;
);

(
Pdef(\soufle, Pbind(
	\instrument, \soufle,
	\degree, Pseq([0],inf),
	\legato, Prand([0.1,1.8],inf),
	\legato, 0.5,
	\tone, Pwhite(0.9,1),
	\tone, Pseq([
		0.91,0.5,
	],inf).stutter(8),
	\tone, Pseg(Pseq([0.1,0.91],inf),8),
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	//\out, BusDef(\bus1),
	\amp, 0.3
)).play;
);
Pdef(\soufle).stop

////////////////////////////
(
Ndef(\snow).put(0, { arg freq=200, pan=0, amp=0.1, speed=1;
	var sig;
	var size = 20;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus2, \audio)), 2); 
	var trig = Impulse.kr({ rrand(1/100,100.0) } ! size * \density.kr(1));
	sig = WhiteNoise.ar ! size;
	sig = sig.collect({ arg sig, x;
		sig = BPF.ar(sig, exprand(40,4300), 0.1);
		sig = sig.fold2( SinOsc.kr(1/23 * ( x+1 ) * speed).range(0.01,8) ) * 4;
		sig = sig * SinOsc.kr(1/26 * ( x+1 ) * speed).range(0.01,1);
	});
	sig = Compander.ar(sig, in, \cpt.kr(0.04), \cpbelow.kr(1), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.01));
	sig = sig / 1;
	sig = Pan2.ar(sig, ( { rrand(-1.0,1) } ! size ), amp).mean;
}).play;
Ndef(\snow).put(1, \set -> Pbind(
	\tone, Pseq([1,1,0.3,2]/1,inf),
	\dur, 1/4,
);)
);

(
Ndef(\snow).put(0, { arg freq=50, pan=0, amp=0.1, speed=1;
	var sig;
	var size = 20;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus2, \audio)), 2); 
	sig = SinOsc.ar(freq * [1,1.01,2.021] * ( 1 + ( SinOsc.ar(110 * ( LagUD.ar(Amplitude.ar(in), 0,2)*8+1 )) * 0.1 ))); 
	sig = Compander.ar(sig, in, \cpt.kr(0.34), \cpbelow.kr(0.1), \cpabove.kr(1.0), \cpclamp.kr(0.06), \cprelax.kr(0.1));
	sig = sig / 70;
	sig = sig.tanh / 1;
	sig = LPF.ar(sig, 12000) + ( sig/4 );
	sig = LPF.ar(sig, 200, mul:2) + ( sig/4 );
	sig = Pan2.ar(sig, 0, amp).mean;
	sig = sig * 2;
}).play;
Ndef(\snow).put(1, \set -> Pbind(
	\degree, Pseq([0,0,1,1, 7,0,5,1],inf),
	\octave, 3,
	\dur, 1/4,
);)
);



(
n = 60;
a = List[1];
b = Pseq([4, 5, 9, 7], inf).iter;
n.do { var x = a.last; a.add(x + b.next) };
)

(
p = { |i| a[i]!2 }.dup(n).plot(minval: 0, maxval: a.last + 1);
p.superpose_(true);
c = Color.fromHexString("#DDDDDD");

p.setProperties(
        \plotColor, Color.black,
        \backgroundColor, c,
        \gridColorX, c,
        \gridColorY, c
);

p.refresh;
)


(
Ndef(\nop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * EnvGen.kr(Env([1,2,1],[0.1,2.8]).circle, 1);
	freq = freq * ( 1 + ( SinOsc.ar( SinOsc.kr((1..9)/12).range(1/2,2) * 1/4 * freq ) * SinOsc.kr((1..9)/10).exprange(0.01,32) ));
	//sig = SinOsc.ar(freq);
	sig = 0;
	sig = sig + LFCub.ar(freq);
	sig = sig.clip2(1);
	//sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	//sig = sig / 8;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
Ndef(\nop).clear

(
Ndef(\nop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	//freq = 2 * (1..100) + 50;
	freq = 1 * (1..102).clump(2).collect({ arg x; var y = SinOsc.kr(1+x/100).range(0,1); [x[0]+y, x[1]-y]; }).flat + 50;
	//freq = [110,220];
	sig = SinOsc.ar(freq) * 8 * 2; 
	sig = LPF.ar(sig, 1700);
	sig = HPF.ar(sig, 100);
	//sig = sig.tanh;
	//sig = Pan2.ar(sig, SinOsc.kr((1..100)/1000), amp).mean;
	sig = Pan2.ar(sig, 0, amp).mean;
	//sig = sig + DelayL.ar(sig, 1/4, 1/4);
}).play;
);

(
Ndef(\pin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sa = (1..10)/10;
	freq = sa;
	freq = SinOsc.ar(freq * 1) * ( freq * 1000 );
	freq = SinOsc.ar(freq * 1) * ( freq * 1 );
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
Ndef(\pin).clear

(
Ndef(\pin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sa = (1..10)/10;
	freq = sa;
	freq = SinOsc.ar(freq * 1) * ( freq * 1000 );
	freq = SinOsc.ar(freq * 1) * ( freq * 1 );
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

{ SinOsc.ar((1..100)*2) ! 2 * 0.01}.play;
a = { SinOsc.ar((1..100)*MouseX.kr(1,100)).tanh ! 2 * 0.01}.play;
a = { SinOsc.ar((1..100)*3).tanh ! 2 * 0.01}.play;
a.release
a = { Klang.ar(`[(1..100)*2]) ! 2 * 0.01}.play;
Ndef(\minitek, { SinOsc.ar((1..100) * 2).mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).tanh.mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).fold2(0.51).mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100) * 2).tanh.mean ! 2  }).play
Ndef(\minitek2, { SinOsc.ar((1..100) * 4).mean ! 2  }).play
Ndef(\minitek3, { SinOsc.ar((1..100) * 1).tanh.mean ! 2  }).play
Ndef(\minitek4, { SinOsc.ar((1..100) * Duty.kr(1,0,Dseq([16,2,8,2],inf))).mean ! 2 * 0.5  }).play
Ndef(\minitek3, { LPF.ar(SinOsc.ar((1..140) * 4, mul:[ LFPulse.kr(1/8).range(0,1),0.4,1, SinOsc.kr(1/2).range(0,1)]).mean, 700) ! 2  }).play

(
Ndef(\bass, { arg freq=70, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [1,1.01]);
	sig = (sig * 2).fold2(0.8);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
NdefMixer.new(s)
Ndef.defaultQuant = 2


~buf = Buffer.new(s, 44100 * 8.0, 2);
~buf.play
