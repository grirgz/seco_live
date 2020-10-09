

// evolve, two moving strategies, transfert food to child, fat means more food to move
// now seek food in local range


~t = 165/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\kickdrum, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1355].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2223].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		
	])
)).play;
);


(
ProtoTemplateDef(\protist, (
	new: { arg self, world;
		self = self.deepCopy;
	
		self.world = world;
		self.position = Point(world.gridSize.x.rand, world.gridSize.y.rand);
		self.generationNum = 1;
		self.age = 0;
		self.energy = 50;
		self.note = rrand(20,90);
		self.player = EventPatternProxy.new;
		self.player.quant = 1;
		self.name = rrand(1,10000);
		self.kind = [0,1].choose;
		self.traits = (
			weight: rrand(1,100),
			childFood: rrand(1,100),
			childFoodRemain: rrand(1,100),
			forwardRate: rrand(0,1.0),
			forwardTime: rrand(1,100),
			sightRange: 5,
		);
		//self.color = if(self.kind.debug("spe") == 0) { Color.green } { Color.red };
		self.refreshColor;
		self.mutationRate = 0.10;
		self.initPlayer;
	
		self;
	},

	refreshColor: { arg self;
		//self.color = Gradient(Color(1,0,0), Color(0,1,0)).at(self.traits.weight/100 ).clip(0,1);

		//[self.energy, ( self.energy/100 ).clip(0,1), Gradient(Color(1,0,0), Color(0,1,0)).at(( self.energy/100 ).clip(0,1) )  ].debug("compute color");
		self.color = Gradient(Color(1,0,0), Color(0,1,0)).at(( self.energy/100 ).clip(0,1) );
		
	},

	cry: { arg self;
		self.name.debug("wakeup");
		{
			//2.0.rand.wait;
			//self.name.debug("wakeup now");
			self.player.play;
		}.fork;
	},

	initPlayer: { arg self;
		var pat;
		pat = [
			{ Pbind(
				\instrument, if(self.kind == 0) { \star } { \basicbass },
				\lpf, 5000,
				\degree, self.note-40,
				\sustain, rrand(0.1,0.3),
				\amp, 0.1/4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				].scramble,inf).coin.not,
				\dur, 1/8,
			) },

			{ Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				].scramble,inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			)},
			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				].scramble,inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			)},
			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				].scramble,inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			)},
		].choose.value;
		self.player.source = pat;
		
	},

	label: { arg self;
		"%: pos=%, energy=%, weigth=%".format(self.name, self.position, self.energy, self.traits.weight);
	},

	kill: { arg self, msg;
		[self.label, msg].debug("death");
		self.player.stop;
		self.player.source = nil;
		self.world.population = self.world.population.reject({ arg x; x === self });
	},

	eat: { arg self, food;
		self.world.food = self.world.food.reject(_ == food);
		self.energy = self.energy + food.quantity;
		self.refreshColor;
		if(self.energy > 40) {
			self.reproduce;
		};
	},

	randDirection: { Point([-1,0,1].choose, [-1,0,1].choose); },

	move: { arg self;
		self.moveRoutine = self.moveRoutine ?? { Routine({
			var randDirection = { self.randDirection };
			var direction;
			inf.do  {
				var oldnearest;
				var nearest;
				if(self.age < 5) {
					// prevent child and parent to follow the exact same path: toddler walk randomly
					var dir = randDirection.();
					10.do { dir.yield; };
				};
				nearest = self.world.kdtreeFood.nearest(self.position.asArray);
				//var knearest = self.world.kdtree.kNearest(self.position.asArray,40);
				//nearest.debug("nearest");
				//knearest.debug("knearest");
				oldnearest = nearest;
				//nearest[0].label.debug("nearest lab");
				//[nearest, nearest[0].label].debug("nearest");
				if(nearest[1] == 0) {
					nearest = oldnearest[0].nearestToNode;
					[nearest, nearest[0].label].debug("nearest2");
				};
				if(nearest[0].label.kingdom != \food) {
					nearest = oldnearest[0].nearestToNode(nearest[0]);
					//nearest.debug("nearest3");
					[nearest, nearest[0].label].debug("nearest3");
				};
				if(nearest[1] < self.traits.sightRange) {
					var dir;
					dir = nearest[0].location.asPoint - self.position;
					//[nearest[0].location.asPoint, self.position, dir].debug("dir1");
					dir = Point(dir.x.clip(-1,1), dir.y.clip(-1,1));
					//dir.debug("dir");
					dir.yield;
				} {
					randDirection.().yield;
				};
			}
		})};
		self.position = self.position + self.moveRoutine.next;

		self.position = Point(self.position.x.wrap(0,self.world.gridSize.x-1), self.position.y.wrap(0,self.world.gridSize.y-1));

		self.age = self.age + 1;
		self.energy = self.energy - (self.world.frictionFactor + (self.traits.weight/100 * self.world.gravity));
		self.energy = self.energy - (0 + (self.traits.sightRange/100 * 50));
		self.refreshColor;
		if(self.age > 100000 or: { self.energy <= 0 }) {
			self.kill("starved to death");
		}
	},

	move_2strategies: { arg self;
		self.moveRoutine = self.moveRoutine ?? { Routine({
			var randDirection = { Point([-1,0,1].choose, [-1,0,1].choose); };
			var direction;
			inf.do  {
				if(self.traits.forwardRate.coin) {
					direction = randDirection.();
					max(self.traits.forwardTime.asInteger, 1).do {
						direction.yield;
					}
				} {
					max(self.traits.forwardTime.asInteger, 1).do {
						randDirection.().yield;
					}
				}
			}
		})};
		self.position = self.position + self.moveRoutine.next;

		self.position = Point(self.position.x.wrap(0,self.world.gridSize.x-1), self.position.y.wrap(0,self.world.gridSize.y-1));

		self.age = self.age + 1;
		self.energy = self.energy - (0 + (self.traits.weight/40));
		if(self.age > 100000 or: { self.energy <= 0 }) {
			self.kill("starved to death");
		}
	},

	reproduce: { arg self;
		var child;
		if(self.age < 20) {
			[self.name, self.age].debug("can't reproduce, too young");
		} {
			if(self.energy > ( self.traits.childFood + self.traits.childFoodRemain )) {
				child = ProtoTemplateDef(\protist).new(self.world);
				child.generationNum = self.generationNum + 1;
				self.name.debug("reproduce");
				child.position = self.position + self.randDirection;
				child.note = (self.note + [-1,1].choose).clip(20,90);
				//child.traits.weight = ( self.traits.weight * gauss(1.0, 0.5) ).clip(0,100);
				child.traits.weight = ( self.traits.weight + gauss(0.0, 10) ).clip(0,100);
				child.traits.childFood = ( self.traits.childFood + gauss(0.0, 10) ).clip(0,100);
				child.traits.childFoodRemain = ( self.traits.childFoodRemain + gauss(0.0, 10) ).clip(0,100);
				child.traits.forwardRate = ( self.traits.forwardRate + gauss(0.0, 0.1) ).clip(0,1);
				child.traits.forwardTime = ( self.traits.forwardTime + gauss(0.0, 3) ).clip(1,100);
				child.traits.sightRange = ( self.traits.forwardTime + gauss(0.0, 1) ).clip(1,100);
				child.initPlayer;
				child.parentName = self.name;
				child.label.debug("new protist");
				self.world.population = self.world.population.add(child);
				self.energy = self.energy - self.traits.childFood;
				self.refreshColor;
				child.energy = self.traits.childFood;
				child.cry;
			} {
				[self.name, self.energy].debug("can't reproduce, not enough energy");
				//self.kill;
			}
		};
		
	},

));


