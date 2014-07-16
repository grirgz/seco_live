2* -10.dbamp
(2* -10).dbamp


~bus = Bus.audio(s,2);



(

~name = \kickfb;



SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|

	var env0, env1, env1m, son;



	//freqpan = [-1,0,1] * freqpan;

	freqpan = [1,0,-1] * freqpan;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));

	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));

	

	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);

	env1 = EnvGen.ar(env1, timeScale:timeScale);

	env1m = env1.midicps;

	

	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);

	son = son + WhiteNoise.ar(1);

	son = LPF.ar(son, env1m*fratio, env0);

	son = son + SinOsc.ar(env1m, 0.5, env0);

	

	son = son * 1.2;

	son = son.clip2(1);



	son = son * amp;

	son = Splay.ar(son, spread, amp, pan);

	

	OffsetOut.ar(out, son);

}).add;

);



(



Pdef(~name, Pbind(

	\instrument, ~name,

	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],

	\env1, [ Env.new([110, 53, 29], [0.015, 0.29], [-4, -5]) ],

	\pan, Pseq([

		Pser([0],17),

		Pwhite(-1.0,1.0,16-1)

	],inf).stutter(1) * 0.5,

	\spread, 0.1,

	\dur, 1/4,

	\out, ~bus,

	\amp, 0.51,

	\isRest, Pseq([1,0,1,0, 0,0,0,0],inf).coin.not,

)).play;



Ndef(~name, {

	var in = InFeedback.ar(~bus,2);

	var sig = in;



	sig = Fb({ arg fb;

		var del;

		var freqshift;

		fb = sig + (fb * 0.97 * \fb.kr(1));

		freqshift = \freqshift.kr(1);

		freqshift = Duty.ar(1, 0, Dseq([10,0,-20,0]*freqshift,inf) + Dstutter(8,Dseq([0,-50,0,50],inf)));

		fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;

		fb;



	},\delay.kr(0.1));

	sig = Normalizer.ar(sig, 0.99,0.01);

	sig = sig / 2;

	

	sig;

}).play;

);



Ndef(~name).edit

Ndef(~name).end

Ndef(~name).play

Ndef(~name).set(\fb, 1, \delay, 0.1, \freqshift, 1)







