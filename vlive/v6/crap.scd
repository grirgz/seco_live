// 8-bit magic
(
play {
    var t = PulseCount.ar(Impulse.ar(8e3));
    HPF.ar(
        (
            ((t * 15) & (t >> 5)) |
            ((t * 5)  & (t >> [3, 4])) |
            ((t * 2)  & (t >> 9)) |
            ((t * 8)  & (t >> 11))
            - 3 % 256
        ) / 127-1 * 3
        , 20
    ).tanh
}
)

(
Ndef(\fou2, {
    var t = PulseCount.ar(Impulse.ar(8e3));
    HPF.ar(
        (
            ((t * 15) & (t >> [5,4]))
        ) / 127-1 * 3
        , 20
    )
}).play
)
