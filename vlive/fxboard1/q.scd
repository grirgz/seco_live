~name = 'fxboard1-q';

~ndef_channel.();

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
//~set_macro.(\k2, Ndef(~name+++\fx), \delay, ControlSpec(0.01,4,\exp));
~set_macro.(\k2, Ndef(~name+++\fx), \delay, ControlSpec(1/16,4,\lin,1/16));
~set_macro.(\k3, Ndef(~name+++\fx), \shift, \freqshift);
~set_macro.(\k4, Ndef(~name+++\fx), \mixshift, \unipolar);
~set_macro.(\k5, Ndef(~name+++\fx), \mixdel);
~set_macro.(\k6, Ndef(~name+++\fx), \distamp, ControlSpec(0.01,50,\exp));
~set_macro.(\k7, Ndef(~name+++\fx), \mixdist, \unipolar);
~set_macro.(\k8, Ndef(~name+++\fx), \fb, ControlSpec(0.01,50,\exp));
~set_macro.(\s1, Ndef(~name+++\fx), \finamp, ControlSpec(0.01,5,\exp));
~set_macro.(\s2, Ndef(~name+++\fx), \hpf, \freq);
~set_macro.(\s3, Ndef(~name+++\fx), \lpf, \freq);
~set_macro.(\s4, Ndef(~name+++\fx), \postmix, \unipolar);