{ SinOsc.ar(10).lag(4/1) }.plot(1)
Ndef(\x, { LFPulse.ar(MouseX.kr(50,1000 * (0.0001*(1..8)+1)).lag(MouseY.kr(0.001,10))) ! 2 * 0.1 }).play
Ndef(\x).clear






    ~bus = Bus.audio(s,2);
     
    (
    ~name = \kickfb;
     
    SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
        var env0, env1, env1m, son;
     
        //freqpan = [-1,0,1] * freqpan;
        freqpan = [1,0,-1] * freqpan;
        env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
        env1 = \env1.kr(Env.new([80, 49, 29], [0.105, 0.29], [-4, -5]));
       
        env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
        env1 = EnvGen.ar(env1, timeScale:timeScale);
        env1m = env1.midicps;
       
        son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
        son = son + WhiteNoise.ar(1);
        son = LPF.ar(son, env1m*fratio, env0);
        son = son + SinOsc.ar(env1m, 0.5, env0);
       
        son = son * 1.2;
        son = son.clip2(1);
     
        son = son * amp;
        son = Splay.ar(son, spread, amp, pan);
       
        OffsetOut.ar(out, son);
    }).add;
    );
     
    (
     
    Pdef(~name, Pbind(
        \instrument, ~name,
        \env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
        \env1, Pfunc{[ Env.new([100, 16.0.rand + 40, 35], [0.015, 0.29], [-4, -5]) ]},
        \pan, Pseq([
            Pser([0],17),
            Pwhite(-1.0,1.0,16-1)
        ],inf).stutter(1) * 0.5,
        \spread, 0.1,
        \dur, 1/4,
        \out, ~bus,
        \amp, 0.51,
        \isRest, Pseq([1,0.2],inf).coin.not,
    )).play;
     
    Ndef(~name, {
        var in = InFeedback.ar(~bus,2);
        var sig = in;
     
        sig = Fb({ arg fb;
            var del;
			var delay;
            fb = sig + (fb * 0.97 * \fb.kr(1));
            delay = Duty.ar(1, 0, Dseq([
				1/8, 1/4, 1/16, 1/8,
				1/8, 1/4, 1/256, 1/8,
				1/32, 1/64, 1/1, 1/56
			],inf));
			fb = fb + DelayL.ar(fb, 1, delay);
			fb = fb/4;
            fb;
     
        },0);
		sig = LPF.ar(sig,(CuspN.ar(sig.midicps * 10,MouseX.kr(0,400),MouseY.kr(0,400)).abs/11).clip(50,19000).lag(0.01).poll + 50); 
        sig = Normalizer.ar(sig, 0.99,0.01);
        sig = sig / 2;
       
        sig;
    }).play;
    );
     
    Ndef(~name).edit
    Ndef(~name).end
    Ndef(~name).play
    Ndef(~name).set(\fb, 1, \delay, 0.1, \freqshift, 10,\crash,200)







    (
    Pdef(~name, Pbind(
        \instrument, ~name,
        \env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
        \env1, [ Env.new([50, 53, 49], [0.015, 0.29], [-4, -5]) ],
        \pan, Pseq([
            Pser([0],17),
            Pwhite(-1.0,1.0,16-1)
        ],inf).stutter(1) * 0.5,
        \spread, 0.1,
        \dur, 1/4,
        \out, ~bus,
        \amp, 0.51,
        \isRest, Pseq([1,0.6,0.6,0.6, 1,1,0.3,0.3],inf).coin.not,
    )).play;
     
    Ndef(~name, {
        var in = InFeedback.ar(~bus,2);
        var sig = in;
		var sig1;
        sig = Fb({ arg fb;
            var del;
            var freqshift;
            fb = sig + (fb * 0.97 * \fb.kr(1));
            freqshift = \freqshift.kr(1);
            freqshift = Duty.ar(1/8, 0, Dseq([10,-20]*freqshift,inf) + Dstutter(2,Dseq([
				0,100,100,50,
				0,100,80,50,
				0,100,-100,50,
				100,200,-100,200,
				400,500,-400,500,
				400,500,-400,500,
				400,500,-400,500,
			],inf)));
			freqshift = SinOsc.ar(1/8).range(0,100);
			freqshift = EnvGen.ar(Env([1,0,100,100,50,400], [1,5,5,1]).circle);
            fb = FreqShift.ar(fb, (0-[1,-1,-1,1,1,2,3,4,5,7,8].clump(2).scramble*freqshift)).mean;
			fb = fb.tanh;
            fb;
        },1,\delay.kr(1));
       
        sig = Normalizer.ar(sig, 0.99,0.01);
        sig = sig / 2;
       
        sig;
    }).play;
    )



	(
    Pdef(~name, Pbind(
        \instrument, ~name,
        \env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
        \env1, [ Env.new([50, 53, 29], [0.015, 0.29], [-4, -5]) ],
        \pan, Pseq([
            Pser([0],17),
            Pwhite(-1.0,1.0,16-1)
        ],inf).stutter(1) * 0.5,
        \spread, 0.1,
        \dur, 1/4,
        \out, ~bus,
        \amp, 0.51,
        \isRest, Pseq([1,0,0,0],inf).coin.not,
    )).play;
)
(
	Ndef(\bla, {
        var in = InFeedback.ar(~bus,2);

		in = in + (Ndef.ar(\bla_end) * 0.15);
		in;
		
	});
	Ndef(\bla_mid, {
        var in = Ndef(\bla).ar(2);
		in = DelayL.ar(in, 1/2,1/2) + in;
		in;
		
	});
	Ndef(\bla_end, {
        var in = Ndef(\bla_mid).ar(2);
        in = Limiter.ar(in, 0.99,0.01);
		in;

	});
	Ndef(\bla_final, {
        var in = Ndef(\bla_end).ar(2);
		in = in / 4;
		in;

	}).play;
)
Ndef(\bla_end).clear

