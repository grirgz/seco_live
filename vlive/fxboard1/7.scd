~name = 'fxboard1-7';

~ndef_channel.();
~fb1 = ~name;

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \lpf, \freq);
~set_macro.(\k3, Ndef(~name+++\fx), \lpfspread, ControlSpec(0.000001,1,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), \select, \unipolar);
~set_macro.(\k5, Ndef(~name+++\fx), \distamp, ControlSpec(0.01,50,\exp,0,1));
~set_macro.(\k6, Ndef(~name+++\fx), \killamp, ControlSpec(0.01,4,\exp,0,1));
~set_macro.(\k7, Ndef(~name+++\fx), \rq, ControlSpec(0.001,1,\exp,0,1));
~set_macro.(\k8, Ndef(~name+++\fx), \fb, ControlSpec(0.01,50,\exp,0,1));

~set_macro.(\s1, Ndef(~name+++\fx), \lpf2, \freq);
//~set_macro.(\s2, Ndef(~name+++\fx), \rq2, ControlSpec(0.001,1,\exp,0,1));
~set_macro.(\s2, Ndef(~name+++\fx), \killlpf, \widefreq);
~set_macro.(\s3, Ndef(~name+++\fx), \fbfm, \widefreq);
~set_macro.(\s4, Ndef(~name+++\fx), \xamp, ControlSpec(0.01,25,\exp,0,1));
~set_macro.(\s5, Ndef(~name+++\fx), \finamp, ControlSpec(0.01,10,\exp,0,1));
~set_macro.(\s6, Ndef(~name+++\fx), \compt, ControlSpec(0.01,2,\exp));
~set_macro.(\s7, Ndef(~name+++\fx), \complow, ControlSpec(0.7,2,\exp));
~set_macro.(\s8, Ndef(~name+++\fx), \comphigh, ControlSpec(0.07,2,\exp));

