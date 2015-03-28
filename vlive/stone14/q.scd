

~ndef_channel.();

~set_macro.(\k1, Ndef(~name+++\fx), \fmfreq, \freq);
~set_macro.(\k2, Ndef(~name+++\fx), \lpf, \freq);
~set_macro.(\k3, Ndef(~name+++\fx), \fspread, ControlSpec(0.000001,1,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), \select, \unipolar);
~set_macro.(\k5, Ndef(~name+++\fx), \distamp, ControlSpec(0.01,50,\exp,0,1));
~set_macro.(\k6, Ndef(~name+++\fx), \killamp, ControlSpec(0.01,1,\exp,0,1));
~set_macro.(\k7, Ndef(~name+++\fx), \rq, ControlSpec(0.01,1,\exp,0,1));

//~set_out_bus.(~name,BusDef(\in1));
~set_send_bus.(~name, 1);
