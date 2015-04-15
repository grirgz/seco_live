

(
Ndef(\ndef_env, { arg pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar( 
		EnvGen.ar( 
			\freqenv.kr(Env([150,550,250,1000],[0.1,0.8,0.3])), // here is the env argument with default envelope
			Impulse.kr(1/2),
			doneAction:0
		)
	);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

~p = Param(Ndef(\ndef_env), \freqenv, XEnvSpec(\freq!4, ControlSpec(0,2,\lin,0,0.1)));

(
w = Window.new;
~env = EnvScaleView.new;
w.layout = HLayout(~env.view);
~envScaleView_mapParam.(~env, ~p);
w.front;
)

(
~envScaleView_mapParam = { arg view, param;
	param.makeSimpleController(view, 
		action:{
			param.set(view.env);
		},
		updateAction: {
			view.env = param.get
		}
	)
};
~envScaleView_unmapParam = { arg view;
	Param.unmapView(view)
}
)
