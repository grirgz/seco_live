
(

Ndef(~name+++\mod1, {  XLine.kr(1,100,10)});
Ndef(~name+++\mod2, { XLine.kr(8000,100,10) });
//Ndef(~name).map(\mod1, Ndef(~name+++\mod1));
//Ndef(~name).map(\mod2, Ndef(~name+++\mod2));
//Ndef(~name+++\mod2, { XLine.kr(8000,1,10) });
);

// END
Ndef(\plop).stop
play{mean({|i|99**(-1-LFSaw.kr(i+1/180,1))*SinOsc.ar(i+1*55)}!48)!2}
