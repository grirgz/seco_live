
(
Ndef(\cyber, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sigA, sigB;
	var oscA, oscB;
	var leak= \leak.kr(0.9);
	sig = LocalIn.ar(2) * \fb.kr(0.1)  + \ktrig.tr(1);
	sig = Integrator.ar(sig, \leakA.kr(1) * leak);
	sigA = sig;
	Out.ar(BusDef(\sigA, \audio, 1), sigA);
	sig = sig * \facA.kr(1);
	sig = Integrator.ar(sig, \leakB.kr(1) * leak);
	sigB = sig;
	Out.ar(BusDef(\sigB, \audio, 1), sigB);
	sig = sig * \facB.kr(1) * (-1);
	//sig.poll;
	//sig = Limiter.ar(sig, 1, dur:0.001);
	sig = DelayL.ar(sig, 0.1, \delay.kr(0.1));
	LocalOut.ar(sig);
	//sig = SinOsc.ar(\oscAfreq.kr(100)) * sigA * \oscAamp.kr(1);
	//sigB = SinOsc.ar(1); 
	oscB = ( SinOsc.ar(\oscBfreq.kr(342)) * sigB.poll * \oscBamp.kr(1) );
	//sig = sig * 0.1;
	//sig = Limiter.ar(sig, 0.1, dur:0.001);
	//sig = sig * amp;
	//sig = oscA + oscB;
	sig = oscB;
	sig = Pan2.ar(sig, pan, amp);
	sig;
	sigB
}).play
);

Ndef(\cyber).clear
Ndef(\cyber).edit


scope
BusDef(\sigB, \audio, 1).scope

// simple cross-FM, inspired by Joker Nies
(
Ndef(\xfm, { arg freqA = 32, freqB = 9, modAtoB=540, modBtoA=240;
	var fbIn = LocalIn.ar(2);
	var sigs = SinOsc.ar([freqA, freqB] + (fbIn.reverse * [modBtoA, modAtoB]));
	LocalOut.ar(sigs);
	sigs * 0.1;
}).play;

Spec.add(\freqA, [1, 10000, \exp]);
Spec.add(\freqB, [1, 10000, \exp]);
Spec.add(\modBtoA, [0, 1000, 5]);
Spec.add(\modAtoB, [0, 1000, 5]);

Ndef(\xfm).gui;
);

// some chaotic presets that display roughness, instabilities, or
Ndef('xfm').set('freqA', 9.0, 'freqB', 40.0, 'modAtoB', 205,  'modBtoA', 243.64);
Ndef('xfm').set('freqA', 5, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 155); // try riding the modBtoA slider just slightly with the arrow buttons > find completely different states; hysteresis when returning. Pitch may move in reverse.
Ndef('xfm').set('freqA', 14, 'freqB', 6.69, 'modAtoB', 151, 'modBtoA', 402);

Ndef('xfm').set('freqA', 5, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 204); // chaotic oscillation between several states

// settling after a short while - press 'send' on the GUI to restart process deterministically
Ndef('xfm').set('freqA', 5.0, 'freqB', 6.36, 'modAtoB', 342.65, 'modBtoA', 448.48);
Ndef('xfm').set('freqA', 223.46, 'freqB', 6.69, 'modAtoB', 70.57, 'modBtoA', 726.15);
Ndef('xfm').set('freqA', 18, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 172.0);

// ideas to extend:
// - add sample-and-hold
// - more than 2 operators in circle feedback topology


~snd = "test.wav"
~buffer = Buffer.read(s, ~snd);
~buffer = BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");

(
SynthDef(\test, {
	var snd, local, trig;
	local = LocalIn.ar(2);
	local = (LPF.ar(local[0], 10) * 1000);
	trig = PulseDivider.ar(local, 2).scope;
	snd = PlayBuf.ar(2, ~buffer, trigger: Delay1.kr(trig), rate: BufRateScale.kr(~buffer) * local.linlin(-1,1,0.01,1), startPos: TIRand.kr(0, BufFrames.kr(~buffer) / 2 , trig));
	snd = CombC.ar(snd, 4, local.linlin(-1,1,0.01, 4));
	LocalOut.ar(snd.fold2);
	Out.ar(\out.kr(0), snd * 0.1);
}).play;
)














//////////////////////////////


