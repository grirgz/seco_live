
~make_fx.();

(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = sig + Fb({ arg fb;
		var isig;
		isig = fb * 0.89 + sig;
		isig = isig + Fb({ arg fb;
			var jsig;
			jsig = fb * 0.69 + isig;
			jsig = HPF.ar(jsig, Ndef(~name+++\hpf).ar) + (jsig * 0.1);
			jsig = LPF.ar(jsig, Ndef(~name+++\lpf).ar) + (jsig * 0.1);
			//jsig = FreqShift.ar(jsig, -10) + (jsig * 0.1)
		},1/4);
		//isig = isig.tanh + (isig * Ndef(~name+++\dist).ar);
		isig = isig.wrap(-1,1) + (isig * Ndef(~name+++\dist).ar);
		isig.postln;
		isig;
	},1/2);

	sig = sig / 4;
	sig;
});
)

Ndef(~name+++\hpf, { 10 })
Ndef(~name+++\lpf, { 14170 })
Ndef(~name+++\dist, { [0.5,0.4] })
Ndef(~name+++\dist, { 0.03 })
Ndef(~name+++\dist).clear


// END
