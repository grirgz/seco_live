~name = 'hole-q';
~ndef_channel.();

RandDelayNetwork(\default).define_specs;

//~set_macro.(\k1, Ndef(~name+++\fx), \delay, ControlSpec(0.001,2,\lin));
//~set_macro.(\k2, Ndef(~name+++\fx), \delay2, ControlSpec(0.001,2,\lin));
//~set_macro.(\k3, Ndef(~name+++\fx), \shift, ControlSpec(0.01,10,\exp));
//~set_macro.(\k4, Ndef(~name+++\fx), \shift2, ControlSpec(0.01,10,\exp));
//~set_macro.(\k5, Ndef(~name+++\fx), \distamp, ControlSpec(0.01,50,\exp));
//~set_macro.(\s1, Ndef(~name+++\fx), \poamp,ControlSpec(0.01,8,\exp));
//~set_macro.(\s2, Ndef(~name+++\fx), \mamp, ControlSpec(0.01,8,\exp));
//~set_macro.(\s3, Ndef(~name+++\fx), \mix, \unipolar);
//~set_macro.(\s7, Ndef(~name+++\fx), \plpf, \freq);
//~set_macro.(\s8, Ndef(~name+++\fx), \phpf, \freq);
//~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
//~set_macro.(\k2, Ndef(~name+++\fx), \lpf, \freq);
//~set_macro.(\k3, Ndef(~name+++\fx), \lpffac, ControlSpec(0.001,4,\exp));
//~set_macro.(\k4, Ndef(~name+++\fx), \select, \unipolar);
//~set_macro.(\k5, Ndef(~name+++\fx), \distamp, ControlSpec(0.01,50,\exp,0,1));
//~set_macro.(\k6, Ndef(~name+++\fx), \killamp, ControlSpec(0.01,4,\exp,0,1));
//~set_macro.(\k7, Ndef(~name+++\fx), \rq, ControlSpec(0.001,1,\exp,0,1));
//~set_macro.(\k8, Ndef(~name+++\fx), \fb, ControlSpec(0.01,50,\exp,0,1));
//
//~set_macro.(\s1, Ndef(~name+++\fx), \pitchlag, ControlSpec(0,1,\lin));
////~set_macro.(\s2, Ndef(~name+++\fx), \rq2, ControlSpec(0.001,1,\exp,0,1));
//~set_macro.(\s2, Ndef(~name+++\fx), \pitchpow, ControlSpec(0.1,5,\lin));
//~set_macro.(\s3, Ndef(~name+++\fx), \fbfm, \widefreq);
//~set_macro.(\s4, Ndef(~name+++\fx), \xamp, ControlSpec(0.01,25,\exp,0,1));
//~set_macro.(\s5, Ndef(~name+++\fx), \finamp, ControlSpec(0.01,10,\exp,0,1));
//~set_macro.(\s6, Ndef(~name+++\fx), \compt, ControlSpec(0.01,2,\exp));
//~set_macro.(\s7, Ndef(~name+++\fx), \complow, ControlSpec(0.7,2,\exp));
//~set_macro.(\s8, Ndef(~name+++\fx), \comphigh, ControlSpec(0.07,2,\exp));

//ParamGroupDef(~name, Veco(~name).lib.macros.reject(_.isNil));
//ParamMorpherDef(~name, ~name, [\p1, \p2]);

//Ndef(~name+++\fx).addHalo(\spec, ()); // who add theses specs ? maybe ~set_macro
//Ndef(~name+++\fx).addSpec(\inbus, XBusSpec());
Ndef(~name+++\fx).lag(\delay2, 1/4);
Ndef(~name+++\fx).lag(\delay, 1/4);
Spec.add(\inbus, XBusSpec());

(
[
	\fb,
	\delay,
	\delay2,
	\distamp,

	\pitchmix,
	\pitchlag,
	\shift,
	\shift2,

	\mamp,

	\prelpf,
	\prehpf,
	\lpf,
	\hpf,

	\postlpf,
	\posthpf,
	\fbdistamp,
	\fbdistmix,
].collect({ arg key, x; 
	var tt = (1..9).collect({ arg x; (\k++x).asSymbol }) ++ (1..9).collect({ arg x; (\s++x).asSymbol });
	~set_macro.(tt[x].debug("fdf"), Param(Ndef(~name+++\fx), key));
});
)

// END

Ndef(~name+++\fx).sources
~name
Veco('fxboard1', '34')
