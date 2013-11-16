(
Ndef(~name, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2;
	mod1 = \mod1.kr(1);
	mod2 = \mod2.kr(40);
	//mod2 = XLine.kr(8000,1,10);
	//mod2 = XLine.kr(40,5000,10);
	sig = SinOsc.ar(LFNoise1.kr([1,2,3,4,5,6] * mod1).range(50,mod2));
	sig = sig.sum;
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
}).play;

//Ndef(~name+++\mod1, {  XLine.kr(Ndef(~name+++\mod1).kr,100,10)});
//Ndef(~name+++\mod2, { XLine.kr(Ndef(~name+++\mod2).kr,10000,10) });
Ndef(~name).map(\mod1, Ndef(~name+++\mod1));
Ndef(~name).map(\mod2, Ndef(~name+++\mod2));
~morph_to.(\mod2, { arg from;  {XLine.kr(from.value,500,10)}});
~morph_to.(\mod1, { arg from;  {XLine.kr(from.value,9,10)}});
//Ndef(~name+++\mod2, { XLine.kr(8000,1,10) });
);
// END
Ndef(\plop).stop
play{mean({|i|99**(-1-LFSaw.kr(i+1/180,1))*SinOsc.ar(i+1*55)}!48)!2}

(
~morph_to = { arg key, gen;
	Ndef(~name+++key, gen.value({Ndef(~name+++key).kr}));
}
)
