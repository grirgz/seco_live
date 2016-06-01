a=View(nil, 150@150).front;
[String].collect { arg x;
        DragSource(a).object_(x).background_(Color.rand)
};
b=View(nil, 150@150).front
.canReceiveDragHandler_{"yes:!".postln; true}

TestMove(nil).front
TestDown(nil).front


b=4.collect{Pbind(\degree, Pwhite(0,5), \dur, Pwhite(1,10) ).asStream};
~iter = Poly(
	*b
).iter;

~iter.next
~iter.nextN(3)
~iter

.nextN(20)

~iter = Poly(
	*b
).iter.nextN(3);

Pseq


(
b=4.collect{Pbind(\degree, Pwhite(0,5), \dur, Pwhite(1,10) ).asStream};
c=r{
        arg inval=();
        var min, copy;
        var a=(degrees: List[], deltas:List[]);
        b.collect({|x| x.next(inval) }).do({|x|
			a.degrees.add(x.degree) ;
			a.deltas.add(x.dur);
		});
		a.debug("1:A");
        loop{
                min=a.deltas.minItem;
                //a.deltas.collectInPlace{arg x, i;
                //        x=x-min; if(x==0)
                //        {
                //                var niouEv;
                //                niouEv=b[i].next(inval);
                //                a.degrees[i]=niouEv.degree;
                //                niouEv.dur
                //        }
                //        {x}
                //};
				//4.do { arg i;
				//	var dur = a.deltas[i] - min;
				//	if(dur == 0) {
				//		var newev = b[i].next(());
				//		a.deltas[i] = newev.dur;
				//		a.degrees[i] = newev.degree;
				//	} {
				//		dur
				//	}
				//};
				4.do { arg i;
					var newev = b[i].next(());
					a.deltas[i] = newev.dur;
					a.degrees[i] = newev.degree;
					a.debug("end a");
				};
				
                (degree:a.degrees, dur:min).debug("yield").yield // consider the + 0
        }
}

)

c.next(nil)
c.nextN(4)
Array.fill(4, { c.next })




{ c.next } ! 4
c.next
RoutinIe
Object

(
	c=r{
		loop  {
			(a:20.rand).yield;
		}
	}
)
c.next
c.nextN(4)





(
b=4.collect{Pbind(\degree, Pwhite(0,5), \dur, Pwhite(1,10) ).asStream};
c=r{
        arg inval=();
        var min, copy;
        var a=(degrees: [], deltas:[]);
        b.collect({|x| x.next(inval) })
        .do({|x|
                a.degrees=a.degrees.add(x.degree) ;
                a.deltas=a.deltas.add(x.dur) });
        loop{
                min=a.deltas.minItem;
                a.deltas.collectInPlace{arg x, i;
                        x=x-min; if(x==0)
                        {
                                var niouEv;
                                niouEv=b[i].next(inval);
                                a.degrees[i]=niouEv.degree;
                                niouEv.dur
                        }
                        {x}
                };
                (degree:a.degrees, dur:min).yield // consider the + 0
        }
}

)


c.next
~list = List.new;

(
4.do { 
	~list.add( c.next );
	~list.debug("list");
}
)


~list[0].degree.dump;
~list[1].degree.dump;
