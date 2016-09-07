
// linear congruent generator
~lgc = { arg seed, modulus, a, c; (seed * a + c) % modulus }
( ~lgc.((1..20), 15510101, 14154101, 25144201)/15510101 ).plot
( ~lgc.((1..20), 2**32, 1664525, 1013904223)/(2**32) ).plot

(
~lgc = { arg seed, modulus, a, c; 
	var sd = seed;
	{ sd = (sd * a + c) % modulus }
}
)
~mylgc = ~lgc.(1, 2**32, 1664525, 1013904223)
~mylgc = ~lgc.((1..20), 2**32, 1664525, 1013904223)
~mylgc.()
( { ~mylgc.() } ! 1000 ).flop.plot
( { ~mylgc.() } ! 1000 ).plot // blue!
