~unity = 1/1;
~minor_3rd = 6/5;
~major_3rd = 5/4;
~major_5th = 3/2;
~major_6th = 12/7;
~minor_7th = 7/4;
~minor = [~unity, ~minor_3rd, ~major_5th];
~minor_6 = ~minor ++ ~major_6th;
~major = [~unity, ~major_3rd, ~major_5th];
~major_7 = ~major ++ ~minor_7th;

~note = {
    arg half_steps_above_A;
    440 * (2 ** (half_steps_above_A / 12))
};

~noise = {
    arg bass, chord; var full_chord, amplitude, side;
    while({bass < 150}, {bass = bass * 2});
    while({bass > 300}, {bass = bass / 2});
    full_chord = {arg octave;
        chord * octave
    }.flop.value(2 ** Array.series(3)).flat;
    amplitude = 4 / 5 / full_chord.size;
	full_chord.debug;
    side = Mix.new(
        {arg ratio; var frequency;
            frequency = bass * ratio;
            SinOsc.ar(frequency, 0, amplitude) * AmpCompA.kr(frequency)
        }.flop.value(full_chord)
    );
    [side, side];
};

~noise.(~bass, ~minor)

~sound = 0;
~play = {
    arg clock, time, bass, chord;
    clock.sched(time, {~sound.release; ~sound = {~noise.value(bass, chord)}.play});
};
~kill = {
    arg clock, time;
    clock.sched(time, {~sound.free});
};

~bass = ~note.value(7);
~time = 0;
~clock = TempoClock.new(60/60);
				~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  2   ; // christ
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  1   ; // je-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  2   ; // sus lay
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // in
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // death's
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // strong
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  1   ; // bands
                ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // for
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // our
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  1   ; // of-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time + (1/2); // fe-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time + (1/2); // en-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // ces-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor_6); ~time = ~time +  1   ; // gi-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  1   ; // i-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  4   ; // ven. therefore
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // let
                ~play.value(~clock, ~time, ~bass, ~minor_6); ~time = ~time +  1   ; // us
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // keep
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  1   ; // the
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  2   ; // feast and
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // sing
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // to
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // god
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // right
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // thank-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // ful-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // ly
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // loud
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  1   ; // songs
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  2   ; // of hal
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // leh
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // lu
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // u-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  2   ; // jah
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  1   ; // hal-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // al-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor  ); ~time = ~time +  1   ; // le
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  1   ; // eh-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~minor_6); ~time = ~time +  1   ; // lu-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major_7); ~time = ~time +  1   ; // u-
~bass = ~bass ; ~play.value(~clock, ~time, ~bass, ~major  ); ~time = ~time +  2   ; // jah
                                          ~kill.value(~clock, ~time                 )


										  
/////////////////////////////////


(
	~notelist = [
		[  1						,					~minor  ,		 2	  ], // christ
		[  1 /  ~minor_7th			 ,				   ~major	 ,	  1   ], // je-
		[  1 /  ~major_5th			 ,				   ~minor  ,		 2   ], // sus lay
		[  1 *  ~major_5th			 ,			   ~major_7,		 1	  ], // in
		[  1 /  ~major_5th			 ,				   ~minor  ,		 1   ], // death's
		[  1 *  ~major_5th			 ,				   ~major_7,		 1   ], // strong
		[  1 /  ~major_5th			 ,				   ~major  ,		 1   ], // bands
		[  1						   ,				   ~major_7,		 1   ], // for
		[  1 /  ~major_5th			 ,				   ~minor  ,		 1   ], // our
		[  1 *  ~major_5th * ~minor_3rd,				   ~major  ,		 1   ], // of-
		[  1 /  ~major_5th			 ,				   ~major  ,		(1/2)], // fe-
		[  1			   * ~major_3rd,				   ~major_7,		(1/2)], // en-
		[  1 /  ~major_5th			 ,				   ~minor  ,		 1   ], // ces-
		[  1 /  ~major_5th			 ,				   ~minor_6,		 1   ], // gi-
		[  1 /  ~major_5th * ~major_6th,				   ~major  ,		 1   ], // i-
		[  1 /  ~major_5th			 ,				   ~minor  ,		 4   ], // ven. therefore
		[  1 /  ~major_5th			 ,				   ~minor  ,		 1   ], // let
		[  1						   ,				   ~minor_6,		 1   ], // us
		[  1 *  ~major_5th			 ,				   ~minor  ,		 1   ], // keep
		[  1 *  ~major_5th * ~minor_3rd,				   ~major  ,		 1   ], // the
		[  1 /  ~major_5th			 ,				   ~major  ,		 2   ], // feast and
		[  1			   / ~minor_3rd,				   ~minor  ,		 1   ], // sing
		[  1 *  ~major_5th			 ,				   ~major_7,		 1   ], // to
		[  1 /  ~major_5th			 ,				   ~major_7,		 1   ], // god
		[  1 * (~major_5th**2)		 ,				   ~major_7,		 1   ], // right
		[  1 /  ~major_5th			 ,				   ~minor  ,		 1   ], // thank-
		[  1 *  ~major_5th			 ,				   ~major_7,		 1   ], // ful-
		[  1 /  ~major_5th			 ,				   ~minor  ,		 1   ], // ly
		[  1 *  ~major_5th * ~minor_3rd,				   ~major_7,		 1   ], // loud
		[  1 /  ~major_5th			 ,				   ~major  ,		 1   ], // songs
		[  1 /  ~major_5th			 ,				   ~major  ,		 2   ], // of hal
		[  1 *  ~major_5th			 ,				   ~major_7,		 1   ], // leh
		[  1 /  ~major_5th / ~minor_3rd,				   ~minor  ,		 1   ], // lu
		[  1 *  ~major_5th			 ,				   ~major_7,		 1   ], // u-
		[  1 /  ~major_5th / ~major_3rd,				   ~major  ,		 2   ], // jah
		[  1 *  ~major_5th			 ,				   ~major  ,		 1   ], // hal-
		[  1			   * ~major_3rd,				   ~major_7,		 1   ], // al-
		[  1 /  ~major_5th			 ,				   ~minor  ,		 1   ], // le
		[  1			   / ~major_3rd,				   ~major  ,		 1   ], // eh-
		[  1			   / ~minor_3rd,				   ~minor_6,		 1   ], // lu-
		[  1 /  ~major_5th * ~major_6th,				   ~major_7,		 1   ], // u-
		[  1 /  ~major_5th			 ,				   ~major  ,		 2   ], // jah

	];

	~bass = ~note.value(7);
	~time = 0;
	~clock = TempoClock.new(60/60);

	~notelist.do { arg note;
		var bass, chord, time;
		#bass, chord, time = note;
		[ bass, chord, time ].debug;
		~bass = ~bass * bass ; ~play.value(~clock, ~time, ~bass, chord  ); ~time = ~time +  time   ;
	};
	~kill.value(~clock, ~time);
)


(
Pdef(\pat, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		[\\dur, 1,
		\amp, 0.1,
	)
).play;
);
