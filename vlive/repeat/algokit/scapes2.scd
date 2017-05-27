(
Ndef(\scape_layer0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var dellfo;
	sig = LFSaw.ar(freq * ( (0..7)/8-0.5 *1 ));
	sig = CombL.ar(sig, 0.1,0.01 * SinOsc.kr(1/12 * (1..8)/8).range(0.01,1),1) + sig;
	sig = LPF.ar(sig, 400);
	sig = sig * 2;
	sig = sig * LFNoise1.kr(1/21).range(0.7,1.3);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\scape_layer1, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var dellfo;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar(1);
	sig1 = SinOsc.ar(freq * rrand(0.8,1.2!8),mul:0.3);
	sig1 = ( sig1*\distamp.kr(100) ).tanh * \distpostamp.kr(1/2);
	sig = sig + sig1;
	sig = BPF.ar(sig, freq);
	sig = BPF.ar(sig, freq);
	sig = BPF.ar(sig, freq);
	sig = BPF.ar(sig, freq);
	sig = BPF.ar(sig, freq * [1,2]);
	sig = sig * 10 * SinOsc.kr(1/21 * ( 1 + ( SinOsc.kr(1/13) * 1 ))).range(0.7,1.3);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\scape_layer2, { arg freq=800, pan=0, amp=0.1;
	var sig;
	var dellfo;
	freq = freq * [0,3,7,7-24,3-12].midiratio;
	sig = LFSaw.ar(freq * ( (1..8).scramble/8*0.1+1 ) * SinOsc.kr((1..8)/8*0.1, mul:0.1,add:1));
	sig = sig.collect({ arg isig, idx;
		BPF.ar(isig, freq.first * SinOsc.kr(idx/22,mul:0.3,add:1), 0.1,mul:10) + ( isig * 0.1 );
	});
	dellfo = SinOsc.ar((1..8).scramble/28 * ( 1 + ( SinOsc.kr((1..8)/24) * 1 ))) * ( (0..7).scramble/8-0.5 * 400 );
	sig = DelayC.ar(sig, 0.1,0.001 + SinOsc.ar(dellfo).range(0,0.001)) + sig;
	sig.debug("sig");
	pan = pan + LFNoise1.kr((1..8)/18,mul:0.7);
	sig = sig * 1.0;
	sig = sig * LFNoise1.kr(1/21).range(0.7,1.3);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);


