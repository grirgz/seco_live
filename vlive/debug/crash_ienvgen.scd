
(
Ndef(\hoo, {
	var sin = SinOsc.ar(440, 0, MouseX.kr(0, 1));
	// if env is an input control, it crash
	// doc say env should be static
	var env = \env.kr(Env([-1, -0.7, 0.7, 1], [ 0.8666, 0.2666, 0.8668 ], \lin, offset: -1.0));
	//var env = Env([-1, -0.7, 0.7, 1], [ 0.8666, 0.2666, 0.8668 ], \lin, offset: -1.0);
	IEnvGen.ar(env, sin) * 0.1 
}).play;
)
