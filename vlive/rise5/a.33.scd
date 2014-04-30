
(
Pdef(~name+++\pre, Pbind(
    \degree, Pstep(Pseq([
        Pseq([0,2,4],4),
        Pseq([0,12,6],4),
        Pseq([0,12,6]+7,1),
    ],inf), 1),
    \degree, Pstep(Pseq([
        Pseq([12],4),
    ],inf), 1),
    \octave, 3,
    //\tab, Pfunc {
    //    var tab;
    //    [
    //        //tab = { arg n; (n + 1.asFloat.rand + 1).tanh / (n.rand+1) } ! 15;
    //        //tab = { arg n; (n + 2.asFloat.rand + 1) / (n+1) } ! 15;
    //        tab = { arg n; (n + 10.asFloat.rand + 1) / (n+1*3) } ! 15;
    //        tab.postln;
    //    ]
    //},
	\tab, [ { arg n; n/(n+1) } ! 15 ],
	\isRest, Veco(~namex).isrest(16),
    //\dur, PdurStutter( Prand([1,2,4],inf), Pseq([1,2,3]/2,inf)),
	\dur, 1/4,
    \amp, 0.4
));
);
