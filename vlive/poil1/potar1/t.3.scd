

(


Pdef(~name +++ \pre, 

	~patfx.(\mypatmod) <>
	
		Pbind(
			\degree, Pseq([0,2,3,2],inf).stutter(4),
			\isRest, Veco(~namex).isrest(16),
			\legato, 0.2,
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
~mypatmod = Pbind(\isRest, Pseq([false],5));
~mypatmod 

MIDIBoard.map(\s1, Sdef(~name, \omg), \ffreq)

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

