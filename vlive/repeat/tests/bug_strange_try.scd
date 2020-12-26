
(
// OK
	{
		var window = Window.new;
		var layout;
		var spec = ControlSpec(0,1,\lin);
		layout = VLayout(
			FixedEnvelopeView.new.totalDur_(spec.times[0])
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}.value
)

(
// ERROR strange
	WindowDef(\test, {
		var window = Window.new;
		var layout;
		var spec = ControlSpec(0,1,\lin);
		layout = VLayout(
			try {
				FixedEnvelopeView.new.totalDur_(spec.times[0])
			} { arg error;
				"errrro".postln;
				nil
			}
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}).front
)

(
// ERROR strange
	{
		var window = Window.new;
		var layout;
		var spec = ControlSpec(0,1,\lin);
		layout = VLayout(
			try {
				FixedEnvelopeView.new.totalDur_(spec.times[0])
			} { arg error;
				"errrro".postln;
				Button.new;
			}
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}.value
)

(
// ERROR strange
	{
		var window = Window.new;
		var layout;
		var spec = ControlSpec(0,1,\lin);
		layout = VLayout(
			try {
				EnvelopeView.new.step_(spec.times[0])
			} { arg error;
				"errrro".postln;
				nil
			}
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}.value
)

(
// OK
	{
		var window = Window.new;
		var layout;
		var spec = ControlSpec(0,1,\lin);
		layout = VLayout(
			try {
				nil.abcdef;
				EnvelopeView.new;
			} { arg error;
				"errrro".postln;
				nil
			}
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}.value
)

(
// OK
	{
		var window = Window.new;
		var layout;
		var spec = ControlSpec(0,1,\lin);
		layout = VLayout(
			try {
				var x = spec.times[0];
				EnvelopeView.new.step_(x);
			} { arg error;
				"errrro".postln;
				nil
			}
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}.value
)

(
// ERROR strange
	{
		var window = Window.new;
		var layout;
		layout = VLayout(
			try {
				var tmp = Ref(nil.abcdef);
				//var y = nil.abcdef;
				Knob.new;
			} { arg error;
				"errrro".postln;
				Button.new;
			}
		);
		window.layout = layout;
		window.front;
	}.value
)

(
// OK
	{
		var window = Window.new;
		var layout;
			try {
				var x = Pn(nil.abcdef);
				//var y = nil.abcdef;
				Knob.new(window);
			} { arg error;
				"errrro".postln;
				Button.new(window);
			};
		window.front;
	}.value
)


(
// ERROR strange
	{
		var window = Window.new;
		var layout;
		layout = VLayout(
			Button.new,
			try {
				var tmp = Ref(nil.abcdef);
				//var y = nil.abcdef;
				Knob.new;
			} { arg error;
				"errrro".postln;
				Button.new;
			}
		);
		window.layout = layout;
		window.front;
	}.value
)

(
// OK
	{
		var window = Window.new;
		var layout;
		layout = VLayout(
			Button.new,
			try {
				var x = nil.abcdef;
				var y = Ref(x);
				Knob.new;
			} { arg error;
				"errrro".postln;
				Button.new;
			}
		);
		window.layout = layout;
		window.front;
	}.value
)


^^ The preceding error dump is for ERROR: Message 'new' not understood.
RECEIVER: a Button



ERROR: Primitive '_QWidget_SetLayout' failed.
Wrong type.
RECEIVER:
Instance of TopView {    (0x55d478f0aa68, gc=84, fmt=00, flg=00, set=06)
  instance variables [35]
    qObject : RawPointer 0x55d45dcd28a0
    finalizer : instance of Finalizer (0x55d478f0ae98, size=2, set=1)
    virtualSlots : instance of Array (0x55d478300fd8, size=1, set=2)
    wasRemoved : false
    font : nil
    resize : Integer 1
    alpha : Float 1.000000   00000000 3FF00000
    decorator : nil
    layout : nil
    userCanClose : true
    deleteOnClose : true
    action : nil
    mouseDownAction : nil
    mouseUpAction : nil
    mouseEnterAction : nil
    mouseLeaveAction : nil
    mouseMoveAction : nil
    mouseOverAction : nil
    mouseWheelAction : nil
    keyDownAction : nil
    keyUpAction : nil
    keyModifiersChangedAction : nil
    keyTyped : nil
    focusGainedAction : nil
    focusLostAction : nil
    dragLabel : nil
    beginDragAction : nil
    canReceiveDragHandler : nil
    receiveDragHandler : nil
    toFrontAction : nil
    endFrontAction : nil
    onClose : nil
    onResize : nil
    onMove : nil
    window : instance of Window (0x55d47658e188, size=5, set=3)
}
PATH: /home/ggz/code/sc/seco/vlive/repeat/tests/bug_strange_try.scd

CALL STACK:
        MethodError:reportError
                arg this = <instance of PrimitiveFailedError>
        Nil:handleError
                arg this = nil
                arg error = <instance of PrimitiveFailedError>
        Thread:handleError
                arg this = <instance of Thread>
                arg error = <instance of PrimitiveFailedError>
        Object:throw
                arg this = <instance of PrimitiveFailedError>
        Object:primitiveFailed
                arg this = <instance of TopView>
        View:layout_
                arg this = <instance of TopView>
                arg newLayout = <instance of Ref>
        Window:layout_
                arg this = <instance of Window>
                arg layout = <instance of Ref>
        < closed FunctionDef >
                var window = <instance of Window>
                var layout = <instance of Ref>
        Interpreter:interpretPrintCmdLine
                arg this = <instance of Interpreter>
                var res = nil
                var func = <instance of Function>
                var code = "(
// ERROR strange
        {
                var ..."
                var doc = <instance of Document>
                var ideClass = nil
        Process:interpretPrintCmdLine
                arg this = <instance of Main>
^^ The preceding error dump is for ERROR: Primitive '_QWidget_SetLayout' failed.
Wrong type.
RECEIVER: a TopView