(
	Ndef(\bla_mid, {
        var in = Ndef(\bla).ar(2);
		in = DelayL.ar(in, 1,1/48) + in;
		in = in * 4.1;
		in;
		
	});
)




b = Buffer.read(s,Platform.resourceDir +/+"sounds/a11wlk01.wav",bufnum:1);
b

// Play and fun:

Ndef(\nx102).play;

(
Ndef(\nx102, {
	Pan2.ar(LeakDC.ar(Normalizer.ar(
				BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(FreeVerb.ar(
					RHPF.ar(RLPF.ar(
					Pulse.ar(
						(PlayBuf.kr(2,b,Rand(50,100),1,0,1)*Rand(100,1000)).clip(
							Rand(5,12),Rand(12,20))) 
						,Rand(100,5000),Rand(0.005,0.1))
						,Rand(5000,20000),Rand(0.005,0.1))
					,0.0,0.0,0.0)
		 ,100,6.0,6),1000,6.0,0),5000,6.0,0),10000,6.0,6)
		 ,(1.25/0.999)*1.0,0.1)),0)
});
)

~nx102 = nil;
b.free;



// http://twitter.com/#!/alln4tural/status/99846300173991936
// http://soundcloud.com/tengototen/esoteric-tweet


fork{loop{h=[5,7,8].choose*(2**(2..8).choose);play{Splay.ar({SinOsc.ar(exprand(h,h+(h/64)),0,0.1)}!64)*LFGauss.ar(9,1/4,0,0,2)};2.wait}};

// really i wanted to do this:
fork{loop{h=([33,38,40].choose.midicps)*(2**((0 .. 5).choose));play{Splay.ar({SinOsc.ar(exprand(h-(h/256),h+(h/256)),0,0.1)}!64)*LFGauss.ar(19,1/4,0,0,2)};4.wait}};
// or more like a constant drone:
fork{loop{h=([33,38,40].choose.midicps)*(2**((0 .. 4).choose));play{Splay.ar({SinOsc.ar(exprand(h-(h/64),h+(h/64)),0,0.1)}!8)*LFGauss.ar(19,1/4,0,0,2)};0.25.wait}};
// primes
fork{loop{h=(4 .. 100).choose.nthPrime*(2**(0..3).choose);play{Splay.ar({SinOsc.ar(exprand(h-(h/256),h+(h/256)),0,0.1)}!64)*LFGauss.ar(19,1/4,0,0,2)};2.wait}}; 
// Fibonacci
fork{loop{h=(List.fib(15).choose)*(2**(0..4).choose);play{Splay.ar({SinOsc.ar(exprand(h-(h/64),h+(h/64)),0,0.1)}!64)*LFGauss.ar(19,1/4,0,0,2)};2.wait}}; 

// but they were too long.
// __________________________
// inspired by http://sctweets.tumblr.com/post/8379573991/sinosc 
// (http://soundcloud.com/rukano)




(
     
SynthDef(\kickfb, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
	var env0, env1, env1m, son;
 
	//freqpan = [-1,0,1] * freqpan;
	freqpan = [1,0,-1] * freqpan;
	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([100, 29, 59], [0.105, 0.29], [-4, -5]));
   
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
   
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
   
	son = son * 1.2;
	son = son.clip2(1);
 
	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);
   
	OffsetOut.ar(out, son);
}).add;
     
