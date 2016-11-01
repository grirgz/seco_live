(
	~get_sample_slices = { arg buffer, action, threshes;
		var list = List.new;
		var rep;
		var repfree;
		var node;
		var mlist;
		threshes = threshes ? (0.1, 0.2 .. 1);
		mlist = {List.new}!threshes.size;

		rep = OSCFunc({ |msg, time| 
			var frame;
			var mode;
			var id;
			//("time:" + t).postln; msg.postln;
			id = msg[2];
			frame = msg[3];
			if(id >= 0) {
				if(list.includes(frame).not) {
					list.add(frame);
					mlist[id].add(frame);
					frame.debug("analysis: add frame");
				}
			} {
				action.value(list, mlist); 
				node.free;
				rep.free;
				debug("Analysis done!");
			}
		}, '/tr', s.addr);


		node = {
				var sig, chain, onsets, pips;
				var frame;
				var fftbuf = LocalBuf(1024);
				var line;

				frame = Phasor.ar(0, BufRateScale.kr(buffer.bufnum), 0, BufFrames.kr(buffer.bufnum));
				line = Line.ar(0,1,BufDur.kr(buffer),doneAction:0);
				SendTrig.kr(Done.kr(line),-1,frame);
				if(buffer.numChannels == 1) {
					sig = BufRd.ar(1, buffer.bufnum, frame);
				} {
					sig = BufRd.ar(buffer.numChannels, buffer.bufnum, frame)[0];
				};

				chain = FFT(fftbuf, sig);

				onsets = Onsets.kr(chain, threshes, \rcomplex);
				SendTrig.kr(onsets,(0..(onsets.size-1)),frame);
				// Generate pips at a variety of pitches
				pips = SinOsc.ar((threshes).linexp(0, 1, 440, 3520), 0, EnvGen.kr(Env.perc(0.001, 0.1, 0.5), onsets)).mean;
				//Out.ar(0, Pan2.ar(sig, -0.75, 0.2) + Pan2.ar(pips, 0.75, 1));
				Out.ar(0, Pan2.ar(sig));
				//Out.ar(0, sig);
		}.play;

		list;
	
	}
)


BufDef(\amen, "vipere/amenbreak.wav");

~get_sample_slices.(BufDef(\amen), { arg x; ~list = x; });
 
(
SynthDef(\playbuf, { arg out=0, sframe, eframe, buf, amp;
		var frame, sig, dur, env;	
		dur = (BufDur.kr(buf)/BufSamples.kr(buf)) * (eframe - sframe) * 2;
		dur = dur * \xdur.kr(1);
		frame = Line.ar(sframe, eframe, dur,doneAction:0);
		env = EnvGen.kr(Env.linen(0.01, max(0,dur-0.03), 0.01),doneAction:2);
		sig = BufRd.ar(2, buf, frame) * env;
		sig = sig * amp;
		Out.ar(out, sig); 
}).add
)
  
(
Pdef(\amen, Pbind(
	\instrument, \playbuf,
	\index, Pseq((0..(~list.size-1))),
	\sframe, Pindex(~list, Pkey(\index)),
	\eframe, Pindex(~list ++ [d.numFrames], Pkey(\index)+1),
	\buf, BufDef(\amen, "vipere/amenbreak.wav"),
	\xdur, 1,
	\amp, 0.1,
	\dur, 1/8,

)).play;
)



////////////////////////////////////////// drafts

d = BufDef.mono(\amen, "vipere/amenbreak.wav");
b = Buffer.alloc(s, 1024,1);

(
SynthDef(\playbuf, { arg out=0, sframe, eframe, buf, amp;
		var frame, sig, dur, env;	
		dur = (BufDur.kr(buf)/BufSamples.kr(buf)) * (eframe - sframe) * 2;
		dur = dur * \xdur.kr(1);
		frame = Line.ar(sframe, eframe, dur,doneAction:0);
		env = EnvGen.kr(Env.linen(0.01, max(0,dur-0.03), 0.01),doneAction:2);
		sig = BufRd.ar(2, buf, frame) * env;
		sig = sig * amp;
		Out.ar(out, sig); 
}).add

)

(
~list = List.new;
o = OSCresponderNode(s.addr, '/tr', { |t, r, msg| 
	var frame;
	//("time:" + t).postln; msg.postln;
	frame = msg[3];
	if(~list.includes(frame).not) {
		~list.add(frame);
	}

}).add;
)

(
var threshes = (0.1, 0.2 .. 1);
x = {
        var sig, chain, onsets, pips;
		var frame;

        // A simple generative signal
        //sig = LPF.ar(Pulse.ar(TIRand.kr(63, 75, Impulse.kr(2)).midicps), LFNoise2.kr(0.5).exprange(100, 10000)) * Saw.ar(2).range(0, 1);
        // or, uncomment this line if you want to play the buffer in
        //sig = PlayBuf.ar(1, d, BufRateScale.kr(d), loop: 1);
		frame = Phasor.ar(0, BufRateScale.kr(d.bufnum), 0, BufFrames.kr(d.bufnum));
		sig = BufRd.ar(1, d.bufnum, frame);

        chain = FFT(b, sig);

        onsets = Onsets.kr(chain, threshes, \rcomplex);
		SendTrig.kr(onsets,0,frame);
        // Generate pips at a variety of pitches
        pips = SinOsc.ar((threshes).linexp(0, 1, 440, 3520), 0, EnvGen.kr(Env.perc(0.001, 0.1, 0.5), onsets)).mean;
        Out.ar(0, Pan2.ar(sig, -0.75, 0.2) + Pan2.ar(pips, 0.75, 1));
		//Out.ar(0, sig);
}.play;
)


