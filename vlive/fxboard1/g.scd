~name = 'fxboard1-g';

~fx_channel.();

Spec.add(\complo, ControlSpec(0,2,\lin));
Spec.add(\comphi, ControlSpec(0,2,\lin));

~set_macro.(\k1, Ndef(~name+++\fx), 'mix');
~set_macro.(\k2, Ndef(~name+++\fx), 'dfreq', \widefreq);
~set_macro.(\k3, Ndef(~name+++\fx), 'decay', ControlSpec(0.1,5.2,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), 'dmix', \unipolar);
~set_macro.(\k5, Ndef(~name+++\fx), 'distamp', ControlSpec(0.01,50,\exp));


~set_macro.(\k6, Ndef(~name+++\fx), 'lpf', \freq);
~set_macro.(\k7, Ndef(~name+++\fx), 'hpf', \freq);
~set_macro.(\k8, Ndef(~name+++\fx), 'fb', ControlSpec(0.01,8,\exp));
~set_macro.(\s1, Ndef(~name+++\fx), 'dspread', ControlSpec(0.00001,2,\exp));
~set_macro.(\s2, Ndef(~name+++\fx), 'killamp', ControlSpec(0.01,2,\exp));
