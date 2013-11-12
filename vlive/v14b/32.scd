~name = \32;

BufDef(\kick, "../hydrogenkits/Roland TR-808/808 Kick_short.flac");
//~mixfx.(~name, ~fx1);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \stereosampler,
	\bufnum, BufDef(\kick).bufnum,
	\degree, Pseq([0],inf),
	//\out, BusDef(~name+++\fx),
	//\out, ~fx3,
	\out, BusDef(~name+++\mixer),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END
BufferPool.reset

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play

(
{
		var name = ~name;
		Ndef(name+++\mixer).isource = { arg send1=0, send2=0, send3=0, send4=0;
			var in = InFeedback.ar(BusDef(name+++\mixer), 2);
			var sig;
			sig = in;

			//make_out.(0, sig, send1);
			//make_out.(1, sig, send2);
			//make_out.(2, sig, send3);
			//make_out.(3, sig, send4);
			Out.ar(~fx1, sig );
			sig;
		};
}.value;
)
~fx1
BusDef('37fx')
