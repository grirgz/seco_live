~a = 2
~env = Environment.make({  })
~env.use({ ~a.postln })
~env.use({ ~a = 3 })
~env.parent = topEnvironment
~a
