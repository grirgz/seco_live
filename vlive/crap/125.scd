
(
WindowDef(\gui, {
	var k = Knob.new;
	k.mode = \vert;
	k.mouseDownAction_({});
	k.mouseUpAction_({});
	k.keyDownAction_({});
	k.keyUpAction_({});
	k.defaultKeyDownAction_({});
}).front
)
