
(
~degcps = { arg deg, octave=5, root=(60.midicps); Scale.major.degreeToFreq(deg, 60.midicps, octave-5); };


~cdegcps = { arg tab, deg, octave=5, root=(60.midicps); 
	tab.collect { arg val;
		if(val >= 0) {
			~degcps.(val % 7, octave + (val/7).asInteger)
		} {
			~degcps.(val % 7, octave + (val-7/7).asInteger)
		}

	}
};


~newfx = { arg suffix;
	var fxname = ~name+++suffix;
	BusDef(fxname, \audio);

	Veco(~name).play_node_hook = {
		fxname.debug("play FX");
		//Ndef(fxname).send;
		Ndef(fxname).play;
	};

	Veco(~name).stop_node_hook = {
		fxname.debug("stop FX");
		Ndef(fxname).end(Ndef(fxname).fadeTime);
	};
};

~isrest = { arg pat;
	pat.collect { arg x; if(x == 1) { false } { true } }
};

~load_quick_quant_chooser = { arg quants;
	var codepad;
	var qp = ~veco.quickpad_controller;
	quants = quants ?? [1/8,1/4,1/2,1,  2,4,8,16];
	quants.do { arg quant, y;
		codepad = qp.get_codepad(Point(0,y));
		codepad.payload = { arg self;
			quant.debug("setting Pdef.defaultQuant to");
			Pdef.defaultQuant = quant;
		};
	}
};

~load_quick_editors = { arg self;
	var codepad;
	var qp = ~veco.quickpad_controller;
	codepad = qp.get_codepad(Point(1,0));
	codepad.payload = { arg self;
		{
			~namex.debug("edit namex");
			Sdef(~namex, \mypreset).edit;
		}.defer;
	};
	
};

ControlSpec.specs[\spread] = \unipolar.asSpec;



~morph = { arg mainkey, lagtime, pat;
	var base = pat.asStream.next(());
	var bind = List.new;
	var proxy;
	var bus;
	base.keysValuesDo { arg key, val;
		var ndefkey = "%.%".format(mainkey, key).asSymbol;
		[key, val].debug("morph:val");
		if(val.isArray) {
			var asize;
			var aval;
			aval = val[0];
			aval = aval.asArray;
			asize = aval.size;
			Ndef(ndefkey, { 
				blend(Ndef(ndefkey).kr(asize), aval, Line.kr(0, 1, lagtime))
			});
			if(val[0].class == Env) {
				bus = val;
			} {
				proxy = Ndef(ndefkey);
				bus = [proxy.busArg];
			}
		} {
			Ndef(ndefkey, { 
				Line.kr(Ndef(ndefkey).kr, val, lagtime)
			});
			proxy = Ndef(ndefkey);
			bus = proxy.bus.asMap;
		};
		bind.add(key);
		bind.add(bus);
	};
	Pbind(*bind)
};


// pattern morphing
~morphpat = { arg pat1, pat2, mpat;
	var spat1, spat2, smpat;
	var ev1, ev2, morph;
	var res_ev;
	var rout;
	var exclu = Set[\dur, \instrument, \isRest];
	//var inclu = Set[\ffreq];
	spat1 = pat1.asStream;
	spat2 = pat2.asStream;
	smpat = mpat.asStream;
	rout = Prout { arg in;
		block { arg break;
			loop {
				in = in.deepCopy;
				ev1 = spat1.next(in);
				ev2 = spat2.next(in);
				morph = smpat.next;
				if(ev1.isNil or: { ev2.isNil or: { morph.isNil }}) { 
					break.value;
				} {
					res_ev = in.deepCopy;
					ev1.keys.difference(exclu).do { arg key;
					//ev1.keys.select({ arg x; inclu.includes(x) }).do { arg key;
						//res_ev[key] = (ev1[key] * morph) + (ev2[key] * (1 - morph));
						if(ev1[key].isNumber or: {ev1[key].isSequenceableCollection}) {
							res_ev[key] = blend(ev1[key], ev2[key], morph)
						}
					};
					res_ev.debug("res_ev");
					in = res_ev.yield;
				}
			}
		}
	};
	rout
};

);
