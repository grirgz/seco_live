
// TSCramble is in wslib quark, make an alternative

(
	// ok but repeat
	// inspired by scztt code
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var indices;
	var sig;
	var trig;
	trig = Impulse.kr(1);
	sig = SinOsc.ar(freq * ( (1..4)/8+1 ));
	indices = Dxrand((0..3),inf);
	indices = 4.collect { Demand.kr(trig, 0, indices) };
	indices.poll;
	sig = Select.ar(indices, sig);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// shuffle the indice array and pull N values from it
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var indices;
	var sig;
	var trig;
	var num= 8;
	trig = Impulse.kr(1);
	sig = SinOsc.ar(freq * ( (1..num)/8+1 ));
	indices = Dseq([Dshuf((0..num-1))],inf);
	indices = num.collect { Demand.kr(trig, 0, indices) };
	indices.poll;
	sig = Select.ar(indices, sig);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
	// crossfading
	// this is basically what is inside TScramble pseudougen
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var indices;
	var sig;
	var trig;
	var num= 8;
	trig = Impulse.kr(1);
	sig = SinOsc.ar(freq * ( (1..num)/8+1 ));
	indices = Dseq([Dshuf((0..num-1))],inf);
	indices = num.collect { Demand.kr(trig, 0, indices) };
	indices.poll;
	sig = SelectX.ar(indices.lag(4), sig);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);


////// toying

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var indices;
	var sig;
	var trig;
	var num= 8;
	trig = Impulse.kr(\scramblefreq.kr(1));
	sig = LFSaw.ar(freq * ( (1..num)*\spratio.kr(1/8)+1 ));
	indices = Dseq([Dshuf((0..num-1))],inf);
	indices = num.collect { Demand.kr(trig, 0, indices) };
	indices.poll;
	sig = SelectX.ar(indices.lag(\lag.kr(4)), sig);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\zed).edit

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var indices;
	var sig;
	var trig;
	var num= 8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var dfreq = freq * ( (1..num)*\spratio.kr(1/8)+1 );
	trig = Impulse.kr(\scramblefreq.kr(1));
	sig1 = LFSaw.ar(dfreq);
	sig2 = SinOsc.ar(dfreq*2);
	sig = SelectX.ar( SinOsc.ar(0.1!num).unipolar, [sig1, sig2].flop  );

	indices = Dseq([Dshuf((0..num-1))],inf);
	indices = num.collect { Demand.kr(trig, 0, indices) };
	indices.poll;
	sig = SelectX.ar(indices.lag(\lag.kr(4)), sig);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);
