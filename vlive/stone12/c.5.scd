
"111111111FUCLKKA.".debug;
Ndef(~scratch1+++\speed).set(\xspeed, 1);
Ndef(~scratch1+++\speed, {
	var lag;
	lag = 0.1;
	SinOsc.kr(Ndef.kr(~scratch1+++\sfreq)*~t).lag(0.5)
		* \speedfmamp.kr(1).lag(1) + \aspeedfmamp.kr(1).lag(1) * \xspeed.kr(0.1).lag(1);
});

Veco(~namex).response_off_hook = {
	"FUCLKKA.".debug;
	Ndef(~scratch1+++\speed).set(\xspeed, 0);
};

// END
Ndef(~scratch1+++\speed).rate 
