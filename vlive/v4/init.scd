
TempoClock.default.tempo = 380/60;
Pdef.defaultQuant=4;
(
~platch = { arg pat;
	Prout { arg ev;
		var last;
		pat.asStream.do { arg val;
			if(val.notNil) {
				last = val;
			}; 
			ev = last.yield;
		};
		loop { 
			ev = last.yield;
		};
	}
};
~load = { arg subidx, name;
	name = name ?? ~name;
	~veco.exec_subbuffer(~veco.name_to_index(name), subidx)

}
);
~mybus = Array.fill(8, { Bus.control(s,1) });
~modgroup = Group.before(1)

//~veco.open_buffer(1)