SynthDef(\kick2, { |which = 1, which2=2, out=2, amp=1, pan=0, release=0.26, fratio=1.5|
        var env0,env1,
    env1m, son;
     
    env0 = \env0.kr(Env.new([0.1, 0.3, 0.8, 0], [0.1, 0.02,0.61], [-4, -2, -4]));
    env1 = \env1.kr(Env.new([100, 34, 37], [0.1, 0.1], [-4, -5]));
     
    env0 = EnvGen.ar(env0, doneAction:2);
        env1 = EnvGen.ar(env1);
     
        env1m = env1.midicps;
        son = LFPulse.ar(env1m,0, 0.01, 1,1.4)*LFSaw.ar(100).distort;
    son = son + WhiteNoise.ar(1);
    son = LPF.ar(son, env1m*fratio, env0);
    son = son + SinOsc.ar(env1m, 0.5, env0);
    son = son * 2.2;
    //son = son.clip2(1);
     
    son = son * amp.distort;
    son = Pan2.ar(son, pan);
    OffsetOut.ar(out, son);
    },
).add;
     
SynthDef(\hats, { |which = 1, which2=2, out=4, amp=1, pan=0, release=0.26, fratio=1.5, timeScale=1|
	var env0,env1,
	env1m, son;
	env0 = \env0.kr(Env.new([0.002, 0.1, 0.01, 0], [0.0001, 0.01, 0.03], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([100,100], [0.5,0.5, 0.1,0.01], [-4, -5]));
 
	env0 = EnvGen.ar(env0, timeScale:timeScale, doneAction:2);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
 
	env1m = env1.midicps;
	son = LFPulse.ar(env1m,0, 0.01, 0.1, -0.5)*LFSaw.ar(1000);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	son = son;
	son = son.clip2(0.2);
 
	son = son * amp;
	son = Pan2.ar(son, pan);
	OffsetOut.ar(out, son);
	},
).add;

SynthDef(\padsin, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; SinOsc.ar( freq/2 * x + ExpRand(freq/64,2*freq/64).poll)}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;


)


