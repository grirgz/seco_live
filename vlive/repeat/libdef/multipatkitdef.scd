FileSystemProject.load("libdef/buttonselector.scd");
(

WindowDef(\multipatkitdef_menu, { arg def, gridlist;
	var gridstack = StackLayout.new;
	var selectmenu;
	var scroller;
	if( gridlist.isNil ) {
		gridlist = List.new;
		PatKitDef.all.do { arg x;
			gridlist.add(x) // take only values
		}
	};
	selectmenu = PopUpMenu.new.items_(gridlist.collect(_.key)).action_({ arg view;
		gridstack.index = view.value;
	});
	gridlist.do { arg grid;
		gridstack.add(WindowDef(\samplekit).asView(grid));
	};
	//scroller = ScrollView.new.canvas_(View.new.layout_( VLayout(
	//	selectmenu,
	//	gridstack
	//).margins_(0).spacing_(0)));
	scroller = ScrollView.new.canvas_(View.new.layout_(  gridstack));
	scroller.hasBorder = false;
	VLayout (
		selectmenu,
		scroller
	);
});

WindowDef(\multipatkitdef, { arg def, gridlist;
	var gridstack = StackLayout.new;
	var selectmenu;
	var scroller;
	var selector = ProtoDef(\ButtonSelector).new({ arg sel, idx;
		gridstack.index = idx;
	});
	if( gridlist.isNil ) {
		gridlist = List.new;
		// TODO: use class method
		PatKitDef.all.do { arg x;
			gridlist.add(x)
		}
	};
	selectmenu = HLayout(
		*gridlist.collect({ arg grid;
			selector.makeButton.string_(grid.key)
		})
		++ [nil]
	);
	gridlist.do { arg grid;
		gridstack.add(WindowDef(\samplekit).asView(grid));
		def.waitIfNeeded;
	};
	//scroller = ScrollView.new.canvas_(View.new.layout_( VLayout(
	//	selectmenu,
	//	gridstack
	//).margins_(0).spacing_(0)));
	scroller = ScrollView.new.canvas_(View.new.layout_(  gridstack));
	scroller.hasBorder = false;
	VLayout (
		selectmenu,
		scroller
	);
});
)

// END
PatKitDef.all
PatKitDef.all.choose.keys

WindowDef(\multigrid).front
WindowDef(\multipatkitdef).front

BufDef('/home/ggz/Musique/sc/reckit/loop/loop2.flac')
BufDef.all['/home/ggz/Musique/sc/reckit/loop/loop2.flac'] = nil
BufDef.clear('/home/ggz/Musique/sc/reckit/loop/loop2.flac')
