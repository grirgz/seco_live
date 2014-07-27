( // beat grid object prototype
~g = {
var l = 8,  // base pulse: 2**l
state_bus = Bus.audio(numChannels:2), // base beat and beat counter
rate_bus = { var b = Bus.control; b.set(0.5.rrand(2).debug('beat rate')); b }.(), // set beat rate
beat_runner = { var  // base beat runner 
	base = Impulse.ar(In.kr(rate_bus)*(2**l)), // base pulse
	c = PulseCount.ar(base, PulseDivider.ar(base,2**(l*4))); // l*4 - max multi beat partition
	Out.ar(state_bus, [base,c]) }.play,
q = {|n,s=0,p=0| var i = InFeedback.ar(state_bus,2), c = Latch.ar(i[1],1);  // server grid quantizer
	n = n + l;
	PulseDivider.ar(i[0], 2**n, neg(2**n-(c%(2**n))) + (s*2.pow(n-(p?0)-1)))},
// proto object
grid = (l:l,q:q,state_bus:state_bus,rate_bus:rate_bus,beat_runner:beat_runner);

rate_bus.get({ |rate| var // sclang synced clock
	status = [nil],
	rater = { Out.kr(rate_bus, \tempo.kr(rate)) }.play,
	clock = TempoBusClock(rater, rate),
	notifier = { var bc = InFeedback.ar(state_bus,2); SendReply.ar(bc[0], '/pulse', [bc[1],In.kr(rate_bus)]) }.play,
	osc = OSCFunc({ |msg| status[0] = msg[3]; clock.beats = status[0]/(2**l) }, '/pulse');
	grid.putPairs([status: status, notifier: notifier, rater: rater, osc: osc, clock: clock, on:[0],
		nextTimeOnGrid: { |self, clock| var n = l + self.on[0], // client grid quantizer
			beats = (2**n) - (self.status[0] % (2**n)) + (if(self.on.size > 1, {2**(n-1-(self.on[2]?0))*self.on[1]}, {0})) / (2**l);
			self.on.debug('on');
			clock.beats + beats }])});
	grid
}.()
)

( // survive cmdperiod
CmdPeriod.add(~g.beat_runner.addUniqueMethod(\cmdPeriod, _.debug('still running')));
~g.clock.permanent = true;
CmdPeriod.add(~g.rater.addUniqueMethod(\cmdPeriod, _.debug('still running')));
CmdPeriod.add(~g.osc.addUniqueMethod(\cmdPeriod, _.debug('still running')));
ServerTree.add(~g, Server.default);
~g[\doOnServerTree] = { 
    Synth(~g.beat_runner.defName); Synth(~g.rater.defName); 
    ~g.clock.tempo = ~g.clock.tempo }
)

( // shortcuts
~q = ~g[\q];
~e = {|p,d,a,c|EnvGen.ar(Env.perc(a?0.01,d?0.5,1,c?(-4)),p)}; // trigable perc envelope
~d = PulseDivider.ar(*_);
~sin = SinOsc.ar(*_);
~w = {|p,mn,mx|Demand.ar(p,0,Dwhite(mn,mx)).max(mn)};
~l = {|d=40,s=1,e=0|Line.kr(s,e,d,doneAction:2)};
)

// examples

~g.clock.tempo; // current tempo
~g.clock.tempo = 1; // change tempo (both sclang+scsynth)

/* grid quantizer explained:
~q.(n,m,k) means impulse each 2**n beat with m*(2**(n-1-k)) beat shift
*/

