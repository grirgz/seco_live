(
SynthDef(\noise, { arg freq, amp, q;
    var signal = BPF.ar(
        WhiteNoise.ar,
        freq: In.kr(freq),
        mul: In.kr(amp),
        rq: In.kr(q)
    );

    Out.ar(0, signal ! 2)
}).add;

SynthDef(\line, { arg start, end, dur, bus;
    var env = Env([start, end], [dur]);
    var signal = EnvGen.kr(env, doneAction: 2);
    Out.kr(bus, signal ! bus.numChannels);
}).add;
)

(
~noiseRamper = { arg initialFreq, initialAmp, initialQ, group=nil;
    var lineGroup = Group.new(group, \addToTail);
    var soundGroup = Group.after(lineGroup);
    var freqBus = Bus.control(s, 2).set(initialFreq);
    var ampBus  = Bus.control(s, 2).set(initialAmp);
    var qBus    = Bus.control(s, 2).set(initialQ);
    var noise = Synth.head(soundGroup, \noise, [
        \freq, freqBus,
        \amp, ampBus,
        \q, qBus
    ]);
    var ramp = { arg bus, end, dur;
        lineGroup.freeAll;
        bus.get { arg value;
            Synth.head(lineGroup, \line, [
                \bus, bus,
                \start, value,
                \end, end,
                \dur, dur
            ])
        };
    };

    (
        free: { arg self;
            noise.free;
            lineGroup.freeAll;
            soundGroup.freeAll;
        },
        rampFreq: { arg self, end, dur;
            ramp.value(freqBus, end, dur);
            self
        },
        rampAmp: { arg self, end, dur;
            ramp.value(ampBus, end, dur);
            self
        },
        rampQ: { arg self, end, dur;
            ramp.value(qBus, end, dur);
            self
        },
    )
};

~noisesFromNetwork = { arg network, fundamental, masterGroup;
	network.collect { arg layer, lIndex;
		var baseIndex = lIndex + 1;

		layer.asArray.collect { arg row, rIndex;
			var rowIndex = rIndex + 1;

			row.collect { arg value, vIndex;
				var valueIndex = vIndex + 1;
				var freqOffset = (2 + value) ** (rowIndex + valueIndex + baseIndex).nextPrime;
				var freq = (fundamental * baseIndex) + freqOffset;
				var amp = value + 0.9;
				var q = value * 0.001;

				~noiseRamper.value(freq, amp, q, masterGroup)
			}
		}
	}
};
)

(
~neuralNetwork = { arg layerDimensions;
	layerDimensions.collect { arg dimensions;
		Matrix.with(Array.fill(dimensions.first, { Array.rand(dimensions.last, 0, 1.0) }))
	}
};

~forward = { arg network, input;
	var weightedInputs = [];
	var activations = [input];
	var currentWeightedInput, currentActivation = input;

	network.do { arg layer;
		currentWeightedInput = currentActivation * layer;
		currentActivation = currentWeightedInput.tanh;
		weightedInputs = weightedInputs add: currentWeightedInput;
		activations = activations add: currentActivation;
	};

	[weightedInputs, activations]
};

~guess = { arg network, input; ~forward.value(network, input).last.last };

~outputError = { arg guess, target; target - guess };

~sigmoidPrime = { arg x; 1 - (x.tanh ** 2) };

~backProp = { arg network, input, target; // calculate weight updates to improve network performance
	var result = ~forward.value(network, input);
	var weightedInputs = result.first;
	var activations = result.last;
	var guess = activations.last;
	var error = target - guess;
	var delta, updates;

	delta = Matrix.with(error.asArray * weightedInputs.last.collect(~sigmoidPrime).asArray);
	updates = [activations.drop(-1).last.flop * delta];

	(network.size - 2).to(0, -1) do: { arg index;
		var weightedInput = weightedInputs at: index;
		var activation = activations at: index;
		var layer = network at: (index + 1);
		var derivative = weightedInput.collect(~sigmoidPrime);

		delta = Matrix with: ((delta * layer.flop).asArray * derivative.asArray);
		updates = [(activation.flop * delta)] ++ updates
	};

	updates
};

~applyUpdates = { arg network, updates, learningRate=0.1;
	network collect: { arg layer, index; layer + (updates.at(index) * learningRate) }
};

~trainLoop = { arg network, observations, steps=10, learningRate=0.1, action={};
	Routine.new {
		steps do: { arg idx;
			var observation = observations.choose;
			var input = observation.first;
			var target = observation.last;
			var updates = ~backProp.value(network, input, target);

			network = ~applyUpdates.value(network, updates, learningRate);
			action.value(idx, network, input, target);
		};
		'done'.postln;
	}
};
)

(
var network = ~neuralNetwork value: [[2, 3], [3, 1]];
var observations = [
	[[[0, 1]], [[1]]],
	[[[1, 0]], [[1]]],
	[[[1, 1]], [[0]]],
	[[[0, 0]], [[0]]],
].collect { arg obs; obs collect: { arg x; Matrix.with(x) } };

~master = Group.new;
~fundamental = 300;
~stepDur = 10;
~noises = ~noisesFromNetwork.value(network, ~fundamental, ~master);

~netLoop = ~trainLoop.value(network, observations,
	steps: 100000,
	learningRate: 0.01,
	action: { arg count, net, in, t;
		~stepDur.wait;
		"-------------".postln;

		net.asArray do: { arg layer, lIndex;
			var layerIndex = lIndex + 1;

			layer do: { arg row, rIndex;
				var rowIndex = rIndex + 1;

				row do: { arg value, vIndex;
					var noise = ~noises.at(lIndex).at(rIndex).at(vIndex);
					var valueIndex = vIndex + 1;
					var freqOffset = (2 + value) ** (rowIndex + valueIndex + layerIndex).nextPrime;
					var freq = (~fundamental * layerIndex) + freqOffset + (value * 25);
					var amp = value + 0.9;
					var q = value * (0.001 + 0.009.rand);

					[freq, amp, q].postln;

					if(noise.notNil && [true, false].choose, {
						noise.rampAmp(amp, ~stepDur).rampFreq(freq, ~stepDur).rampQ(q, ~stepDur);
					})
				}
			}
		};
	}
).play
)
