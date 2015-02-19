
//Veco(~name.debug("name")).uname.debug("heyyy");
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var del = 1/116;
	
	in.debug("un");
	sig = DelayL.ar(sig ! 8, del,LFNoise1.kr((1..8)/28).unipolar*del);
	sig.debug("heh");
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, 1).mean;
	sig = sig.mean;
	sig.debug("hexh");


	sig;
});
);

// END

Veco.main.name
Veco('stone12-64')
Veco.side_project[]
~trigpadboard[\veco].
