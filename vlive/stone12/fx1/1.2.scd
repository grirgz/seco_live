
//Veco(~name.debug("name")).uname.debug("heyyy");
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = sig * SinOsc.ar(120 * SinOsc.kr(1/7).range(4,1));

	sig;
});
);

// END

Veco.main.name
Veco('stone12-64')
Veco.side_project[]
~trigpadboard[\veco].
