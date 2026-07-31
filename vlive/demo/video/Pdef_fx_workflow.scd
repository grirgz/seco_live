I will give an example. Here is how i build my composition with the second paradigm, each part of the composition have this layout. I can easily add or remove Pbinds, and each part can have a different number of Pbind (or any other pattern, you get it)

Note that I use BusDef from my own quark, which automatically create a bus with a given name, but you can do the same with regular busses.

```
(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(...),
		Pbind(...),
		Pbind(...),
		Pbind(...),
	])
)).play;
);
```

If I need to add a reverb to a Pbind, i will do this. I can chain the fx or route two Pbind inside the same fx.

```
(
Pdef(\part, Pdef(\bridge, 
	Ppar([
		Pbind(...),
		Pbind(...),
		Pbind(...),
		Pbind(
			...
			\out, BusDef(\verbfx, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verbfx, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
		),
	])
)).play;
);
```

Following the first/DAW paradigm, i would rather work like this:

```
(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(
			...
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			...
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			...
			\out, BusDef(\mixer3, \audio),
		),
	])
)).play;
);
```

Then I have a mixer which is a group of Ndef that read \mixerN busses, one for each mixer track, and i can change gain or add fx to it, add delay, add send routing, etc.
