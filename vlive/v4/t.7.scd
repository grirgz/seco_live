
Pdef(~name +++ \pre, Pbind(
	\fmfreq, 500,
	\spread, 1,
	\fmtab, Prout{ arg ev;
		loop{
			var ar = [0,1,0,0, 0,0,0,0]+0.1;

			(8*4).do { 
					
				ar = ar.rotate(1);
				ar = ar * (1+0.5.rand);
				ar.debug("xxar");

				ev = ar.yield;
			}
		}
	},
	\cartab, Prout{ arg ev;
		loop{
			var ar = [0,0,0,0, 0,0,0,0]+0.1;

			(8*4).do { 
					
				var idx;
				ar = ar.rotate(1);
				idx = ar.size.rand;
				ar[idx] = 1.0.rand;
				ar.debug("xxar2");
				4.do {
					ev = ar.yield;
				}
			}
		}
	},
));
