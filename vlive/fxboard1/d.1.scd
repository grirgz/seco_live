
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitch, haspitch;
	var inpitch;

	in = InFeedback.ar(\inbus.kr(BusDef(\in1, \audio)), 2); 
	inpitch = InFeedback.ar(\inbus2.kr(BusDef(\in6, \audio)), 2); 
	pitch = (LagUD.kr(Amplitude.kr(inpitch.sum),0,\pitchlag.kr(1))+0).pow(\pitchpow.kr(1)).linlin(0.01,1,80,18000);
	//pitch.poll;
	//haspitch.poll;
	//pitch = 1000;
	sig = Fb { arg fb;
		var sig;
	
		var lpf;
		
		sig = in * 70;
		sig = sig + ( fb * 1 * \fb.kr(0.1) * LFSaw.ar(\fbfm.kr(1)).unipolar );

		sig = LPF.ar(sig.abs > \killamp.kr(0.8) * \killfm.kr(1), 50) * sig;
		lpf = Select.kr(1, [\lpf.kr(1000), pitch]);
		lpf = ( pitch * \lpffac.kr(1) ).clip(20,18000);
		sig = RLPF.ar(sig, lpf, \rq.kr(0.5));
		sig = (sig*\distamp.kr(1)).tanh * SelectX.ar(\select.kr(1), [DC.ar(1), sig]);
		sig = sig * \xamp.kr(1.4);
		
		sig = Limiter.ar(sig, 1);
		sig = sig * 1;
		sig = LeakDC.ar(sig);
		//amp = amp * XLine.ar(0.3,1);
		//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
		sig = SelectX.ar(\mix.kr(0),[in, sig]);
		sig = Compander.ar(sig, in, \compt.kr(0.4), \complow.kr(1.001), \comphigh.kr(0.9));
	};
	sig = sig * 1;
	amp = amp * \gain.kr(1);
	amp = amp * \finamp.kr(1);
	sig = sig * amp;
	sig = LeakDC.ar(sig);
	sig;
})

// END

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

~t = 1;

Ndef(~name+++\fx).set(\lpf, 100)
Veco(~name).lib.macros.do(_.postln);
ParamGroupDef(~name).save(\p1)
ParamGroupDef(~name).save(\p2)
ParamGroupDef(~name).getArchive
ParamGroupDef(~name).
Archive.write
~pm = ParamMorpher(~name, [\p1, \p2])
MIDIMap(\k9, ~pm)
Ar
