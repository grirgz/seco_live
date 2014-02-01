~name = '39';

~newfxmix.(\fx);
Veco(~name).make_mixer;

Veco(~name).lib.macros = [
	[Ndef(~name+++\fx), \fb, ControlSpec(0.5,1.5,'lin',0,0.9)],
	[Ndef(~name+++\fx), \shift, ControlSpec(-800,800,'lin',0,0)],
	[Ndef(~name+++\fx), \lpfreq, \freq.asSpec],
	[Ndef(~name+++\fx), \hpfreq, \freq.asSpec],
];
