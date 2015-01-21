
Veco(\4).stop_node
Veco(\4).play_node
Veco(\5).stop_node


Ndef(Veco('4').uname+++\fx)[1] = \filter -> { arg in; in+CombL.ar(in,1,1/4,4) }
Ndef(Veco('4').uname+++\fx)[2] = \filter -> { arg in; in+CombL.ar(in,1,1/7,4) }
Ndef(Veco('4').uname+++\fx)[1] = \filter -> { arg in; in+CombL.ar(in,1,1/7,4) }
Ndef(Veco('4').uname+++\fx)[2] = \filter -> { arg in; in+CombL.ar(in,1,1/4,4) }
Ndef(Veco('4').uname+++\fx)[2] = nil
Ndef(Veco('4').uname+++\fx)[1] = nil

~x1 + ~x7.4
[1.12, 2.3].play

Ndef(\yep)[0] = {


};
