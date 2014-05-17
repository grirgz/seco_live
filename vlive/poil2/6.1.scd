

(


Pdef(~name +++ \pre, 

	~patfx.(\mypatmod) <>
	
		Pbind(
			\freq, Pseq([20,24,20],inf),
			\isRest, Veco(~namex).isrest(16),
			\legato, Pseq([3.4,0.4,0.3,1.3],inf),
			//\ffreq, 1000,
			\dur, 1/8,
		)
	<> Sdef(~name, \omg).pbind
);

Pdef(~name).play;

);


// END
~patfx.asCompileString
Sdef(~name, \omg).get(0,0).vals[\ffreq].get_val
Sdef(~name, \omg).getsub(0).vals[\ffreq].get_val
Sdef(~name, \omg).get(0).vals[\ffreq].set_bus_mode(true)
Sdef(~name, \omg).get(0).vals[\shift].set_bus_mode(true)
~mypatmod = Pbind(\isRest, Pseq([false],5));
~mypatmod 
Sdef(~name, \omg).rebuild
Sdef(~name, \omg).edit
Sdef(~name, \omg).get_active_score.vals[\freq]

VecoLib.load_lib
MIDIBoard.map(\s1, Sdef(~name, \omg), \ffreq)
MIDIBoard.map(\s2, Sdef(~name, \omg), \shift)

~wrapper = { 
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
		var count = 0;
		var pat;
        while( { ev.notNil } ) {
            var evc = ev.copy;
			if(~mypatmod.notNil) {
				pat = ~mypatmod;
				~mypatmod = nil;
				str = pat.asStream;
				ev = str.next(in);
			}


			if(count.odd) {
				in = evc.yield;
			} {
				evc[\amp] = amp.value * ev[\amp];
				in = evc.yield;
			};
            ev = str.next(in);
			count = count + 1;
        };
        nil;
    };
};

Pdef(~name +++ \pre, 
	
	Pcollect(
		{
			arg item;
			if(~mypatmod.notNil) {
				item[\isRest] = ~mypatmod;
			};
			item.debug("item");
			item;
		},
		Pbind(
			\degree, Pseq([0,2,3,2],inf).stutter(4),
			\isRest, Veco(~namex).isrest(16),
			\dur, 1/8,
		)
	)
);

(
~wrapper = { 
    Prout { arg in;
        //while( { ev.notNil } ) {
		var pat;
		var ev, str;
		510.do {
			if(~mypatmod.notNil) {
				pat = ~mypatmod;
				str = pat.asStream;
				~mypatmod = nil;
				ev = str.next(in);
			};
			if(ev.notNil) {
				in = ev.yield;
				ev = str.next(in);
			} {
				pat = nil;
				in.debug("in");
				in = in.yield;
			}
        };
        nil;
    };
};


Pdef(~name +++ \pre, 

	~wrapper.() <>
	
		Pbind(
			\degree, Pseq([0,2,3,2],inf).stutter(4),
			\isRest, Veco(~namex).isrest(16),
			//\ffreq, 1000,
			\dur, 1/8,
		)
	<> Sdef(~name, \omg).pbind
);

Pdef(~name).play;

);

