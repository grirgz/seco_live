
// two species
(
ProtoTemplateDef(\protist, (
	new: { arg self, world;
		self = self.deepCopy;
	
		self.world = world;
		self.position = Point(world.gridSize.x.rand, world.gridSize.y.rand);
		self.age = 0;
		self.energy = 50;
		self.note = rrand(20,90);
		self.player = EventPatternProxy.new;
		self.player.quant = 0;
		self.name = rrand(1,10000);
		self.kind = [0,1].choose;
		self.traits = (
			weight: rrand(1,100),
			childFood: rrand(1,100),
		);
		//self.color = if(self.kind.debug("spe") == 0) { Color.green } { Color.red };
		self.refreshColor;
		self.mutationRate = 0.10;
		self.initPlayer;
	
		self;
	},

	refreshColor: { arg self;
		self.color = Gradient(Color(1,0,0), Color(0,1,0)).at(self.traits.weight/100 ).clip(0,1);
		
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
			\instrument, if(self.kind == 0) { \star } { \basicbass },
			\lpf, 5000,
			\midinote, self.note,
			\sustain, rrand(0.1,0.3),
			\amp, 0.1/2,
			\dur, rrand(1.3,12),
		);
		
	},

	label: { arg self;
		"%: pos=%, weigth=%".format(self.name, self.position, self.traits.weight);
	},

	kill: { arg self;
		[self.name, self.energy].debug("death");
		self.player.stop;
		self.player.source = nil;
		self.world.population = self.world.population.reject({ arg x; x === self });
	},

	eat: { arg self, food;
		self.world.food = self.world.food.reject(_ == food);
		self.energy = self.energy + food.quantity;
		if(self.energy > 40) {
			self.reproduce;
		};
	},

	move: { arg self;
		self.position = self.position + Point([-1,0,1].choose, [-1,0,1].choose);
		self.position = Point(self.position.x.clip(0,self.world.gridSize.x-1), self.position.y.clip(0,self.world.gridSize.y-1));
		self.age = self.age + 1;
		self.energy = self.energy - (0 + (self.traits.weight/100));
		if(self.age > 1000 or: { self.energy <= 0 }) {
			self.kill;
		}
	},

	reproduce: { arg self;
		var child;
		if(self.age < 20) {
			[self.name, self.age].debug("can't reproduce, too young");
		} {
			if(self.energy > ( self.traits.childFood + 10 )) {
				child = ProtoTemplateDef(\protist).new(self.world);
				self.name.debug("reproduce");
				child.position = self.position;
				child.note = self.note + [-1,1].choose;
				//child.traits.weight = ( self.traits.weight * gauss(1.0, 0.5) ).clip(0,100);
				child.traits.weight = ( self.traits.weight + gauss(0.0, 10) ).clip(0,100);
				child.traits.childFood = ( self.traits.childFood + gauss(0.0, 10) ).clip(0,100);
				self.refreshColor;
				child.initPlayer;
				child.name.debug("new protist");
				self.world.population = self.world.population.add(child);
				self.energy = self.energy - self.traits.childFood;
				child.energy = self.traits.childFood;
				child.cry;
			} {
				[self.name, self.energy].debug("can't reproduce, not enough energy");
				// self.kill; // why should it die T_T
			}
		};
		
	},

));


