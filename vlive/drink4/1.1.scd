
Veco(~namex).response_mode = \exec;


(
	(

'instrument': 'drink4-1',
'timeScale': 1,
'degree': 0,
'dur': 0.125000,
'oscmix': 0.712613,
'env1': [ Env([ 110, 46, 30 ], [ 0.015, 0.19 ], [ -4, -5 ]) ],
'amp': 0.406640,
'fratio2': 0.824993,
'env0': [ Env([ 0.0, 1, 0.1, 0 ], [ 0.005, 0.16, 0.1 ], [ -4, -2, 4 ]) ],
'isRest': false,
'env3': 0.000000,
'pan': 0.000000,
'fratio': 0.500000,
'time': 0.000000,
'fratio1': 0.772042,
//'out': Bus('audio', 340, 2, s),
'distlim': 1.400000,
'osc2mix': 0.100000,
'spread': 0.100000,
'distmix': 0.000000,
'freqpan': 0.001000,
'latency': Ref(nil),

	).play
)



// END

Pdef(\hey).edit
Sdef()

[0.6]
[110,53,29].midicps

Ndef(~name+++\mixer).get(\amp)
