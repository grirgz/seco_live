
//~fx_gate.('32fx');

Ndef(~name+++\mixer).set(\xfade, 1);
Ndef(~name+++\mixer).put(~rlpfindex, \filter -> { arg in; Out.ar(BusDef(~fxrlpf+++\fx), in); in; });
