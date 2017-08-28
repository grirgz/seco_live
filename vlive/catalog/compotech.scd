//////////////// techniques de rhytme

- groove amp
- swing tempo
- offset/lag	
	- offset negatif: precipitation
	- offset positif: traine les pieds
- double: deux perc presque au meme moment
- modulate sustain
- offset start of sample
- modulate envelope
- hat style aspiration juste avant le snare ou le kick
- faire un rytme lent et faire un legato au max ou bien remplacer les longues notes par des tres rapides courtes notes regulieres, chaque type de percussion du rhytme lent peut etre remplacé par des textures differentes
- perc qui reviens regulierement mais a un interval regulier tres espacé
- stutter sample

// style (need examples..)
- break
- 4 to the floor

- duo: kick/snare
- trio: kick/hat/snare


////////////////// random techniques
- deux sequences d'une longueur differente pour faire au total une longue sequence qui est la multiplication de la longueur des deux
	- fonctionne aussi pour des frequences de lfo
- \isRest, .coin.not

///////////////// notation techniques
- \isRest, .coin.not
- \isRest, {[1,0].clump(8).choose}.dup(4).coin.not
- \isRest, Pkey(\legato)
- compute legato by reversing isRest pattern
- Pdict
- PmonoArtic


////////////////// fx
- delay network + feedback + dist
- echo
- sidechain
- compressor


///////////////// random arpegiate

\note, Pseq([
	[1,5,8],
	[1,6,10],
	[3,8,12, 0],
	[1,6,10, -2],
],inf).stutter(8).collect({ arg x; x.choose }),
