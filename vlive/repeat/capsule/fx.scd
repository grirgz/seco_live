
(
ProtoDef(\rdn).proxy.put(1111, \filter -> { arg in;
	var sig;
	sig = in;
	sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.2), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * \cpgain.kr(1);
	SelectX.ar(\cpmix.kr(1), [in, sig]);
})
)

Spec.add(\cpmix, \unipolar);
Spec.add(\cpt, ControlSpec(0.001,5,\exp));
