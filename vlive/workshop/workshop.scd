
(
        ~win = Window.new;

        ~bt1 = Button.new;

        ~bt1.states = [
            [ "start Synth1" ],
            [ "stop Synth1" ],
        ]; 

		~bt1.action = { arg but;
			if(but.value == 1) {
				Pdef(\a).play
				~synth1 = Synth(\default, [\freq, 200]);
			} {
				~synth1.release;
			}
		};

		~slider1 = Slider.new;

		~map1 = \freq.asSpec;
		~slider1.action = { arg sli;
			~synth1.set(\freq, ~map1.map(sli.value))
		};

        ~layout = VLayout.new;
        ~layout.add(~bt1);
		~layout.add(~slider1);
        ~win.view.layout = ~layout;
        ~win.front;
        
)

////////////////


(
        ~win = Window.new;

		~hlayout = HLayout.new;

		8.collect { arg x;
		
			var env;
			env = Environment.make {
				~layout = VLayout.new;
				~bt1 = Button.new;

				~bt1.states = [
					[ "start Synth"++x ],
					[ "stop Synth"++x ],
				]; 

				~bt1.action = { arg but;
					if(but.value == 1) {
						~synth1 = Synth(\default, [\freq, 200]);
					} {
						~synth1.release;
					}
				}.inEnvir;

				~slider1 = Slider.new;

				~map1 = \freq.asSpec;
				~slider1.action = { arg sli;
					~synth1.set(\freq, ~map1.map(sli.value))
				}.inEnvir;


				~layout.add(~bt1);
				~layout.add(~slider1);
			};
			~hlayout.add(env[\layout]);
		};

        ~win.view.layout = ~hlayout;
        ~win.front;
        
)
