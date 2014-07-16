~name = 'rise9-8';

BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
~ndef_channel.(\fx);
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
Ndef(~name+++\fx).fadeTime=4;
Ndef(~name+++\mixer).fadeTime = 4;

// END

