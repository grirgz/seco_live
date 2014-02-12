Ndef('1lfo1').set(\base, 100);
~set_macro.(\k1, Ndef('1lfo1'), \base, \freq.asSpec);
~set_macro.(\k2, Ndef('1lfo1'), \lof, \freq.asSpec);

// END

Veco.force_init
{SinOsc.ar(100)!2}.play
