
(
ProtoTemplateDef('MainProject', (
	//parent: FileSystemProject.defaultParent,
	edit: { arg self;
		WindowDef(\MainProject).front(self);
	}
));
FileSystemProject('ex6', ProtoTemplateDef( \MainProject ))
)

(
WindowDef(\MainProject, { arg def, proj;
	HLayout (
		VLayout (
			HLayout (
				StaticText.new.string_("quant:"),
				Param(Message(proj), \defaultQuant).asTextField
			),
			HLayout (
				StaticText.new.string_("tempo:"),
				Param(Message(proj), \tempo).asTextField
			),
		),
		[VLayout (
			HLayout (
				StaticText.new.string_(FileSystemProject.unresolve(proj.key.asString)),
				BasicButton.new.string_("...").action_({
					WindowDef(\MainProjectOverlayMenu).front(proj)
				}).maxWidth_(30)
			),
			HLayout (
				BasicButton.new.string_("Timeline").action_({
					ClipTimeline(\mainTimeline).edit
				}),
				BasicButton.new.string_("Mixer").action_({
					ProtoDef(\simpleMixer).edit
				}),
				BasicButton.new.string_("TrackList"),
				BasicButton.new.string_("TrackGrid").action_({
					TrackDef(\mygrid, TrackTemplateDef(\playergrid)).edit
				}),
			)
		), stretch:2]
	)

}).front(FileSystemProject('ex6'));
)

TrackDef(\mygrid).clear
					TrackDef(\mygrid, TrackTemplateDef(\playergrid)).edit
					TrackDef(\mygrid).children
					TrackDef(\mygrid).childAtOffset(Point(0,0))
					TrackDef(\mygrid).childAt(0)
					TrackDef(\mygrid).childClass.new
					TrackTemplateDef(\playergrid).childClass

FileSystemProject.paths

ProtoDef(\simpleMixer).edit
ProtoDef(\playergrid).edit
TrackDef(\playergrid).edit

(
WindowDef(\MainProjectOverlayMenu, { arg def, model, view, x=600, y=600;
	var inview, layout;
	[x, y].debug("xy");
	def.windowDo { arg win;
		var ab = view !? {view.absoluteBounds} ? Rect(0,0,600,600);
		win.bounds = Rect(x+ab.origin.x, Window.screenBounds.height - ab.top - y, 200,100);
		win.endFrontAction = { win.close };
	};
	inview = View.new;


	layout = VLayout (
		BasicButton.new.string_("Scope").action_({
			s.scope
		}),
		BasicButton.new.string_("FreqScope").action_({
			s.freqscope
		}),
		BasicButton.new.string_("Nodes").action_({
			s.plotTree
		}),
		nil
	);
	//def.windowDo { arg win;
		//win.setInnerExtent(view.bounds.extent.min(20));
	//};
	inview.layout_(layout);
	
}).border_(false);
)
