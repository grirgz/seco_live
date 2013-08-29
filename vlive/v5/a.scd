~name = \a;

//Veco(~name)[\get_node_player] = { arg self; Ndef(self.get_name) }

(
Ndef(~name, {
    var t = PulseCount.ar(Impulse.ar(8e3));
    HPF.ar(
        (
            ((t * 15) & (t >> [5,4]))
        ) / 127-1 * 3
        , 20
    )
})
)
