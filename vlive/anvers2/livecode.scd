

~tblafx = BusDef(\blafx, \audio);

(
~set_out_bus.('2', 0);
~set_out_bus.('1', 0);
)

(
~set_out_bus.('2', ~tblafx);
~set_out_bus.('1', ~tblafx);
)

(
Ndef(\plop, { arg freq=200, pan=0, amp=1, clip, distmix= 0.5;
	var sig;
	var sig2;
	var sig3;
	var mix2;
	sig = InFeedback.ar(~tblafx, 2);
	//sig = CombL.ar(sig, 0.1,0.01*CuspN.ar(1).abs,0.1) + sig;
	sig2 = sig;
	//sig2 = sig2 * 50;
	sig2 = sig2 * 50 * CuspN.ar(4).abs;
	sig2 = sig2.clip2(0.18);
	sig2 = sig2 * 50 * SinOsc.kr(4).abs;
	sig2 = sig2.distort * 0.18;
	sig = SelectX.ar(distmix, [sig, sig2]);

	sig2 = LPF.ar(sig, 8000);
	sig3 = HPF.ar(sig, 1000);
	//mix2 = LFNoise1.kr(4).range(0.5,2.5);
	mix2 = Demand.kr(Impulse.kr(4*t), 0, Dseq([0,1,2,1],inf)).lag(0.2).poll;
	sig = SelectX.ar(mix2, [sig, sig2, sig3]);
	//sig = sig * LFSaw.ar(CuspN.ar(1) * 300);

	//sig = Pan2.ar(sig, pan, amp);
	sig;
}).play;
);

Pbindef('1mod', \isRest, Pseq([1,0,0,0, 0,0,0,0, 1,0,1,0, 0,0,0.5,0],inf).coin.not);
Pbindef('2mod', \isRest, Pseq([0,0,0,0, 1,0,0.5,0, 0,0,0.5,0, 1,0,0,0],inf).coin.not);

Pbindef('1mod', \isRest, Pseq([1,0,0.5,0, 0.5,0,0,0, 0,0,1,0,		0,0,0.5,0],inf).coin.not);
Pbindef('2mod', \isRest, Pseq([0,0,0,0, 0,0,0.5,0, 1,0,0.5,0,   0,0,0,0],inf).coin.not);

Pbindef('1mod', \isRest, Pseq([1,0],inf) < 1);
Pbindef('2mod', \isRest, Pseq([0,0,0,0, 1,0,1,0, 0,0,0,0, 1,0,0,0],inf) < 1);
Pbindef('2mod', \isRest, Pwalk([0,0,0,0, 1,0,1,0, 0,0,0,0, 1,0,0,0],Pseq([1,1,1,2],inf)) < 1);
Pbindef('1mod', \isRest, Pwalk([0,0,0, 1,0,1,0, 0,0,0,0, 1,0,0,0,0],Pseq([1,4,1,2],inf)) < 1);
Pbindef('1mod', \isRest, nil);
Pbindef('2mod', \isRest, nil);

Ndef(\plop).set(\distmix, 1)
Ndef(\plop).set(\distmix, 0)
Ndef(\plop).unset(\distmix)


Ndef(\plop).map(\distmix, Ndef(\lfo1, { LFNoise0.kr(1).range(0,1).poll }))





