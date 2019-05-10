FileSystemProject.load("libdef/apc.scd");
(
ProtoDef(\patkitdef_apc, (
	activate: { arg self, patkitdef;
		var grid = ProtoClass(().putAll(ProtoTemplateDef(\playergrid)));
		patkitdef.children.do { arg node, idx;
			var px, py;
			if(idx % 32 < 16) {
				px = idx % 4;
				py = ( idx/4 ).asInteger;
			} {
				px = idx % 4 + 4;
				py = ( idx/4 ).asInteger -4;
			};
			grid.childAt(px,py).source = node;
			grid.childAt(px,py).edit = { arg self; 
				patkitdef.edit(idx)
			};
			grid.childAt(px,py).playMode = { arg self; self.source.playMode };
		};
		self.grid = grid;
		ProtoDef(\apc40).activate(grid);
	},

));
)

// END
FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/track_rdnpreset.scd");
FileSystemProject.load("libdef/apc.scd");

ProtoDef(\patkitdef_apc).activate(PatKitDef(\bla))
ProtoDef(\patkitdef_apc).grid.edit
ProtoDef(\apc40).activate(ProtoDef(\patkitdef_apc).grid)
ProtoDef(\apc40).grid.edit
ProtoDef(\apc40).grid.childAt(1,0).isEmpty
ProtoDef(\apc40).grid.childAt(0,0).isEmpty
ProtoDef(\apc40).grid.childAt(0,1).play
ProtoDef(\apc40).grid.childAt(1,0).playMode
PatKitDef(\bla).edit(2);
PatKitDef(\bla)[\edit].asCompileString;
PatKitDef(\bla).clear
PatKitDef(\bla3).edit;
PatKitDef(\bla2).keys
PatKitDef(\bla2).clear
PatKitDef(\bla2).edit

PatKitDef(\bla).presetCompileString.editorInsert
(
PatKitDef('bla').targets = [
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('fix3/kick1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('fix3/snare1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('fix4/snare3.flac'))),
];
);


// deprecated

ProtoDef(\patkitdef_apc, (
	parent: ProtoDef(\apc),

	new: { arg self, grid;
		self = self.deepCopy;
	
		self.grid = grid;
		//~lazy_property.(self, \quickpad, { { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 ) });
		//self.clearAll;
		//if(self.ktl.device.notNil) {
			//self.ktl.sendSpecialMessage(\enableFlashMode);
		//};
	
		self;
	},

	childAtOffset: { arg self, point;
		var px, py;
		point = point + self.offset;
		px = if(point.x > 3) {
			px = point.x % 4;
			py = py-4;
		};
		py = point.y;
		self.grid.childAt(px+( py*4 ))
	},

	offset: Point(0,0),
	offset_: nil,

	activate: { arg self;
		var move_in_grid;
		if(grid.notNil) {
			self.grid = grid;
		};
		if(FileSystemProject.current.isNil) {
			FileSystemProject.current = ();
		};
		FileSystemProject.current.current_trackgrid = { self.grid };
		//self.ktl.elAt(\bt, \bt_user2).action = { arg el;
			//self.edit_mode = ( el.value != 0 );
			//self.edit_mode.debug("edit mode!");
		//};
		//self.ktl.elAt(\bt, \bt_mixer).action = { arg el;
			//self.modifier_mixer = ( el.value != 0 );
			//self.modifier_mixer.debug("mixer mode!");
		//};

		self.ktl.sendSpecialMessage(\setLiveMode);


		self.ktl.elAt(\bt, \clip).do { arg row, rowidx;
			row.do { arg pad, colidx;

				pad.elAt(\on).action = {
					var point = Point(colidx, rowidx);
					if(node.playMode == \gate) {
						PlayerWrapper(node).play;
					} {
						PlayerWrapper(node).togglePlay;
					}
				};
				pad.elAt(\off).action = {
					var point = Point(colidx, rowidx);
					var node = self.childAtOffset(point);
					if(node.playMode == \gate) {
						PlayerWrapper(node).stop;
					} {
						// NOOP
					}
				};
			};
		};

		self.ktl.elAt(\bt, \flat, \shift, \on).action =  { arg me;
			"kjkjk".debug;
			self.shiftModifier = true;
		};
		self.ktl.elAt(\bt, \flat, \shift, \off).action = { arg me;
			"aaakjkjk".debug;
			self.shiftModifier = false;
		};

		self.ktl.elAt(\bt, \master, \on).action = { arg me;
			if(self.shiftModifier) {
				{
					self.grid.edit
				}.defer;
			}{
				~master.()
			};
			self.render_grid;
		};

		self.ktl.elAt(\bt, \stopAll, \on).action = { arg me;
			if(self.shiftModifier) {
				//{
				//ProtoDef(\simpleMixer).edit
				//}.defer;
			}{
				CmdPeriod.run;
			};
			self.render_grid;
		};

		// debug
		//self.ktl.elAt(\bt, 0).action = { self.render_grid; "refresh!!!!".debug };
		move_in_grid = { arg el, offset;
			el.value.debug("drole!!");
			if(el.value == 0) {

			} {
				self.gridOffset = self.gridOffset + offset;
			}
		};
		self.ktl.elAt(\bt, \bank, \up,\on).action = { arg el; move_in_grid.(el, Point(0,-1)) }; // down
		self.ktl.elAt(\bt, \bank, \down,\on).action = { arg el; move_in_grid.(el, Point(0,1)) }; // up
		self.ktl.elAt(\bt, \bank, \left,\on).action = { arg el; move_in_grid.(el, Point(-1,0)) }; // left
		self.ktl.elAt(\bt, \bank, \right,\on).action = { arg el; move_in_grid.(el, Point(1,0)) }; // right

		//self.clearAll;

		if(self.grid.notNil) {
			self.render_grid;
		}
		
	},

))
