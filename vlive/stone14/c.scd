~name = 'stone14-c';

~ndef_channel.();
//~fb2 = ~name;

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \compt, ControlSpec(0.01,4,\exp));
~set_macro.(\k3, Ndef(~name+++\fx), \complo, ControlSpec(0.01,4,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), \comphi, ControlSpec(0.01,4,\exp));
~set_macro.(\k5, Ndef(~name+++\fx), \compat, ControlSpec(0.001,4,\exp));
~set_macro.(\k6, Ndef(~name+++\fx), \comprel, ControlSpec(0.001,4,\exp));
~set_macro.(\k8, Ndef(~name+++\fx), \xamp, ControlSpec(0.01,44,\exp));
