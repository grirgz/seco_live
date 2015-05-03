~name = 'fxboard1-z';

~fx_channel.();

Spec.add(\complo, ControlSpec(0,2,\lin));
Spec.add(\comphi, ControlSpec(0,2,\lin));

~set_macro.(\k1, Ndef(~name+++\fx), 'mix');
~set_macro.(\k2, Ndef(~name+++\fx), 'compt', ControlSpec(0.01,2,\exp));
~set_macro.(\k3, Ndef(~name+++\fx), 'complo', \complo);
~set_macro.(\k4, Ndef(~name+++\fx), 'comphi', \comphi);
~set_macro.(\k5, Ndef(~name+++\fx), 'freq', \freq);
~set_macro.(\k6, Ndef(~name+++\fx), 'hpfreq', \freq);
~set_macro.(\k7, Ndef(~name+++\fx), 'lpfreq', \freq);
~set_macro.(\k8, Ndef(~name+++\fx), 'distamp', ControlSpec(0.1,100,\exp));
~set_macro.(\s1, Ndef(~name+++\fx), 'del', ControlSpec(0.001,2,\exp));

