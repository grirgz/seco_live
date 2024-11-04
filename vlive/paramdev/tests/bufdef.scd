
BufDef(\bla, 10000, 2)
BufDef(\bla)

BufDef(\bloc, 10000, 2)
BufDef(\march4, "vipere/march.flac", 3);
BufDef(\amen, "vipere/amenbreak.wav", 1);
BufDef(\amen)
BufDef(\moeten, "voices/02_moeten.flac", 3)
BufDef('voices/02_moeten.flac')
BufDef(\moeten, nil, 5)
BufDef(\moeten)
BufDef.mono(\moeten)
BufDef.relpath_to_abspath("vipere/march.flac")
~b = Buffer.readChannel(s, BufDef.relpath_to_abspath("vipere/march.flac"), 0, -1, [0])
~b
BufDef(\march, "vipere/march.flac").free;
BufDef.free(\march)
BufDef.free(\amen)
BufDef.bufferChannelCache
