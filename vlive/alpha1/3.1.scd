(
Pdef(~name +++ \pre, 
	
	Pmono(~name+++\trig,
	\freq, 120 * Pseq([0,1,-1,0].midiratio,inf).stutter(16),
	\freq, 120 * Pseq([1,1.0212,1.0478,0.871],inf).stutter(32),
	//\freq, 400/5 * Pwalk((0..12), Pseq([1,0,-1,2, 1,0,-1,-2],inf),Pseq([1],inf)).midiratio.stutter(8),
	\fmrange, Pseq([0.5,1,1.5,4, 5,9],inf),
	\fmfreq, Pseq([0.5,1,2, 4,7,8,9],inf),
	\fmfreq, 2,
	\fmrange, 2.01,
	\dur, 1/8,
	//\isustain, Pseq([
	//	Prand([
	//		Pseq([
	//			1.5,0, 0,1.82, 0,0,1.92,0,
	//			0.0,2, 0,0, 2,0,0.3,0,
	//		],8),
	//		Pseq([
	//			4.5,0, 0,0, 0,0,0,0,
	//			2.0,0, 0,1, 1,1,0.3,0,
	//			4.5,0, 0,0, 0,0,0,0,
	//			0.0,0, 2,0, 0,0,0,0,
	//			4.5,0, 0,0, 0,0,0,0,
	//			0.0,1, 0,0, 1,0,0,0,
	//		],1),
	//	],1),
	//],inf) * 1/4 * (1+Pseq([-0.5,0.3,0.5,0],inf)),
	\igate, (Pkey(\isustain) > 0).asInteger,
	\irelease, Pkey(\isustain) +0.01 + Pseq([0,0,0.7,0,0,0.3],inf) ,

	\irelease, 0.1,
	\iadsr, Pseq([
		Pfunc({ arg ev;
			[ Env.adsr(0.01,0.1,0.8,ev[\irelease]) ]
		}),
	],inf),
	//\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(2),
	//\lpf, Pkey(\freq) * Pseq([2,4,7,8, 9,1,4,8],inf).stutter(1),
	//\hpf, Pkey(\freq) / 4,
	\isRest, false,
)
<>
Pbind(
	//\isustain, Pseq( 
	//	8.collect { arg nn;
	//		Pfuncn({ arg ev; sin( ev[\xx] * nn * ev[\xxffac])+1/2 * ev[\xxmul] },1);
	//	}
	//,inf),
	\isustain, Pseq( 
		[1,cos(_+pi)+1/2,cos(_*2/3)+1/2,cos(_+pi)+1/2].collect {  arg fun;
			Pfuncn({ arg ev;
				fun.value(ev[\xx] * 2*pi) * ev[\xxmul]
			},1)
		}
	,inf),
	\isustain, Pseq(
		4.collect{ arg x;
			Pfuncn({ arg ev;
				[
					[1,0,1,0],
					[1,1,1,1],
					[1,0,0,0],
				].flop[x].blendAt(ev[\xx] * 2).debug("out") * ev[\xxmul]
			},1);
		}
	,inf)
	//\isustain, 0.04,
	
)
<>
	~dPdef.(~name+++\mac) 
	<> Pbind(
		\xx, 1,
		\xxffac, 1,
		\xxmul, 1/4,
	)


);
)

// END

[7,9,3].interpolateAt(0)
Pdef(~name+++\mac).setBusMode(\lpf);
Pdef(~name+++\mac).setBusMode(\hpf);
~set_macro.(\)



(
	~win.close;
	~win = Window.new;
	~control = Slider.new.action_({ arg v; ~fun.(v.value) });
	~sliders = 4.collect({
		Slider.new;
	});
	~layout = HLayout.new(*
		[~control] ++ ~sliders 
	);
	~win.layout = ~layout;
	~win.front;
	~win.alwaysOnTop = true;
)
(
	// 2 4 1
	~fun = { arg x;
		var tab;
		tab = [1,cos(x)+1/2,cos(x*2/3)+1/2,cos(x)+1/2];
		tab.do { arg v, n; ~sliders[n].value = v }
	
	};

)

100.collect({ arg x; x= x/100 * 2*pi; [1,cos(x+pi)+1/2,cos(x*2/3)+1/2,cos(x+pi)+1/2] }).flop.plot

(
	// sin
	~fun = { arg x;
		x = x*[1,2,3,4]*4;
		x = sin(x);
		x.do { arg v, n; ~sliders[n].value = v }
	
	};

)



r = (-100..100)/100; // for testing

x=0.6;
plot(((r*r)**(1/(1-x)))/r) // 0 should be handled separately.

plot(sign(r)*(abs(r)**(1/(1-x)))) // not quite as nice looking when x is small

x = 0.9979;
a = 1/x;
plot(log((a+r)/(a-r))/log((a+1)/(a-1))) // inverse tanh mapping 
