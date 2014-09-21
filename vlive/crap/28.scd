(
var xSize = 60;
var ySize = 60;
var scale = 10;
var waitDur = 0.3;
var win = Window.new("game of lyf", Rect(0, 0, xSize*scale, ySize*scale));
var uview;
var arr, buf, initFunc, iterFunc, startIter, finalize, task, iter;
var xPos, yPos;


initFunc = {
	arr = Array.fill2D(xSize,ySize,{ [0, 1, 1, 0, 0].choose });

	~arr = arr;
};

uview = UserView.new(win, Rect(0, 0, xSize*scale, ySize*scale));
uview.clearOnRefresh = true;
uview.drawFunc = { |uview|
	xSize.do { |x|
		ySize.do { |y|
			Pen.fillColor = if(~arr[x][y]>0, {Color.black},{Color.white});
			Pen.fillRect(Rect(x * scale,y * scale, scale, scale));
			Pen.fill;
		}
	}
};

// TODO:
// __borders not working correctly
// __rules slightly off ...
iterFunc = {
	var state, localArr, border, xP, yP;

	border = arr.size - 1;

	ySize.do{ |y|
		xSize.do{ |x|
			xP = x;
			yP = y;

			localArr = Array.fill2D(3, 3, { |y, x|
				var xPos, yPos;
				xPos = x + xP - 1;
				yPos = y + yP - 1;

				if( yPos == -1, { 0 }, {
					if( yPos >= border, { 0 }, {
						if( xPos == -1, { 0 }, {
							if ( xPos >= border, { 0 }, {
								~arr[xPos][yPos]
							})
						})
					})
				});

			});

			state = localArr.sum.sum;
			//localArr.postln;
			//state.postln;

			if(~arr[xP][yP] == 1, {
				state = state - 1;
				if(state < 2, { ~arr[xP][yP] = 0 });
				if(state > 3, { ~arr[xP][yP] = 0 });
			});
			if(~arr[xP][yP] == 0, {
				if(state == 3, { ~arr[xP][yP] = 1 });
			});
		}
	};
};

startIter = {
	initFunc.value;
	task = iter.fork(AppClock);
};

iter = {
	inf.do{
		//"---------------------------------------------------".postln;
		uview.refresh;
		waitDur.wait;
		iterFunc.value;

	}
};

finalize = {
	task.stop;
};

win.front;
win.onClose = finalize.value;
startIter.value;
)
