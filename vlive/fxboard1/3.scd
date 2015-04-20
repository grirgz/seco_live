~name = 'fxboard1-3';

~ndef_channel.();
//~fb2 = ~name;

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \xamp, ControlSpec(0.001,6,\exp));
~set_macro.(\k3, Ndef(~name+++\fx), \rate, ControlSpec(1/16,16,\exp,1/16));
~set_macro.(\k4, Ndef(~name+++\fx), \bufgate, ControlSpec(0,1,\lin,1));
~set_macro.(\k5, Ndef(~name+++\fx), \stutter, ControlSpec(1,128,\lin,1));
