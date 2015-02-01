~name = 'stone11-i';

~ndef_channel.();

~set_macro.(\k1, Ndef(~name+++\fx), \morph, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \fend1, \lofreq);
~set_macro.(\k3, Ndef(~name+++\fx), \fend2, \lofreq);
~set_macro.(\k4, Ndef(~name+++\fx), \fend3, \lofreq);
~set_macro.(\k5, Ndef(~name+++\fx), \fend4, \lofreq);
~set_macro.(\k6, Ndef(~name+++\fx), \release, \release);
~set_macro.(\k7, Ndef(~name+++\fx), \delay, \release);
~set_macro.(\k8, Ndef(~name+++\fx), \cdecay, \release);
