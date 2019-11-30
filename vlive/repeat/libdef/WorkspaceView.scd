
//ProtoDef(\WorkspaceView)
(
WindowDef(\WorkspaceView, { arg def;
	var view = View.new;
	var refresh;
	refresh = {
		"refresh".debug;
		view.removeAll;
		view.layout_(
			VLayout(*
				TagSpecDef('GlobalLibrary.type.Editable').list.collect({ arg typetag;
							typetag.key.debug("============");
					VLayout (*
						[ StaticText.new.string_(typetag.key) ] ++
						TagSpecDef(typetag.key).list.collect({ arg tag;
							var playbutton;
							tag.debug("mmm========");
							if(typetag.key == \PatKitDef) {
								playbutton = BasicButton.new.string_(tag.key);
							} {
								playbutton = try({PlayerWrapper(tag.value).asView}, { BasicButton.news.tring_(tag.key) });
							};
							HLayout (
								playbutton,
								BasicButton.new.string_("Edit").action_({
									tag.value.edit;
								})
							)

						})
					)
				})++[nil]
			)
		)
	};
	view.toFrontAction = {
		refresh.();
	};
	ScrollView.new.canvas_(view);

});
)
