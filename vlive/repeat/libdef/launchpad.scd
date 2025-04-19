(

ProtoDef(\launchpad_playergrid, (
	new: { arg self, grid;
		self = ProtoClass((parent:self));
		
		self.grid = grid;
		self.flash_colors = self.colors.collect({ arg x; x - 0x0c });
		//~lazy_property.(self, \quickpad, { { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 ) });
		//self.clearAll;
		if(self.ktl.device.notNil) {
			self.ktl.sendSpecialMessage(\enableFlashMode);
		};
	
		self;
	},

	clearAll: { arg self;
		self.ktl.sendSpecialMessage(\clearAll);
		self.ktl.sendSpecialMessage(\enableFlashMode);
	},

	quickpad: { arg self;
		var name = \quickpad;
		self['property_'+++name] ?? {
			self['property_'+++name] = { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 );
			self['property_'+++name]
		}
	},

	quickpad_: { arg self, val;
		var name = \quickpad;
		self['property_'+++name] = val
	},

	colors: (
			red: 0x0f,
			red2: 0x0e,
			dimred: 0x0d,
			green: 0x3c,
			green2: 0x2c,
			dimgreen: 0x1c,
			yellow: 0x3e,
			orange: 0x2f,
			amber: 0x3f,
			off: 4, // set both buffers to black
	),

	gridsize: Point(8,8),

	gridOffset_: { arg self, val;
		self.grid.gridOffset = val;
		self.render_grid;
	},

	gridOffset: { arg self;
		self.grid.gridOffset;
	},

	ktl: { 
		MKtl(\lp, "novation-launchpad-s");
	},

	padAt: { arg self, pos;
		//pos.debug("padAt");
		self.ktl.elAt(\pad, pos.x+( pos.y*self.gridsize.x ));
	},

	setColorAt: { arg self, pos, color, mode;
		//[pos, color].debug("setColorAt");
		if(mode == \flash) {
			color = color - 0x0c;
		};
		self.padAt(pos).elAt(\on).value = color/127;
	},

	render_cell: { arg self, pos, isPlaying, mode;
		// playerWrapper to pad
		var color;
		var child = self.grid.childAtOffset(pos);
		if(child.isEmpty == true) {
			color = \off
		} {
			//[isPlaying, child.isPlaying].debug("render_cell: is, chiisp");
			isPlaying = isPlaying ?? { child.isPlaying };
			if(isPlaying) {
				color = \green;
			} {
				if(child.isActive) {
					color = \red;
				} {
					color = \yellow;
				}
			};
		};
		color = self.colors[color];
		self.setColorAt(pos, color, mode);
	},

	render_linebutton: { arg self, idx;
		var clip = self.grid.linePlayerAt(idx);
		if(clip.isPlaying) {
			self.ktl.elAt(\arr, idx).value = self.colors.green;
		} {
			self.ktl.elAt(\arr, idx).value = self.colors.off;
		};
	},

	render_grid: { arg self;
		self.gridsize.x.do { arg x;
			self.gridsize.y.do { arg y;
				var pos = Point(x, y);
				self.render_cell(pos);
				self.listenAt(pos);
			}
		};
		self.gridsize.y.do { arg x;
			self.render_linebutton(x)
		};
		self.makeListeners;
	},

	controllers: { arg self;
		var k = self.ktl.getHalo(\controllers);
		if(k.isNil) {
			k = { nil ! ( self.gridsize.y + 1 )} ! ( self.gridsize.x + 1 );
			self.ktl.addHalo(\controllers, k)
		};
		k
	},

	controllers_dict: { arg self;
		var k = self.ktl.getHalo(\controllers_dict);
		if(k.isNil) {
			k = IdentityDictionary.new;
			self.ktl.addHalo(\controllers_dict, k)
		};
		k
	},

	listenAt: { arg self, pos;
		var player = PlayerWrapper(self.grid.childAtOffset(pos));
		if(self.controllers[pos.x][pos.y].notNil) {
			self.controllers[pos.x][pos.y].remove;
		};
		self.controllers[pos.x][pos.y] = player.makeListener({ arg me, msg, args;
			//{
			//[msg, args].debug("listenat!!");
				self.render_cell(pos, msg == \play, \flash);
				player.doWithQuant {
					self.render_cell(pos);
				};
			//}.defer(1)
		});
	},

	makeListeners: { arg self;
		if(self.controllers_dict[\gridOffset].notNil) {
			self.controllers_dict[\gridOffset].remove;
		};
		self.controllers_dict[\gridOffset] = SimpleController(self.grid).put(\gridOffset, {
			self.render_grid;
		});
	},

	activate: { arg self;
		var move_in_grid;
		if(FileSystemProject.current.isNil) {
			FileSystemProject.current = ();
		};
		FileSystemProject.current.current_trackgrid = { self.grid };
		self.ktl.elAt(\bt, \bt_user2).action = { arg el;
			self.edit_mode = ( el.value != 0 );
			self.edit_mode.debug("edit mode!");
		};
		self.ktl.elAt(\bt, \bt_mixer).action = { arg el;
			self.modifier_mixer = ( el.value != 0 );
			self.modifier_mixer.debug("mixer mode!");
		};
		self.ktl.elAt(\pad).do { arg pad, idx;
			pad.elAt(\on).action = {
				var point = Point(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger);
				if(self.edit_mode == true) {
					{
						self.grid.childAtOffset(point).edit;
					}.defer;
				} {
					if(self.modifier_mixer == true) {
						//point.debug("what ?");
						//self.quickpad[point.x][point.y].debug("2what ?");
						self.quickpad[point.x][point.y].value(self, point);
						//self.quickpad[point.x][point.y].debug("end what ?");
					} {
						PlayerWrapper(self.grid.childAtOffset(point)).togglePlay;
					};
				}
			};
			pad.elAt(\off).action = {
				//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			};
		};
		self.ktl.elAt(\arr).do { arg pad, idx;
			pad.action = {
				PlayerWrapper(self.grid.linePlayerAt(idx + self.gridOffset.y)).togglePlay;
			};
			//pad.action = {
			//	//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			//};
		};

		// debug
		//self.ktl.elAt(\bt, 0).action = { self.render_grid; "refresh!!!!".debug };
		move_in_grid = { arg el, offset;
			//el.value.debug("drole!!");
			if(el.value == 0) {

			} {
				self.gridOffset = self.gridOffset + offset;
			}
		};
		self.ktl.elAt(\bt, 0).action = { arg el; move_in_grid.(el, Point(0,-1)) };
		self.ktl.elAt(\bt, 1).action = { arg el; move_in_grid.(el, Point(0,1)) };
		self.ktl.elAt(\bt, 2).action = { arg el; move_in_grid.(el, Point(-1,0)) };
		self.ktl.elAt(\bt, 3).action = { arg el; move_in_grid.(el, Point(1,0)) };

		//self.clearAll;
		self.render_grid;
	},
));

ProtoDef(\lauchpad_offsetgrid, (
	parent: ProtoDef(\launchpad_playergrid),
	render_cell: { arg self, pos, isPlaying, mode;
		// playerWrapper to pad
		var color;
		var offsetpos = pos*8;
		var child = self.grid.childAtOffset(offsetpos);
		if(child.isEmpty == true) {
			color = \off
		} {
			//[isPlaying, child.isPlaying].debug("render_cell: is, chiisp");
			isPlaying = isPlaying ?? { child.isPlaying };
			if(isPlaying) {
				color = \green;
			} {
				if(child.isActive) {
					color = \red;
				} {
					color = \yellow;
				}
			};
		};
		color = self.colors[color];
		self.setColorAt(pos, color, mode);
	},
	activate: { arg self;
		var move_in_grid;
		if(FileSystemProject.current.isNil) {
			FileSystemProject.current = ();
		};
		FileSystemProject.current.current_trackgrid = { self.grid };
		self.ktl.elAt(\bt, \bt_user2).action = { arg el;
			self.edit_mode = ( el.value != 0 );
			self.edit_mode.debug("edit mode!");
		};
		self.ktl.elAt(\bt, \bt_mixer).action = { arg el;
			self.modifier_mixer = ( el.value != 0 );
			self.modifier_mixer.debug("mixer mode!");
		};
		self.ktl.elAt(\pad).do { arg pad, idx;
			pad.elAt(\on).action = {
				var point = Point(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger);
				if(self.edit_mode == true) {
					{
						self.grid.childAtOffset(point).edit;
					}.defer;
				} {
					if(self.modifier_mixer == true) {
						//point.debug("what ?");
						//self.quickpad[point.x][point.y].debug("2what ?");
						self.quickpad[point.x][point.y].value(self, point);
						//self.quickpad[point.x][point.y].debug("end what ?");
					} {
						self.gridOffset = Point(idx % 8, ( idx / 8 ).trunc);
					};
				}
			};
			pad.elAt(\off).action = {
				//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			};
		};
		self.ktl.elAt(\arr).do { arg pad, idx;
			pad.action = {
				PlayerWrapper(self.grid.linePlayerAt(idx + self.gridOffset.y)).togglePlay;
			};
			//pad.action = {
			//	//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			//};
		};

		// debug
		//self.ktl.elAt(\bt, 0).action = { self.render_grid; "refresh!!!!".debug };
		move_in_grid = { arg el, offset;
			//el.value.debug("drole!!");
			if(el.value == 0) {

			} {
				self.gridOffset = self.gridOffset + offset;
			}
		};
		self.ktl.elAt(\bt, 0).action = { arg el; move_in_grid.(el, Point(0,-1)) };
		self.ktl.elAt(\bt, 1).action = { arg el; move_in_grid.(el, Point(0,1)) };
		self.ktl.elAt(\bt, 2).action = { arg el; move_in_grid.(el, Point(-1,0)) };
		self.ktl.elAt(\bt, 3).action = { arg el; move_in_grid.(el, Point(1,0)) };

		//self.clearAll;
		self.render_grid;
	},

));

~launchpad_playergrid = ProtoDef(\launchpad_playergrid);
)
