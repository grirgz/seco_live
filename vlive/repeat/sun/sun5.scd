
(
Ndef(\drone1, { arg freq=80, pan=0, amp=0.1;
	var sig;

	sig = 0;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig = SinOsc.ar(freq * ( SinOsc.ar( 2 * ( SinOsc.ar(isig * [1,3,4]) * 3 + 1 ) ) * 4 + 1 ));
		isig;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);

(
Ndef(\drone2, { arg freq=80, pan=0, amp=0.1;
	var sig;

	sig = 0;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig = LFSaw.ar(freq * ( SinOsc.ar( 100 * ( SinOsc.ar(isig * [1,3,4]) * 30 + 1 ) ) * 40 + 1 ));
		isig;
	});
	sig = Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) );
	
		isig = BPF.ar(sig, ( freq * ( SinOsc.ar( [1,10,100] * ( SinOsc.ar(isig * [10,3,4]) * 3 + 1 ) ) * 40 + 1 ) ).clip(20,19900), 0.51);
		isig;
	});
	sig = sig / 1;
	sig = Limiter.ar(sig);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);

(
Ndef(\drone3, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var ttrig = Dust.kr(10);
	freq = freq * ( SinOsc.kr(1 * ( SinOsc.kr(2) * 1 + 1 )) * 1 + 1 ) * LFNoise0.kr(2).range(0.5,2.0);
	env1 = EnvGen.kr(Env([1.2,1.1,1.0],[0.01,0.01]), ttrig);
	env2 = EnvGen.kr(Env([0,1,0],[0.001,0.1]), ttrig);
	sig = LFSaw.ar(freq * env1) * env2;
	sig = RLPF.ar(sig, \lpf.kr(800) * ( SinOsc.kr(1) * 1 + 1 ), \rq.kr(0.5));
	//sig = HPF.ar(sig, 50);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
