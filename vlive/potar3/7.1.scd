
//~pharma = Pbind(\isRest, Pgate(Pseq([false],1), \bla, ~rah))
~rah = 1;
~pharma = Pbind(\isRest, Pseq([false],inf), \bla, Pfunc({~rah}));
Veco(~namex).response_off_hook = { ~rah = nil };
Veco(~namex).response_mode = \play;
