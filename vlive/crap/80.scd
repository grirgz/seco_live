(
Ndef(\pop,{ arg amp = 0.3;
	var pm;
var fund = XLine.kr(30,78,16).midicps;
fund = 46.midicps * SinOsc.kr(1/19 * [1,1.01]).range(1,1.101) * [1,2];
pm = 5.collect({ arg y;
	var pm1;
	pm = PMOsc.ar(fund, fund/ 2.05, 2pi*0.1);
	5.do({ arg item, i; pm = SinOsc.ar(fund/(2+0.01)*( y+(1/ 3 * item )), i/4 * SinOsc.kr( 1/i/10/4 ).range(0,2pi+y)*pm)});
	pm1 = BPF.ar(pm, SinOsc.kr(1/18*y/2).range(200,7001), SinOsc.kr(1/7/7/y).range(0.1,1));
	pm = SelectX.ar( SinOsc.kr(y+1/5/5).range(0,1), [pm, pm1]);
	pm;
});
pm = pm.debug("pm").flatten;
Pan2.ar(pm, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! pm.size, amp).mean;
}).play;
)

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var xsig, ysig, zsig;
	var isig;

	freq = freq * (1..8)/4;

	//isig = SinOsc.ar(freq);
	isig = DC.ar(0);
	ysig = DC.ar(0);
	3.do { arg z;
		ysig = 3.collect ({ arg y;
			xsig = isig;
			3.do { arg x;
				xsig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(y/5*freq) * ( SinOsc.kr(z+1).range(0,1) ) )) * x/5) + xsig;
			};
			xsig
		}) + ysig;
		ysig;
	};
	sig = ysig;
	sig.debug("sig");
	sig = sig.flatten;
	Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);
