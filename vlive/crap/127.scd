(
~ampBus= Bus.control(s,1);

Ndef(\test_sound).addSpec( \ffreq, [ 100, 1000, \exp, 0.1 ] );

Ndef(\test_sound, {
        var out = SinOsc.ar( \ffreq.kr(1000), 0, 0.3);
        Out.ar(1, out );
}).play;

Ndef(\receive, {

        Out.kr(~ampBus.index, SinOsc.kr(1, 0, 0.5, 0.5));
}).play;
)



Ndef(\receive).getSpec(\amp)


Ndef()

(
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
		xspec.map(in);
	};
	obj.set(key, obj.getHalo(halokey));
	//obj.getHalo(halokey).play;
};
)

(
Ndef(\test_sound).addSpec( \ffreq, [ 100, 1000, \exp, 0.1 ] );

Ndef(\test_sound, {
		var out = SinOsc.ar( \ffreq.ar(1000), 0, 0.3);
		out = Pan2.ar(out, 0, 0.1);
		Out.ar(0, out );
}).play;
)

~ampBus= Bus.control(s,1);

(
Ndef(\receive, {
		Out.kr(~ampBus.index, SinOsc.kr(1, 0, 0.5, 0.5));
});
)

~map_bus.(Ndef(\test_sound), \ffreq, ~ampBus);


(
Ndef(\sin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
});
);

~map_bus.(Ndef(\test_sound), \ffreq, Ndef(\sin));

Ndef(\sin).set(\freq, 1)
Ndef(\sin).set(\freq, 10)
Ndef(\sin).set(\freq, 1000)
Ndef(\sin).set(\freq, 2000)
Ndef(\sin).set(\freq, Ndef(\sinsin, { SinOsc.ar(1/7) * 1000 })); // further modulation, this time, simple way

// change spec
Ndef(\test_sound).addSpec( \ffreq, [ 100, 7000, \exp, 0.1 ] );
~map_bus.(Ndef(\test_sound), \ffreq, Ndef(\sin));

// direct way
~map_bus.(Ndef(\test_sound), \ffreq, Ndef(\sin), ControlSpec(30,5999,\exp));
~map_bus.(Ndef(\test_sound), \ffreq, Ndef(\sin), ControlSpec(330,15999,\exp));



Ndef(\test_sound).play

(
Ndef(\test_sound, {
		var out = LFSaw.ar( \ffreq.ar(1000), 0, 0.3);
		out = Pan2.ar(out, 0, 0.1);
		Out.ar(0, out );
});
)



Ndef(\test_sound).addSpec( \ffreq, [ 100, 1000, \exp, 0.1 ] );

Ndef(\test_sound, {
        var out = SinOsc.ar( \ffreq.kr(1000), 0, 0.3);
        Out.ar(1, out );
}).play;

