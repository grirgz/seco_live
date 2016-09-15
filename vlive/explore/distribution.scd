//Helper functions for investigating pdfs and cdfs

(

	//normalize total sum of an array to 1.0

	~normalize = {|array|   array/(array.sum)}; //note, not safe if array is empty or otherwise sums to zero

	//(could also use normalizeSum, just showing this explicitly)


	//create array of cumulative values, assuming input is normalized (sums to 1.0)

	~cumulative = {|array| 

		var num = array.size; 

		var accumulate = 0.0; 

		var cumul; 


		cumul = array.collect{|val, i|  var old= accumulate; accumulate = accumulate+val; old};


		cumul

	}; 


	//use cumulative distribution to find an output value for an input

	//assumes array is a cumulative distribution function, and array size is at least 1

	~draw= {|input, array|

		var nextindex;


		nextindex= array.indexOfGreaterThan(input); //also see indexInBetween if want linearly interpolated index


		//get nil if input greater than anything in array

		if (nextindex.isNil,{nextindex= array.size;});


		nextindex= nextindex-1; //get index before; we 'went past' and have to go one back to find the slot our input falls in


		//nextindex should never be less than 0


		nextindex/(array.size); //get position proportional within array length

	}


)





Plotting approximations to different probability distributions:



//1. Uniform distribution, equal chance for any equal subsection of the range:


p= ~normalize.value(Array.fill(1000,1.0));


p.plot(minval:0.0, maxval:2.0/1000)  //pdf


c= ~cumulative.value(p); 


c.plot	//cdf


Array.fill(1000,{ ~draw.value(1.0.rand, c)}).sort.plot //choose values; driven by uniform random number, could also just provide increasing uniform numbers from 0.0 to 1.0 (and then wouldn't need the sort) 

//we do this a thousand times to simulate 'rolling the dice' many times; the distribution only really shows itself over many trials (and can do it more times for better approximations)


Array.fill(1000,{ 1.0.rand }).sort.plot //create values directly	
Array.fill(1000,{ 1.0.rand }).plot //create values directly	













//2. Linear distribution, probability density drops linearly, so more likely to get lower values:


p= ~normalize.value(Array.fill(1000,{|i| 1000-i}));


p.plot  //pdf


c= ~cumulative.value(p); 


c.plot	//cdf


Array.fill(1000,{ ~draw.value(1.0.rand, c)}).sort.plot //choose values 
Array.fill(1000,{ ~draw.value(1.0.rand, c)}).plot //choose values 


Array.fill(1000,{ 1.0.linrand }).sort.plot //create values directly	













//3. Negative exponential distribution, probability density drops exponentially, so much more likely to get lower values:



//there is a parameter here for the rate of fall off of the distribution 

~alpha= 100.0; 


p= ~normalize.value(Array.fill(1000,{|i| exp((i.neg/1000)*~alpha) })); 


p.plot  //pdf


c= ~cumulative.value(p); 


c.plot	//cdf


Array.fill(1000,{ ~draw.value(1.0.rand, c)}).sort.plot //choose values 



//go back and try ~alpha= 100.0; note the quantisation caused by only working with arrays of limited size as we create a discrete approximation to the ideal continuous distribution














//4. Normal distribution (Gaussian)


//two parameters, mean ('centre') and standard deviation ('spread'); here we take sensible values to plot the distribution easily


~mu= 0.5; //mean

~sigma=  0.17; //standard deviation; most of probability mass within 3 standard deviations, so this makes the Gaussian fit the 0.0 to 1.0 range easily for our plotting; try changing these parameters later to see the effect. 


//normalization constant calculated automatically, though there is a mathematical expression for it

p= ~normalize.value(Array.fill(1000,{|i|  exp((((i/1000)-~mu)/~sigma).squared.neg)})); 


p.plot  //pdf


c= ~cumulative.value(p); 


c.plot	//cdf


Array.fill(1000,{ ~draw.value(1.0.rand, c)}).sort.plot //choose values 


Array.fill(1000,{  0.5.gauss(0.17).max(0.0).min(1.0)  }).sort.plot //create values directly, clamping within +-3 standard deviations	












//5. Arbitrary distribution


//let's make up our own function


p= ~normalize.value(Array.fill(1000,{|i|  var prop= (i/1000.0); if(prop<0.2,{(0.2-prop)**(0.3)},{(prop-0.2)**2}) })); 


p.plot  //pdf


c= ~cumulative.value(p); 


c.plot	//cdf


Array.fill(1000,{ ~draw.value(1.0.rand, c)}).sort.plot //choose values 



//example in use; 20 notes drawn using the custom distribution (0.0 to 1.0 range output rescaled to MIDI notes 48 to 72)

(

	{

		20.do{

			Synth(\acsound,[\freq, 48+(24*~draw.value(1.0.rand, c))]); 

			//could quantise the notes to discrete pitches, e.g., with .round(1.0)

			

			0.25.wait;

		}

	}.fork;

)










There are many other interesting distributions you might investigate, see for example: 

Charles Ames. A catalog of statistical distributions: Techniques for transforming random, determinate and chaotic sequences. Leonardo Music Journal, 1(1):55–70, 1991. 

Denis Lorrain. A panoply of stochastic 'cannons'. Computer Music Journal, 41(1):53–81, 1980. 





In practice, we often work with a relatively small discrete set of options. It is easy to create a custom probability distribution over a set: 


