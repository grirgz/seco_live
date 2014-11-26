
~ndef_channel.();
(
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
);

(
~set_macro.(\k1, Ndef(~name+++\fx), \freq, \freq.asSpec);
~set_macro.(\k2, Ndef(~name+++\fx), \nfreq, \freq.asSpec);
~set_macro.(\k3, Ndef(~name+++\fx), \panmax, \unipolar.asSpec);
~set_macro.(\k4, Ndef(~name+++\fx), \pan, \bipolar.asSpec);
~set_macro.(\k5, Ndef(~name+++\fx), \fspread, ControlSpec(0.00001,1,\exp,0,0.00001));
~set_macro.(\k6, Ndef(~name+++\fx), \ffreq, \freq);
~set_macro.(\k7, Ndef(~name+++\fx), \hpfreq, \freq);
)
