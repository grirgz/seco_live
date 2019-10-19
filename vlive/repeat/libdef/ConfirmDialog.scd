// TODO: add escape key shortcut

WindowDef(\ConfirmDialog, { arg me, question, savefun, cancelfun;
	me.windowName = "Confirm: " ++ question;
	VLayout (
		StaticText.new.string_(question),
		HLayout(
			nil,
			BasicButton.new.string_("Yes").action_({ 
				savefun.();
				me.closeWindow;
			}),
			BasicButton.new.string_("Cancel").action_({
				cancelfun.();
				me.closeWindow;
			}),
		)
	)
});

WindowDef(\RenameDialog, { arg me, question, defaultValue="", savefun, cancelfun;
	var textfield;
	me.windowName = question;
	VLayout (
		StaticText.new.string_(question),
		textfield = TextField.new.string_(defaultValue),
		HLayout(
			nil,
			BasicButton.new.string_("Yes").action_({ 
				savefun.(textfield.value);
				me.closeWindow;
			}),
			BasicButton.new.string_("Cancel").action_({
				cancelfun.(textfield.value);
				me.closeWindow;
			}),
		)
	)
});

// END

WindowDef(\ConfirmDialog).front("this will destroy everything, are you shure????")
