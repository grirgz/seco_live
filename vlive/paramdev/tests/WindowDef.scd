
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

/// WindowDef with prototype
(
WindowDef(\test, (
	buttonName: "hello",
	asView: { arg self, def, param1;
		BasicButton.new.string_(self.buttonName)
	},
));
)
WindowDef(\test).front;

(
// you can inherit a WindowDef prototype
// here asView is inherited, but button label will be different;
WindowDef(\test_child, (
	buttonName: "hello child",
	parent: WindowDef(\test).proto,
)).front;
)

/////////////////

(
Pdef(\help1, 
	Pbind(
		\instrument, \default,
	)
);
Pdef(\help2, 
	Pbind(
		\instrument, \saw,
	)
);
);

(
WindowDef(\doubleEditor, { arg def, pdefkey1, pdefkey2;
	ParamProto.init; // PdefEditor is in prototype lib
	HLayout (
		WindowDef(\PdefEditor).asView(Pdef(pdefkey1)),
		WindowDef(\PdefEditor).asView(Pdef(pdefkey2)),
	)
}).front(\help1, \help2);
);

///////////////// embedView

(
WindowDef(\closeButton, { arg def, name="close";
	BasicButton.new.string_(name).action_({
		def.closeWindow; // this only work if def.window is defined
	});
});

WindowDef(\help, { arg def;
	VLayout (
		WindowDef(\closeButton).asView("close (will fail)"),
		WindowDef(\closeButton).embedView(def, "close (will work)"),
		nil,
	)
}).front;
);

/////////////////// followChange

(
Pdef(\model, Pbind(\instrument, \default));

WindowDef(\help, { arg def, pdef;
	var view = View.new;
	def.followChange(pdef, \source, { arg ...args;
		args.debug("change!");
		ParamProto.init; // PdefEditor is in prototype lib
		view.removeAll; // always remove before adding again
		view.layout = WindowDef(\PdefEditor).asView(pdef);
	}); 
	view;
}).frontTop(Pdef(\model));
);


Pdef(\model, Pbind(\instrument, \saw)); // when you load another Pbind in the Pdef, GUI will update
Pdef(\model, Pbind(\instrument, \default));
Pdef(\model).changed(\source); // send changed signal manually

WindowDef(\help).simpleControllerDict; // internally, it is SimpleController
WindowDef(\help).freeAllSimpleControllers; // free them all if something goes wrong

///////////////////

(
WindowDef(\help, { arg def;
	def.windowDo { arg win;
		{

			win.name = "hello"; // change window title
		}.defer(1)
	};
	Button.new;
}).front;
);


wait



