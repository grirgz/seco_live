
(
	Ndef(~name, {
		var a, trig, n=5, m=64;
		a = {
			var x;
			x = { 0.2.rand2 } ! m;
			x = x ++ ({  Drand({ 0.2.rand2 } ! n) } ! m.rand);
			Dseq(x.scramble, inf)
		} ! n;
		trig = TDuty.ar(
				MouseY.kr(1, 2048, 1) * SampleDur.ir * [1, 1.02],
				0,
				//Dswitch1(a, MouseY.kr(0, n-1))
				a
			);
		Ringz.ar(trig, MouseX.kr(50,5000), 0.01)
	
	}).play(Veco.main.master_bus);
);

Veco(~name).add_stop_node_hook(\ndef, { arg name; Ndef(name).stop });


