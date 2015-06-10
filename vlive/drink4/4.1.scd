
Veco(~namex).response_mode = \exec;

(
'instrument': ~name,
'degree': 0,
'dur': 0.125000,
'time': 0.000000,
'decay': #{ ~dur * ~legato * ~stretch },
'amp': 0.027759,
'isRest': false,
'prob': 0,
//'out': Bus('audio', 200, 2, s),
'legato': 0.850000,
'shift': 100,
'freqfactor': [ 0.5, 3 ],
'latency': Ref(nil),

).play;
