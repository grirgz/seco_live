
//Veco(~name.debug("name")).uname.debug("heyyy");
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = sig * SinOsc.ar(1/7).range(1,100);
	sig = sig.tanh / 8;

	sig;
});
);

// END

Ndef(~name+++\fx).clear
Veco.main.name
Veco('stone12-64')
Veco.side_project[]
~trigpadboard[\veco].
