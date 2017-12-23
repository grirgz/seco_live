(
SynthDef(\fxknife, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	sig = LocalIn.ar(2) * \fb.kr(0.9);
	sig = sig + in;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.1*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = CombL.ar(sig, 4/~t, 1/8/~t,1/~t) + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/2 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	sig = LocalIn.ar(2) * \fb.kr(0.7);
	sig = sig + in;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.1*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/2 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	sig = LocalIn.ar(2) * \fb.kr(0.2);
	sig = sig + in;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	//sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.kr(8*~t) * 1 + 1 ) * ( SinOsc.ar(208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.1*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	//sig = RLPF.ar(sig, SinOsc.kr(4*~t).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);

	// dist

	sig1 = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/4);
	sig = SelectX.ar(\distmix.kr(0.18), [sig, sig1]);

	// delay

	sig = DelayC.ar(sig, 2, 1/3/~t)+sig;

	// limiter

	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	//insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\gain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	//insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife4fil, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	//insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	sig = LPF.ar(sig, \lpf.kr(10000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
//Pdef(\part_drum).reset;
);

(
SynthDef(\memefx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.9);
	sig = sig + in;
	sig = FreqShift.ar(sig, \shift.kr(100)) + sig;
	sig = sig * ( 1 + ( SinOsc.ar(freq) * 1 ));
	//sig = CombL.ar(sig, 1/~t, \combbias.kr(1/2/~t) * SinOsc.kr(\comblfo.kr(2/~t)).range(1/8,1), 1) + sig;
	sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	LocalOut.ar(sig);
	sig = sig /2;
	sig = RLPF.ar(sig, 15000,0.6);
	sig = HPF.ar(sig, 150);
	sig = Limiter.ar(sig * \limit.kr(1.2)) / \limit.kr;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\medelfx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sigx;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.9);
	sig = sig + in;
	//sig = FreqShift.ar(sig, \shift.kr(100)) + sig;
	//sig = sig * ( 1 + ( SinOsc.ar(freq) * 1 ));
	sig = DelayC.ar(sig, 1, \delays1.kr(rrand(0.0001,0.4)) * SinOsc.kr(1/2).range(1,1.1)) + sig;
	sigx = sig;
	sig = DelayC.ar(sig, 1, \delays2.kr(rrand(0.0001,0.4)));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = DelayC.ar(sig, 1, \delays3.kr(rrand(0.0001,0.4)) * SinOsc.kr(1/2).range(1,1.1)) + sig;
	sig = sig + sigx;
	sig1 = Compander.ar(sig, in, \cpt.kr(0.04), \cpbelow.kr(1.701), \cpabove.kr(1), \cpclamp.kr(0.01), \cprelax.kr(2.1));
	sig = SelectX.ar(\compmix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = sig /2;
	sig = RLPF.ar(sig, \lpf.kr(15000,0.6));
	sig = HPF.ar(sig, \hpf.kr(150));
	//sig = Limiter.ar(sig * \limit.kr(1.2)) / \limit.kr;
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\medelfx2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sigx;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.9);
	sig = sig + in;
	//sig = FreqShift.ar(sig, \shift.kr(100)) + sig;
	//sig = sig * ( 1 + ( SinOsc.ar(freq) * 1 ));
	sig = DelayC.ar(sig, 1, \delays1.kr(rrand(0.0001,0.4)) * SinOsc.kr(1/2).range(1,1.1)) + sig;
	sigx = sig;
	sig = DelayC.ar(sig, 1, \delays2.kr(rrand(0.0001,0.4)));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig + sigx;
	sig = DelayC.ar(sig, 1, \delays3.kr(rrand(0.0001,0.4)) * SinOsc.kr(1/2).range(1,1.1)) + sig;
	sig1 = Compander.ar(sig, in, \cpt.kr(0.04), \cpbelow.kr(1.701), \cpabove.kr(1), \cpclamp.kr(0.01), \cprelax.kr(2.1));
	sig = SelectX.ar(\compmix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = sig /2;
	sig = RLPF.ar(sig, \lpf.kr(15000,0.6));
	sig = HPF.ar(sig, \hpf.kr(150));
	//sig = Limiter.ar(sig * \limit.kr(1.2)) / \limit.kr;
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\seqdelfx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sigx;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var delays1 = \delays1.kr(1!4);
	sig = LocalIn.ar(2) * \fb.kr(0.9);
	sig = sig + in;
	//sig = FreqShift.ar(sig, \shift.kr(100)) + sig;
	//sig = sig * ( 1 + ( SinOsc.ar(freq) * 1 ));
	sig = [
		{ arg sig;
			delays1.do { arg del;
				sig = DelayC.ar(sig, 1, del) + sig;
			};
			sig;
		}.value(sig),
		{ arg sig;
			\delays2.kr({ rrand(0.0001,0.4) }!4).do { arg del, idx;
				var xsig = sig;
				if(idx==0) {
					sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
				};
				sig = DelayC.ar(sig, 1, del) + xsig;
			};
			sig;
		}.value(sig),
		{ arg sig;
			\delays3.kr({ rrand(0.0001,0.4) }!4).do { arg del;
				sig = DelayC.ar(sig, 1, del) + sig;
			};
			sig;
		}.value(sig),
	].mean + sig;
	sig1 = Compander.ar(sig, in, \cpt.kr(0.04), \cpbelow.kr(1.701), \cpabove.kr(1), \cpclamp.kr(0.01), \cprelax.kr(2.1));
	sig = SelectX.ar(\compmix.kr(0), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = sig /2;
	sig = RLPF.ar(sig, \lpf.kr(15000,0.6));
	sig = HPF.ar(sig, \hpf.kr(150));
	//sig = Limiter.ar(sig * \limit.kr(1.2)) / \limit.kr;
	sig = SelectX.ar(\mix.kr(1), [DelayC.ar(in, 0.04,0.04), sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
		SynthDef(\rdnroom, { arg out=0, gate=1;
			var sig;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 587079;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = (si * 10.rand * \distamp3.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = (si * 10.rand * \distamp3.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = SelectX.ar(\shiftmix.kr, [
					si,
					FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
				]);
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
			}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;
		SynthDef(\rdnroomff, { arg out=0, gate=1;
			var sig;
			var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 587079;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = (si * 10.rand * \distamp3.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = (si * 10.rand * \distamp3.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = SelectX.ar(\shiftmix.kr, [
					si,
					FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
				]);
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
			}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			sig1 = sig;
			sig1 = HPF.ar(sig1, \ehpf.kr(140), \ehprq.kr(1));
			sig1 = LPF.ar(sig1, \elpf.kr(10000), \elprq.kr(1));
			sig = SelectX.ar(\ffmix.kr(0.0), [sig, sig1]);
			sig = sig * \wetgain.kr(1);
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;


		Pbind(
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.0001,
			'delay3', 0.00010394574653723,
			'distamp', 0.60466190090704,
			'distamp2', 0.23886430789846,
			'distamp3', 2.8985772146511,
			'shift', -5.0,
			'shift2', -1.1344537815126,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'stereo', 0.0,
			'fbdistamp', 3.9234346672443,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
		)


);

// END

(
Pdef(\part, Pdef(\plop, 
	Ppar([

		
	])
)).play;
)

(
	~master_simple.();
	Pdef(\part, Pdef(\comlexfx,
		Ppar([

			Pbind(\out, BusDef(\mixer6))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.011,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.07,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,0,
						1,1,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,0,1,
						1,0,1,0,
						1,0,1,0,
						0,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,1,0,0,
						1,0,1,0,
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.05,Pser([
							0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,
						],15),
						0.05,Pser([
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
						],15),

					],inf),
					\dur, 1/16,
					\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
			]),
			Pbind(
				\instrument, \simplebass,
				\out, BusDef(\mixer3, \audio),
				\degree, Pseq([0,2b,4,-4],inf),
				\legato, Pseq([
					Pseq([ 1,1,1,1, ],3),
					Pseq([ 1,1,1,1, ]/4,1),

				],inf),
				\lpf, Pseq([400,200],inf),
				\rq, 0.5,
				\octave, 3,
				\dur, 1,
				\amp, 0.1,
			),
		Pbind(
			\instrument, \fmz1,
				\out, BusDef(\mixer4, \audio),
			\note, Pseq([
				0,4,3,4,
				3,4,7,7,
				2,4,3,4,
				3,4,9,9,
			],inf),
			\legato, Pseq([
				2,0,0,0, 0,0,1,0,
				8,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,1,0,
				2,0,1,0, 2,0,1,0,
			],inf)*0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.5) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 4,
			\dur, 1/16,
			\amp, 0.1,

		),

			Pbind(\inbus, BusDef(\sendbus1))<>
			Pseq([

				Pmono(\fxknife2,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.4,
					\dur, Pseq([1/2],8),
					\amp, 0.1,
				),
				Pmono(\fxknife4,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],8),
					\amp, 0.1,
				),
				Pmono(\fxknife3,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						Pser([
							0
						],1),
						~pmodenv.(Pseq([1,0]*0.5,1), 1/2,1,1),
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],8),
					\amp, 0.1,
				),
		Pmono(\fxknife,
			//\samplerate, ~pmodenv.(Pseq([1,0.1,0.0004,0.03,0.05],inf), 1,1,1),
			\freq, 200,
			\dur, 1/2 * Pseq([1],8),
			\amp, 0.1,
		),
		Pmono(\medelfx,
			\inbus, BusDef(\fx, \audio),
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, Pseq([
				Pser([
					0.017,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.00005,0.01,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.00001,0.0000005,0.00001,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.00001,0.00005,0.01,0.0001 ].rand,
			],8),
			\delays3, Pseq([
				[rrand(1/16,1/2)/~t, 0.001.rand,0.001.rand,0.001.rand],
			],inf),
			\hpf, 40,
			\limit, 5,
			\mix, 0.5,
			\distamp, 140,
			\gain, 0.1,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2 * Pseq([1],8),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx, \audio),
			\fb, 0.4,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, Pseq([
				50,4000,
				50,2000,
			],2),
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\mix, 0.5,
			\dur, 1/2,
			\amp, 0.1,
		),
				Pmono(\medelfx2,
					\compmix, 0,
					\fb, Pseg(Pseq([0,1],inf),8),
					\fb, Pseq([
						Pser([
							0.010,
						],1),
						0,
					],inf),
					\delays1, Pseq([
						[ [ 0.00001,0.0005,0.0001,0.0001 ].rand ],
					],inf),
					\delays2, Pseq([
						[ [ 0.0101,0.0005,0.00071,0.0001 ].rand ],
					],inf),
					\delays3, Pseq([
						[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
						[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
						[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
						[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
					],2).stutter(4),
					\hpf, 40,
					\mix, Pseq([
						0,1,
					],inf),
					\limit, 5,
					\distamp, 84,
					\gain, 0.35,
					\freq, Pseg(Pseq([0,1,10],inf),8)*200,
					\freq, 500,
					\shift, Pseg(Pseq([0,1],inf),8)*200,
					\dur, 1/4,
					\amp, 0.1,
				),
				Pmono(\ronordn,
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00201,
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],4),
				),
				Pmono(\rdnroom,
					\freq, 200,
					\dur, 1/4,
					\amp, 0.1,
					'wet10', 1.0,
					'mix', 0.5,
					'gain', 1/4,
					'fb', 0.0000111,
					'delay3', Pseq([
						0.0001,0.000041,0.000001,0.00001,
						0.0001,0.000041,0.000081,0.00001,
						0.0001,0.000041,0.000001,0.40001,
						0.0001,1.400041,0.000001,0.00001,
					],2),
					'delay2', 0.000072394574653723,
					'distamp', Pseq([
						Pseq([ 0.73886430789846, ],8*4),
						Pseq([ 1.73886430789846, ],4*4),
						Pseq([ 0.93886430789846, ],4*4),
					],inf),
					'distamp3', 0.6985772146511,
					'shift', -70.0001,
					'shiftmix', 0.0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 100.0,
					'fbdistamp', 3.9234346672443,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,
					'brfrqfac', 0.37940593233798,
					'brffac', 0.60195390291997,
				),
			],inf),
		])
	)).play;
);

///////////////////////////////////////// test rono

	(
	SynthDef(\ronoreal, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 740492;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			CheckBadValues.ar(si, id:0);
			si = (si * 10.0.rand * \distamp.kr).tanh / 2;
			CheckBadValues.ar(si, id:1);
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
			]);
			CheckBadValues.ar(si, id:11);
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			CheckBadValues.ar(si, id:12);
			BRF.ar(si, exprand(100.0,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			CheckBadValues.ar(si, id:13);
			BRF.ar(si, exprand(100.0,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			CheckBadValues.ar(si, id:14);
			si = (si * 10.rand * \distamp3.kr).tanh / 2;

			CheckBadValues.ar(si, id:2);

			////////// safe part

			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = (si * 10.0.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			CheckBadValues.ar(si, id:3);
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift3.kr) + si / 1.2,
			]);
			CheckBadValues.ar(si, id:4);
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			CheckBadValues.ar(si, id:5);
			si = (si * 10.0.rand * \distamp.kr).tanh / 2;
			CheckBadValues.ar(si, id:6);
			si = LPF.ar(si, \ilpf.kr(19000), \ilprq.kr(1));
			si;
		}.value(si, env);

		sig = LeakDC.ar(sig);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
		sig = HPF.ar(sig, \ehpf.kr(14), \ehprq.kr(1));
		sig = LPF.ar(sig, \elpf.kr(19000), \elprq.kr(1));
		sig = sig * \wetgain.kr(1);
		sig = SelectX.ar(\mix.kr(0.5), [DelayL.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0)); // doesnt change signal, just add a pan control
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;
	)


	(
	SynthDef(\ronordn, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 740492;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			CheckBadValues.ar(si, id:0);
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			CheckBadValues.ar(si, id:1);
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
			]);
			CheckBadValues.ar(si, id:11);
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			CheckBadValues.ar(si, id:12);
			BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			CheckBadValues.ar(si, id:13);
			BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			CheckBadValues.ar(si, id:14);
			si = (si * 10.rand * \distamp3.kr).tanh / 2;

			CheckBadValues.ar(si, id:2);

			////////// safe part

			si = [
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			CheckBadValues.ar(si, id:3);
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift3.kr) + si / 1.2,
			]);
			CheckBadValues.ar(si, id:4);
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			CheckBadValues.ar(si, id:5);
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			CheckBadValues.ar(si, id:6);
			si;
		}.value(si, env);

		sig = LeakDC.ar(sig);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
		//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0)); // doesnt change signal, just add a pan control
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;
	)

	(
	SynthDef(\ronordn, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 740492;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			CheckBadValues.ar(si, id:0);
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			CheckBadValues.ar(si, id:1);
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
			]);
			CheckBadValues.ar(si, id:11);
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			CheckBadValues.ar(si, id:12);
			BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			CheckBadValues.ar(si, id:13);
			BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			CheckBadValues.ar(si, id:14);
			si = (si * 10.rand * \distamp3.kr).tanh / 2;

			CheckBadValues.ar(si, id:2);

			////////// safe part

			si = [
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			CheckBadValues.ar(si, id:3);
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift3.kr) + si / 1.2,
			]);
			CheckBadValues.ar(si, id:4);
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			CheckBadValues.ar(si, id:5);
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			CheckBadValues.ar(si, id:6);
			si;
		}.value(si, env);

		sig = LeakDC.ar(sig);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
		//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0)); // doesnt change signal, just add a pan control
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;
	)





	// sauvegarde
	(
	SynthDef(\ronordn, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 740492;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
			]);
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			si = (si * 10.rand * \distamp3.kr).tanh / 2;
			si = [
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift3.kr) + si / 1.2,
			]);
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
		}.value(si, env);

		sig = LeakDC.ar(sig);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
		//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0)); // doesnt change signal, just add a pan control
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;
	)
