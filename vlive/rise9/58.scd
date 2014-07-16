~name = 'rise9-58';
~ndef_channel.();

// END

~set_macro.(\k1, Ndef(~name+++\fx), \fb, \unipolar.asSpec);
~set_macro.(\k2, Ndef(~name+++\fx), \delay, \delay.asSpec);
~set_macro.(\k3, Ndef(~name+++\fx), \freqshift, \freqshift.asSpec);
