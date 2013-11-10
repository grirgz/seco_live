Pdef(~name +++ \pre, Pbind(
	\freq, 100,
));

// END

Ndef(~name+++\mixer).parentGroup = ~fxgroup
(
~fxgroup = Group.after;
~fxgroup.register(true)
~fxgroup.isPlaying
)
Ndef(~name+++\mixer).parentGroup

(
)
~get_mixer_group.()
