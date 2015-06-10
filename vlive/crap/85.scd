(
var modulo=8;
all{

                : [x, y, z],

                x <- modulo,
                y <- modulo,
                z <- modulo

}
)


(
	~yep = {
		var window = Window.new;
		var layout;
		var ms = MultiSliderView.new;
		layout = HLayout(
			ms
		);
		~ms = ms;
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	};
	~yep.value;
)

~ms.value  = [1,2,3,4,5]
~ms.action = { arg ...args; args.debug("args") };
