
/////// reverse delay
// TODO: 
// - do kind of cool effect but don't know what is happening, need to think hard to understand how to do reverse delay

Veco(~name).lib.dsize = 8;

Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var size = Veco(~name).lib.dsize;
	var bufnum = LocalBuf(s.sampleRate * 2/~t, 2);
	var speed=1, pos=0, doneAction=0, loop=1;
	var delay = 1/2/~t;
	var trigger = Trig.kr(Impulse.kr(1/delay), 0.01);

	sig = in;
	RecordBuf.ar(sig, bufnum, offset:0, recLevel:0.9, preLevel:0.1, run:1, loop:1, trigger:1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed * -1, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);

	//sig = sig + in;

	//sig = SinOsc.ar(210);

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// END

(
ParamGroup([ 
	Param( Ndef(~name+++\fx), \delaytab),
	Param( Ndef(~name+++\fx), \amptab),
]).edit
)

2**((0..7))/128
1/128
