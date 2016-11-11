
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name,
        ~patfx.(~name+++\patfx) <>
        Pdef(~name +++ \pre) <> Pbind(
        \instrument, ~name,
        \bufnum, BufDef(\moeten),
        \bufnum, BufDef(\woodshop),
        \degree, Pseq([0],inf),
        \isRest, Veco(~name).isrest,
        \dur, 1/8,
        \amp, 0.21 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// insert isRest false until button release
~insert_beat.(~name+++\patfx);

// insert a pattern (should not be infinite else no way to stop it)
~patfx_insert.(~name+++\patfx, Pbind(
	\dur, Pseq([0.12,0.1],4),
))

// same than patfx_insert but will remove pattern when button release, can be infinite
~patfx_gate.(~name+++\patfx, Pbind(
	\dur, Pseq([0.12,0.1],inf),
))

//////////////////////////////////
(
~patechoblend = { arg pat, blend;
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
		var count = 0;
		var old, oldold;
        while( { ev.notNil } ) {
            var evc = ev.copy;
			if(oldold.notNil) {
			//if(false) {
				var evb;
				evc[\dur] = ev[\dur]/2;
				evc[\server] = nil;
				oldold[\server] = nil;
				oldold[\dur] = ev[\dur]/2;
				evc.debug("lkjlkj");
				in = evc.yield;
				evb = blend(evc, oldold, blend.value);
				//evb = evc;
				in = evb.yield;
			} {
				in = evc.yield;
			};
			oldold = old;
			old = evc;
            ev = str.next(in);
			count = count + 1;
        };
        nil;
    };
};
~patecho = { arg pat, amp;
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
		var count = 0;
		var old, oldold;
        while( { ev.notNil } ) {
            var evc = ev.copy;
			if(oldold.notNil) {
				evc[\dur] = ev[\dur]/2;
				in = evc.yield;
				oldold[\amp] = amp.value * oldold[\amp];
				in = oldold.yield;
			} {
				in = evc.yield;
			};
			oldold = old;
			old = evc;
            ev = str.next(in);
			count = count + 1;
        };
        nil;
    };
};
)

~preset = ~class_preset.new([\mamp, \amp.asSpec]);
~preset.edit;

////////////////////:

Pchain
Prout
Pstutter
(
// repeat last
// without internal pattern
~preset = ~class_preset.new([\mamp, \amp.asSpec]);
~wrapper = { arg pat, amp;
    Prout { arg in;
        var ev = in;
		var count = 0;
		var old, oldold;
        while( { ev.notNil } ) {
            var evc = ev.copy;
			in.debug("INNNNNNN");
			if(oldold.notNil) {
				evc[\dur] = ev[\dur]/2;
				in = evc.yield;
				oldold[\amp] = amp.value * oldold[\amp];
				in = oldold.yield;
			} {
				in = evc.yield;
			};
			oldold = old;
			old = evc;
			ev = in;
			count = count + 1;
        };
        nil;
    };
};

~pat = Pbind(\freq, Pseq([100,200,400,300],inf));
Pdef(\plop,
	~wrapper.(~pat, ~preset.vals[\mamp].valpattern.asStream) 
	<> ~pat
	<> Pbind(
		\bla, Pseq([10,20,30],inf),
		\dur, 1/4,
	)
).play;
//(~wrapper.(~pat)).trace.play;
)
~preset.edit;


////////////////////:
a = Pseq([100,200,300,400],4);
b= a.asStream;
b.value
a = Pseq([100,200,300,400],4);
a.value

(
// repeat last
~preset = ~class_preset.new([\mamp, \amp.asSpec]);
~wrapper = { arg pat, amp;
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
		var count = 0;
		var old, oldold;
        while( { ev.notNil } ) {
            var evc = ev.copy;
			if(oldold.notNil) {
				evc[\dur] = ev[\dur]/2;
				in = evc.yield;
				oldold[\amp] = amp.value * oldold[\amp];
				in = oldold.yield;
			} {
				in = evc.yield;
			};
			oldold = old;
			old = evc;
            ev = str.next(in);
			count = count + 1;
        };
        nil;
    };
};

