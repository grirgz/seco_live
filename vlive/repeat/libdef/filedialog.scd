
(
WindowDef(\filedialog, { arg def, path, callback;
	var panes;
	var size = 4;
	var cwds = ""!size;
	var layout;
	var option_auto_apply = Ref(true); // not implemented yet
	var supported_extensions = [
		"wav",
		"flac",
	];
	var playfile = { arg curpathname;
		if(curpathname.isFile and: { supported_extensions.includesEqual(curpathname.extension.debug("e")) }) {
			SoundFile(curpathname.fullPath).play;
		}
	};
	layout = VLayout (
		Button.new.states_([
			["Auto apply", Color.yellow],
			["Auto apply", Color.red],
		]).mapParam(Param(Message(option_auto_apply), \value, XBoolSpec())),
		HLayout (*
			panes = size.collect({
				ListView.new;
			})
		);
	);

	panes[0].items = [path, "/", "~", "~/Musique/sc/samplekit/com"].select(_.notNil);
	size.do { arg idx;
		var curpath, curpathname;
		panes[idx].selectionAction = { arg view;
			if(idx==0) {
				curpath = view.items[view.value];
			} {
				curpath = cwds[idx] +/+ view.items[view.value];
			};
			curpathname = PathName(curpath);
			playfile.(curpathname);
			panes[idx+1].items = curpathname.entries.collect({ arg path;
				if(path.isFolder) {
					path.folderName ++ "/"
				} {
					path.fileName
				}
			});

			cwds[idx+1] = curpath;
		};
		panes[idx].keyDownAction_({ arg view, key, modifiers, unicode, keycode;
			[view, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
			if(key == $ ) {
				playfile.(curpathname);
			};
			if(key == 27.asAscii) {
				def.window.close;
			};
			if(key == $\r) {
				callback.(curpathname.fullPath);
				def.window.close;
			}
		});
	};
	layout;

});
)

// END

WindowDef(\filedialog).front("./", { arg def, view, path; def.window.close; path.debug("choosen path") });
