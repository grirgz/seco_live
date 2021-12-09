

SynthDef(\fx_equi, { arg out=0, gate=1;
	var sig, in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in.poll;
	sig = in.equi;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\ifx_equi, { arg out=0, gate=1;
	var sig, in;
	in = In.ar(out, 2); 
	in.poll;
	sig = in.equi;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	XOut.ar(out, \wet.kr(0), [sig, in] * \gain.kr(1));
}).add;

TagSpecDef(\SynthDef_fx).addUnique(\fx_equi);
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_equi);
SynthDesc(\fx_equi).addHalo(\edit, { arg model; "edit!!".debug; WindowDef(\Equi).front(model) });
SynthDesc(\ifx_equi).addHalo(\edit, { arg model; "edit!!".debug; WindowDef(\Equi).front(model) });


(
	ProtoTemplateDef(\Equi, (
		asPattern: { arg self;
			self.proxy;
		},
		proxyKey: { arg self;
			\equi_ +++ self.key;
		},
		inbus: BusDef(\equi, \audio, 2),

		proxy: { arg self;
			Pdef(self.proxyKey, 
				Pmono(\fx_equi,
					\inbus, Plazy({ Pkeyd(\inbus, self.inbus).keep(1) }).loop,
					\dur, 1,
				).trace
			);
			Pdef(self.proxyKey).addHalo(\edit, { self.edit; });
			Pdef(self.proxyKey);

		},
		edit: { arg self;
			WindowDef(\equi_ +++ self.key, WindowDef(\Equi)).front(self.proxy, self.inbus);
		},	

	));

			WindowDef(\Equi, { arg def, model, inbus, paramdict;
				var equi, equiparams;
				var scope = FreqScopeView(nil, Rect(0,0,100,100))
								.freqMode_(1)
								.active_(true);
				if(paramdict.isNil) {
					paramdict = Dictionary.newFrom([
						inbus: Param(model, \inbus),
						mix: Param(model, \mix),
						gain: Param(model, \gain),
						out: Param(model, \out),
					]);
				};
				if(inbus.notNil) {
					scope.inBus = inbus;
				};
				scope.onClose = {
					scope.kill;
				};
				scope.followChange(model, \set, {
					scope.inBus = paramdict[\inbus].get;
				});
				
				//equiparams = EQuiParams.new(
					//* #[
						//loShelfFreq,
						//loShelfGain,
						//loShelfRs,
						//loPeakFreq,
						//loPeakGain,
						//loPeakRq,
						//midPeakFreq,
						//midPeakGain,
						//midPeakRq,
						//hiPeakFreq,
						//hiPeakGain,
						//hiPeakRq,
						//hiShelfFreq,
						//hiShelfGain,
						//hiShelfRs
					//].collect({ arg key;
						////key -> model.get(key)
						//model.get(key)
					//})
				//);
				equi = EQui(nil,nil,model);
				equi.sync;
				VLayout (
					View.new.layout_(
						VLayout(
							HLayout (
								PlayerWrapper(model).asView,
								BasicButton.new.string_("edit").action_({ 
									WindowDef(\PdefEditor).front(model)
								}),
								BasicButton.new.string_("reset").action_({ 
									equi.value = EQuiParams.new;
								}),
							),
							ParamGroupLayout.two_panes(
								ParamGroup ([
									paramdict[\mix],
									paramdict[\gain],
									paramdict[\inbus],
									paramdict[\out],
								])
							)
						)
					).maxHeight_(150),
					View.new.layout_(
						VLayout (
							equi
						)
					).minHeight_(300),
					scope,
				)
			});
ProtoDef(\equi, ProtoTemplateDef(\Equi));
//ProtoDef(\equi).edit;

);

// END
ProtoDef(\equi).proxy
ProtoDef(\equi).inbus
ProtoDef(\equi).proxy.get(\inbus)
ProtoDef(\equi).edit;

LPF.scopeResponse
// basic usage. try these. Each one will open a new window
// move the mouse left and right to test response in different ranges
LPF.scopeResponse
HPF.scopeResponse
MoogFF.scopeResponse
BBandPass.scopeResponse
BLowShelf.scopeResponse // by default BLowShelf doesn't mangle much
Resonz.scopeResponse

(
w = Window("My Analyzer", Rect(0, 0, 511, 300)); // width should be 511
f = FreqScopeView(w, w.view.bounds);
f.active_(true); // turn it on the first time;

w.onClose_({ f.kill }); // you must have this
w.front;
{ SinOsc.ar([500, 1000], 0, 0.25).mean.dup }.play(s); // start two sine waves
)BRF.scopeResponse
Integrator.scopeResponse
Median.scopeResponse // nonlinear, and therefore interesting

// customize the parameters for more informative scoping
{|in| MoogFF.ar(in, freq: MouseX.kr(10, 10000, 1), gain:MouseY.kr(4, 0))}.scopeResponse

TagSpecDef(\out)
Spec.specs[\out].list
:w


///////////:


(
Pdef(\help, Pbind(\out, BusDef(\mybus, \audio))).play;
WindowDef(\scope_help, { arg def;
	var scope = FreqScopeView(nil, Rect(0,0,100,100))
					.freqMode_(1)
					.active_(true);
	scope.inBus = BusDef(\mybus, \audio);
	scope.onClose = {
		scope.kill;
	};
}).front;
)

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