~pat = Pbind(\freq, Pseq([100,200,400,300],inf));
Pdef(\plop,
	~wrapper.(~pat, 1) 
	<> Pbind(
		\bla, Pseq([10,20,30],inf),
		\dur, 1/4,
	)
).play;
//(~wrapper.(~pat)).trace.play;
)
~preset.edit;


////////////////////:

(
// stutter
~preset = ~class_preset.new([\mamp, \amp.asSpec]);
~wrapper = { arg pat, amp;
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
		var count = 0;
        while( { ev.notNil } ) {
            var evc = ev.copy;
			evc[\dur] = ev[\dur]/2;
			in = evc.yield;
			evc[\amp] = amp.value * ( ev[\amp] ? 1 );
			in = evc.yield;
            ev = str.next(in);
			count = count + 1;
        };
        nil;
    };
};

~pat = Pbind(\freq, Pseq([100,200,400,300],inf));
Pdef(\plop,
	~wrapper.(~pat, ~preset.vals[\mamp].valpattern.asStream) 
	<> Pbind(
		\bla, Pseq([10,20,30],inf),
		\dur, 1/4,
	)
).play;
//(~wrapper.(~pat)).trace.play;
)

~preset.edit;


a = ~preset.vals[\mamp].valpattern.asStream
a.value


//////////////////////////////
(
// stutter
~wrapper = { arg pat, amp;
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
		var count = 0;
        while( { ev.notNil } ) {
            var evc = ev.copy;
			evc[\dur] = ev[\dur]/2;
			in = evc.yield;
			evc[\amp] = amp.value * ev[\amp];
			in = evc.yield;
            ev = str.next(in);
			count = count + 1;
        };
        nil;
    };
};

~amp = Ref(0);
~pat = Pbind(\freq, Pseq([100,200,400,300],inf));
Pdef(\plop,
	~wrapper.(~pat, ~amp) 
	<> Pbind(
		\bla, Pseq([10,20,30],inf),
		\dur, 1/4,
	)
).play;
//(~wrapper.(~pat)).trace.play;
)
~amp

(
w = Window.new.front;
g = EZSlider( w,         // parent
              390@20,    // bounds
              " test ",  // label
              \amp,     // controlSpec
              { |ez| ~amp.value = ez.value; (ez.value.asString ++" is the value of " ++ ez).postln } // action
);
g.setColors(Color.grey,Color.white)
);


//////////////////////////////

(
// mute the even notes
~wrapper = { arg pat, amp;
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
		var count = 0;
        while( { ev.notNil } ) {
            var evc = ev.copy;
			if(count.odd) {
				in = evc.yield;
			} {
				evc[\amp] = amp.value * ( ev[\amp] ? 1 );
				in = evc.yield;
			};
            ev = str.next(in);
			count = count + 1;
        };
        nil;
    };
};

~amp = Ref(0.2);
~pat = Pbind(\freq, Pseq([100,200,400,300],inf));
Pdef(\plop,
	~wrapper.(~pat, ~amp) 
	<> Pbind(
		\bla, Pseq([10,20,30],inf),
		\legato, 0.1,
		\dur, 1/4,
	)
).play;
//(~wrapper.(~pat)).trace.play;
)
~amp

(
w = Window.new.front;
g = EZSlider( w,         // parent
              390@20,    // bounds
              " test ",  // label
              \amp,     // controlSpec
              { |ez| ~amp.value = ez.value; (ez.value.asString ++" is the value of " ++ ez).postln } // action
);
g.setColors(Color.grey,Color.white)
);


//////////////////////////////



(
/// base patfx : stutter(2) notes with swing
~wrapper = { arg pat;
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
        while( { ev.notNil } ) {
            var evc = ev.copy;
            evc[\dur] = 0.8 * ev[\dur];
            evc.yield;
            evc[\dur] = 0.2 * ev[\dur];
            in = evc.yield;
            ev = str.next(in);
        };
        nil;
    };
};

~pat = Pbind(\freq, Pseq([100,200],4));
(~wrapper.(~pat) <> Pbind(\bla, Pseq([10,20,30],inf))).trace.play;
//(~wrapper.(~pat)).trace.play;
)


