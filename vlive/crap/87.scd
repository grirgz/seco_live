a = Plazy({ Prand([64,65,66,67]).stutter(rrand(1,4)) }).loop
a = Prand([64,65,66,67],inf).stutter(Pwhite(1,4))
b= a.asStream
b.next
