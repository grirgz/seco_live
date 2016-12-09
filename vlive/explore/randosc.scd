


MCElectronique.newDef(210,8,0.8,0.6,0.3,0.2,true).postln.interpret


(
Ndef(\mce, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var oscs;
	var oscsgen = [
		LFSaw,
		SinOsc,
		LFPulse,
	];
	var size = 10;
	var prev;
	prev = 0!size;
	oscs = size.collect({ arg idx;
		oscsgen.choose.ar(exprand(1,10000) * ( 1 + ( prev[idx] * 1 )))
	});
	prev = oscs;
	oscs = size.collect({ arg idx;
		oscsgen.choose.ar(exprand(1,10000) * ( 1 + ( prev[idx] * 1 )))
	});
	prev = oscs;
	oscs = size.collect({ arg idx;
		oscsgen.choose.ar(exprand(100,10000) * ( 1 + ( prev[idx] * 1 )))
	});
	sig = oscs.mean;

	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\mce, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var oscs;
	var oscsgen = [
		LFSaw,
		SinOsc,
		LFPulse,
		LFTri,
	];
	var size = 10;
	var prev;
	var prevprev;
	oscs = 0!size;
	8.do {
		prev = oscs;
		oscs = size.collect({ arg idx;
			var ifreq = exprand(1,10000) * XLine.kr(1,exprand(1/10,20),rrand(4.0,20)) * ( 1 + ( prev[idx] * \fmamp.kr(1) ));
			ifreq = ifreq.clip(1,18000);
			oscsgen.choose.ar(ifreq)
		});
	};
	sig = oscs.mean;

	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\mce).edit
