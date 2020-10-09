


(
ProtoTemplateDef(\protist, (
	new: { arg self, world;
		self = self.deepCopy;
	
		self.world = world;
		self.position = Point(world.gridSize.x.rand, world.gridSize.y.rand);
		self.age = 0;
		self.energy = 4;
		self.note = rrand(20,90);
		self.player = EventPatternProxy.new;
		self.player.quant = 0;
		self.name = rrand(1,10000);
		self.initPlayer;
	
		self;
	},

	cry: { arg self;
		self.name.debug("wakeup");
		{
			2.0.rand.wait;
			//self.name.debug("wakeup now");
			self.player.play;
		}.fork;
	},

	initPlayer: { arg self;
		self.player.source = Pbind(
			\midinote, self.note,
			\sustain, rrand(0.1,0.3),
			\dur, rrand(1.3,12),
		);
		
	},

	kill: { arg self;
		self.name.debug("death");
		self.player.stop;
		self.player.source = nil;
		self.world.population = self.world.population.reject({ arg x; x === self });
	},

	move: { arg self;

		self.position = self.position + Point([-1,0,1].choose, [-1,0,1].choose);
		self.position = Point(self.position.x.clip(0,self.world.gridSize.x-1), self.position.y.clip(0,self.world.gridSize.y-1));
		self.age = self.age + 1;
		if(self.age > 1000) {
			self.kill;
		}
	},

	reproduce: { arg self;
		var child;
		if(self.age < 20) {
			[self.name, self.age].debug("can't reproduce, too young");
		} {
			if(self.energy > 1) {
				child = ProtoTemplateDef(\protist).new(self.world);
				self.name.debug("reproduce");
				child.position = self.position;
				child.note = self.note + [-1,1].choose;
				child.initPlayer;
				child.name.debug("new protist");
				self.world.population = self.world.population.add(child);
				self.energy = self.energy - 1;
				child.cry;
			} {
				[self.name, self.energy].debug("can't reproduce, not enough energy");
				self.kill;
			}
		};
		
	},

));


ProtoDef(\cellgrid, (
	gridSize: 50@50,
	init: { arg self;
		self.genpop;

	},
	genpop: { arg self;
		self.population.do { arg indiv;
			indiv.kill;
		};
		self.population = 10.collect  {
			ProtoTemplateDef(\protist).new(self);
		};
	},

	run: { arg self;
		self.task = self.task ?? { TaskProxy.new };
		self.population.do({ arg indiv;
			indiv.cry;
		});
		self.task.source = {
			"==start world".debug;
			10000.do  {
				var poppos;
				"-- world tic: %".format(self.population.size).debug;
				self.changed(\tic);
				poppos = Dictionary.new;
				self.population.do { arg indiv;
					indiv.move;
					poppos[ indiv.position ] = poppos[ indiv.position ].add( indiv );
				};
				poppos.keys.do { arg key;
				   var localpop = poppos[key];
					if(localpop.size > 2) {
						localpop.do(_.kill);
					} {
						if(localpop.size > 1) {
							localpop.first.reproduce;
						}
					}
				};
				if(self.population.size > 250) {
					"===== pandemy!!!".debug;
					self.population.scramble.keep(150).do(_.kill)
				};
				0.1.wait;
			}
		};
		self.task.reset.play;
	}
));
ProtoDef(\cellgrid).init;
ProtoDef(\cellgrid).run;
WindowDef(\cellgrid).front(ProtoDef(\cellgrid));
)
ProtoDef(\cellgrid).population.size
ProtoDef(\cellgrid).clear
ProtoDef(\cellgrid).task.source.asCompileString
(
WindowDef(\cellgrid, { arg def, grid;
	
	var uv = UserView.new;
	uv.drawFunc = {
		var orig = Point(10,10);
		var zoom = 15;
		var delta = grid.gridSize * zoom;
		var deltax = Point(delta.x,0);
		var deltay = Point(0,delta.y);
		var pos;

		// draw grid

		Pen.color = Color.black;
		( grid.gridSize.x+1 ).do { arg x;
			pos = orig+Point((x*zoom),0);
			Pen.moveTo(pos);
			Pen.lineTo(pos+deltay);
			Pen.stroke;
		};
		( grid.gridSize.y+1 ).do { arg y;
			pos = orig+Point(0,(y*zoom));
			Pen.moveTo(pos);
			Pen.lineTo(pos+deltax);
			Pen.stroke;
		};
		Pen.stroke;

		// draw organisms

		grid.population.do { arg indiv;
			var rectpos = Rect(indiv.position.x * zoom + (zoom/2)+ (zoom.rand/5), indiv.position.y * zoom + (zoom/2)+ (zoom.rand/5), zoom/2, zoom/2 );
			Pen.color = Color.green;
			Pen.fillOval(rectpos );
			Pen.color = Color.blue;
			Pen.strokeOval( rectpos);
		}

	};
	uv.onChange(grid, \tic, {
		//"visual tic".debug;
		defer {
			uv.refresh;
		}
	});
	uv.background = Color.clear;
	VLayout(
		//Knob.new.action_({ arg vi;
			//~size = vi.value.linlin(0,1,1,300);
			//uv.refresh;
		//}),
		uv
	)

}).front(ProtoDef(\cellgrid));
)
