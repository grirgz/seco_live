
// equations lotka volterra


(
	// does not work 
Ndef(\lotka, { arg freq=200, pan=0, amp=0.1, freq2=500, fm1up=(2/3), fm1down=(4/3), fm2up=1, fm2down=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fm1, fm2;
	var dfm1, dfm2;
	var fm;
	var delta = \delta.kr(0.000000001);
	delta = s.options.blockSize * SampleDur.ir;		
	delta = SampleDur.ir;		
	fm = LocalIn.ar(2) * \fb.kr(1) + (Trig1.ar(1,0.12)*[freq,freq2]/4);
	fm1 = fm[0];
	fm2 = fm[1];
	dfm1 = fm1up * fm1 - ( fm1down * fm1 * fm2 );
	dfm2 = fm2up * fm1 * fm2 - ( fm2down * fm2 );
	dfm1.poll;
	fm1 = fm1 + (dfm1 * delta);
	fm2 = fm2 + (dfm2 * delta);
	sig1 = SinOsc.ar(fm1);
	sig2 = SinOsc.ar(fm2);
	LocalOut.ar([fm1, fm2]);
	sig = [sig1, sig2];
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);
Ndef(\lotka).edit
