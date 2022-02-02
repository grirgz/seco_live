(
{ arg
	dotColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ),
	borderSize = ~gm.at( \borderSize ),
	dotRatio = 0.8,
	subdivisionMultiplier = 0.75,
	probabilities = [ 0, 0.25, 0.5, 0.75, 1 ],
	numberOfBeats = 4,
	numberOfBeatSubdivisions = 2,
	track = Array.fill( numberOfBeats * numberOfBeatSubdivisions, {
		probabilities[ 0 ] } );

	var view = UserView();

	view.drawFunc = { | view |

		var caseSize;
		var dotSize;

		Pen.fillColor_( borderColor );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		);

		Pen.fillColor_( backgroundColor );
		Pen.fillRect(
			Rect(
				borderSize,
				borderSize,
				view.bounds.width - ( borderSize * 2 ),
				view.bounds.height - ( borderSize * 2 )
			)
		);

		caseSize = view.bounds.width - ( borderSize * 2 ) / track.size;
		dotSize = caseSize * dotRatio / 2;
		if( dotSize > ( view.bounds.height / 2 * dotRatio / 2 ), {
			dotSize = ( view.bounds.height / 2 * dotRatio / 2 ) } );

		track.do( { | probability, index |

			var thisDotSize = dotSize;
			if( index%numberOfBeatSubdivisions != 0, {
				thisDotSize = dotSize * subdivisionMultiplier } );
			thisDotSize = thisDotSize * probability;

			case
			{ probability == 0 } {
				Pen.fillColor_( Color.white );
				Pen.addArc(
					Point(
						borderSize + ( caseSize / 2 ) + ( caseSize * index ),
						view.bounds.height * 0.25
					),
					dotSize * 0.05,
					0, 2pi
				);
				Pen.addArc(
					Point(
						borderSize + ( caseSize / 2 ) + ( caseSize * index ),
						view.bounds.height * 0.75
					),
					dotSize * 0.05,
					0, 2pi
				);
				Pen.fill; }

			{ probability == probabilities[ probabilities.size - 1 ] } {
				Pen.fillColor_(
					Color(
						dotColor.red * probability,
						dotColor.green * probability,
						dotColor.blue * probability
					)
				);
				Pen.addArc(
					Point(
						borderSize + ( caseSize / 2 ) + ( caseSize * index ),
						view.bounds.height * 0.25;
					),
					thisDotSize,
					0, 2pi
				);
				Pen.fill;
				Pen.fillColor_( Color.white );
				Pen.addArc(
					Point(
						borderSize + ( caseSize / 2 ) + ( caseSize * index ),
						view.bounds.height * 0.75
					),
					dotSize * 0.05,
					0, 2pi
				);
				Pen.fill;
			}

			{
				( probability > 0 )
				&&
				( probability == probabilities[ probabilities.size - 1 ] ).not
			} {
				Pen.fillColor_(
					Color(
						dotColor.red * probability,
						dotColor.green * probability,
						dotColor.blue * probability
					)
				);
				Pen.addArc(
					Point(
						borderSize + ( caseSize / 2 ) + ( caseSize * index ),
						view.bounds.height * 0.75;
					),
					thisDotSize,
					0, 2pi
				);
				Pen.fill;
				Pen.fillColor_( Color.white );
				Pen.addArc(
					Point(
						borderSize + ( caseSize / 2 ) + ( caseSize * index ),
						view.bounds.height * 0.25
					),
					dotSize * 0.05,
					0, 2pi
				);
				Pen.fill;
			};



			/*
			if( probability > 0, {
			Pen.fillColor_(
			Color(
			dotColor.red * probability,
			dotColor.green * probability,
			dotColor.blue * probability
			)
			);
			Pen.addArc(
			Point(
			borderSize + ( caseSize / 2 ) + ( caseSize * index ),
			view.bounds.height / 2
			),
			thisDotSize,
			0, 2pi
			);
			}, {
			Pen.fillColor_( Color.white );
			Pen.addArc(
			Point(
			borderSize + ( caseSize / 2 ) + ( caseSize * index ),
			view.bounds.height / 2
			),
			dotSize * 0.05,
			0, 2pi
			);
			} );
			Pen.fill; */
		} );
	}; // End of drawFunc

	// Methods
	view.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; view.refresh } );
	view.addUniqueMethod( \setDotColor, { | self, newColor | dotColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; view.refresh } );
	view.addUniqueMethod( \setDotRatio, { | self, newRatio | dotRatio = newRatio; view.refresh } );
	view.addUniqueMethod( \setSubdivisionMultiplier, { | self, newMultiplier | subdivisionMultiplier = newMultiplier; view.refresh } );

	view.addUniqueMethod( \setNumberOfBeats, { | self, newNumberOfBeats |
		if( numberOfBeats != newNumberOfBeats, {
			numberOfBeats = newNumberOfBeats;
			track = Array.fill( numberOfBeats * numberOfBeatSubdivisions, {
				probabilities[ 0 ] } );
			view.refresh
		} )
	} );

	view.addUniqueMethod( \setNumberOfBeatSubdivisions, { | self, newNumberOfBeatSubdivisions |
		if( numberOfBeatSubdivisions != newNumberOfBeatSubdivisions, {
			numberOfBeatSubdivisions = newNumberOfBeatSubdivisions;
			track = Array.fill( numberOfBeats * numberOfBeatSubdivisions, {
				probabilities[ 0 ] } );
			view.refresh
		} )
	} );

	view.addUniqueMethod( \setProbabilties, { | self, newProbabilities |
		probabilities = newProbabilities;
		track.do( { | probability, index |
			if( probabilities.includes( probability ).not, {
				track[ index ] = probabilities[ 0 ];
			} )
		} );
		view.refresh } );

	view.addUniqueMethod( \setTrack, { | self, newTrack |
		track = newTrack;
		view.refresh;
	} );

	view.addUniqueMethod( \bindFunction, { | self, function |
		view.mouseDownAction_( { | view, x, y |

			var current_selection;

			var selectedDot = x.linlin( borderSize, view.bounds.width - ( borderSize * 2 ), 0, track.size ).asInteger;
			var clickZone = y.linlin( 0, view.bounds.height, 0, 2 ).asInteger;

			// Safety check if user clicked on the right border
			if( selectedDot == track.size, { selectedDot = selectedDot - 1 } );

			current_selection = probabilities.detectIndex( { | item, index |
				item == track[ selectedDot ] } );

			if( clickZone == 0, {
				if( current_selection == ( probabilities.size - 1 ), {
					track[ selectedDot ] = probabilities[ 0 ]
				}, {
					track[ selectedDot ] = probabilities[ probabilities.size - 1]
				} );
			}, {
				if( current_selection == ( probabilities.size - 1 ), {
					track[ selectedDot ] = probabilities[ 1 ]
				}, {
					track[ selectedDot ] = probabilities[ current_selection + 1 ]
				} );
			} );

			function.value( track );
			view.refresh;
		} )
	} );

	view
}
)