ProtoDef(\cellgrid, (
	gridSize: 50@50,
	init: { arg self;
		self.genpop;
		self.logDict = IdentityDictionary.new;

	},
	genpop: { arg self;
		self.population.do { arg indiv;
			indiv.kill;
		};
		self.population = 100.collect  {
			ProtoTemplateDef(\protist).new(self);
		};
		self.food = [

		];
	},

	logData: { arg self, key, val;
		if(self.logDict.isNil) { self.logDict = IdentityDictionary.new };
		self.logDict[key] = self.logDict[key].add(val);
	},

	run: { arg self;
		self.task = self.task ?? { TaskProxy.new };
		self.population.do({ arg indiv;
			indiv.cry;
		});
		self.task.source = {
			"==start world".debug;
			10000.do  {
				var protistDict; 
				var foodDict;
				var allEntities;
				"-- world tic: %".format(self.population.size).debug;
				self.changed(\tic);
				protistDict = Dictionary.new;
				foodDict = Dictionary.new;
				allEntities = Dictionary.new;
				//self.kdtree = KDTree
				self.food = self.food.add( (
					position: Point( self.gridSize.x.rand, self.gridSize.y.rand ),
					quantity: rrand(5,50),
					kingdom: \food,
				) );
				self.population.do { arg indiv;
					indiv.move;
					protistDict[ indiv.position ] = protistDict[ indiv.position ].add( indiv );
			   		allEntities[indiv.position] = allEntities[indiv.position].add(indiv);
				};
				self.logData(\popsize, self.population.size);
				self.logData(\foodsize, self.food.size);
				self.logData(\avgWeight, self.population.collect({arg x;x.traits.weight}).mean);
				self.logData(\avgEnergy, self.population.collect({arg x;x.energy}).mean);
				self.logData(\childFood, self.population.collect({arg x;x.traits.childFood}).mean);
				self.food.do { arg piece;
			   		allEntities[piece.position] = allEntities[piece.position].add(piece);
					foodDict[piece.position] = foodDict[piece.position].add(piece);
				};
				protistDict.keys.do { arg key;
					var protistpop = protistDict[key];
					var foodpop = foodDict[key];
					var biggest;
					//protistpop.collect(_.label).debug("pop");
					biggest = protistpop.reduce({ arg a, b; 
						if(a.traits.weight > b.traits.weight) {
							a
						} {
							b
						}
					});
					[protistpop.collect({ arg x; x.traits.weight }), biggest.traits.weight].debug("biggest");
					if(foodpop.notNil) {
						biggest.eat(foodpop.sortBy(\quantity).first);
					};
					if(protistpop.size > 1) {
						var ennemies = protistpop.reject({ arg x; x == biggest});
						biggest.energy = biggest.energy + ennemies.collect(_.energy).sum;
						ennemies.do(_.kill);
					};
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
ProtoDef(\cellgrid).logDict
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
			var rectpos = Rect(indiv.position.x * zoom + (zoom/1.2)+ (zoom.rand/5), indiv.position.y * zoom + (zoom/1.2)+ (zoom.rand/5), zoom/2, zoom/2 );
			Pen.color = indiv.color;
			Pen.fillOval(rectpos );
			Pen.color = Color.blue;
			Pen.strokeOval( rectpos);
		};

		grid.food.do { arg indiv;
			var rectpos = Rect(indiv.position.x * zoom + (zoom/1.2)+ (zoom.rand/5), indiv.position.y * zoom + (zoom/1.2)+ (zoom.rand/5), zoom/3, zoom/3 );
			Pen.color = Color.new(11/255,200/255,11/255);
			Pen.fillOval(rectpos );
			Pen.color = Color.blue;
			Pen.strokeOval( rectpos);
		};

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
		HLayout (
			uv,
			VLayout (
				//* [\popsize, \foodsize, \avgWeight].collect({ arg key;)}
				* [\popsize, \foodsize,\avgWeight, \avgEnergy, \childFood].collect({ arg key;
					VLayout (
						StaticText.new.string_(key),
						WindowDef(\plotLogData).asView(grid, key)
					)
				}) ++ [nil]
			)
		)
	)

}).front(ProtoDef(\cellgrid));
)

(
WindowDef(\plotLogData, { arg def, world, key;
	var plot;
	//z = CompositeView(nil, nilRect(10, 35, 490, 400)).background_(Color.rand(0.7)).resize_(5);
	var view;
	view = View.new.minSize_(400@150);
	plot = Plotter("plot", parent:view);
	plot.setProperties(\labelX, "khjjkjk iiii");
	view.followChange(world, \tic, {
		if(world.logDict.notNil) {
			defer{
				plot.value_(world.logDict[key] ?? { [0] })
			}
		};
		//plot.refresh;
	});

	view;


}).front(ProtoDef(\cellgrid), \size)
)