(
// chaotic feedback
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Impulse.ar(0);
	sig = Decay.ar(WhiteNoise.ar, 0.01);
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	mod1.poll;
	LocalOut.ar(sig);
	sig = SinOsc.ar(mod1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Impulse.ar(0);
	sig = Decay.ar(WhiteNoise.ar, 0.1);
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	mod2 = Integrator.ar(sig,0.9);
	mod2.poll;
	LocalOut.ar(sig);
	sig = SinOsc.ar(mod1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = SinOsc.ar(freq);
	mod1 = Integrator.ar(sig, \coef.kr(0.9));
	//mod1.poll;
	sig = SinOsc.ar(\freq2.kr(100) * ( mod1 * \fma.kr(0.1) + 1 ).poll(100));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\zed).edit

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Impulse.ar(0);
	sig = Decay.ar(WhiteNoise.ar, 0.1);
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	mod2 = Integrator.ar(sig,\leak.kr(0.9));
	mod2.poll;
	sig = sig.neg;

	LocalOut.ar(sig);
	sig = SinOsc.ar(mod1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
WindowDef(\NdefEditor).front(Ndef(\zed))
(
	// full network but dont work
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Impulse.ar(0);
	sig = Decay.ar(WhiteNoise.ar, 0.01);
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	sig = sig * 1;
	sig = Integrator.ar(sig,\leak.kr(0.9));
	mod2 = sig;
	sig = sig.neg * 1;
	sig = Integrator.ar(sig,\leak.kr(0.9));
	LocalOut.ar(sig);

	mod2.poll;
	sig = SinOsc.ar(mod2);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
	// am instead of fm
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Impulse.ar(0);
	sig = Decay.ar(WhiteNoise.ar, 0.01);
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	sig = sig * 1;
	sig = Integrator.ar(sig,\leak.kr(0.9));
	mod2 = sig;
	sig = sig.neg * 1;
	sig = Integrator.ar(sig,\leak.kr(0.9));
	LocalOut.ar(sig);

	//mod2.poll;
	sig = SinOsc.ar(freq) * ( mod2 * \ama.kr(0.1) * 0.001 + 1 ).clip(-1,1).poll(100);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// am instead of fm
	// delay
	// value too big
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Impulse.ar(0);
	sig = Decay.ar(WhiteNoise.ar, 0.01); // incorrect
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	sig = sig * 1;
	sig = Integrator.ar(sig,\leak.kr(0.9));
	mod2 = sig;
	sig = sig.neg * 1;
	sig = Integrator.ar(sig,\leak.kr(0.9));
	sig = DelayL.ar(sig, 0.21);
	LocalOut.ar(sig);

	//mod2.poll;
	sig = SinOsc.ar(freq) * ( mod2 * \ama.kr(0.1) * 0.00000001 + 1 ).clip(-1,1).poll(100);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// with lpf
	// am instead of fm
	// delay
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = Impulse.ar(0);
	sig = Decay.ar(Impulse.ar(0), 0.1) * WhiteNoise.ar; // correct
	mod3 = sig;
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	sig = sig * \iamp.kr(1.4); // 1.4 seems stable
	sig = LPF.ar(sig, \lpf.kr(1));
	mod2 = sig;
	sig = sig.neg * \iamp.kr;
	sig = LPF.ar(sig, \lpf.kr);
	//mod1 = sig;
	//sig = DelayL.ar(sig, 0.21);
	LocalOut.ar(sig);

	//mod2.poll;
	lfo2 = ( mod2 * \ama.kr(0.1) + 1 ).clip(-10,10); // try with big ama
	//lfo2.poll(100);
	mod2.poll(100);
	sig = SinOsc.ar(freq) * lfo2;
	//sig = sig + SinOsc.ar(\freq2.kr(200)) * ( mod1 * \ama.kr(0.1) + 1 ).clip(-10,10).poll(100);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
WindowDef(\NdefEditor).front(Ndef(\zed))
Ndef(\zed).addSpec(\lpf, \lofreq)
Ndef(\zed).addSpec(\lpf, \lofreq)
Ndef(\zed).quant

(
	// This WORKS!!!!  with big ama and iamp=1.4
	// with lpf
	// am instead of fm
	// delay
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = Impulse.ar(0);
	//sig = Decay.ar(Impulse.ar(0), 0.01) * WhiteNoise.ar; // correct
	mod3 = sig;
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	sig = sig * \iamp.kr(1);
	sig = LPF.ar(sig, \lpf.kr(1));
	mod2 = sig;
	sig = sig.neg * \iamp.kr;
	sig = LPF.ar(sig, \lpf.kr);
	//mod1 = sig;
	//sig = DelayL.ar(sig, 0.21);
	LocalOut.ar(sig);

	//mod2.poll;
	lfo1 = ( mod1 * \ama.kr(0.1) + 1 ).clip(-2,2);
	lfo2 = ( mod2 * \ama.kr(0.1) + 1 ).clip(-2,2);
	lfo2.poll(10);
	//mod2.poll(100);
	sig = SinOsc.ar(freq) * lfo1;
	sig = sig + ( SinOsc.ar(\freq2.kr(200)) * lfo2 );
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

////////////////////////////

// think another way


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Decay.ar(WhiteNoise.ar, 0.01);
	sig = LocalIn.ar(2) * \fb.kr(0.1) + sig;
	mod1 = Amplitude.ar(sig);
	sig = sig * ( 1/mod1 );
	mod2 = sig;
	LocalOut.ar(sig);
	mod2.poll;
	sig = SinOsc.ar(freq * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
WindowDef(\NdefEditor).front(Ndef(\zed))

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Decay.ar(WhiteNoise.ar, 0.01);
	sig = LocalIn.ar(2) * \fb.kr(0.1) + sig;
	mod1 = Amplitude.ar(sig);
	sig = sig - ( mod1 - 1);
	mod2 = sig;
	LocalOut.ar(sig);
	mod2.poll;
	sig = SinOsc.ar(freq * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


// i should find a way to regulate the feedback with threshold

(
	// lag the amplitude measure
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = Decay.ar(WhiteNoise.ar, 0.01);
	sig = LocalIn.ar(2) * \fb.kr(0.1) + sig;
	mod1 = Amplitude.ar(sig).lag(1);
	sig = sig * ( 1/mod1 );
	sig = LPF.ar(sig, \lpf.kr(1));
	mod2 = sig;
	LocalOut.ar(sig);
	mod2.poll;
	sig = SinOsc.ar(freq * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\zed).edit


(
	// this show that an impulse in a feedback loop produce a impulse train of ControlRate frequency
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var hasPitch, pitch;
	sig = Impulse.ar(0);
	sig = LocalIn.ar(1) * 1.001 + sig;
	mod2 = sig;
	LocalOut.ar(sig);
	ZeroCrossing.ar(mod2).poll;
	//sig = SinOsc.ar(freq * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = mod2;
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);

(
	// but with an LPF, you have the slowly (but exponientialy) increasing value
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var hasPitch, pitch;
	sig = Impulse.ar(0);
	sig = LocalIn.ar(1) * 1.1 + sig;
	sig = LPF.ar(sig, 1);
	mod2 = sig;
	LocalOut.ar(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	//sig = SinOsc.ar(freq * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = mod2;
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);

(
	// doesnt work, stuck at 0.99, goes up quicker, never goes down
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var hasPitch, pitch;
	sig = Impulse.ar(0);
	sig = LocalIn.ar(1) * 1.1 + sig;
	sig = LPF.ar(sig, 1);
	mod2 = sig;
	sig = ( ( sig > 1 ) * ( sig * 0.05 ) ) + ( ( sig < 0.1 ) * ( sig * 2 ) ) + ( ( sig > 0.1 ) * ( sig < 1 ) * ( sig ) );
	LocalOut.ar(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	//sig = SinOsc.ar(freq * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = mod2;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);

(
	// work like a charm
	// Schmidt
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var hasPitch, pitch;
	sig = Impulse.ar(0);
	sig = LocalIn.ar(1) * 1.1 + sig;
	sig = LPF.ar(sig, 5);
	mod2 = sig;
	sig = sig * Select.ar(Schmidt.ar(sig, lo:0.1, hi:1), DC.ar([2,0.5]));
	LocalOut.ar(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	//sig = SinOsc.ar(freq * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = mod2;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);

(
	// more Schmidt
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var hasPitch, pitch;
	sig = Impulse.ar(0);
	sig = LocalIn.ar(1) * \fb.kr(1.1) + sig;
	sig = LPF.ar(sig, \lpf.kr(5));
	mod2 = sig;
	sig = sig * Select.ar(Schmidt.ar(Amplitude.ar(sig), lo:0.1, hi:1), K2A.ar([\corfac.kr(2),1 / \corfac.kr]));
	LocalOut.ar(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	sig = SinOsc.ar(freq * ( mod2 * \fmamp.kr(0.5) + 1 ));
	//sig = mod2;
	//sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);
WindowDef(\NdefEditor).front(Ndef(\zed))

////////////////////////////
// next stage


(
Ndef(\cyber, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fbmain, fbosc;
	//sig = Decay.ar(Impulse.ar(0), 0.01) * WhiteNoise.ar; // correct
	fbmain = FbNode(1);
	fbosc = FbNode(2);
	sig = Impulse.ar(0);
	sig = sig + ( LocalIn.ar(1) * \fb.kr(1.0) );
	mod1 = sig;
	//sig = sig * \iamp.kr(1) * fbosc[1];
	sig = sig * \iamp.kr(1);
	sig = LPF.ar(sig, \lpf.kr(1));
	mod2 = sig;
	//sig = sig.neg * \iamp.kr * fbosc[0];
	sig = sig.neg * \iamp.kr;
	sig = LPF.ar(sig, \lpf.kr);
	//mod1 = sig;
	//sig = DelayL.ar(sig, 0.21);
	fbmain.write(sig);

	//mod2.poll;
	lfo1 = ( mod1 * \ama.kr(0.1) + 1 ).clip(-2,2);
	lfo2 = ( mod2 * \ama.kr(0.1) + 1 ).clip(-2,2);
	//lfo2.poll(10);
	mod2.poll(100);
	//fbosc[0].poll;
	sig1 = SinOsc.ar(freq * ( fbosc[1] * \fmamp.kr(0.5) + 1 ) ) * lfo1;
	sig2 = SinOsc.ar(\freq2.kr(200) * ( fbosc[0] * \fmamp.kr(0.5) + 1 )) * lfo2;
	fbosc.write( [ EnvFollow.ar(sig1), EnvFollow.ar(sig2) ] );
	sig = [sig1, sig2].sum;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
WindowDef(\NdefEditor).front(Ndef(\cyber))
Ndef(\cyber).addSpec(\lpf, \lofreq)
Ndef(\cyber).addSpec(\fmamp, ControlSpec(0,10,\lin))


{ var source = SinOsc.ar(40); var env = EnvFollow.ar(source, 0.999); [source,env] }.plot(0.5)
{ var source = SinOsc.ar(140); var env = Amplitude.ar(source); [source,env] }.plot(0.5)

{ControlRate.ir.reciprocal.poll}.play
{ControlRate.ir.poll}.play


(
	// model 1 with FbNode
Ndef(\cyber, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fbmain, fbosc;
	sig = Impulse.ar(0);
	//sig = Decay.ar(Impulse.ar(0), 0.01) * WhiteNoise.ar; // correct
	mod3 = sig;
	fbmain = FbNode(1);
	sig = sig + ( fbmain * \fb.kr(1.0) );
	mod1 = sig;
	sig = sig * \iamp.kr(1);
	sig = LPF.ar(sig, \lpf.kr(1));
	mod2 = sig;
	sig = sig.neg * \iamp.kr;
	sig = LPF.ar(sig, \lpf.kr);
	//mod1 = sig;
	//sig = DelayL.ar(sig, 0.21);
	fbmain.write(sig);

	//mod2.poll;
	lfo1 = ( mod1 * \ama.kr(0.1) + 1 ).clip(-2,2);
	lfo2 = ( mod2 * \ama.kr(0.1) + 1 ).clip(-2,2);
	lfo2.poll(10);
	//mod2.poll(100);
	sig = SinOsc.ar(freq) * lfo1;
	sig = sig + ( SinOsc.ar(\freq2.kr(200)) * lfo2 );
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// model 2 with FbNode
	// no iamp modulation
Ndef(\cyber, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fbmain, fbosc;
	sig = Impulse.ar(0);
	//sig = Decay.ar(Impulse.ar(0), 0.01) * WhiteNoise.ar; // correct
	mod3 = sig;
	fbmain = FbNode(1);
	fbosc = FbNode(2);
	sig = sig + ( fbmain * \fb.kr(1.0) );
	mod1 = sig;
	sig = sig * \iamp.kr(1);
	sig = LPF.ar(sig, \lpf.kr(1));
	mod2 = sig;
	sig = sig.neg * \iamp.kr;
	sig = LPF.ar(sig, \lpf.kr);
	//mod1 = sig;
	//sig = DelayL.ar(sig, 0.21);
	fbmain.write(sig);

	//mod2.poll;
	lfo1 = ( mod1 * \ama.kr(0.1) + 1 ).softclip(-2,2);
	lfo2 = ( mod2 * \ama.kr(0.1) + 1 ).softclip(-2,2);
	lfo4 = fbosc[1] * \fmamp.kr(0.5) + 1;
	lfo5 = fbosc[0] * \fmamp.kr(0.5) + 1;
	lfo4.poll(10);
	//mod2.poll(100);
	sig1 = SinOsc.ar(freq * lfo4) * lfo1;
	sig2 = SinOsc.ar(\freq2.kr(200) * lfo5) * lfo2;
	fbosc.write([EnvFollow.ar(sig1), EnvFollow.ar(sig2)]);
	sig = [sig1, sig2].sum;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// model 2 with FbNode
	// with iamp modulation
Ndef(\cyber, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fbmain, fbosc;
	sig = Impulse.ar(0);
	//sig = Decay.ar(Impulse.ar(0), 0.01) * WhiteNoise.ar; // correct
	mod3 = sig;
	fbmain = FbNode(1);
	fbosc = FbNode(2);
	lfo4 = fbosc[1] * \fmamp.kr(0.5) + 1;
	lfo5 = fbosc[0] * \fmamp.kr(0.5) + 1;

	sig = sig + ( fbmain * \fb.kr(1.0) );

	mod1 = sig;
	sig = sig * \iamp.kr(1) * lfo4;
	sig = LPF.ar(sig, \lpf.kr(1));
	mod2 = sig;
	sig = sig.neg * \iamp.kr * lfo5;
	sig = LPF.ar(sig, \lpf.kr);
	//mod1 = sig;
	//sig = DelayL.ar(sig, 0.21);
	fbmain.write(sig);

	//mod2.poll;
	lfo1 = ( mod1 * \ama.kr(0.1) + 1 ).softclip(-2,2);
	lfo2 = ( mod2 * \ama.kr(0.1) + 1 ).softclip(-2,2);
	lfo4.poll(10);
	//mod2.poll(100);
	sig1 = SinOsc.ar(freq * lfo4) * lfo1;
	sig2 = SinOsc.ar(\freq2.kr(200) * lfo5) * lfo2;
	fbosc.write([EnvFollow.ar(sig1), EnvFollow.ar(sig2)]);
	sig = [sig1, sig2].sum;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);




///////////////////////////
// testing with Schmidt


(
	// both osc are phase sync unlike before
Ndef(\schmidt, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var fbmain;
	sig = Impulse.ar(0);
	fbmain = FbNode(1);
	sig = fbmain * \fb.kr(1.1) + sig;
	sig = LPF.ar(sig, \lpf.kr(5));
	mod1 = sig;
	sig = sig * Select.ar(Schmidt.ar(Amplitude.ar(sig), lo:0.1, hi:1), K2A.ar([\corfac.kr(2),1 / \corfac.kr]));
	mod2 = sig;
	fbmain.write(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	sig1 = SinOsc.ar(freq * ( mod1 * \fmamp.kr(0.5) + 1 ));
	sig2 = SinOsc.ar(\freq2.kr(200) * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = [sig1, sig2].sum;
	//sig = mod2;
	//sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);
WindowDef(\NdefEditor).front(Ndef(\schmidt))
Spec.add(\lpf, \lofreq);
Spec.add(\schlag, \lag);
Spec.add(\fb, ControlSpec(0,4,\lin));

(
	// adding back .neg
Ndef(\schmidt, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var fbmain;
	sig = Impulse.ar(0);
	fbmain = FbNode(1);
	sig = fbmain * \fb.kr(1.1) + sig;
	mod1 = sig;
	sig = LPF.ar(sig, \lpf.kr(5));
	sig = sig * Select.ar(Schmidt.ar(Amplitude.ar(sig), lo:0.1, hi:1), K2A.ar([\corfac.kr(2),1 / \corfac.kr]));
	mod2 = sig;
	sig = sig.neg;
	sig = LPF.ar(sig, \lpf.kr(5));
	fbmain.write(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	sig1 = SinOsc.ar(freq * ( mod1 * \fmamp.kr(0.5) + 1 ));
	sig2 = SinOsc.ar(\freq2.kr(200) * ( mod2 * \fmamp.kr(0.5) + 1 ));
	sig = [sig1, sig2].sum;
	//sig = mod2;
	//sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);

(
	// back to AM
	// nice alternating tone like in the paper
	// some regular click, i think due to Schmidt regulating amplitude
Ndef(\schmidt, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var fbmain;
	sig = Impulse.ar(0);
	fbmain = FbNode(1);
	sig = fbmain * \fb.kr(1.1) + sig;
	mod1 = sig;
	sig = LPF.ar(sig, \lpf.kr(5));
	sig = sig * Select.ar(Schmidt.ar(Amplitude.ar(sig), lo:0.1, hi:1), K2A.ar([\corfac.kr(2),1 / \corfac.kr]));
	mod2 = sig;
	sig = sig.neg;
	sig = LPF.ar(sig, \lpf.kr(5));
	fbmain.write(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	mod4 = 0;
	mod5 = 0;
	sig1 = SinOsc.ar(freq * ( mod4 * \fmamp.kr(0.5) + 1 )) * mod1;
	sig2 = SinOsc.ar(\freq2.kr(200) * ( mod5 * \fmamp.kr(0.5) + 1 )) * mod2;
	sig = [sig1, sig2].sum;
	//sig = mod2;
	//sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);

(
	// with SelectX the click disapear
Ndef(\schmidt, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var fbmain;
	sig = Impulse.ar(0);
	fbmain = FbNode(1);
	sig = fbmain * \fb.kr(1.1) + sig;
	mod1 = sig;
	sig = LPF.ar(sig, \lpf.kr(5));
	sig = sig * SelectX.ar(Schmidt.ar(Amplitude.ar(sig), lo:0.1, hi:1).lag(\schlag.kr(1)), K2A.ar([\corfac.kr(2),1 / \corfac.kr]));
	mod2 = sig;
	sig = sig.neg;
	sig = LPF.ar(sig, \lpf.kr(5));
	fbmain.write(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	mod4 = 0;
	mod5 = 0;
	sig1 = SinOsc.ar(freq * ( mod4 * \fmamp.kr(0.5) + 1 )) * mod1;
	sig2 = SinOsc.ar(\freq2.kr(200) * ( mod5 * \fmamp.kr(0.5) + 1 )) * mod2;
	sig = [sig1, sig2].sum;
	//sig = mod2;
	//sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp) * 0.1;
	sig = Limiter.ar(sig);
}).play;
);

(
Ndef(\schmidt, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var fbmain, fbosc;
	sig = Impulse.ar(0);
	fbmain = FbNode(1);
	fbosc = FbNode(2);
	sig = fbmain * \fb.kr(1.1) + sig;
	mod1 = sig;
	sig = sig * ( fbosc[1] * \fboscamp.kr(0.4) + 1 );
	sig = LPF.ar(sig, \lpf.kr(5));
	mod2 = sig;
	sig = sig.neg * ( fbosc[0] * \fboscamp.kr + 1 );
	sig = LPF.ar(sig, \lpf.kr(5));
	sig = sig * SelectX.ar(Schmidt.ar(Amplitude.ar(sig), lo:0.1, hi:1).lag(\schlag.kr(1)), K2A.ar([\corfac.kr(2),1 / \corfac.kr]));
	fbmain.write(sig);
	//ZeroCrossing.ar(mod2).poll;
	mod2.poll;
	mod4 = fbosc[1];
	mod5 = fbosc[0];
	sig1 = SinOsc.ar(freq * ( mod4 * \fmamp.kr(0.5) + 1 )) * mod1;
	sig2 = SinOsc.ar(\freq2.kr(200) * ( mod5 * \fmamp.kr(0.5) + 1 )) * mod2;
	fbosc.write(EnvFollow.ar([sig1, sig2]));
	sig = [sig1, sig2].sum;
	//sig = mod2;
	//sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp) * 0.1;
	sig = Limiter.ar(sig);
}).play;
);
WindowDef(\NdefEditor).front(Ndef(\schmidt))
