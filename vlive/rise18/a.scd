~name = 'rise18-a';

BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
BufDef.mono(\bomb, "vipere/bomb.flac");
~ndef_channel.(\fx);
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
Ndef(~name+++\fx).fadeTime=1/4;
Ndef(~name+++\mixer).fadeTime = 4;

// END

