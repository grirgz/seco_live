~name = 'fxboard1-4';

~ndef_channel.();
//~fb2 = ~name;

Ndef(~name+++\fx).addSpec(\delay, ControlSpec(0,4,\lin,1/8));

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \delay, ControlSpec(0,4,\lin,1/8));
~set_macro.(\k3, Ndef(~name+++\fx), \damp, ControlSpec(0.01,4,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), \size, ControlSpec(0.01,4,\exp));
~set_macro.(\k5, Ndef(~name+++\fx), \diff, ControlSpec(0.001,4,\exp));
~set_macro.(\k6, Ndef(~name+++\fx), \feedback, ControlSpec(0.001,4,\exp));
~set_macro.(\k7, Ndef(~name+++\fx), \modDepth, ControlSpec(0.01,4,\exp));
~set_macro.(\k8, Ndef(~name+++\fx), \modFreq, ControlSpec(0.01,40,\exp));

~set_macro.(\s1, Ndef(~name+++\fx), \postmix, \unipolar);
~set_macro.(\s2, Ndef(~name+++\fx), \xamp, ControlSpec(0.001,4,\exp));

ParamGroupDef(~name, Veco(~name).lib.macros.reject(_.isNil));
ParamMorpherDef(~name, ~name, [\p1, \p2, \p3]);

// END

ParamGroupDef(~name).clear
ParamGroupDef(~name).save(\p1)
ParamGroupDef(~name).save(\p2)
ParamGroupDef(~name).save(\p3)
ParamGroupDef(~name).getArchive
ParamGroupDef(~name).
Archive.write
~pm = ParamMorpher(~name, [\p1, \p2,\p3])
MIDIMap(\k9, ~pm)

MIDIMap(\k1, ParamMorpher('fxboard1-1', [\p1, \p2]))
MIDIMap(\k2, ParamMorpher('fxboard1-4', [\p1, \p2,\p3]))
]~pm)
~pm = ParamMorpher('fxboard4-1', [\p1, \p2,\p3])
