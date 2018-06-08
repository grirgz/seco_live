
/// self organization

KDTree

(
	ProtoDef(\cell, (
		position: Point(0,0),
		freq: 523,
		delta: 50,
		timedelta: 5,
		space: { ~space },
		world: { ProtoDef(\world) },
		timepos: 0,
		agefreq: 1,
		clone: { arg self; self.deepCopy },
		squeak: { arg self;
			"im % at %, doing %".format(self.id, self.timepos, self.freq).debug;
			Pbind(
				\instrument, \default,
				\freq, self.freq,
				\dur, Pn(1/8,1),
				\amp, 0.1,
			).play;
		},
		makeChild: { arg self;
			var child = self.clone;
			child.agefreq = rrand(0.2,2);
			child;
		},

		live: { arg self;
			var changed = false;
			self.world.book.values.do { arg other;
				if(other === self) {

				} {

					var tpos = other.timepos;
					var fr = other.freq;
					if( ( fr - self.freq ).abs < self.delta) {
						self.freq = self.freq + (self.delta * [-1,1].choose * rrand(1/1.3,4.0));
						self.freq = self.freq.fold(50,19900);
						//self.freq.debug("freq is now");
						changed = true;
					};

					if( ( tpos - self.timepos ).abs < self.timedelta) {
						self.timepos = self.timepos + (self.timedelta.rand);
						self.timepos = self.timepos.fold(0,128);
						//self.freq.debug("freq is now");
						changed = true;
					};

				}

			};
			if(changed) {
				"now at %,%".format(self.position, self.freq).debug;
			};
			self.squeak;
			
		},
		play: { arg self;
			//var fr = self.space.nearest(self.position.asArray);
			if(self.task.notNil) {
				self.task.stop;
			};
			self.task = Task({
				200.do { arg age;
					(1/self.agefreq).wait;
					self.age = age;
					self.live;
				};
				"die %,%".format(self.position, self.freq).debug;

			});
			self.task.play;

		},
	));

	ProtoDef(\world, (
		worldsize: Point(100,100),

		make_world: { arg self;
			var inhabitants;
			self.book = IdentityDictionary.new;
			inhabitants = 20.collect({ arg idx;
				var cell = ProtoDef(\cell).makeChild;
				cell.position = self.worldsize.rand;
				cell.id = idx;
				self.book[cell.id] = cell;
				cell.init;
				//cell.squeak;
				[cell.position.x, cell.position.y, cell.id]
			});
			~space = KDTree(inhabitants, lastIsLabel:true);
		},
		live: { arg self;
			~space.asArray(incLabels:true).do  { arg node;
				var cell;
				//node.debug("node");
				cell = self.book[node[2]];
				//cell.debug("cell");
				cell.live;
			}
		},

		play: { arg self;
			self.book.values.do(_.play);
			//Tdef(\world, {
				//self.day = 0;
				//100.do {
					//self.day.debug("new day");
					//self.live;
					//1.wait;
					//self.day = self.day + 1;
				//}
			//}).play;
		},

	));
	ProtoDef(\world).make_world;
	ProtoDef(\world).play;
)
	ProtoDef(\world).book[0]
~space.asArray(true)
~inhabitants
 Point(100,100).rand
			(
			~inhabitants = 20.collect({ arg idx;
				var cell = ProtoDef(\cell).clone;
				cell.debug("cell");
				cell.position = Point(100,100).rand;
				cell.position.debug("po");
				cell.id = idx;
				cell.squeak;
				[cell.position.x, cell.position.y];
				[cell.position.x, cell.position.y, cell.id];

			});
			)
			~space = KDTree(~inhabitants);
			~inhabitants




(
	ProtoDef(\cell, (
		position: Point(0,0),
		freq: 523,
		delta: 50,
		timedelta: 5,
		space: { ~space },
		world: { ProtoDef(\world) },
		timepos: 0,
		agefreq: 1,
		clone: { arg self; self.deepCopy },
		squeak: { arg self;
			"im % at %, doing %".format(self.id, self.timepos, self.freq).debug;
			Pbind(
				\instrument, \default,
				\freq, self.freq,
				\dur, Pn(1/8,1),
				\amp, 0.1,
			).play;
		},
		makeChild: { arg self;
			var child = self.clone;
			child.agefreq = rrand(0.2,2);
			child.timepos = rrand(0,self.world.worlddur);
			child;
		},

		live: { arg self;
			var changed = false;
			self.world.book.values.do { arg other;
				if(other === self) {

				} {

					var tpos = other.timepos;
					var fr = other.freq;
					if( ( fr - self.freq ).abs < self.delta) {
						self.freq = self.freq + (self.delta * [-1,1].choose * rrand(1/1.3,4.0));
						self.freq = self.freq.fold(50,19900);
						//self.freq.debug("freq is now");
						changed = true;
					};

					if( ( tpos - self.timepos ).abs < self.timedelta) {
						self.timepos = self.timepos + (self.timedelta.rand + 2);
						self.timepos = self.timepos.wrap(0,self.world.worlddur);
						//self.freq.debug("freq is now");
						changed = true;
					};

				}

			};
			if(changed) {
				"now at %,%".format(self.position, self.freq).debug;
			};
			self.squeak;
			
		},
		play: { arg self;
			//var fr = self.space.nearest(self.position.asArray);
			if(self.task.notNil) {
				self.task.stop;
			};
			self.task = Task({
				200.do { arg age;
					(1/self.agefreq).wait;
					self.age = age;
					self.live;
				};
				"die %,%".format(self.position, self.freq).debug;

			});
			self.task.play;

		},
	));

	ProtoDef(\world, (
		worldsize: Point(100,100),
		worlddur: 16,
		inhabitants_count: 20,

		make_world: { arg self;
			var inhabitants;
			self.book = IdentityDictionary.new;
			inhabitants = self.inhabitants_count.collect({ arg idx;
				var cell = ProtoDef(\cell).makeChild;
				cell.position = self.worldsize.rand;
				cell.id = idx;
				self.book[cell.id] = cell;
				cell.init;
				//cell.squeak;
				[cell.position.x, cell.position.y, cell.id]
			});
			~space = KDTree(inhabitants, lastIsLabel:true);
		},
		live: { arg self;
			~space.asArray(incLabels:true).do  { arg node;
				var cell;
				//node.debug("node");
				cell = self.book[node[2]];
				//cell.debug("cell");
				cell.live;
			}
		},

		play: { arg self;
			//self.book.values.do(_.play);
			Tdef(\world, {
				self.day = 0;
				100.do {
					var score = nil!self.worlddur;
					self.book.values.do { arg cell;
						score.wrapPut(cell.timepos, score.wrapAt(cell.timepos).add(cell));
					};
					self.day.debug("==============new day");
					score.do { arg val, idx;
						var cell = score[idx];
						//idx.debug("idx");
						if (cell.notNil) {
							if(cell.isSequenceableCollection) {
								cell.do(_.live)
							} {
								cell.live;
							}
						};
						( 1/16 ).wait;
					};
						self.day = self.day + 1;
					//self.live;
					//1.wait;
				}
			}).play;
		},

	));
	ProtoDef(\world).make_world;
	ProtoDef(\world).play;
)
	ProtoDef(\world).book.values.first.live
