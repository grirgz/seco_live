(Document.current.dir ++ "/trySynth.rtf").load;

(
Ndef(\sinus,{

var	sig=	RHPF.ar(
			LFSaw.ar(54,
				[62.1,63]*1.8
				,LFSaw.kr(
					LFSaw.kr(
					LFPulse.kr(0.009,0,0,1,0.0009),0,0.18
					),0.009
					,LFSaw.kr(
					0.000009,0,[0.09,0.2pi])),[1,1]
			).clip.distort.tanh*
			LFSaw.ar(
				[36,34.2]*1.8
				,LFSaw.kr(
					LFSaw.kr(
						LFPulse.kr(
							0.9,0,0,1,0.0009),0,0.18),0.009
					    ,LFSaw.kr(0.000009,0,[0.09,0.2pi])
				),[1,1]
			)
			,Sweep.ar(
				LFPulse.kr(
					Duty.ar(
						1,0,Dseq(
							[1,8,16,32],inf)
			))
			,20000));
	sig = Compander.ar(sig, InFeedback.ar(2,2),
        thresh: 0.5,
        slopeBelow: 1.5,
        slopeAbove: 0,
        clampTime: 01,
        relaxTime: 01,
	);
		Out.ar(4,sig)
}).play;
)


Pdef(\x).play;
Pdef(\y).play;
Pdef(\z).play;
Pdef(\v,Pbind(\instrument,\snare,\out,2,\dur,1,\isRest,Pseq([0,1],inf).coin.not)).play;

Ndef(\sinus).clear;

Pdef(\x).stop;
Pdef(\y).stop;
Pdef(\z).stop;
Pdef(\v).stop;


Pdef(\x).play;
Pdef(\y).play;
Pdef(\z).play;
Pdef(\v,Pbind(\instrument,\snare,\out,2,\dur,1,\isRest,Pseq([0,1],inf).coin.not)).play;

Ndef(\sinus).clear;
Ndef(\a).clear;
Ndef(\b).clear;
Pdef(\x).stop;
Pdef(\y).stop;
Pdef(\z).stop;
Pdef(\v).stop;
