
Quark("JITLibExtensions").install; // should have JITLibExtentions quark installed for getHalo/addHalo
s.boot;

(
// a function to map a bus or a Ndef to an argument of another Ndef, using the default spec or a given one
~map_bus = { arg obj, key, bus, spec;
	var halokey = ("busmapper_"++key).asSymbol;
	if( obj.getHalo(halokey).isNil ) {
		obj.addHalo(halokey, NodeProxy.new)
	};
	obj.getHalo(halokey).source = { 
		var xspec = spec ? obj.getSpec(key);
		var in;
		xspec.debug("spec");
		in = if(bus.isKindOf(Ndef)) {
			var rate = if(bus.rate == \audio) { \ar } { \kr };
			bus.perform(rate, bus.numChannels);
		} {
			if(bus.rate == \audio) {
				InFeedback.ar(bus.index, bus.numChannels);
			} {
				In.kr(bus.index, bus.numChannels)
			};
		};
		xspec.map(in) + \offset.kr(0);
	};
	obj.getHalo(halokey).mold(bus.numChannels, bus.rate); // mold change the rate and number of channel of the mapper NodeProxy
	obj.set(key, obj.getHalo(halokey));
};
)

// base sound
(
Ndef(\test_sound).addSpec( \ffreq, [ 100, 1000, \exp, 0.1 ] );

Ndef(\test_sound, {
		var out = SinOsc.ar( \ffreq.ar(1000), 0, 0.3);
		out = Pan2.ar(out, 0, 0.1);
		Out.ar(0, out );
}).play;
)

//////// map a bus

~ampBus= Bus.control(s,1);

(
Ndef(\receive, {
		Out.kr(~ampBus.index, SinOsc.kr(1, 0, 0.5, 0.5));
});
)

~map_bus.(Ndef(\test_sound), \ffreq, ~ampBus);

//////// map a Ndef

(
Ndef(\sin, { arg freq=200;
	var sig;
	sig = SinOsc.ar(freq);
});
);

// map it
~map_bus.(Ndef(\test_sound), \ffreq, Ndef(\sin));

// set args
Ndef(\sin).set(\freq, 1)
Ndef(\sin).set(\freq, 10)
Ndef(\sin).set(\freq, 1000)
Ndef(\sin).set(\freq, 2000)

// further modulation, this time, simple way
Ndef(\sin).set(\freq, Ndef(\sinsin, { SinOsc.ar(1/7) * 1000 })); 

// change spec
Ndef(\test_sound).addSpec( \ffreq, [ 100, 7000, \exp, 0.1 ] );
~map_bus.(Ndef(\test_sound), \ffreq, Ndef(\sin)); // must reload the mapper

// direct way
~map_bus.(Ndef(\test_sound), \ffreq, Ndef(\sin), ControlSpec(30,5999,\exp));
~map_bus.(Ndef(\test_sound), \ffreq, Ndef(\sin), ControlSpec(330,15999,\exp));


CmdPeriod.run;
Ndef(\test_sound).play; // Ndef type modulators are restarted automatically, but not the bus ones


/////////// access to busmapper 

Ndef(\test_sound).getHalo(\busmapper_ffreq)
Ndef(\test_sound).getHalo(\busmapper_ffreq).set(\offset, 100);
Ndef(\test_sound).getHalo(\busmapper_ffreq).set(\offset, 3300);
