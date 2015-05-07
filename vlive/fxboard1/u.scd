

~ndef_channel.();

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k3, Ndef(~name+++\fx), \lpf, \freq);
~set_macro.(\k4, Ndef(~name+++\fx), \finamp, ControlSpec(0.01,8,\exp));
~set_macro.(\k8, Ndef(~name+++\fx), \fb, ControlSpec(0.01,50,\exp));