~bus = Bus.audio(s,2);
(
Pdef(\pat1).play;
Pdef(\pat1,
	Ppar([

		Pbind(
			\instrument, \kickfb,
			\env0, [ Env.new([0.5, 1, 0.5, 0], [0.5, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env.new([110, 43, 29], [0.015, 0.29], [-4, -5]) ],
			\pan, Pseq([
				Pser([0],17),
				Pwhite(-1.0,1.0,16-1)
			],inf).stutter(1) * 0.5,
			\spread, 0.1,
			\dur, 1/4,
			\out, ~bus,
			\amp, 0.51,
			//\amp,0.0,
			\isRest, Pseq([1,0.6],inf).coin.not,
		),
   
		Pbind(
			//\instrument,Pseq([\kick2,\kick],inf),
			\instrument, \hats,
			//\out,[0,1],
			\pan,Pwhite(-1,1,inf)/4,
			\pan, 0,
			\dur, 1/8,
			\timeScale, Pseq([1,1.2,0.7,3],inf) + Pseq([0,0.51,0,0.7],inf).stutter(2),
			\timeScale, Pseq([0.4,0.8,0.4,0.81],inf),
			\amp,Pseq([0.8,0.74,0.6,0.71],inf),//*v[\level1].asMap,
			\isRest, Pseq([1],inf).coin.not,
		),
		Pbind(
			//\instrument,Pseq([\kick2,\kick],inf),
			\instrument, \kick2,
			//\out,[0,1],
			//\pan,Pwhite(-1,1,inf),
			\pan, 0,
			\dur, 1/4,
			\amp,2,//*v[\level1].asMap,
			\isRest, Pseq([
				0,0,0,0,
				1,0,0,0,
			],inf).coin.not,
		)
	]);
);
)
               
(
	Ndef(\fb, {
		var in = InFeedback.ar(~bus,2);
		var sig = in;
		var sig1;
		sig = Fb({ arg fb;
			var del;
			var freqshift;
			fb = sig + (fb * 0.97 * \fb.kr(1));
			freqshift = \freqshift.kr(1);
			freqshift = Duty.ar(1/8, 0, Dseq([10,0,-20,0]*freqshift,inf) + Dstutter(2,Dseq([0,-50,0,50],inf)));
			fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;
			fb;
		},1/4,\delay.kr(1/4));
		sig = Normalizer.ar(sig, 0.99,0.01);
		sig = sig / 2;

		sig;
	}).play;
)
     
     
     


(
~hey = { arg sig, ffreq; RLPF.ar(sig, 150) };

SynthDef(\plop, { arg out=0, freq=110, gate=1, amp=1, pan=0;
	var sig = LFSaw.ar(freq);
	sig = ~hey.(sig, 1250);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);

	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\allez, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 1
)).play;
);



(
SynthDef(\padsin, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; SinOsc.ar( freq/2 * x + ExpRand(freq/64,2*freq/64).poll)}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)


(
Pdef(\pat2, Pbind(
	\instrument, \padsin,
	\note, Pseq([
		Prand([0,2,4,7,3]),
		Prand([0,2,4,7,3])+7,
	],inf),
	\dur, 2,
	\amp, 0.071,
	\legato, 3.5,
	\isRest, false,
)).play;
)




////////////////////////////////////////////:



(
     
SynthDef(\kickfb, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
    var env0, env1, env1m, son;
 
    //freqpan = [-1,0,1] * freqpan;
    freqpan = [1,0,-1] * freqpan;
    env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
    env1 = \env1.kr(Env.new([100, 29, 59], [0.105, 0.29], [-4, -5]));
   
    env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
    env1 = EnvGen.ar(env1, timeScale:timeScale);
    env1m = env1.midicps;
   
    son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
    son = son + WhiteNoise.ar(1);
    son = LPF.ar(son, env1m*fratio, env0);
    son = son + SinOsc.ar(env1m, 0.5, env0);
   
    son = son * 1.2;
    son = son.clip2(1);
 
    son = son * amp;
    son = Splay.ar(son, spread, amp, pan);
   
    OffsetOut.ar(out, son);
}).add;
     
SynthDef(\kick2, { |which = 1, which2=2, out=2, amp=1, pan=0, release=0.26, fratio=1.5|
        var env0,env1,
    env1m, son;
     
    env0 = \env0.kr(Env.new([0.1, 0.3, 0.8, 0], [0.1, 0.02,0.61], [-4, -2, -4]));
    env1 = \env1.kr(Env.new([100, 34, 37], [0.1, 0.1], [-4, -5]));
     
    env0 = EnvGen.ar(env0, doneAction:2);
        env1 = EnvGen.ar(env1);
     
        env1m = env1.midicps;
        son = LFPulse.ar(env1m,0, 0.01, 1,1.4)*LFSaw.ar(100).distort;
    son = son + WhiteNoise.ar(1);
    son = LPF.ar(son, env1m*fratio, env0);
    son = son + SinOsc.ar(env1m, 0.5, env0);
    son = son * 2.2;
    //son = son.clip2(1);
     
    son = son * amp.distort;
    son = Pan2.ar(son, pan);
    OffsetOut.ar(out, son);
    },
).add;
     
SynthDef(\hats, { |which = 1, which2=2, out=4, amp=1, pan=0, release=0.26, fratio=1.5, timeScale=1|
    var env0,env1,
    env1m, son;
    env0 = \env0.kr(Env.new([0.002, 0.1, 0.01, 0], [0.0001, 0.01, 0.03], [-4, -2, -4]));
    env1 = \env1.kr(Env.new([100,100], [0.5,0.5, 0.1,0.01], [-4, -5]));
 
    env0 = EnvGen.ar(env0, timeScale:timeScale, doneAction:2);
    env1 = EnvGen.ar(env1, timeScale:timeScale);
 
    env1m = env1.midicps;
    son = LFPulse.ar(env1m,0, 0.01, 0.1, -0.5)*LFSaw.ar(1000);
    son = son + WhiteNoise.ar(1);
    son = LPF.ar(son, env1m*fratio, env0);
    son = son + SinOsc.ar(env1m, 0.5, env0);
    son = son;
    son = son.clip2(0.2);
 
    son = son * amp;
    son = Pan2.ar(son, pan);
    OffsetOut.ar(out, son);
    },
).add;
 
SynthDef(\padsin, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; SinOsc.ar( freq/2 * x + ExpRand(freq/64,2*freq/64).poll)}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
 
)
 
