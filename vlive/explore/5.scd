~name = "plop";

//Ndef(~name+++\fx).put(0, { arg amp=0.1;
Ndef(\hey).fadeTime=0.2;
Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 100;
	var size;
	
	sig = 1;
	size = 6;
	size.do { arg i;
		var ii = i+1;
		sig1 = LFSaw.ar(freq * (1 + ( sig * SinOsc.ar(0+( ( i+1 )/20 )).range(0,10+i) )));
		sig2 = SinOsc.ar(freq * (1 + ( sig * SinOsc.ar(0+( ( i+1 )/20 )).range(0,10+i) )));
		sig = SelectX.ar( SinOsc.kr(ii/29).range(0,1), [sig1, sig2]);

		sig1 = RLPF.ar(sig, SinOsc.kr(1/ii).range(40,1000), \rq.kr(0.5));
		sig2 = sig;
		sig = SelectX.ar( SinOsc.kr(ii/29).range(0,1), [sig1, sig2]);
	};
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play

Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 100;
	var size;
	
	sig = 1;
	size = 6;
	size.do { arg i;
		var ii = i+1;
		sig1 = LFSaw.ar(freq * (1 + ( sig * SinOsc.ar(0+( ( i+1 )/120 )).range(0,10+i) )));
		sig2 = SinOsc.ar(freq * (1 + ( sig * SinOsc.ar(0+( ( i+1 )/120 )).range(0,10+i) )));
		sig = SelectX.ar( SinOsc.kr(ii/129).range(0,1), [sig1, sig2]);

		sig1 = RLPF.ar(sig, SinOsc.kr(1/ii/90).range(40,9000), \rq.kr(0.5));
		sig2 = sig;
		sig3 = RHPF.ar(sig, SinOsc.kr(1/ii/110).range(40,1000), \rq.kr(0.5));
		sig = SelectX.ar( SinOsc.kr(ii/149).range(0,2), [sig1, sig2, sig3]);
	};
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play

Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 100;
	var size;
	var time;
	var env1, env2, env3;
	var env0;

	
	sig = 1;
	size = 12;
	time = 20;
	env0 = Line.kr(0,1,time);
	env0 = EnvGen.kr(Env([0,1,0.51,0.02],[2.1,0.8,4]), 1);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	size.do { arg i;
		var ii = i+1;
		sig1 = SinOsc.ar(freq * (1 + ( sig * env1.range(0,10+i) )));
		sig2 = LFSaw.ar(freq * (1 + ( sig * env0.range(0,10+i) )));
		sig = SelectX.ar( Line.kr(0,1,time), [sig1, sig2]);

		sig1 = RLPF.ar(sig, env0.range(40,9000), 0.1);
		sig2 = sig;
		sig3 = RHPF.ar(sig, env0.range(4400,100), 0.5);
		sig = SelectX.ar( env2.range(0,2), [sig1, sig2, sig3]);
	};
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play

Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 400 * [1,1.01,1.0001, 2,4];
	var size;
	var time;
	var env1, env2, env3;
	var env0;

	
	sig = 1;
	size = 4;
	time = 20;
	env0 = Line.kr(0,1,time);
	env0 = EnvGen.kr(Env([0,1,0.51,0.02],[2.1,0.8,14]), 1);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	size.do { arg i;
		var ii = i+1;
		sig1 = SinOsc.ar(freq * (1 + ( sig * env1.range(0,10+i*[1,2,1,2]) )));
		sig2 = LFSaw.ar(freq * (1 + ( sig * env0.range(0,10+i) )));
		sig = SelectX.ar( Line.kr(0,1,time), [sig1, sig2]);

		sig1 = RLPF.ar(sig, env3.range(40,9000), 0.1);
		sig2 = sig;
		sig2 = BPF.ar(sig, env1.range(80,13000));
		sig3 = RHPF.ar(sig, env0.range(4400,100), 0.5);
		sig = SelectX.ar( env2.range(0,2), [sig1, sig2, sig3]);
	};
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play

Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 60 * [1,1.01,1.0001, 2,4];
	var size;
	var time;
	var env1, env2, env3;
	var env0;

	
	sig = 1;
	size = 2;
	time = 20;
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	size.do { arg i;
		var ii = i+1;
		sig1 = SinOsc.ar(freq * (1 + ( sig * env1.range(0,4/ii*[1,2,1,2]) )));
		sig2 = LFSaw.ar(freq * (1 + ( sig * env0.range(0,4/ii) )));
		sig = SelectX.ar( env3, [sig1, sig2]);

		sig1 = RLPF.ar(sig, env3.range(40,9000), 0.1);
		sig2 = sig;
		sig2 = BPF.ar(sig, env1.range(80,13000));
		sig3 = RHPF.ar(sig, env0.range(4400,100), 0.5);
		sig = SelectX.ar( env2.range(0,2), [sig1, sig2, sig3]);
	};
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play

Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 60 * [1,1.01,1.0001, 2,4];
	var size;
	var time;
	var env1, env2, env3;
	var env0;

	
	sig = 1;
	size = 2;
	time = 20;
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	size.do { arg i;
		var ii = i+1;
		sig = SinOsc.ar(freq * (1 + ( sig * env1.range(0,4/ii*[1,2,1,2]) )));
		sig = sig.collect({ arg isig, j;
			var jj = j+1;
			
			//isig = isig.fold2( SinOsc.kr(1/ii/10).range(0,1) )
			isig = isig.fold2( env2 * SinOsc.kr(( 1/ii/6 ) + ( ( ii / 5 ) + (jj/17)  )).range(0,1) )
		});
	};
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play


Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 460 * [1,1.0001];
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;

	freq = ( freq *.t [0,5-12,7+12].midiratio ).flat;
	
	sig = 1;
	size = 8;
	time = 20;
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	osig = List.new;
	size.do { arg i;
		var ii = i+1;
		sig = SinOsc.ar(freq * (1 + ( sig * env1.range(0,4/ii*[1,2,1,2]) )));
		osig.add(sig * SinOsc.kr(1/ii).range(0,1));
		sig = sig.collect({ arg isig, j;
			var jj = j+1;
			
			//isig = isig.fold2( SinOsc.kr(1/ii/10).range(0,1) )
			isig = isig.fold2( env2 * ( 1 + SinOsc.kr(( 1/ii/6 ) + ( ( ii / 5 ) + (jj/17)  )) ) )
		});
	};
	sig = sig.collect({ arg isig, i;
		var ii = i+1;
		isig * SinOsc.kr(1/ii).range(0,1);
	
	});
	sig = sig + osig;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play


Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 460 * [1,1.0001/2];
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;

	freq = ( freq *.t Duty.kr(4, 0, Dseq([
		[0,5,7],
		[0,4,7],
		[0,5-12,7+12],
		[0,5+12,7-12],
		[0,4+12,7-12],
	],inf)).lag(0.4).midiratio ).flat;
	
	sig = 1;
	size = 8;
	time = 20;
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	osig = List.new;
	size.do { arg i;
		var ii = i+1;
		sig = SinOsc.ar(freq * (1 + ( sig * env1.range(0,4/ii*[1,2,1,2]) )));
		osig.add(sig * SinOsc.kr(1/ii).range(0,1));
		sig = sig.collect({ arg isig, j;
			var jj = j+1;
			
			//isig = isig.fold2( SinOsc.kr(1/ii/10).range(0,1) )
			isig = isig.fold2( env2 * ( 1 + SinOsc.kr(( 1/ii/6 ) + ( ( ii / 5 ) + (jj/17)  ) / 10) ) )
		});
	};
	sig = sig.collect({ arg isig, i;
		var ii = i+1;
		isig * SinOsc.kr(1/ii).range(0,1);
	
	});
	sig = sig + osig;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play


Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 460 * [1,1.0001/2];
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		[0,5,7],
		[0,4,7],
	],inf)).lag(0.4).midiratio ;
	chords = chords.collect({
		arg isig, i;
		isig * Duty.kr(1+i*pi*8, 0, Dseq([
			1,2,1/2,1/4,
			4,1/2,1,1/4,
		].rotate(i),inf)).lag(18.4)

	});

	freq = ( freq *.t chords).flatten;
	freq.debug("freq");
	
	sig = 1;
	size = 8;
	time = 20;
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	osig = List.new;
	size.do { arg i;
		var ii = i+1;
		sig = SinOsc.ar(freq * (1 + ( sig * env1.range(0,4/ii*[1,2,1,2]) )));
		osig.add(sig * SinOsc.kr(1/ii).range(0,1));
		sig = sig.collect({ arg isig, j;
			var jj = j+1;
			
			//isig = isig.fold2( SinOsc.kr(1/ii/10).range(0,1) )
			isig = isig.fold2( env2 * ( 1 + SinOsc.kr(( 1/ii/6 ) + ( ( ii / 5 ) + (jj/17)  ) / 10) ) )
		});
	};
	sig = sig.collect({ arg isig, i;
		var ii = i+1;
		isig * SinOsc.kr(1/ii).range(0,1);
	
	});
	sig = sig + osig;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play


Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 260 ;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		[0,5,7],
		[0,4,7],
	],inf)).lag(0.4).midiratio ;
	chords = chords.collect({
		arg isig, i;
		isig * Duty.kr(4, 0, Dseq([
			1,2,1/2,1/4,
			4,1/2,1,1/4,
		].rotate(i),inf)).lag(0.4)

	});

	freq = ( freq *.t chords).flatten;
	freq.debug("freq");
	
	sig = 1;
	size = 8;
	time = 20;
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	osig = List.new;
	size.do { arg i;
		var ii = i+1;
		sig = SinOsc.ar(freq * (1 + ( sig * env1.range(0,4/ii*[1,2,1,2]) )));
		osig.add(sig * SinOsc.kr(1/ii).range(0,1));
		sig = sig.collect({ arg isig, j;
			var jj = j+1;
			
			//isig = isig.fold2( SinOsc.kr(1/ii/10).range(0,1) )
			isig = isig.fold2( env2 * ( 1 + SinOsc.kr(( 1/ii/6 ) + ( ( ii / 5 ) + (jj/17)  ) / 10) ) )
		});
	};
	sig = sig.collect({ arg isig, i;
		var ii = i+1;
		isig * SinOsc.kr(1/ii).range(0,1);
	
	});
	osig = Splay.ar(osig, \spread.kr(0.8)+ LFNoise1.kr(1/19,mul:0.2), amp, \pan.kr(0) + LFNoise1.kr(1/14,mul:0.1));
	osig.debug("osig");
	//sig = sig + osig;
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = sig + osig;
	sig;
}).play

Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 260 * [1.00001,1,1.0001];
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		[0,5,7],
		[0,4,7],
	],inf)).lag(0.4).midiratio ;
	chords = chords.collect({
		arg isig, i;
		isig * Duty.kr(4+(i/10), 0, Dseq([
			1,2,1/2,1/4,
			4,1/2,1,1/4,
		].rotate(i),inf)).lag(0.4 * SinOsc.kr(1/10+(i/11)).range(0,1))

	});

	freq = ( freq *.t chords).flatten;
	freq.debug("freq");
	
	sig = 1;
	size = 8;
	time = 20;
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	osig = List.new;
	size.do { arg i;
		var ii = i+1;
		sig = LFSaw.ar(freq * (1 + ( sig * env1.range(0,1/ii*[1,2,1,2]) )));
		//osig.add(sig * SinOsc.kr(1/ii).range(0,1));
		sig = sig.collect({ arg isig, j;
			var jj = j+1;
			var lfo;
			lfo = SinOsc.kr(( 1/ii/6 ) + ( ( ii / 5 ) + (jj/17)  ) / 10);
			
			//isig = isig.fold2( SinOsc.kr(1/ii/10).range(0,1) )
			if(i < (size-1)) {
				isig = SelectX.ar( lfo.range(0,1), [DC.ar(0), isig]);
			} {
				isig;
			};
		});
	};
	sig = sig.collect({ arg isig, i;
		var ii = i+1;
		isig = isig * SinOsc.kr(1/ii/10).range(0,1);
		isig = isig.fold( SinOsc.kr(1/ii/5).range(0.1,1) );
		//isig = BPF.ar(isig, SinOsc.kr(1/ii/9).range(70,14001), SinOsc.kr(1/ii/pi).range(0.1,0.81)) / 2 + isig
		isig = SelectX.ar(
			SinOsc.kr(1/ii/pi/2).range(0,1),
			[

			BPF.ar(isig, SinOsc.kr(1/ii/9).range(70,14001), SinOsc.kr(1/ii/pi).range(0.1,0.81)) , isig
			]
		)
	});
	sig = sig*4;
	//osig = Splay.ar(osig, \spread.kr(0.8)+ LFNoise1.kr(1/19,mul:0.2), amp, \pan.kr(0) + LFNoise1.kr(1/14,mul:0.1));
	osig.debug("osig");
	//sig = sig + osig;
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	//sig = sig + osig;
	sig;
}).play


Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170 * [1.00001,1,4,1.0001];
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;

	chords = Duty.kr(4, 0, Dseq([
		[0,5,7],
		[0,4,7],
		[0,3,7],
		[0,5,9],
	],inf)).lag(0.4).midiratio ;
	chords = chords.collect({
		arg isig, i;
		isig * Duty.kr(4+(i/10), 0, Dseq([
			1,2,1/2,1/4,
			4,1/2,1,1/4,
		].rotate(i),inf)).lag(0.4 * SinOsc.kr(1/10+(i/11)).range(0,1))

	});

	freq = ( freq *.t chords).flatten;
	freq.debug("freq");
	
	sig = 1;
	size = 4;
	time = 20;
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	osig = List.new;
	size.do { arg i;
		var ii = i+1;
		var sig0 = sig;
		sig = LFSaw.ar(freq * (1 + ( sig * env1.range(0,1/ii*[1,2,1,2]) )));
		sig = SelectX.ar( SinOsc.kr(1/ii/4).range(0,1), [sig, sig * sig0]);
		//osig.add(sig * SinOsc.kr(1/ii).range(0,1));
		sig = sig.collect({ arg isig, j;
			var jj = j+1;
			var lfo;
			lfo = SinOsc.kr(( 1/ii/6 ) + ( ( ii / 5 ) + (jj/17)  ) / 10);
			
			//isig = isig.fold2( SinOsc.kr(1/ii/10).range(0,1) )
			if(i < (size-1)) {
				isig = SelectX.ar( lfo.range(0,1), [DC.ar(0), isig]);
			} {
				isig;
			};
		});
	};
	sig = sig.collect({ arg isig, i;
		var ii = i+1;
		var isig0;
		isig = isig * SinOsc.kr(1/ii/10).range(0,1);
		isig = isig.fold( SinOsc.kr(1/ii/5).range(0.9,1) );
		//isig = BPF.ar(isig, SinOsc.kr(1/ii/9).range(70,14001), SinOsc.kr(1/ii/pi).range(0.1,0.81)) / 2 + isig
		isig = SelectX.ar(
			SinOsc.kr(1/ii/pi/2).range(0,1),
			[

			BPF.ar(isig, SinOsc.kr(1/ii/9).range(70,14001), SinOsc.kr(1/ii/pi).range(0.1,0.81)) , isig
			]
		);
		isig0 = isig;
		isig = DelayL.ar(isig, 0.01,0.001 * SinOsc.kr(1/ii/12).range(0.9,1));
		isig = DelayL.ar(isig, 0.01,0.001*ii)+isig+isig0;
	});
	sig = sig*2;
	//osig = Splay.ar(osig, \spread.kr(0.8)+ LFNoise1.kr(1/19,mul:0.2), amp, \pan.kr(0) + LFNoise1.kr(1/14,mul:0.1));
	osig.debug("osig");
	//sig = sig + osig;
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	//sig = sig + osig;
	sig;
}).play



