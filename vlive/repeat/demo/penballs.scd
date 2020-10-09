// code by neil cosgrove
(
var ms = 0.25;
var noBalls = 2500;
var balls = [];
var friction = 0.4;
var width = Window.screenBounds.width, height = Window.screenBounds.height;
noBalls.do{|i|
 balls = balls.add((
 xspeed:(30.0.rand-15),
 yspeed:(6.0.rand-3),
 x:width * (1.0.rand),
 y:height * (1.0.rand),
 color:Color(0.2.rand,0,0.33+(0.66.rand),1.0.rand).lighten(0.5.rand),
))};
w = Window("holes", Rect(100, 200, width, height));
u = UserView(w, Rect(0, 0, width, height));
u.background = Color.black;
u.animate = true;
u.clearOnRefresh = false;
u.drawFunc = {
 var ss;
    var ft = u.frame/25*ms;
    Pen.smoothing_(false);
 Pen.fillColor = Color(0.0,0.0,0.0,0.06);
 Pen.fillRect(Rect(0,0,width,height));
    balls.do{|ball,i|
        var size = 25-(i%25+2);
        // walls left & right
        if(ball[\x]<0 or:{ball[\x]>width }, {
            var velocity = ((ball[\xspeed]**2) + (ball[\yspeed]**2))**0.5;
            ball[\xspeed] = 0 - (ball[\xspeed]*friction);
            ball[\x] = ball[\x].fold(0,width);
        });
        // walls up & down
        if( (ball[\y]<0)or:{ball[\y]>height}, {
            var velocity = ((ball[\xspeed]**2) + (ball[\yspeed]**2))**0.5;
            ball[\yspeed] = 0 - (ball[\yspeed]*friction);
            ball[\y] = ball[\y].fold(0,height);
        });
        // apply acceleration
 ball[\yspeed] = ball[\yspeed]  + ((40.0.rand-20)*ms);
        ball[\xspeed] = ball[\xspeed] + ((40.0.rand-20)*ms);
        // apply speed
        ball[\x] = ball[\x] + (ball[\xspeed]/20*ms);
        ball[\y] = ball[\y] + (ball[\yspeed]/20*ms);
 ss = size*((u.frame+i).fold(0,40)/90+0.25);
 //Pen.fillColor = ball[\color].lighten(((u.frame+30+i).fold(0,40)/40));
 Pen.strokeColor = ball[\color];
 Pen.strokeOval(Rect.aboutPoint(Point(ball[\x], ball[\y]), ss,ss));
    };
};
w.front;
w.fullScreen;
)
