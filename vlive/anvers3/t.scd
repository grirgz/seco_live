~name = \t;


Veco(~name).make_mixer;
~newfxmix.(\fx);
Veco(~name)[\is_playing] = { arg self; Ndef(self.get_name+++\fx).isPlaying };

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name+++\base, Pbind(
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
