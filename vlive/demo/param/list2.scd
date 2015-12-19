// TODO: find the views for stepevent
// what about buttons like add parameter to stepevent, ways to hide/show, etc

(
~list = StepList[1,0,1,1,0,0,0,1];

~bank = ParBankList[
	StepEvent.newFrom((
		legato: StepList.newFrom(0.5!8),
		isRest: StepList.newFrom(0.5!8),
	))
];

//~legato = 3.collect({ List.newFrom(0.5 ! 8) });
//
//~p = Param(~list, \list, \unipolar);
//
//~pg = ParamGroup(
//	~bank.collect({ arg x;
//		Param(x, \list, \unipolar) 
//	})
//);
//~pglegato = ParamGroup(
//	~legato.collect({ arg x;
//		Param(x, \list, ControlSpec(0.1,2,\lin)) 
//	})
//);

)
ParBankList.new[0]
~bank[0][\legato].edit
				StepListView.new(~bank[0][\legato]).view

(
WindowDef(\bla, {
	VLayout(
		* ~bank.collect({ arg se;
			VLayout(
			*se.values.collect({ arg val;
				StepListView.new(val.debug("val")).view
			})
				
			)
		})
	)
}).alwaysRecreate_(true).front;
)
