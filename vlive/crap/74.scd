~b1 = Buffer.alloc(s,s.sampleRate*5, 1);
~b2 = Buffer.alloc(s,s.sampleRate*5, 1);

~input = NodeProxy.audio(s,1);
~rec = NodeProxy.audio(s,1);
~play = NodeProxy.audio(s,1);
~rec2 = NodeProxy.audio(s,1);
~play2 = NodeProxy.audio(s,1);

~input.source = {|amp=1| SoundIn.ar(0)*amp};
~input.bus;
~input.stop
~input.source = {|amp=1| SinOsc.ar( LFNoise1.kr(1).range(60,700) )*amp};

~rec.source = {|buf,recLev=1,preLev=0,loop=1,run=0,in=0| RecordBuf.ar(In.ar(in),buf,0,recLev,preLev,run,loop)};

~play.source = { |buf=0,startPos=0.0,loop=1,rate=1| (PlayBuf.ar(1,buf,rate,1,1,loop))};

//I've been inputting each line individually
~rec.bus;
~rec.set(\run, 1, \in, ~input.index, \buf, ~b1);
~rec.set(\run, 0);
~play.set(\buf, ~b1);
~play.play;
//~play.pause;
//~play.resume;

~rec.set(\run, 1,\buf, ~b2);
~rec.set(\run, 0);//can hear sound on ~b1 even before I set ~play to read from buf ~b2
~play.set(\buf, ~b2);
~play.stop


//I've tried running similar nodeproxies reading from different buffers as seen below, but get very unpredictable behaviour
~rec2.source = {|buf,recLev=1,preLev=1,loop=1,run=0,in=0|
    RecordBuf.ar(In.ar(in),buf,0,recLev,preLev,run,loop)};

~play2.source = { |buf=0,startPos=0.0,loop=1,rate=1|
    (PlayBuf.ar(1,buf,rate,1,1,loop))};

~rec2.bus;
~rec2.set(\run, 1, \in, ~input.index, \buf, ~b2);
~rec2.set(\run, 0);
~play2.set(\buf, ~b2);
~play2.play;
~play2.pause;
~play2.resume;
