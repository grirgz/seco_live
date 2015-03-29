~name = 'stone14-v';

~ndef_channel.();
//~fb2 = ~name;

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \delay, ControlSpec(0.00001,1,\exp));
~set_macro.(\k3, Ndef(~name+++\fx), \dspread, ControlSpec(0.0001,1,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), \decay, ControlSpec(0.01,14,\exp));
~set_macro.(\k8, Ndef(~name+++\fx), \xamp, ControlSpec(0.01,44,\exp));
