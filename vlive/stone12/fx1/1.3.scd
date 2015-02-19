
//Veco(~name.debug("name")).uname.debug("heyyy");
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var ffreq;
	
	//sig = sig * SinOsc.ar(70 * SinOsc.kr(4*~t).range(4,1));
	ffreq = Duty.kr(1/~t, 0, Dseq([
		2,4,8,2,
	],inf));
	sig = RLPF.ar(sig,  SinOsc.kr(ffreq*~t).range(150,70)*1,0.3);

	sig;
});
);

// END

Veco.main.name
Veco('stone12-64')
Veco.side_project[]
~trigpadboard[\veco].
