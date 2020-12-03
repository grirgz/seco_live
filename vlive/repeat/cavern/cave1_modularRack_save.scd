Param(Builder('osc1'), 'oscType').set('saw');
Param(Builder('osc1'), 'numVoices').set(10.0);


Param(Pdef('osc1'), 'dur').set(1.0);
Param(Pdef('osc1'), 'legato').set(1);
Param(Pdef('osc1'), 'out').set(BusDef('stereobus0'));
Param(Pdef('osc1'), 'amp').set(0.21355601469238);
Param(Pdef('osc1'), 'pan').set(0.0);
Param(Pdef('osc1'), 'freq').set(43.846919449669);
Param(Pdef('osc1'), 'fspread').set(0.001);
Param(Pdef('osc1'), 'adsr').set(Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));


Param(Builder('osc2'), 'oscType').set('pulse');
Param(Builder('osc2'), 'numVoices').set(10.0);


Param(Pdef('osc2'), 'dur').set(0.25);
Param(Pdef('osc2'), 'legato').set(1.6024317616056);
Param(Pdef('osc2'), 'out').set(0);
Param(Pdef('osc2'), 'amp').set(0.34917355371901);
Param(Pdef('osc2'), 'pan').set(0.0);
Param(Pdef('osc2'), 'freq').set(86.575225621661);
Param(Pdef('osc2'), 'fspread').set(0.0010537249727361);
Param(Pdef('osc2'), 'pulseWidth').set(0.5);
Param(Pdef('osc2'), 'adsr').set(Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));


Param(Builder('filter1'), 'filterType').set('rlpf');


Param(Pdef('filter1'), 'dur').set(1.0);
Param(Pdef('filter1'), 'legato').set(0.8);
Param(Pdef('filter1'), 'out').set(BusDef('stereobus2'));
Param(Pdef('filter1'), 'gain').set(1.0);
Param(Pdef('filter1'), 'cutoff').set(438.46919449669);
Param(Pdef('filter1'), 'inbus').set(BusDef('stereobus0'));
Param(Pdef('filter1'), 'rq').set(0.17944405846008);
Param(Pdef('filter1'), 'adsr').set(Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));


Param(Builder('filter2'), 'filterType').set('lpf');


Param(Pdef('filter2'), 'dur').set(1.0);
Param(Pdef('filter2'), 'legato').set(0.8);
Param(Pdef('filter2'), 'out').set(0);
Param(Pdef('filter2'), 'gain').set(1.0);
Param(Pdef('filter2'), 'cutoff').set(500.0);
Param(Pdef('filter2'), 'inbus').set(20.0);
Param(Pdef('filter2'), 'adsr').set(Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));


Param(Pdef('modseq1'), 'dur').set(1.4608991161173);
Param(Pdef('modseq1'), 'legato').set(0.33271404624298);
Param(Pdef('modseq1'), 'out').set(BusDef('krbus0'));
Param(Pdef('modseq1'), 'seqrate').set(196.36500284824);
Param(Pdef('modseq1'), 'amp').set(0.21355601469238);
Param(Pdef('modseq1'), 'lagTime').set(0.015151515151515);
Param(Pdef('modseq1'), 'seqtab').set([ 0.0, 0.78846150636673, 0.87568682432175, 0.89423078298569, 0.80288457870483, 0.64423072338104, 0.53846156597137, 0.0 ]);
Param(Pdef('modseq1'), 'adsr').set(Env([ 0.0, 1.0, 0.625, 0.0 ], [ 0.0099999997764826, 0.075409835693045, 0.034590169298844 ], [ -4.0, -4.0, -4.0 ], 2.0));


Param(Pdef('modseq2'), 'dur').set(1.0);
Param(Pdef('modseq2'), 'legato').set(0.8);
Param(Pdef('modseq2'), 'out').set(0);
Param(Pdef('modseq2'), 'seqrate').set(236.25593350753);
Param(Pdef('modseq2'), 'amp').set(0.1);
Param(Pdef('modseq2'), 'lagTime').set(0.0);
Param(Pdef('modseq2'), 'seqtab').set([ 0.0, 0.0, 0.0, 0.5, 0.58928573131561, 0.70512813329697, 0.55769228935242, 0.0 ]);
Param(Pdef('modseq2'), 'adsr').set(Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.0099999997764826 ], [ -4.0, -4.0, -4.0 ], 2.0));


Param(Builder('modosc1'), 'oscType').set('sin');


Param(Pdef('modosc1'), 'dur').set(4);
Param(Pdef('modosc1'), 'legato').set(1);
Param(Pdef('modosc1'), 'out').set(BusDef('krbus2'));
Param(Pdef('modosc1'), 'amp').set(0.3228305785124);
Param(Pdef('modosc1'), 'freq').set(0.38541666666667);
Param(Pdef('modosc1'), 'adsr').set(Env([ 0, 1, 0.837634, 0 ], [ 0.0147414, 0.293966, 0.048276 ], [ -4, 0, 0 ], 2));


Param(Builder('modosc2'), 'oscType').set('sin');


Param(Pdef('modosc2'), 'dur').set(1.0);
Param(Pdef('modosc2'), 'legato').set(0.8);
Param(Pdef('modosc2'), 'out').set(0);
Param(Pdef('modosc2'), 'amp').set(0.1);
Param(Pdef('modosc2'), 'freq').set(261.6255653006);
Param(Pdef('modosc2'), 'adsr').set(Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));


Param(Ndef('fx1'), 'inbus').set(BusDef('stereobus3'));
Param(Ndef('fx1'), 'gain').set(1.0);
Param(Ndef('fx1'), 'room').set(0.83881138695224);
Param(Ndef('fx1'), 'damp').set(0.5);
Param(Ndef('fx1'), 'mix').set(0.5);
Param(Ndef('fx1'), 'verbmix').set(1.0);


Param(Ndef('fx2'), 'inbus').set(BusDef('stereobus2'));
Param(Ndef('fx2'), 'shift').set(0.0);
Param(Ndef('fx2'), 'amp').set(0.10000000149012);
Param(Ndef('fx2'), 'mix').set(0.12878787878788);
Param(Ndef('fx2'), 'adsr').set(Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
