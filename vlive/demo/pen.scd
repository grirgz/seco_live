
(
WindowDef(\distri, {
	var uv = UserView.new;
	uv.drawFunc = {
		Pen.addRect(Rect(0,0,~size,50));
		Pen.fill;
	};
	VLayout(
		Knob.new.action_({ arg vi;
			~size = vi.value.linlin(0,1,1,300);
			uv.refresh;
		}),
		uv
	)
}).front;
)
