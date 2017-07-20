
~ndefmod = { arg key, prop;
	var bus;
	bus = BusDef(\ndefmod_+++key+++ '_' +++ prop, \control);
	Ndef(key).map(prop, bus.asMap);
	bus;
}
