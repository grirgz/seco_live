~name = \56;

~fxname = 'fx1';
~newfxmix.(\fx); // fx using mixer
//~newfx.(\fx); // fx
Veco(~name).make_mixer;

(

Ndef(~name+++\fx).put(0, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(~fx1, 2);
	sigin;
});
);

// END

Ndef(~name+++\fx).play
Ndef(~name+++\fx).stop
Ndef(~name+++\fx).clear
Ndef(~name+++\fx).play
Veco(~name)[\play_node_hook_dict].asCompileString
Veco(~name)[\val_play_node_hook_dict][\fx].value