(
	SynthDef("help-SendTrig",{
		        SendTrig.kr(Dust.kr(1.0),19850,0.9);

	}).play;

	// register to receive this message
	o = OSCFunc({ arg msg, time;
	        [time, msg].postln;
		},'/tr', s.addr);

)


(
	~get_sample_slices = { arg buffer, action;
		var threshes = (0.1, 0.2 .. 1);
		var list = List.new;
		var rep;
		var repfree;
		var node;

		rep = OSCFunc({ |msg, time| 
			var frame;
			var mode;
			//("time:" + t).postln; msg.postln;
			mode = msg[2];
			frame = msg[3];
			if(mode == 0) {
				if(list.includes(frame).not) {
					list.add(frame);
					frame.debug("analysis: add frame");
				}
			} {
				action.value(list); 
				node.free;
				rep.free;
				debug("Analysis done!");
			}
		}, '/tr', s.addr);


		node = {
				var sig, chain, onsets, pips;
				var frame;
				var fftbuf = LocalBuf(1024);
				var line;

				frame = Phasor.ar(0, BufRateScale.kr(buffer.bufnum), 0, BufFrames.kr(buffer.bufnum));
				line = Line.ar(0,1,BufDur.kr(buffer),doneAction:0);
				SendTrig.kr(Done.kr(line),1,frame);
				if(buffer.numChannels == 1) {
					sig = BufRd.ar(1, buffer.bufnum, frame);
				} {
					sig = BufRd.ar(buffer.numChannels, buffer.bufnum, frame)[0];
				};

				chain = FFT(fftbuf, sig);

				onsets = Onsets.kr(chain, threshes, \rcomplex);
				SendTrig.kr(onsets,0,frame);
				// Generate pips at a variety of pitches
				pips = SinOsc.ar((threshes).linexp(0, 1, 440, 3520), 0, EnvGen.kr(Env.perc(0.001, 0.1, 0.5), onsets)).mean;
				//Out.ar(0, Pan2.ar(sig, -0.75, 0.2) + Pan2.ar(pips, 0.75, 1));
				Out.ar(0, Pan2.ar(sig));
				//Out.ar(0, sig);
		}.play;

		list;
	
	}
)

~my = ~get_sample_slices.(BufDef.mono(\amen))
~my = ~get_sample_slices.(BufDef.mono(\amen), { arg x; ~hip = x; })
~my = ~get_sample_slices.(BufDef(\amen), { arg x; ~hup = x; })
~my = ~get_sample_slices.(BufDef(\amen), { arg x; ~hup = x; })
~hep
~hep.size;
~hip.size;
~hop.size;
~hup.size;
~my

~list

~mlist = (0..(~list.size-1)).scramble;
~mlist
(
Pdef(\amen, Pbind(
	\instrument, \playbuf,
	\index, Pseq(~mlist),
	\index, Pseq((0..(~list.size-1)),inf),
	\index, ~frozzer.(Pseq((0..(~list.size-1)),inf), Pseq([
		Pser([0],4),
		Pser([1],2),
	],inf)),
	\sframe, Pindex(~list, Pkey(\index)),
	\eframe, Pindex(~list ++ [d.numFrames], Pkey(\index)+1),
	\buf, BufDef(\amen, "vipere/amenbreak.wav"),
	//\dur,Pseq([1,4,2,1]/10,inf)
	\legato, 2,
	\xdur, 1 * Pseq([Pser([1],7),1.1,1],inf),
	\amp, 0.1,
	\dur, 1/4 * Pseq([1,1/2],inf),

)).play;
)



(
Pdef(\amen, Pbind(
	\instrument, \playbuf,
	\index, Pseq(~mlist),
	\index, Pseq((0..(~list.size-1)),inf),
	\index, ~frozzer.(Pseq((0..(~list.size-1)),inf), Pseq([
		Pser([0],4),
		Pser([1],2),
	],inf)),
	\index, Pseq([0,2,0,8],inf),
	\sframe, Pindex(~list, Pkey(\index)),
	\eframe, Pindex(~list ++ [d.numFrames], Pkey(\index)+1),
	\buf, BufDef(\amen, "vipere/amenbreak.wav"),
	//\dur,Pseq([1,4,2,1]/10,inf)
	\legato, 2,
	\xdur, 1 * Pseq([Pser([1],7),1.1,1],inf),
	\amp, 0.1,
	\dur, 1/4 * Pseq([1,1/2],inf),

)).play;
)
