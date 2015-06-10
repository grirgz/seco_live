
Veco(~namex).response_mode = \exec;

(
'instrument': ~name,
'degree': 0,
'dur': 0.125000,
'time': 0.000000,
'decay': 1/3,
'amp': 0.027759,
'isRest': false,
'prob': 0,
//'out': Bus('audio', 200, 2, s),
'legato': 0.850000,
'shift': -900,
'freqfactor': [ 0.5, 2 ],
'latency': Ref(nil),

).play;
