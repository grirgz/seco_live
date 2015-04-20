~name = 'fxboard1-4';

~ndef_channel.();
//~fb2 = ~name;

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \delay, ControlSpec(0.01,4,\exp));
~set_macro.(\k3, Ndef(~name+++\fx), \damp, ControlSpec(0.01,4,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), \size, ControlSpec(0.01,4,\exp));
~set_macro.(\k5, Ndef(~name+++\fx), \diff, ControlSpec(0.001,4,\exp));
~set_macro.(\k6, Ndef(~name+++\fx), \feedback, ControlSpec(0.001,4,\exp));
~set_macro.(\k7, Ndef(~name+++\fx), \modDepth, ControlSpec(0.01,4,\exp));
~set_macro.(\k8, Ndef(~name+++\fx), \modFreq, ControlSpec(0.01,40,\exp));
