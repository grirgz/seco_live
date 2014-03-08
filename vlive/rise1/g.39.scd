~patfx_gate.(~name+++\patfx, ~emul_release.(\adsr, 0.5))

// END
~patfx_gate.(~name+++\patfx, Pbind(\isRest, false))

~a = Env([0.0,0.55,0.0],[0.3,0.2])
~a.times[~a.times.size-1] = 4.1
~a.array = nil
~a.asCompileString
~a.times
~mul_release.(\adsr, 0.2)
~a.plot
~a.test
~a
