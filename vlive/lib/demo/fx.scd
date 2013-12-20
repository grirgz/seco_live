
~name = '36';

~newfxmix.(\fx); // fx using mixer
~newfx.(\fx); // fx
Veco(~name).make_mixer; // mixer

//////////// clip


//b = Buffer.alloc(s, s.sampleRate * 0.125 * 9,2);
(
//Ndef(~name+++\fx, { arg in, mix=0.5, amp=1,
Ndef(~name+++\fx, { arg mix=0.5, amp=1, del1=1, del2=1, del3=1, del4=1, del5=1, del6=1, del7=1, del8=1;
	var sigin, sig;
	var delay = 0.125;
	var numdelay = 8;
	var bufnum;
	var delays = (1..numdelay) * delay;
	bufnum = LocalBuf(s.sampleRate * delay * (numdelay+2), 2);
	bufnum.clear;
	sigin = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sigin = SinOsc.ar(200) !2;
	//bufnum = b;
	sig = MultiTap.ar(Ref( (1..numdelay) * delay), Ref([del1, del2, del3, del4, del5, del6, del7, del8]), sigin, 1, 0, bufnum);
	//sig = sigin;
	//sig[0] = DelayN.ar(sig[0], delays, delays) * [del1, del2, del3, del4, del5, del6, del7, del8];
	//sig[1] = DelayN.ar(sig[1], delays, delays) * [del1, del2, del3, del4, del5, del6, del7, del8];
	//sig[0] = sig[0].sum;
	//sig[1] = sig[1].sum;
	sig.postln;
	//sig.poll;
	//sig = sig * EnvGen.ar(Env.asr(0.0001,1,0.0001),gate,doneAction:2);
	sig = SelectX.ar(mix, [sigin, sig]);
	//Out.ar(out, sig);
});
)


// END
Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).play(BusDef(~name+++\mixer))
Ndef(~name+++\fx).stop

////////////////////////////// init

~wobblefx = '1fx';
~twobble = '1';
~tfx1 = '36';
~tfx2 = '37';
~tfx3 = '38';
~tfx4 = '39';
~fx1 = BusDef(~tfx1+++'fx', \audio, 2);
~fx2 = BusDef(~tfx2+++'fx', \audio, 2);
~fx3 = BusDef(~tfx3+++'fx', \audio, 2);
~fx4 = BusDef(~tfx4+++'fx', \audio, 2);

///////////////////////// fx in track