Ndef(\hey).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170 * [1.00001,1,4,1.0001];
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
	chords = chords.collect({
		arg isig, i;
		isig * Duty.kr(4+(i/10) * Duty.kr(4, 0, Dseq([
			1,1,1,1/4 + (i/8),
			1,1,1,1,
			1,1,1,1,
			1,1,1,1,
			1,1,1,1/4 + (i/8),
			1,1,1,1/4 + (i/8),
			1,1,1,1,
			1,1,1,1,
			1,1,1,1,
		],inf)), 0, Dseq([
			1,2,1/2,1/4,
			4,1/2,1,1/4,
		].rotate(i),inf)).lag(0.4 * SinOsc.kr(1/10+(i/11)).range(0,1))

	});

	freq = ( freq *.t chords).flatten;
	freq.debug("freq");
	
	sig = 1;
	size = 4;
	time = 20;
	env0 = Line.kr(0,1,time);
	env1 = EnvGen.kr(Env([0,1,0.51,0.02],[4.1,4.8,4]), 1);
	env2 = EnvGen.kr(Env([1,0.1,0.51,0.92],[7.1,8.8,4]), 1);
	env3 = EnvGen.kr(Env([0.1,0.1,0.51,0.92],[1.1,8.8,4]), 1);
	env0 = Duty.kr(1, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env1 = Duty.kr(4, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(1);
	env2 = Duty.kr(8, 0, Dseq([
		1,0.2,0.81,0,
	],inf)).lag(4);
	env3 = Duty.kr(4, 0, Dseq([
		0.2,0.81,0,1,
		0.1,0.2,0.5,0.8,
	],inf)).lag(4);
	osig = List.new;
	size.do { arg i;
		var ii = i+1;
		var sig0 = sig;
		sig = LFSaw.ar(freq * (1 + ( sig * env1.range(0,1/ii*[1,2,1,2]) )));
		sig = SelectX.ar( SinOsc.kr(1/ii/4).range(0,1), [sig, sig * sig0]);
		//osig.add(sig * SinOsc.kr(1/ii).range(0,1));
		sig = sig.collect({ arg isig, j;
			var jj = j+1;
			var lfo;
			lfo = SinOsc.kr(( 1/ii/6 ) + ( ( ii / 5 ) + (jj/17)  ) / 10);
			
			//isig = isig.fold2( SinOsc.kr(1/ii/10).range(0,1) )
			if(i < (size-1)) {
				isig = SelectX.ar( lfo.range(0,1), [DC.ar(0), isig]);
			} {
				isig;
			};
		});
	};
	sig = sig.collect({ arg isig, i;
		var ii = i+1;
		var isig0;
		isig = isig * SinOsc.kr(1/ii/10).range(0,1);
		isig = isig.fold( SinOsc.kr(1/ii/5).range(0.9,1) );
		//isig = BPF.ar(isig, SinOsc.kr(1/ii/9).range(70,14001), SinOsc.kr(1/ii/pi).range(0.1,0.81)) / 2 + isig
		isig = SelectX.ar(
			SinOsc.kr(1/ii/pi/2).range(0,1),
			[

			BPF.ar(isig, SinOsc.kr(1/ii/9).range(70,14001), SinOsc.kr(1/ii/pi).range(0.1,0.81)) , isig
			]
		);
		isig0 = isig;
		isig = DelayL.ar(isig, 0.01,0.001 * SinOsc.kr(1/ii/12).range(0.9,1));
		isig = DelayL.ar(isig, 0.01,0.001*ii)+isig+isig0;
	});
	sig = sig*2;
	//osig = Splay.ar(osig, \spread.kr(0.8)+ LFNoise1.kr(1/19,mul:0.2), amp, \pan.kr(0) + LFNoise1.kr(1/14,mul:0.1));
	osig.debug("osig");
	//sig = sig + osig;
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = LeakDC.ar(sig);
	//sig = sig + osig;
	sig;
}).play


