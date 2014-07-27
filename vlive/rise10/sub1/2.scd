~name = 'sub1-2';

BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
~ndef_channel.(\fx);
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
(
~fadeTime = 1;
Ndef(~name+++\fx).fadeTime=~fadeTime;
Ndef(~name+++\mixer).fadeTime = ~fadeTime;
)

// END

