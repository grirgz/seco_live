~name = '34';

~newfxmix.(\fx);
Veco(~name).make_mixer;

// END

Ndef(~name+++\fx, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(~name+++\fx), 2);
	sigin;
});
