
Ndef(\crack).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.collect({ arg isig,i;
		isig * SinOsc.kr(1/9+(i/12)).range(0,1)
	});
	sig = sig.sum;
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig;
}).play



Ndef(\crack).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( 
		{ arg i; SinOsc.kr(1/14+ (i/21)).range(0,2) } ! sig1.size, 
		[sig1, sig2, sig3]
	);
	sig = sig.collect({ arg isig,i;
		isig * SinOsc.kr(1/49+(i/72)).range(0,1)
	});
	sig = sig.sum;
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig;
}).play

Ndef(\crack).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( 
		{ arg i; SinOsc.kr(1/14+ (i/21)).range(0,2) } ! sig1.size, 
		[sig1, sig2, sig3]
	);
	sig = sig.collect({ arg isig,i;
		isig * SinOsc.kr(1/49+(i/72)).range(0,1)
	});
	sig = sig.sum;
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig;
}).play


Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 1.05501 * SinOsc.kr((1..sig.size).normalizeSum+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr((1..sig.size).normalizeSum+0.1).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig;
}).play

Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.1/(1..sig.size).normalizeSum).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size).normalizeSum+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr((1..sig.size).normalizeSum+0.1).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig;
}).play


Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);
	sig = sig * SinOsc.kr(1/(1..sig.size)+(pi/100)).range(0,1);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
}).play


Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);
	sig = sig * SinOsc.kr(1/(1..sig.size)+(pi/100)).range(0,1);

	sig1 = sig * sig.clip2(0.1);
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01+(pi/4)).range(0.5,1) , [sig, sig1]);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
}).play


Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);

	sig1 = sig * sig.clip2(0.1);
	sig = SelectX.ar(SinOsc.kr(0.1/(1..sig.size)+0.001+(pi/14)).range(0.5,1) , [sig, sig1]);
	sig = sig * SinOsc.kr(1/(1..sig.size)+(pi/100)).range(0,1);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
}).play

Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);
	sig = sig * SinOsc.kr(1/(1..sig.size)+(pi/100)).range(0,1);

	sig1 = sig * sig.clip2(0.1);
	sig = SelectX.ar(SinOsc.kr(4/(1..sig.size)+0.01+(pi/4)).range(0.5,1) , [sig, sig1]);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)), amp).flop;
	sig;
}).play

Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);
	sig = sig * SinOsc.kr(1/(1..sig.size)+(pi/100)).range(0,1);

	sig1 = sig * sig.clip2(0.1);
	sig = SelectX.ar(SinOsc.kr(4/(1..sig.size)+0.01+(pi/4)).range(0.5,1) , [sig, sig1]);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/100 * SinOsc.kr(1/47).range(1,100)), amp).flop;
	sig;
}).play

Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);
	sig = sig * SinOsc.kr(1/(1..sig.size)+(pi/100)).range(0,1);

	sig1 = sig * sig.clip2(0.1);
	sig = SelectX.ar(SinOsc.kr(SinOsc.kr(1/57).range(0.01,100)/(1..sig.size)+0.01+(pi/40)).range(0.5,1) , [sig, sig1]);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/100 * SinOsc.kr(1/47).range(1,100)), amp).flop;
	sig;
}).play


Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);
	sig = sig * SinOsc.kr(SinOsc.kr(1/67).range(0.01,100)/(1..sig.size)+(pi/100)).range(0,1);

	sig1 = sig * sig.clip2(0.1);
	sig = SelectX.ar(SinOsc.kr(SinOsc.kr(1/57).range(0.01,100)/(1..sig.size)+0.01+(pi/40)).range(0.5,1) , [sig, sig1]);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/100 * SinOsc.kr(1/47).range(1,100)), amp).flop;
	sig;
}).play


Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 140;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+12],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+12],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	//sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	//sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);

	//sig1 = sig * (sig*10).clip2(0.1);
	//sig = SelectX.ar(SinOsc.kr(SinOsc.kr(1/57).range(0.01,100)/(1..sig.size)+0.01+(pi/40)).range(0.5,1) , [sig, sig1]);

	//sig1 = sig + DelayL.ar(sig, 0.1, SinOsc.kr(SinOsc.kr(1/57).range(0.01,0.000100)/(1..sig.size)+0.01+(pi/40)).range(0.1,0.001)).clip2(0.1);
	//sig = SelectX.ar(SinOsc.kr(SinOsc.kr(1/27).range(0.01,100)/(1..sig.size)+0.01+(pi/40)).range(0.5,1) , [sig, sig1]);
	sig2 = sig * SinOsc.kr(SinOsc.kr(1/67).range(0.01,100)/(1..sig.size)+(pi/100)).range(0,1);
	sig1 = sig * LFPulse.kr(SinOsc.kr(1/67).range(0.01,100)/(1..sig.size)+(pi/100)).range(0,1);
	sig = SelectX.ar( SinOsc.kr(1/27).range(0,1), [sig1, sig2]);

	sig= sig * DelayL.ar(sig, 0.1, SinOsc.kr(SinOsc.kr(1/57).range(0.01,0.000100)/(1..sig.size)+0.01+(pi/40)).range(0.1,0.001));
	//sig = SelectX.ar(SinOsc.kr(SinOsc.kr(1/17).range(0.01,1)/(1..sig.size)+0.01+(pi/40)).range(0.5,1) , [sig, sig1]);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/100 * SinOsc.kr(1/47).range(0.1,10)), amp).flop;
	sig;
}).play

Ndef(\pelu).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 140;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+12],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+12],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	//sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	//sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);

	//sig1 = sig * (sig*10).clip2(0.1);
	//sig = SelectX.ar(SinOsc.kr(SinOsc.kr(1/57).range(0.01,100)/(1..sig.size)+0.01+(pi/40)).range(0.5,1) , [sig, sig1]);

	//sig1 = sig + DelayL.ar(sig, 0.1, SinOsc.kr(SinOsc.kr(1/57).range(0.01,0.000100)/(1..sig.size)+0.01+(pi/40)).range(0.1,0.001)).clip2(0.1);
	//sig = SelectX.ar(SinOsc.kr(SinOsc.kr(1/27).range(0.01,100)/(1..sig.size)+0.01+(pi/40)).range(0.5,1) , [sig, sig1]);
	sig2 = sig * SinOsc.kr(SinOsc.kr(1/67).range(0.01,100)/(1..sig.size)+(pi/100)).range(0,1);
	sig1 = sig * LFPulse.kr(SinOsc.kr(1/67).range(0.01,100)/(1..sig.size)+(pi/100)).range(0,1);
	sig = SelectX.ar( SinOsc.kr(1/27).range(0,0.1), [sig1, sig2]);

	//sig= sig * DelayL.ar(sig, 0.1, SinOsc.kr(SinOsc.kr(1/57).range(0.01,0.000100)/(1..sig.size)+0.01+(pi/40)).range(0.1,0.001));
	//sig = SelectX.ar(SinOsc.kr(SinOsc.kr(1/17).range(0.01,1)/(1..sig.size)+0.01+(pi/40)).range(0.5,1) , [sig, sig1]);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/100 * SinOsc.kr(1/47).range(0.1,10)), amp).flop;
	sig;
}).play

Ndef(\pelu).quant = 4
Ndef(\pelu).fadeTime = 0.4;

(
// This filters a simple sine wave, producing a chaotic result
x = {
var sig, out;
sig = SinOsc.ar(660);
out = Friction.ar(sig, friction: 0.41322e-5, mass: 8.05501);
Pan2.ar(out, 0, 0.1);
}.play
)
