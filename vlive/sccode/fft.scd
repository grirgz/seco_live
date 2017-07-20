// Set 'x' to the input waveform
(
var stream = Pstutter(64, Pseq([1, -1], inf))/*.drop(16)*/.asStream;
x = Signal.fill(128, stream);
x.plot;
)

// Then run this whole block
(
var factor = 8,
waitTime = 0.3,
scale = 0.3,

sigSize = x.size * factor,
sig,
intermediateSig = nil, interp = 0,
w = Window("inverse Fourier", Rect(400, 200, 800, 600)).front,
m, uv, r, fftSize, halfSize;
var indexRange, indexLNum, indexRNum, runButton, stepButton,
rangeSpec,
rangeFunc = { |view| [rangeSpec.map(view.lo).asInteger, rangeSpec.map(view.hi).asInteger] };

var allCosines;

y = x.fft(Signal.newClear(x.size), Signal.fftCosTable(x.size));
y = y.asPolar;

fftSize = y.rho.size;
halfSize = fftSize div: 2;
rangeSpec = [0, halfSize, \lin, 1, 0].asSpec;

allCosines = Array.fill(fftSize div: 2 + 1, { |j|
	var mag = y.rho[j], phase = y.theta[j],
	magScale = mag / fftSize, phaseScale = 2pi * j / sigSize;
	if(j > 0 and: { j < (fftSize div: 2) } ) { magScale = magScale * 2 };
	Signal.fill(sigSize, { |i|
		cos((i * phaseScale) + phase) * magScale;
	});
});

sig = allCosines[0];

w.layout = VLayout(
	uv = UserView(),
	View().maxHeight_(60).layout_(
		VLayout(
			HLayout(
				indexLNum = NumberBox().fixedWidth_(80), // .fixedSize_(Size(80, 20)),
				indexRNum = NumberBox().fixedWidth_(80), // .fixedSize_(Size(80, 20)),
				indexRange = RangeSlider().orientation_(\horizontal)
			).margins_(2),
			// indexView = LayoutValueSlider(initValue: 0, spec: [0, fftSize div: 2, \lin, 1, 0]),
			HLayout(
				nil,
				runButton = Button().fixedWidth_(80),
				stepButton = Button().fixedWidth_(80),
				nil
			).margins_(2)
		).margins_(2)
	)
);  // display all

runButton.states_([["stopped"], ["running", Color.black, Color(0.7, 1, 0.7)]])
.action_({ |view|
	if(view.value > 0) {
		// indexView.enabled = false;
		[indexRange, indexLNum, indexRNum].do(_.enabled = false);
		r.play;
	} {
		// indexView.enabled = true;
		[indexRange, indexLNum, indexRNum].do(_.enabled = true);
		r.stop;
	};
});

stepButton.states_([["step"]])
.action_({ |view|
	var lo, hi;
	#lo, hi = rangeFunc.(indexRange);
	if(hi < (fftSize div: 2)) {
		hi = hi + 1;
		// j = indexView.hi.asInteger;
		if(y.rho[hi] < 0.0001) {
			sig = allCosines[lo .. hi].sum;
			indexRange.hi = rangeSpec.unmap(hi);
			indexRNum.value = hi;
			uv.refresh;
		} {
			{
				indexRange.hi = rangeSpec.unmap(hi);
				indexRNum.value = hi;
				[indexRange, indexLNum, indexRNum].do(_.enabled = false);
				// indexRange.enabled = false;
				view.enabled = false;
				intermediateSig = allCosines[hi];
				forBy(0.0, 1.0, 0.01, { |frac|
					interp = frac;
					uv.refresh;
					if(frac == 0.0) { 0.5.wait } { 0.02.wait };
				});
				intermediateSig = nil;
				sig = allCosines[lo .. hi].sum;
				uv.refresh;
				view.enabled_(true).focus(true);
				[indexRange, indexLNum, indexRNum].do(_.enabled = true);
				// indexView.enabled = true;
			}.fork(AppClock);
		};
	};
});

indexRange.action_({ |view|
	var lo, hi;
	#lo, hi = rangeFunc.(view);
	sig = allCosines[lo .. hi].sum;
	uv.refresh;
	indexLNum.value = lo;
	indexRNum.value = hi;
}).setSpan(0, 0);

indexLNum.action = { |view|
	var v = view.value;
	if(v.inclusivelyBetween(0, indexRNum.value)) {
		indexRange.activeLo_(rangeSpec.unmap(v));
	};
};

indexRNum.action = { |view|
	var v = view.value;
	if(v.inclusivelyBetween(indexLNum.value, halfSize)) {
		indexRange.activeHi_(rangeSpec.unmap(v));
	};
};


uv.drawFunc = { |view|
	var bounds = view.bounds,
	height = bounds.height, width = bounds.width,
	scaleY = height * (0.5 - scale), scaleX;
	Pen.color_(Color.gray(0.7))
	.moveTo(Point(0, scaleY)).lineTo(Point(width, scaleY))
	.moveTo(Point(0, height - scaleY)).lineTo(Point(width, height - scaleY))
	.moveTo(Point(0, height * 0.5)).lineTo(Point(width, height * 0.5))
	.stroke;
	if(factor > 1) {
		scaleX = width / x.size;
		x.size.do { |i|
			i = i * scaleX;
			Pen.moveTo(Point(i, scaleY)).lineTo(Point(i, scaleY - 6))
			.moveTo(Point(i, height - scaleY)).lineTo(Point(i, height - scaleY + 6))
			.moveTo(Point(i, height * 0.5 - 4)).lineTo(Point(i, height * 0.5 + 4))
			.stroke;
		};
	};
	Pen.color_(Color.white);
	scaleX = width / sigSize;
	sig.do { |y, i|
		if(intermediateSig.notNil) {
			y = y + (intermediateSig[i] * interp);
		};
		y = height * (0.5 - (y * scale));
		i = i * scaleX;
		if(i == 0) { Pen.moveTo(Point(i, y)) } { Pen.lineTo(Point(i, y)) };
	};
	Pen.stroke;
	if(intermediateSig.notNil) {
		Pen.color_(Color.gray(0.7));
		intermediateSig.do { |y, i|
			y = blend(y, sig[i] + y, interp);
			y = height * (0.5 - (y * scale));
			i = i * scaleX;
			if(i == 0) { Pen.moveTo(Point(i, y)) } { Pen.lineTo(Point(i, y)) };
		};
		Pen.stroke;
	};
};
uv.refresh;

r = Task({
	var halfSize = y.rho.size div: 2, lo, hi;
	#lo, hi = rangeFunc.(indexRange);
	while { hi < halfSize } {
		hi = hi + 1;
		indexRange.hi = rangeSpec.unmap(hi);
		indexRNum.value = hi;
		sig = allCosines[lo .. hi].sum;
		uv.refresh;
		waitTime.wait;
	};
	runButton.value = 0;
}, AppClock);

w.onClose = { r.stop };
)
