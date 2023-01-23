
// neural network test



(
Window.closeAll;
s.waitForBoot{
	var synth, multislider, win, xyslider;
	var xydata = FluidDataSet(s);
	var paramsdata = FluidDataSet(s);
	var xybuf = Buffer.alloc(s,3);
	var paramsbuf = Buffer.alloc(s,3);
	var counter = 0;
	var predicting = false;

	var mlp = FluidMLPRegressor(s,
		[3],
		activation:FluidMLPRegressor.sigmoid,
		outputActivation:FluidMLPRegressor.sigmoid,
		maxIter: 1000,
		learnRate:0.1,
		batchSize:1,
		validation:0
	);

	win = Window("ChaosSynth", Rect(10, 10, 840, 320)).front;

	multislider = MultiSliderView(win,Rect(10, 10, 400, 300))
	.elasticMode_(1)
	.isFilled_(1)
	.action_({
		arg ms;
		paramsbuf.setn(0,ms.value);
	})
	.value_(0.5.dup(10));

	xyslider = Slider2D(win,Rect(420,10,300,300))
	.action_{
		arg view;
		xybuf.setn(0,[view.x,view.y]);

		if(predicting){
			mlp.predictPoint(xybuf,paramsbuf,{
				paramsbuf.getn(0,10,{
					arg prediction;
					defer{
						multislider.value_(prediction);
					}
				});
			});
		};
	};

	Button(win,Rect(730,10,100,20))
	.states_([["Add Points"]])
	.action_{
		var id = "point-%".format(counter);
		xydata.addPoint(id,xybuf);
		paramsdata.addPoint(id,paramsbuf);
		counter = counter + 1;

		xydata.print;
		paramsdata.print;
	};

	Button(win,Rect(730,40,100,20))
	.states_([["Save Data"]])
	.action_{
		FileDialog({
			arg folder;
			folder.postln;
			xydata.write(folder+/+"xydata.json");
			paramsdata.write(folder+/+"paramsdata.json");
		},{},2,0,true);
	};

	Button(win,Rect(730,70,100,20))
	.states_([["Load Data"]])
	.action_{
		FileDialog({
			arg folder;
			xydata.read(folder+/+"xydata.json");
			paramsdata.read(folder+/+"paramsdata.json");
		},fileMode:2,acceptMode:0,stripResult:true);
	};

	Button(win,Rect(730,100,100,20))
	.states_([["Train"]])
	.action_{
		mlp.fit(xydata,paramsdata,{
			arg loss;
			loss.postln;
		});
	};

	Button(win,Rect(730,130,100,20))
	.states_([["Save MLP"]])
	.action_{
		Dialog.savePanel({
			arg path;
			if(PathName(path).extension != "json"){
				path = "%.json".format(path);
			};
			mlp.write(path);
		});
	};

	Button(win,Rect(730,160,100,20))
	.states_([["Load MLP"]])
	.action_{
		Dialog.openPanel({
			arg path;
			mlp.read(path);
		});
	};

	Button(win,Rect(730,190,100,20))
	.states_([["Not Predicting"],["Predicting"]])
	.action_{
		arg but;
		predicting = but.value.asBoolean;
	};

	s.sync;

	synth = {
		arg freq=200, pan=0, amp=0.1;
		var val = FluidBufToKr.kr(paramsbuf);
		var osc1, osc2, feed1, feed2, base1=69, base2=69, base3 = 130, loud1, loud2;
		var sig;

		sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(1)) * \fma.kr(0.1) + 1 ));

		sig = Pan2.ar(sig, pan, amp);
		Out.ar(0,sig);
	}.play;
};
)

(
	SynthDef(\mlpfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, paramsbuf;
		var val = FluidBufToKr.kr(paramsbuf, numFrames:3);
		var osc1, osc2, feed1, feed2, base1=69, base2=69, base3 = 130, loud1, loud2;
		var sig;

		sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(1)) * \fma.kr(0.1) + 1 ));

		sig = Pan2.ar(sig, pan, amp);
		Out.ar(0,sig);
	}).add;
);

(
Pdef(\synth, 
	Pmono(
		\mlpfm,
		\degree, Pseq([0,2],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);


(
	ParamGroupDef(\synth, [
		Param(Pdef(\synth), \freq),
		Param(Pdef(\synth), \fmf),
		Param(Pdef(\synth), \fma),
	]);
	ParamGroupDef(\synth).collect { arg param, idx;
		param.setBusMode(true)
		
	};
);

(
ProtoDef(\mlp, ( 

	clearDataset: { arg self;
		self.indata.clear;
		self.outdata.clear;
		
	},
	edit: { arg self;
		WindowDef(\mlp).front;
	},
));
ProtoDef(\mlp).mlp = ProtoDef(\mlp).mlp ?? {
	FluidMLPRegressor(s,
		[3],
		activation:FluidMLPRegressor.sigmoid,
		outputActivation:FluidMLPRegressor.sigmoid,
		maxIter: 1000,
		learnRate:0.1,
		batchSize:1,
		validation:0
	);
};
ProtoDef(\mlp).indata = ProtoDef(\mlp).indata ?? { FluidDataSet(s) };
ProtoDef(\mlp).outdata = ProtoDef(\mlp).outdata ?? { FluidDataSet(s) };
);


(
Tdef(\timer, {
	var inbuf, outbuf, time;
	var model = ProtoDef(\mlp);
	var counter = 0;
	inbuf = BufDef(\timer, 3);
	outbuf = BufDef(\outbuf, 3);
	ProtoDef(\mlp).clearDataset;
	loop {
		time = TempoClock.beats % [2,8,16];
		inbuf.setn(0, time);
		time.debug("time");
		if(model.isLearning == true) {
			var id = "point-%".format(counter).asSymbol;
			var outvals;
			outvals = ParamGroupDef(\synth).valueList;
			outbuf.setn(0, outvals);
			model.indata.addPoint(id,inbuf);
			model.outdata.addPoint(id,outbuf);
			"added point %: % -> %".format(id, time, outvals).postln;
			counter = counter + 1;
		};
		if(model.isPredicting == true) {
			model.mlp.predictPoint(inbuf,outbuf,{
				paramsbuf.getn(0,10,{
					arg prediction;
					defer{
						multislider.value_(prediction);
					}
				});
			});
		};
		( 1/8 ).wait;
	}
});
//Tdef(\timer).play;
);

(
WindowDef(\mlp, { arg def;
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\synth)).asView,
			PlayerWrapper(Tdef(\timer)).asView,
		),
		ParamGroupDef(\synth).asView,
		Param(Message(ProtoDef(\mlp)), \isPredicting, ParamBoolSpec()).asButton,
		Param(Message(ProtoDef(\mlp)), \isLearning, ParamBoolSpec()).asButton,
		nil
	)
}).front;
);






Tdef(\timer).stop

TempoClock.beats % 1


ProtoDef(\mlp).mlp
ProtoDef(\mlp).clearDataset
