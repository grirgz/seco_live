(
s.waitForBoot{
	var synth, srcs, snds, path, win, bnds, view, vIn, scope, h, w, v, iW, oW, btns, f, snd, flt, fltSel, fltTxts;
	
	fltSel = Bus.control(s,1);
	
	synth = {
		arg which, frq, mul;
		var in, src, rq;
		in = Saw.ar(200,0.3!2);
		srcs = [
			Decay.ar(
				Impulse.ar(LFGauss.kr(5, 0.5).range(2, 7)),
				0.1,
				in*MouseButton.kr(0, 1, 0.001)
			),
			WhiteNoise.ar(0.08!2),
			PinkNoise.ar(0.08!2),
			BrownNoise.ar(0.08!2),
			GrayNoise.ar(0.08!2),
			ClipNoise.ar(0.08!2),
			Impulse.ar(10!2),
			Dust.ar(10!2),
			Dust2.ar(10!2),
			Crackle.ar(1.5, 0.08!2)
		];
		src = Select.ar(which, srcs);
		
		rq = MouseY.kr(0.01, 10, 1);
		
		snds = [
			src,
			LPF.ar(src, frq),
			LPF.ar(LPF.ar(src, frq), frq),
			HPF.ar(src, frq),
			BRF.ar(src, frq, rq),
			BPF.ar(src, frq, rq),
			Resonz.ar(src, frq, rq),
			Resonz.ar(
				Resonz.ar(src, frq, rq),
				frq,
				rq
			),
			BBandPass.ar(src, frq, rq),
			RLPF.ar(src, frq, rq),
			RHPF.ar(src, frq, rq)
		];
		
		flt = Out.kr(fltSel, MouseX.kr(0, snds.size));
		
		Select.ar(In.kr(fltSel), snds) * mul
	};
	
	snd = synth.play(args:[frq:1000, mul:0, which:0]);
	
	bnds = Window.screenBounds;
	h = bnds.height;
	w = bnds.width;
	win = Window("control", Rect(0, 0, w, h)).fullScreen;
	win.onClose_{ snd.free };
	iW = w/srcs.size;
	oW = w/snds.size;
	
	StaticText(win, Rect(10, 10, 500, 30))
	.align_(\topLeft)
	.font_(Font("Arial", 24))
	.string_("Input Signal (Source) Seleciton");
	
	btns = srcs.size.collect {
		|i|
		var x, inputs, outputs;
		inputs = [
			"decay",
			"whiteNoise",
			"pinkNoise",
			"brownNoise",
			"grayNoise",
			"clipNoise",
			"impulse",
			"dust",
			"dust2",
			"crackle"
		][i];
		Button(win, Rect(iW * i, 50, iW, 30))
		.states_([
			[inputs, Color.grey, Color.white],
			[inputs, Color.white, Color.grey]
		])
		.action_{ arg butt;
			if(butt.value == 1) {
				snd.set(\which, i);
				btns.size.do{|n|
					[n, i];
					if (n != i) { btns[n].value = 0 }
				}
			}
		}
		.value_(if(i==0) { 1 })
	};
	
	StaticText(win, Rect(10, 95, 2000, 60))
	.align_(\topLeft)
	.font_(Font("Arial", 24))
	.string_("Output Signal (Filtered Sound) Selection: press a mouse button and navigate the columns.
From the 5th to 11th column, the vertical position is related to Q-factor.");
	
	view = UserView(win, Rect(0, 160, w, h-430));
	
	vIn = true;
	
	view
	.mouseDownAction_{ |view, x, y, modifiers, buttonNumber, clickCount|
		if(buttonNumber==0 && (clickCount==1)) { snd.set(\mul, 1) }
	}
	.mouseUpAction_{ |view, x, y, modifiers, buttonNumber, clickCount|
		if(buttonNumber==0) { snd.set(\mul, 0) }
	}
	.mouseLeaveAction_{ |view, x, y|
		snd.set(\mul, 0)
	}
	.mouseMoveAction_{ | view, x, y |
		if (view.bounds.containsPoint(x@(y + 160))) {
			vIn = true;
			snd.set(\mul, 1)
		} {
			if (vIn) {
				vIn = false;
				view.mouseLeaveAction.()
		} }
	}
	.animate_(true);
	
	fltTxts = snds.size.collect{
		|i|
		var outputs;
		outputs = [
			"S\nR\nC",
			"S\nR\nC\n↓\nL\nP\nF",
			"S\nR\nC\n↓\nL\nP\nF\n↓\nL\nP\nF",
			"S\nR\nC\n↓\nH\nP\nF",
			"S\nR\nC\n↓\nB\nR\nF",
			"S\nR\nC\n↓\nB\nP\nF",
			"S\nR\nC\n↓\nR\nE\nS\nO\nN\nZ",
			"S\nR\nC\n↓\nR\nE\nS\nO\nN\nZ\n↓\nR\nE\nS\nO\nN\nZ",
			"S\nR\nC\n↓\nB\nB\nA\nN\nD\nP\nA\nS\nS",
			"S\nR\nC\n↓\nR\nL\nP\nF",
			"S\nR\nC\n↓\nR\nH\nP\nF"
		][i];
		StaticText(view, Rect(oW * (i + 0.1), 10, 200, 500))
		.align_(\topLeft)
		.font_(Font("Arial", 24))
		.string_(outputs)
	};
	
	view.drawFunc = {
		snds.do {
			|which, i|
			Pen.strokeColor = Color.black;
			Pen.moveTo(0@0);
			Pen.lineTo(0@h);
			Pen.translate(oW, 0);
			Pen.stroke;
			
			fltTxts[i].stringColor_(
				if(fltSel.getSynchronous.asInteger==i) {
					Color.black
				}{
					Color.gray
				}
			)
		}
	};
	
	ServerMeterView.new(s, win, 10@(h-235), 0, 2);
	
	scope = UserView(win, Rect(90, h-257, 247, 247));
	Stethoscope(s, view:scope);
	
	FreqScopeView(win, Rect(350, h-255, w-360, 245))
	.active_(true)
	.freqMode_(1);
	
	win.front
}
)
