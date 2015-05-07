
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 

	//sig = in;
	sig = SelectX.ar(\mix.kr(0.5), [DC.ar(0), in]);
	sig = Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig.debug("isig");
		isig = DelayL.ar(isig, 4, \delay.kr(2).lag(0.1)/~t) + isig;
		//isig = LPF.ar(isig, ( 4700 * Amplitude.kr(sig).clip(0.1,8) ).clip(20,18000));
		//Amplitude.kr(isig).poll;
		isig = FreqShift.ar(isig, \shift.kr(100)) + isig;
		isig = LeakDC.ar(isig);
		isig = Limiter.ar(isig);
		isig.debug("isig");
		isig;
	};
	sig.debug("sig");
	//sig = sig.sum + sig;
	sig.debug("sig");
	sig = sig * 8;
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});
Ndef(~name+++\fx).addSpec(\delaytab, XArraySpec( ControlSpec(0.001,2,\exp)!8 ) );
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
