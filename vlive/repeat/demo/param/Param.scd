
(
	s.boot;
SynthDef(\saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\sampler1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\reverb, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreeVerb.ar(sig, mix:\verbmix.kr(0.2), room: \room.kr(0.5), damp:\damp.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;

BufDef.addPath(Platform.resourceDir);
BufDef(\a11, "sounds/a11wlk01.wav");
);


(
Pdef(\sampler, 
	Pbind(
		\instrument, \sampler1,
		\bufnum, BufDef(\a11),
		\loop, 1,
		\dur, 1,
		\gain, 1,
	)
).play;
);

(
Pdef(\reverb, 
	Pmono(\reverb,
		\inbus, BusDef(\reverb, \audio),
		\addAction, \addToTail,
		\lag, 0.0009,
		\dur, 1,
	),
).play;
);

(
Pdef(\saw, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq((0..14),inf) % Pseq((5..10),inf),
		\dur, 1/8,
	)
).play;
);

Pdef(\sampler).edit;
Pdef(\reverb).edit;
Pdef(\saw).edit;

(
WindowDef(\PdefEditor, { arg def;
	"haha".postln;
	Button.new;
	
}).front;
)
			Param(Pdef(\sampler),\out, TagSpecDef(\BufDef)).spec.isKindOf(TagSpec)
			Param(Pdef(\sampler),\out, TagSpecDef(\BufDef)).type
TagSpecDef(\BufDef).list
(
	ParamProto.init;
WindowDef(\rack, { arg def, items;
	items = items ?? {
		[
			Pdef(\sampler),
			Pdef(\reverb),
			Pdef(\saw),
			Param(Pdef(\sampler),\out, TagSpecDef(\BusDef)).label_("sampler out"),
			Param(Pdef(\reverb),\room),
			Param(Pdef(\reverb),\mix),
		]
	};
	VLayout (
		* items.collect { arg item, idx;
			ParamGroupLayout.formEntry(item, \full)
		} ++ [nil];
	)
}).front;
)

\freq.asSpec
Spec.specs[\widefreq]


//////////////////////////////////////////////////

BufDef(\osc, s.sampleRate * 2, 2)
BufDef(\osc).clear
BufDef(\osc).plot
BufDef(\osc).sine1(1/[1,2,3,4,5], true, false, true)
Buffer
s.boot;
(
b = Buffer.alloc(s, 512, 1);
b.sine1(1.0 / [1, 2, 3, 4], true, true, true);
b.sine1(1.0 / [1, 2, 3, 4], true, false, true);
b.plot
x = { Osc.ar(b, 200, 0, 0.5) }.play;
)
x.free; b.free;

(
b = BufDef(\hihi3, 512, 1);
b.sine1(1.0 / [1, 2, 3, 4], true, true, true);
b.sine1(1.0 / [1, 2, 3, 4], true, false, true);
b.plot
x = { Osc.ar(b, 200, 0, 0.5) }.play;
)


Pbindef(\sampler).source.at(\bufnum).source = nil
Pbindef(\sampler).source.at(\bufnum).source = Pkey(\bufnum)
Pbindef(\sampler, \bufnum, Pkey(\bufnum));
Pbindef(\sampler).source.at(\bufnum).clear

////////////////////////ko

		var con = ContextMenuWindow.new();
		con.action = { arg menu, selection;
			switch(selection,
				0, {
					param.setBusMode(param.inBusMode.not);
				},
				1, {
					param.unset
				},
				2, {
					if(param.target.isKindOf(EventPatternProxy)) {
						Pbindef(param.target.key, param.propertyRoot, Pkey(param.propertyRoot));
					} {
						Log(\Param).info("Can't override, not an EventPatternProxy");
					}
				},
				3, {
					param.set(param.default)
				},
				4, {
					var midi = param.target.getHalo(\MIDIFunc, param.property);
					if(midi.notNil) {
						midi.free;
						param.target.addHalo(\MIDIFunc, param.property, nil);
					};
					midi = MIDIFunc.cc({ arg ... args;
						//args.debug("MENU MIDI Func");
						param.normSet(args[0]/127)
					}).fix.learn;
					param.target.addHalo(\MIDIFunc, param.property, midi);
				},
				5, {
					var midi = param.target.getHalo(\MIDIFunc, param.property);
					if(midi.notNil) {
						midi.free;
						param.target.addHalo(\MIDIFunc, param.property, nil);
					};
				}
			)
		};
		con.attach(view, {
			con.list = [ 
				if(param.inBusMode) {
					"Disable bus mode"
				} {
					"Enable bus mode"
				},
				"Unset",
				"Override",
				"Default",
				"MIDI CC learn and map",
				if(param.target.getHalo(\MIDIFunc, param.property).notNil) {
					"Clear MIDI (%)".format(param.target.getHalo(\MIDIFunc, param.property).msgNum);
				} {
					"Clear MIDI (not set)";
				},
			]
		});
