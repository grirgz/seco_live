
~morph_to.(\mod2, { arg from;  {SinOsc.kr(1, add:1).abs * XLine.kr(from.value,9000,1)}});
~morph_to.(\mod2, { arg from;  {LFSaw.kr([1,1/4,1/3,1/7], add:1).mean.abs * XLine.kr(from.value,9000,1)}});
~morph_to.(\mod1, { arg from;  {from.value.lag(0.1) * (SinOsc.kr(1)*0.5+1.01) }});
~morph_to.(\mod1, { arg from;  {from.value.lag(0.1) * (SinOsc.kr(4)*0.5+42.51) }});
~morph_to.(\mod2, { arg from;  {from.value.lag(0.1) * (SinOsc.kr(1)*0.5+1.01) }});
