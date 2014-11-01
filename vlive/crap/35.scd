(

Server.default.waitForBoot({

	SynthDef(\SimpleHarmonicPing, { |out, freq, amp, sustain, pan|

		var snd = BLowPass4.ar(Saw.ar(freq), freq*Line.kr(2, 1, sustain/4), 1);

		snd = snd * EnvGen.ar(Env.perc(0.01, sustain), doneAction:2);

		OffsetOut.ar(out, Pan2.ar(snd, pan, amp))

	}).add;

});

~scale = Scale.chinese;

~octave = 4;

~sustain = 1.25;

~root = 0;

~mtranspose = 0;

~ctranspose = 0;

)



(

var n = 7*2;

var w = 1024, h = 600;

var win = Window("", Rect(100, 100, w, h)).front;

var uv = UserView(win, win.view.bounds);

var sinFunc = { |i, periode=2pi| sin((i/n)*periode) };

var lastValues = { 0 }.dup(n);

uv.background = Color.black;

uv.animate = true;

uv.frameRate = 120;

uv.drawFunc = { |uv|

	var values = Array.fill(n, { |i| sinFunc.((i-1) + (uv.frame/100), uv.frame.linexp(1,60*(60*12), pi, 24pi)) }); // for 2 min

	QPen.strokeColor = Color.white;

	QPen.line( Point(0, h/2), Point(w, h/2) );

	QPen.stroke;

	QPen.fillColor = Color.red;

	QPen.use{

		QPen.translate(w/n/2,0);

		values.do{ |value, i|

			var lastValue = lastValues[i];

			var center = Point( (i/n) * w,  (h/2) + (value * (h/3)));

			QPen.fillOval(Rect.aboutPoint( center, 3, 3 ));

			if( ((lastValue < 0) and: { value > 0 }) or: { (lastValue > 0) and: { value < 0 } } ) {

				QPen.strokeColor = Color.white;

				QPen.strokeOval(Rect.aboutPoint( center, 5, 5) );

				QPen.strokeOval(Rect.aboutPoint( center, 10, 10) );

				(

					scale: ~scale,

					instrument: \SimpleHarmonicPing,

					octave: ~octave,

					degree:i,

					amp:0.1,

					mtranspose: ~mtranspose,

					ctranspose: ~ctranspose,

					root: ~root,

					sustain: ~sustain,

					pan:i.linlin(0,n,-1, 1),

					detune:2.0.rand2,

				).play;

				"trig %".format(i).postln;

			};

		};

	};

	lastValues = values;

};

)






(
~particles = 5;
~rect = Array.fill(512, {arg i; rrand(-1.0, 1.0)});
~sig = Signal.sineFill(512, ~rect);
~buff = Buffer.sendCollection(s,~sig);

SynthDef(\fm, { arg freq = 60, l_shift = 0, lfo_rate = 0.5,fm_ratio = 3, fm_amount, dur = 2, fm_lfo;
	var snd, fm, env, lfo;
	lfo = LPF.ar(Wrap.ar(LFSaw.ar(lfo_rate, 1, 0.5, 0.5) + l_shift), 50);
	fm = SinOsc.ar(freq * fm_ratio, 0, SinOsc.ar(fm_lfo, 0, fm_amount));
	env = EnvGen.kr(Env.sine(dur, 0.1), doneAction: 2);
	snd = SinOsc.ar(freq + fm, 0, env)  * lfo;
	snd = RLPF.ar(BufRd.ar(1,~buff, LinLin.ar(snd, -1.0, 1.0, 0.0, BufFrames.kr(~buff))), 2000, 2.reciprocal) * 0.25;

	Out.ar(0, Pan2.ar(snd, 0));
}).add;
)

(
var seq = [66, 73, 85, 76, 66, 73, 87, 78, 66, 73, 85, 76, 66, 73, 87, 78, 59, 66, 82, 73, 59, 66, 83, 75, 59, 66, 82, 73, 59, 66, 83, 75, 66];
var count = 0;
~t = Task({
	seq.size.do({
		postln(count);
		for(0, ~particles, {arg i; Synth(\fm, [\freq, (seq[count] - 24).midicps * i, \lfo_rate, 0.5, \dur, 12, \l_shift, ~particles.reciprocal * i, \fm_ratio, [2,3,4,5,6].choose, \fm_lfo, rrand(0.5,3.0), \fm_amount, rrand(100,500)])});
		count = count + 1;
		4.wait;
	});
}).play;
)
