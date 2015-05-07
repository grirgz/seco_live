~name = 'fxboard1-y';

~ndef_channel.();

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \lpf, \freq);
~set_macro.(\k3, Ndef(~name+++\fx), \lpffac, ControlSpec(0.001,4,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), \select, \unipolar);
~set_macro.(\k5, Ndef(~name+++\fx), \distamp, ControlSpec(0.01,50,\exp,0,1));
~set_macro.(\k6, Ndef(~name+++\fx), \killamp, ControlSpec(0.01,4,\exp,0,1));
~set_macro.(\k7, Ndef(~name+++\fx), \rq, ControlSpec(0.001,1,\exp,0,1));
~set_macro.(\k8, Ndef(~name+++\fx), \fb, ControlSpec(0.01,50,\exp,0,1));

~set_macro.(\s1, Ndef(~name+++\fx), \pitchlag, ControlSpec(0,1,\lin));
//~set_macro.(\s2, Ndef(~name+++\fx), \rq2, ControlSpec(0.001,1,\exp,0,1));
~set_macro.(\s2, Ndef(~name+++\fx), \pitchpow, ControlSpec(0.1,5,\lin));
~set_macro.(\s3, Ndef(~name+++\fx), \fbfm, \widefreq);
~set_macro.(\s4, Ndef(~name+++\fx), \xamp, ControlSpec(0.01,25,\exp,0,1));
~set_macro.(\s5, Ndef(~name+++\fx), \finamp, ControlSpec(0.01,10,\exp,0,1));
~set_macro.(\s6, Ndef(~name+++\fx), \compt, ControlSpec(0.01,2,\exp));
~set_macro.(\s7, Ndef(~name+++\fx), \complow, ControlSpec(0.7,2,\exp));
~set_macro.(\s8, Ndef(~name+++\fx), \comphigh, ControlSpec(0.07,2,\exp));

ParamGroupDef(~name, Veco(~name).lib.macros.reject(_.isNil));
ParamMorpherDef(~name, ~name, [\p1, \p2]);

// END

ParamGroupDef(~name).save(\p1)
ParamGroupDef(~name).save(\p2)
ParamGroupDef(~name).getArchive
ParamGroupDef(~name).
Archive.write
MIDIMap(\k9, ~pm)
