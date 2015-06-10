

(
Ndef(~name+++\fx).unset(\bufgate);
Ndef(~name+++\fx).unset(\stutter);
Ndef(~name+++\fx).put(1, \set -> Pbind(
	\bufgate, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,1, 0,1,1,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,1,1,1,
	],inf),
	\stutter, Pseq([32,36,8,16,8],inf),
	\dur, 1/4,

))
)

Veco(~namex).response_mode = \exec;
