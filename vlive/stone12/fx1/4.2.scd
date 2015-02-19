
//Veco(~name.debug("name")).uname.debug("heyyy");
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var del = 1/2;
	
	in.debug("kjk");
	sig = CombL.ar(sig, del,del,2);


	sig;
});
);

// END

Veco.main.name
Veco('stone12-64')
Veco.side_project[]
~trigpadboard[\veco].
~trigpadboard.use({ Veco(~name).execute })
~trigpadboard.use({ Veco(~name).execute })
Ndef(~name+++\fx).clear
