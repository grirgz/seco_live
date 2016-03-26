
/////// pattern delay
// TODO: 
// - pitch control
// - pattern bank
// - amptab pattern bank (morphing ?)
// - sync and not sync

Veco(~name).lib.dsize = 8;

Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var size = Veco(~name).lib.dsize;

	sig = DelayL.ar([in], \maxdelay.kr(1) / ~t, 2**(\delaytab.kr(1!size))/128 / ~t);
	sig = sig * \amptab.kr(1!size);
	//sig = sig + in;

	//sig = SinOsc.ar(210);

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig.sum;
	sig.debug("sig");
	sig;
});
Ndef(~name+++\fx).addSpec(\delaytab, XArraySpec( ControlSpec(0,7,\lin, 1) ! Veco(~name).lib.dsize ));
Ndef(~name+++\fx).addSpec(\amptab, XArraySpec( ControlSpec(0.001,1,\exp) ! Veco(~name).lib.dsize ));

// END

(
ParamGroup([ 
	Param( Ndef(~name+++\fx), \delaytab),
	Param( Ndef(~name+++\fx), \amptab),
]).edit
)

2**((0..7))/128
1/128
