
(
Ndef(\gradubid0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1/2*~t).range(1,20);
	freq = (1..10)*lfo1+200;
	sig = SinOsc.ar(freq).mean;
	sig = sig + LFSaw.ar(freq).mean;
	lfo2 = Duty.kr(1/~t, 0, Dseq([
		2,1,1,1,
	],inf));
	sig = CuspN.ar(lfo2 * 100, 1.8);
	sig = LPF.ar(sig, 1000);
	sig = Pan2.ar(sig, pan, amp);
});
);

(
Ndef(\gradubid1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1/2*~t).range(1,20);
	freq = (1..10)*lfo1+200;
	sig = SinOsc.ar(freq).mean;
	sig = sig + LFSaw.ar(freq).mean;
	lfo2 = Duty.kr(1/~t, 0, Dseq([
		2,1,1,1,
	],inf));
	sig = CuspN.ar(lfo2 * 100, 1.8);
	//sig = LPF.ar(sig, 1000);
	sig = Pan2.ar(sig, pan, amp);
});
);

(
Ndef(\gradubid2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1/2*~t).range(1,20);
	freq = (1..10)*lfo1+200;
	sig = SinOsc.ar(freq).mean;
	sig = sig + LFSaw.ar(freq).mean;
	lfo2 = Duty.kr(1/~t, 0, Dseq([
		2,1,1,1,
	],inf));
	sig = CuspN.ar(lfo2 * 100, 1.8, 2.2);
	sig = sig + CuspN.ar(lfo2* 400, 1);
	sig = LPF.ar(sig, 5000);
	sig = HPF.ar(sig, 200);
	sig = Pan2.ar(sig, pan, amp);
});
);

(
Ndef(\gradubid3, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1/2*~t).range(1,20);
	freq = (1..10)*lfo1+200;
	sig = SinOsc.ar(freq).mean;
	sig = sig + LFSaw.ar(freq).mean;
	lfo2 = Duty.kr(1/~t, 0, Dseq([
		2,1,1,1,
	],inf));
	lfo4 = Duty.kr(1/2/~t, 0, Dseq([
		2,2,2,2,
		2,2,2,8,
	],inf));
	lfo3 = SinOsc.kr(lfo4*~t).range(1,8);
	sig = CuspN.ar(lfo2 * 100, 3.8, 2.2);
	sig = sig + CuspN.ar(lfo2* 400, 1);
	sig = LPF.ar(sig, 500 * lfo3);
	sig = HPF.ar(sig, 200);
	sig = Pan2.ar(sig, pan, amp);
});
);


(
Ndef(\police, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = LFSaw.ar(freq * SinOsc.kr(1/4*~t).range(2,1).pow(2).tanh);
	sig = sig * 1/2;
	sig = LFPulse.ar(2*~t,pi,0.2) * sig;
	sig = sig * LFSaw.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
});
);