~bus = Bus.audio(s,2);
(
Pdef(\kickfb,
	Pbind(
		\instrument, \kickfb,
		\env0, [ Env.new([0.5, 1, 0.5, 0], [0.5, 0.16, 0.01], [-4, -2, -4]) ],
		\env1, [ Env.new([110, 43, 29], [0.015, 0.29], [-4, -5]) ],
		\pan, Pseq([
			Pser([0],17),
			Pwhite(-1.0,1.0,16-1)
		],inf).stutter(1) * 0.5,
		\spread, 0.1,
		\dur, 1/4,
		\out, ~bus,
		\amp, 0.51,
		//\amp,0.0,
		\isRest, Pseq([1,0.6],inf).coin.not,
	)
);

Pdef(\hats,
	Pbind(
		//\instrument,Pseq([\kick2,\kick],inf),
		\instrument, \hats,
		//\out,[0,1],
		\pan,Pwhite(-1,1,inf)/4,
		\pan, 0,
		\dur, 1/8,
		\timeScale, Pseq([1,1.2,0.7,3],inf) + Pseq([0,0.51,0,0.7],inf).stutter(2),
		\timeScale, Pseq([0.4,0.8,0.4,0.81],inf),
		\amp,Pseq([0.8,0.74,0.6,0.71],inf),//*v[\level1].asMap,
		\isRest, Pseq([1],inf).coin.not,
	)
);

Pdef(\kick2,
        Pbind(
            //\instrument,Pseq([\kick2,\kick],inf),
            \instrument, \kick2,
            //\out,[0,1],
            //\pan,Pwhite(-1,1,inf),
            \pan, 0,
            \dur, 1/4,
            \amp,2,//*v[\level1].asMap,
            \isRest, Pseq([
                0,0,0,0,
                1,0,0,0,
            ],inf).coin.not,
        )
);

Pdef(\pat2, Pbind(
	\instrument, \padsin,
	\note, Pseq([
		Prand([0,2,4,7,3]),
		Prand([0,2,4,7,3])+7,
	],inf),
	\dur, 2,
	\amp, 0.071,
	\legato, 3.5,
	\isRest, false,
));

)
               
(
    Ndef(\fb, {
        var in = InFeedback.ar(~bus,2);
        var sig = in;
        var sig1;
        sig = Fb({ arg fb;
            var del;
            var freqshift;
            fb = sig + (fb * 0.97 * \fb.kr(1));
            freqshift = \freqshift.kr(1);
            freqshift = Duty.ar(1/8, 0, Dseq([10,0,-20,0]*freqshift,inf) + Dstutter(2,Dseq([0,-50,0,50],inf)));
            fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;
            fb;
        },1/4,\delay.kr(1/4));
        sig = Normalizer.ar(sig, 0.99,0.01);
        sig = sig / 2;
 
        sig;
    });
)
 
(
Tdef( \track, {
 
    loop{
        Pdef(\pat2).play;
        16.wait;
        Pdef(\kick2).play;
        Pdef(\hats).play;
		2.wait;
        Pdef(\pat2).stop;
        2.wait;
		Pdef(\kickfb).play;
		Ndef(\kickfb).play;
        8.wait;
		Pdef(\pat2).play;
		8.wait;
		Pdef(\kick2).stop;
		Pdef(\hats).stop;
    };
}).play;
)
 
Tdef( \tack).stop;
 
 
  Pdef(\kick).stop;
        Ndef(\fb).stop;