[0,1,2,3,4,5].wchoose([0.2,0.3,0.1,0.1,0.05,0.25]) //make sure weights add to 1.0, or use normalizeSum



//examination using our machinery for pdf, cdf, and draws:

p= ~normalize.value([0.2,0.3,0.1,0.1,0.05,0.25]); 




~samples.sort.plot
~samples = ~samples.collect({ arg x; x**4 })
0.5.gauss(0.2)

(
~samples = 1000.collect({ 1.0.rand });
~lin = 1000.collect({ arg x; x }).normalize(0,1);
//~samples = ~samples.collect({ arg x; x.gaussCurve(1.1,0,0.3) });
~transfert = { arg x; ( x*2-1 )**3 };
~samples2 = ~samples.collect(~transfert);
~lin2 = ~lin.collect(~transfert);
[~lin, ~lin2, ~samples, ~samples2, ~samples.copy.sort].plot

)

(0..1000).normalizeSum.collect(_.gaussCurve(2.06,0.95,0.1)).plot
( (1..1000)/100.0 ).collect(_.gaussCurve(0.1,0.1,0.1))
( (1..1000)/1000.0 )

~transfert.(~samples, ~a, ~b, ~c)
~transfert.(0.1, 0.1, 0, 1)

(-3).pow(2.9)
(
~samples = 100.collect({ 1.0.rand });
//~samples = 100.collect({ arg x; x/100});
~transfert = { arg x, a, b, c;
	//2**(x * a);
	//x.gaussCurve(a*4, b*4, c*4)
	//a * (exp(squared(x - b) / (-2.0 * squared(c))))
	var val;
	//x = x + 0.5;
	val = x;
	val = val * a * 4;
	//val = val + b;
	
	val = val * 2 - 1;
	val = val**3;
	val = ( val*c ) + ( ( val**3 ) * (1-c) );
	[val, ( val-0.5 ).softclip(0,1)+0.5].debug("bb,aa");
	val = val + (b*2-1);
	val = val.softclip;
	val = val +1 / 2 - 0.0625;
	//val = (x**3);
	//val = ( x*a*4 )**(3) + 0.5;
	//val.softclip(0,1);
	val
};
WindowDef(\distri, { arg def;
	var uv = UserView.new;
	var uv2 = UserView.new;
	var params;
	~a = ~a ? 0;
	~b = ~b ? 0;
	~c = ~c ? 0;
	params = [
		Param(currentEnvironment, \a, \unipolar),
		Param(currentEnvironment, \b, \unipolar),
		Param(currentEnvironment, \c, \unipolar),
	];
	uv.drawFunc = {
		//~samples.copy.sort.collect({ arg x;
		~samples.collect({ arg x;
			//~a = 1/(~c * sqrt(2pi));
			x = ~transfert.(x, ~a, ~b, ~c);
			x = x * uv.bounds.width;
			//Pen.line(x@0, x@uv.bounds.height);
			Pen.line(x@0, x@uv.bounds.height);
			Pen.stroke;
		});
			//Pen.rotate(pi/2);
			//Pen.translate(uv.bounds.width/10, uv.bounds.height/10);
		//~samples.copy.sort.collect({ arg samp, idx;
		//	//~a = 1/(~c * sqrt(2pi));
		//	idx = idx/~samples.size * uv.bounds.width;
		//	samp = ~transfert.(samp, ~a, ~b, ~c);
		//	samp = samp * uv.bounds.height;
		//	Pen.line(idx@samp, ( idx+(uv.bounds.width/~samples.size) )@samp );
		//	//Pen.line(x@0, x@uv.bounds.height);
		//	//Pen.line(x@0, x@uv.bounds.height);
		//	Pen.stroke;
		//});
		//Pen.addRect(Rect(0,0,~size,50));
		//Pen.fill;
	};
	uv2.drawFunc = {
		//~samples.copy.sort.collect({ arg x;
		//	//~a = 1/(~c * sqrt(2pi));
		//	x = ~transfert.(x, ~a, ~b, ~c);
		//	x = x * uv.bounds.width;
		//	//Pen.line(x@0, x@uv.bounds.height);
		//	Pen.line(x@0, x@uv.bounds.height);
		//	Pen.stroke;
		//});
			//Pen.rotate(pi/2);
			//Pen.translate(uv.bounds.width/10, uv.bounds.height/10);
		~samples.collect({ arg samp, idx;
			var idxg;
			var fac = uv.bounds.width/~samples.size;
			//~a = 1/(~c * sqrt(2pi));
			idxg = idx * fac;
			[samp, ~transfert.(samp, ~a, ~b, ~c)].debug("before, after");
			samp = ~transfert.(samp, ~a, ~b, ~c);
			samp = samp * uv.bounds.height;
			Pen.line(idxg@samp, ( ( idx+1 )*fac )@samp );
			//Pen.line(x@0, x@uv.bounds.height);
			//Pen.line(x@0, x@uv.bounds.height);
			Pen.stroke;
		});
		//Pen.addRect(Rect(0,0,~size,50));
		//Pen.fill;
	};
	//params.debug("param");
	VLayout(
		HLayout (
			*params.collect({ arg p;
				//p.debug("p");
				def.window.isClosed.debug("win");
				p.makeListener({ 
					uv2.refresh; 
					uv.refresh; 
					"akkj".debug; 
				}, def.window);
				VLayout (
					p.asKnob,
					p.asTextField
				)
			})
		),
		uv,
		uv2,
	)
}).front;
)


		Param(currentEnvironment, \a, \unipolar).
