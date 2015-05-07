
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 

	//sig = in;
	sig = SelectX.ar(\mix.kr(0.5), [DC.ar(0), in]);
	sig = DelayL.ar([sig], 2, \delaytab.kr(0.1!8).lag(0.1)) * \delvoltab.kr(1!8);
	sig.debug("sig");
	//sig = sig.sum + sig;
	sig = sig.sum;
	sig.debug("sig");
	
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
~plm.save(0)
~plm.load(0)
~plm.save(1)
MIDIMap(\k1, ~plm)
	PresetListMorpherDef(~name+++\deltab, ~name+++\deltab, 8)
PresetListMorpherDef(~name+++\deltab).save(0)
PresetListMorpherDef(~name+++\deltab).group
PresetListMorpherDef(~name+++\deltab).clear
PresetListMorpherDef.all
PresetListMorpherDef(~name+++\deltab).presets


Param( Ndef(~name+++\fx), \delaytab, XArraySpec( ControlSpec(0.001,4,\exp)!8 ) )
Param( Ndef(~name+++\fx), \delvoltab, XArraySpec( ControlSpec(0.001,4,\exp)!8 ) )
