
(
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([100,90,80,70],inf).stutter(8),
	\isRest, Veco(~namex).isrest(16),
	\legato, 1.5,
	\degree, Pstep(Pseq([7,5,6b,7,5,6],inf),1) + [0,-7],
	\dur, PdurStutter(Pseq([1,1,2,2, 1,1,4,4],inf), 1/4),
	\ffreq, Pseq([[700,800],[100,200]],inf),
));
);

Ndef(~name+++\lfo1, { Line.kr(Ndef(~name+++\lfo1).kr,0,10) });
Ndef(~name+++\mixer).map(\send2, Ndef(~name+++\lfo1));

// END

Ndef(~name+++\lfo1, { Line.kr(0.0001,1,10) }))
Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0,1) })
Ndef(~name+++\mixer).xset(\send2, Ndef(~name+++\lfo1, { XLine.kr(0,1,10) }))
Ndef(~name+++\mixer).map(\send2, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0,1) }))
