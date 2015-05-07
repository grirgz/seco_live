
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 

	//sig = in;
	sig = SelectX.ar(\mix.kr(0.5), [DC.ar(0), in]);
	sig = Fb( { arg fb;
		var isig;
		var isig1, isig2, isig3;
		fb.debug("fb");
		isig = [( fb * \fb.kr(1) )] + sig;
		isig = isig.flop;
		//isig.deb
	
		isig.debug("isig");
		isig1 = DelayL.ar(isig[0], 4, \delay.kr(2).lag(0.1)/~t * 1) + isig[0];
		isig2 = DelayL.ar(isig[1], 4, \delay.kr(2).lag(0.1)/~t * 1/2) + isig[1];
		isig3 = DelayL.ar(isig[2], 4, \delay.kr(2).lag(0.1)/~t * 1/4) + isig[2];
		isig1.debug("isig1");
		isig = [isig1, isig2, isig3];
		isig.debug("isig");
		//isig = LPF.ar(isig, ( 4700 * Amplitude.kr(sig).clip(0.1,8) ).clip(20,18000));
		//Amplitude.kr(isig).poll;
		isig1 = FreqShift.ar(isig, \shift.kr(100)) + isig;
		isig = SelectX.ar(\mixshift.kr(0.5), [isig, isig1]);
		isig1 = ( isig * \distamp.kr(4) ).tanh;
		isig = SelectX.ar(\mixdist.kr(0.5), [isig, isig1]);
		isig = LeakDC.ar(isig);
		isig = Limiter.ar(isig);
		isig.debug("isig");
		isig;
	}, numChannels:3);
	sig.debug("sig");
	sig = SelectX.ar(\mixdel.kr(0) * 2, sig);
	sig.debug("sig");
	//sig = sig.sum + sig;
	sig.debug("sig");
	sig = sig * 8;
	
	amp = amp * \gain.kr(1);
	amp = amp * \finamp.kr(1);
	sig = sig * amp;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});
Ndef(~name+++\fx).addSpec(\mixdel, \unipolar);
//Ndef(~name+++\fx).addSpec(\delay, ControlSpec(0,1,\lin) );
Ndef(~name+++\fx).addSpec(\delvoltab, XArraySpec( ControlSpec(0.001,2,\exp)!8 ) );

// END

(
	ParamGroupDef(~name+++\deltab, [
		Param( Ndef(~name+++\fx), \delaytab),
		Param( Ndef(~name+++\fx), \delvoltab),
	]);
	~plm = PresetListMorpher(~name+++\deltab, 8);
);
ParamGroupDef(~name+++\deltab).edit;
ParamGroupDef(~name+++\deltab).clear
~plm.save(0)
~plm.load(0)
~plm.save(1)
MIDIMap(\k1, Param~plm)
<F10>à
MIDIMap(\k2, ~plm)
	PresetListMorpherDef(~name+++\deltab, ~name+++\deltab, 8)
PresetListMorpherDef(~name+++\deltab).save(0)
PresetListMorpherDef(~name+++\deltab).group
PresetListMorpherDef(~name+++\deltab).clear
PresetListMorpherDef.all
PresetListMorpherDef(~name+++\deltab).presets


Param( Ndef(~name+++\fx), \delaytab, XArraySpec( ControlSpec(0.001,4,\exp)!8 ) )
Param( Ndef(~name+++\fx), \delvoltab, XArraySpec( ControlSpec(0.001,4,\exp)!8 ) )
