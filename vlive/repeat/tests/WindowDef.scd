
//////////////////////////////
//////// test WindowDef proto


(
WindowDef(\test, (
	asView: { arg self, def, param1;
		BasicButton.new
	},
));
)
WindowDef(\test).front
WindowDef(\test2, WindowDef(\test)).front

(
WindowDef(\test_child, (
	parent: WindowDef(\test2).proto,
)).front;
)
