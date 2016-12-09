
(

WindowDef(\mixergui, { arg def, grid;

	var stage_delay = 1;
	var add_delay = { arg mixer;
		mixer.proxy.put(mixer.stages.postfx+stage_delay, \filter -> { arg in, postdelay=0;
			DelayC.ar(in, 0.1, postdelay);
		})
	};
	var has_delay = { arg mixer;
		mixer.stages = mixer.stages ? (
			postfx: 2000

		);
		mixer.proxy.objects[mixer.stages.postfx+stage_delay].notNil
	};



	HLayout (*
		8.collect({ arg x;
			var boxview = View.new;
			var delayview;
			var mixer = grid.childAt(x).mixer;
			var mixerview;
			var button;
			button = BasicButton.new.string_("postdelay:").action_({ arg me;
				add_delay.(mixer);
				me.background = Color.gray;
			}); 
			if(has_delay.(mixer)) {
				button.background = Color.gray;
			};
			delayview = TextField.new;
			delayview.mapParam( Param(mixer.proxy, \postdelay, ControlSpec(0,0.1,\lin)) );
			boxview.layout = VLayout (
				StaticText.new.string_(mixer.key),
				mixerview = WindowDef(\mixerView).asView(grid.childAt(x)),
				HLayout(
					button,
					delayview
				),
			);
			boxview.background = Color.gray;
			mixerview.slider.minWidth_(10);
			boxview;
		})
	).spacing_(2)

});
WindowDef(\mixergui).front(TrackDef(\sco4));
)