ProtoDef(\cellgrid, (
	gridSize: 50@50,
	initialFoodSize: 10,
	initialPopulationSize: 60,
	newFoodPerTurn: 4,
	gravity: 5,
	frictionFactor: 0,
	turnTime: 0.1,

	init: { arg self;
		self.genpop;
		self.logDict = IdentityDictionary.new;

	},
	genpop: { arg self;
		self.population.do { arg indiv;
			indiv.kill("init");
		};
		self.population = self.initialPopulationSize.collect  {
			ProtoTemplateDef(\protist).new(self);
		};
		self.food = [

		];
	},

	logData: { arg self, key, val;
		if(self.logDict.isNil) { self.logDict = IdentityDictionary.new };
		self.logDict[key] = self.logDict[key].add(val);
	},

	logsToDisplay: [\popsize, \foodsize, \avgEnergy,\avgWeight, \sightRange, \childFood, \childFoodRemain, \note, \generationNum],


	addFood: { arg self;
		var piece = (
			position: Point( self.gridSize.x.rand, self.gridSize.y.rand ),
			quantity: rrand(5,40),
			kingdom: \food,
		);
		self.food = self.food.add( piece );
	},

	run: { arg self;
		self.task = self.task ?? { TaskProxy.new };
		self.population.do({ arg indiv;
			indiv.cry;
		});
		self.task.source = {
			"==start world".debug;

			// initial food
			self.initialFoodSize.do {
				self.addFood;
			};

			10000.do  {
				var protistDict; 
				var foodDict;
				var allEntities;
				var kdcol;
				var entityDictToKDTree = { arg dict;
					var kdcol = dict.asPairs.clump(2).collect({ arg x; 
						x[1].collect({ arg ev;
							[x[0].x, x[0].y, ev] 
						});
					}).flatten;
					if(kdcol.size == 0) {
						kdcol = [[0,0,1215]]
					};
					KDTree.new( kdcol, lastIsLabel:true );
				};
				"-- world tic: %".format(self.population.size).debug;
				self.changed(\tic);

				//// init collections

				protistDict = Dictionary.new;
				foodDict = Dictionary.new;
				allEntities = Dictionary.new;
				self.newFoodPerTurn.do { self.addFood };
				self.population.do { arg indiv;
					protistDict[ indiv.position ] = protistDict[ indiv.position ].add( indiv );
			   		allEntities[indiv.position] = allEntities[indiv.position].add(indiv);
				};
				self.food.do { arg piece;
			   		allEntities[piece.position] = allEntities[piece.position].add(piece);
					foodDict[piece.position] = foodDict[piece.position].add(piece);
				};
				//allEntities.asPairs.clump(2).debug("col1");
				//kdcol.debug("kdcol");
				self.kdtree = entityDictToKDTree.(allEntities);
				self.kdtreeFood = entityDictToKDTree.(foodDict);

				////// move

				self.population.do { arg indiv;
					indiv.move;
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
					//[protistpop.collect({ arg x; x.traits.weight }), biggest.traits.weight].debug("biggest");
					if(foodpop.notNil) {
						biggest.eat(foodpop.sortBy(\quantity).first);
					};
					if(protistpop.size > 1) {
						var ennemies = protistpop.reject({ arg x; x == biggest}).reject({ arg x;
							// don't kill child or mother
							x.parentName == biggest.name or: { biggest.parentName == x.name }
						});
						biggest.label.debug("fight!!!");
						biggest.energy = biggest.energy + ennemies.collect(_.energy).sum;
						ennemies.do(_.kill("killed in fight by %".format(biggest.label)));
					};
				};

				//////// log

				self.logData(\popsize, self.population.size);
				self.logData(\foodsize, self.food.size);
				self.logData(\avgWeight, self.population.collect({arg x;x.traits.weight}).mean);
				self.logData(\avgEnergy, self.population.collect({arg x;x.energy}).mean);
				self.logData(\note, self.population.collect({arg x;x.note}).mean);
				self.logData(\generationNum, self.population.collect({arg x;x.generationNum}).mean);
				[\childFood, \childFoodRemain, \sightRange, \forwardRate, \forwardTime].do { arg key;
					self.logData(key, self.population.collect({arg x;x.traits[key]}).mean);
				};

				//////// population control: pandemy

				if(self.population.size > 250) {
					"===== pandemy!!!".debug;
					self.population.scramble.keep(150).do(_.kill)
				};

				if(Process.elapsedTime - TempoClock.default.seconds > 0.3) {
					[TempoClock.default.seconds - Process.elapsedTime, TempoClock.default.seconds, Process.elapsedTime].debug("late compensation system activated!");
					(Process.elapsedTime - TempoClock.default.seconds).wait;
				};
				
				self.turnTime.wait;
			}
		};
		self.task.reset.play;
	}
));

