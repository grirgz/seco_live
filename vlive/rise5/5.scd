~name = '5';
~tbits1 = ~name;

Veco(~name).make_mixer;
~newfxmix.(\fx);

(
Veco(~name).lib.macros = [
		[Ndef(~name+++\fx), \freq, \freq.asSpec],
		[Ndef(~name+++\fx), \freqfac, ControlSpec(0.01,20,\lin, 0,15)],
		[Ndef(~name+++\fx), \ffreq, \freq.asSpec],
		[Ndef(~name+++\fx), \shift, ControlSpec(0.01,5,\lin, 0,1)],
		[Ndef(~name+++\fx), \sigmix, \unipolar.asSpec],
];
);
