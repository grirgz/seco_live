~name = 'stone3-r';
~ndef_channel.();
(
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
Ndef(~name+++\mixer).fadeTime = 10.1;
Ndef(~name+++\fx).fadeTime = 0.1;
Ndef(~name+++\fx).addHalo(\fadeOut, 10);
Ndef(~name+++\mixer).addHalo(\fadeOut, 10);
);

// END

Ndef(~name+++\fx).getHalo(\fadeOut)
