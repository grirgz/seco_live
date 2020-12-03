
(
{
var window = Window.new;
var layout;
var slider = Slider.new.orientation_(\horizontal);
layout = VLayout(
	Button.new.action_({
	}),
	slider
);
~fun = {
		try {
			slider.makeError;
			slider.value = 1.0.rand;
		} { arg error;
			//error.reportError;
			"catched".postln;
			//error.throw;
		}

};
SimpleController.new(~fun).put(\change, {
	~fun.();
});
window.layout = layout;
//window.alwaysOnTop = true;
window.front;
}.value
)

~fun.()
~fun.changed(\change)


////////// this trigger

Builder(\mybuilder, { arg self, arg1; arg1.postln;  });
Builder(\mybuilder).set(\arg1, "hello2"); // print "hello", but only if arg1 change
Param(Builder(\mybuilder), \arg1).edit
String
"kjkj".contains("k")


WindowDef(\textentry, { Param(Builder(\mybuilder), \arg1, ParamNonFloatSpec()).asTextField }).front;
WindowDef(\textentry, { Param(Builder(\mybuilder), \arg1).asTextField }).front;
WindowDef(\textentry, { Param(Builder(\mybuilder), \arg1).asView }).front;
WindowDef(\textentry, { Param(Builder(\mybuilder), \arg1).asSlider }).front;
Param(Builder(\mybuilder), \arg1, ParamNonFloatSpec()).spec

1
(
{
var window = Window.new;
var layout;
layout = VLayout(
	Param(Builder(\mybuilder), \arg1).asSlider
	
);
window.layout = layout;
//window.alwaysOnTop = true;
window.front;
}.value
)





Param(Pdef(\help), \adsr, ParamEnvSpec.adsr).get.asCompileString
Param(Pdef(\help), \adsr, ParamEnvSpec.adsr).normGet.asCompileString
Param(Pdef(\help), \adsr, ParamEnvSpec.adsr).spec.times[0].unmap(2)
