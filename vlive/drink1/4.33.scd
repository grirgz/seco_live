(
~key = '5rhy';
Pdef(~key, Pseq([
	Pbind(\ffreq, Pser([500,8000,5000],16)),
	Pbind(),
]));
Pdef(~key).quant = 0.5;
Veco(~namex).response_mode = \exec;
)