// simple examples
{~sin.(60) * ~e.(~q.(0),0.2)/4!2 * ~l.()}.play // every beat
{~sin.(160) * ~e.(~q.(0,0.5),0.2)/4!2 * ~l.()}.play // every beat + 1/4 beat shift
{~sin.(Stepper.ar(~q.(0),0,60,90,2).midicps) * ~e.(~q.(0,0.5),0.2)/4!2 * ~l.()}.play // every beat + 1/4 beat shift
{~sin.(360) * ~e.(~q.(0,3,1),0.2)/4!2 * ~l.()}.play // every beat + 3/4 beat shift
{~sin.(120) * ~e.(~q.(0,1),0.05)/4!2 * ~l.()}.play // every beat + 1/2 beat shift
{~sin.(240) * ~e.(~q.(1,1),0.05)/4!2 * ~l.()}.play // every 2 beat + 1 beat shift
{~sin.(200.exprand(1000)) * ~e.(~q.(1,1,0),0.05)/4!2 * ~l.()}.play // same on other freq
{~sin.(200.exprand(1000)) * ~e.(~q.(1,3,1),0.05)/4!2 * ~l.()}.play // every 2 beat + 3/2 beat shift
{~sin.(200.exprand(1000)) * ~e.(~q.(1,3,2),0.05)/4!2 * ~l.()}.play // every 2 beat + 3/4 beat shift
{~sin.(200.exprand(1000)) * ~e.(~q.(1,[2,3],2),0.05)/4 * ~l.()}.play // every 2 beat + 2/4 beat shift on left and 3/4 beat shift on right

// run pattern in sync with server tempo grid
s.latency = 0.001; // low latency

(Pdef(\t, Pbind(*[
degree:Pseries(), delta: Pseq(1!10), dur:1
])).play(~g.clock, quant:[1,0.5]))  // default quant: i.e. on first 1.5 beat
Pdef(\t).stop;

(Pdef(\tt, Pbind(*[ // grid
degree:Pseries(), delta: Pseq(2!10,inf), dur:0.2, 
])).play(~g.clock, quant:(parent:~g, on:[2,1.5])))  // position like ~q.(...), but args in "on" key (here: on nearest 4 beat line + 3 beat shift)
Pdef(\tt).stop;

// live coding example
~g.clock.tempo = 1;
Ndef(\dur, { 1/In.kr(~g.rate_bus) }).play; // beat duration
Ndef(\bk, {Formlet.ar(LPF.ar(~q.(-2) bitXor: ~q.(0), ~w.(~q.(3),250,500)), Demand.ar(~q.(2), 0, Dbrown(120,420,20)).max(120), 0.01, Ndef(\dur)/2) ! 2 / 4 }).play;
Ndef(\k, {~sin.(60) * ~e.(~q.(0), Ndef(\dur)/3) ! 2 / 2 }).play;
Ndef(\k1, {~sin.(490.rrand(800)) * ~e.(~q.(1,1.5), 0.1) ! 2 / 3 }).play;
Ndef(\k2, {BPF.ar(Saw.ar(90)) * ~e.(~q.(-1) bitXor: ~q.(1), 0.15) ! 2 / 2 }).play;

Ndef(\k3, {RLPF.ar(Pulse.ar(~w.(~q.(2),60,110)),~w.(~q.(4),180,300)) * ~e.(~q.(0,0.5), 0.1) ! 2 / 3 }).play;

Ndef(\k2, {BPF.ar(Saw.ar(~w.(~q.(2),60,110)),~w.(~q.(3),180,300)) * ~e.(~q.(-1) bitXor: ~q.(1), 0.15) ! 2 / 2 }).play;

( Ndef(\k1, {
~sin.(~w.(~q.(3),60,80).midicps*~sin.(~w.(~q.(0),5,18)).range(0.05,1.03))
.madd(0.95,0.05*~sin.(~w.(~q.(4),200,800))).tanh ! 2 * ~e.(~q.(3,1.5), 2.3) / 8 }).play )

Ndef(\k, {~sin.(~w.(~q.(3),60,80)) * ~e.(~q.(0), Ndef(\dur) * ~w.(~q.(2),4,8)/4) ! 2 / 2 }).play;

Ndef(\p).play;
( Ndef(\p, { var a = Array; DynKlank.ar(`[a.exprand(8,2e2,2e4).sort, a.exprand(8,0.1,1).sort.reverse, a.exprand(8,0.25,1).sort.reverse],
~q.(-1,1) bitXor: ~q.(1,1,1) / 30 * LFBrownNoise0.ar(1/4).madd(0.7,0.3), ~w.(~q.(3),4,8)/4, 0, ~w.(~q.(3),1,4)/4) ! 2 }) )

~g.clock.tempo = 2;

// etc..
