~name = '59';


Veco(~name).lib.fxname = 'fx4';
~newfxmix.(\fx); // fx using mixer
Veco(~name).make_mixer; // mixer
BusDef(Veco(~name).lib.fxname, \audio);

Ndef(~name+++\fx).put(0, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(Veco(~name).lib.fxname), 2);
	sigin;
});

Veco(~name).lib.macros = {
	~ndef_to_macros.(~name+++\fx) ++ [ ]; 
};

// END

~get_spec