WindowDef(\cellgrid, { arg def, grid;
	
	var uv = UserView.new;
	var logView = View.new;
	var logScroller = ScrollView.new;
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
	logScroller.canvas = logView;
	logView.layout = VLayout (
		//* [\popsize, \foodsize, \avgWeight].collect({ arg key;)}
		* grid.logsToDisplay.collect({ arg key;
			VLayout (
				StaticText.new.string_(key),
				WindowDef(\plotLogData).asView(grid, key)
			)
		}) ++ [nil]
	);
	VLayout(
		//Knob.new.action_({ arg vi;
			//~size = vi.value.linlin(0,1,1,300);
			//uv.refresh;
		//}),
		HLayout (
			uv.minSize_(800@800),
			logScroller,
		)
	)

});

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


});


ProtoDef(\cellgrid).init;
ProtoDef(\cellgrid).run;
WindowDef(\cellgrid).front(ProtoDef(\cellgrid));
Pdef(\part).play;
)
ProtoDef(\cellgrid).population.size
ProtoDef(\cellgrid).population.collect(_.note)
ProtoDef(\cellgrid).clear
ProtoDef(\cellgrid).logDict
ProtoDef(\cellgrid).task.source.asCompileString

(
)

(
a = { (0..30).scramble }.dup(2).flop.plot;
a.superpose = true;
a.setProperties(
    \fontColor, Color.red,
    \plotColor, Color.blue,
    \backgroundColor, Color.black,
    \gridColorX, Color.white,
    \labelX, "Humidity"
);
a.refresh;
);

GUI.skin.at(\plot); // defaults


