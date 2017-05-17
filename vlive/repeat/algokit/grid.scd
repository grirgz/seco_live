
(
Log(\Param).level = \warning;
~generate_set = { arg pat, count=2;
	var gridcount = count;
	var supergrid = nil ! gridcount;
	///// generate kits
	~kits = gridcount.collect {
		var str = Pdef(\algo2_p3).asStream.nextN(10,());
		var kit = nil ! 8;
		str.collect({ arg ev;
			var tidx = ev[\trackIndex];
			kit[tidx] = ();
			[\kitIndex, \speed, \sustain].collect({ arg key;
				kit[tidx][key] = ev[key];
			})
		});
		kit;
	};
	"kits loaded, now building supergrid".debug;

	supergrid = ~kits.collect({ arg kit, kitnumber;
		8.collect({ arg rowidx;
			var el = XEventList.newFrom( Pfindur(16, Pdef(\algo2_p3)) );
			var tracks;
			"building grid % row %".format(kitnumber, rowidx).debug;
			tracks = 7.collect({ arg colidx;
				try {
					var evlist;
					evlist = el.copy.select({ arg ev;
						ev[\trackIndex] == colidx or: { [\start, \end].includes(ev[\type]) };
					});
					evlist = evlist .collect({ arg ev;
						ev = ev.copy;
						kit[colidx].keys.do { arg kitparamkey;
							ev[kitparamkey] = kit[colidx][kitparamkey];
						};
						ev;
					});
					XEventList.newFrom( evlist );
				} {
					XEventList.new;
				}
			})
		})
	
	});
	"DONE".postln;
	supergrid;
};

~generate_monogrid = { arg set;
	///////////// generate grid
	var playergrid;
	var catplayergrid;
	playergrid = set.collect({ arg grid, grididx;
		grid.collect({ arg col, colidx;
			col.collect({ arg row, rowidx;
				var key = "algogrid_%_%_%".format(grididx, colidx, rowidx).asSymbol;
				key.postln;
				KitTimeline(key).clear;
				KitTimeline(key, PatKitDef(\algokit)).eventList = row;
				Pdef(key, KitTimeline(key).asPattern)
			})
		}).flop
	});
	catplayergrid = nil ! 8;
	playergrid.do { arg grid, grididx;
		7.do { arg colidx;
			catplayergrid[colidx] = catplayergrid[colidx].addAll( grid[colidx] )
		};
	};
	catplayergrid;
};

~sort_cells_by_rest = { arg set;
	set.do({ arg grid, grididx;
		grid.do({ arg col, colidx;
			col.sort({ arg a, b;
				a.size > b.size
			});
		});
	});

};

~sort_rows_by_rest = { arg set;
	set.do({ arg grid, grididx;
		grid.flop.sort({ arg a, b;
			a.collect({ arg x; x.size }).sum > a.collect({ arg x; x.size }).sum;
		})
	});

};


);

// END

