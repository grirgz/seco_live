~name = 'stone18-z';

~ndef_channel.();

~set_macro.(\k2, Ndef(~name+++\fx), 'xfreq', \freq);
~set_macro.(\k3, Ndef(~name+++\fx), 'sweepfreq', \lofreq);
~set_macro.(\k4, Ndef(~name+++\fx), 'combfreq', \freq);
~set_macro.(\k5, Ndef(~name+++\fx), 'combdecay', ControlSpec(0,4,\lin));
~set_macro.(\k6, Ndef(~name+++\fx), 'lpf', \freq);
~set_macro.(\k7, Ndef(~name+++\fx), 'vol', ControlSpec(0,4,\lin));

