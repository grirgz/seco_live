
Ndef(~scratch1+++\speed, {
	SinOsc.kr(Ndef.kr(~scratch1+++\sfreq)*~t) 
		* \speedfmamp.kr(1).lag(0.1) + \aspeedfmamp.kr(1).lag(0.1) ;
});


// END
Ndef(~scratch1+++\speed).rate 
