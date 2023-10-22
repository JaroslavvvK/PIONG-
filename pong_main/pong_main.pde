// PPPPP  III  OOOOO NN  N GGGGG   !
// P   P   I   O   O N N N G       !
// PPPPP   I   O   O N  NN G  GG   !
// P       I   O   O N   N G   G   !
// P       I   O   O N   N G   G   
// P      III  OOOOO N   N GGGGG   !
//
//             _____
//            /  |  \
//           |\J/ \ /|
//           | X A X |
//           |/ \ /K\|
//            \__|__/
//    
//
// PIONG! 2023 JAK GAMES
// Giant thanks to iTut for help in learning Processing!

import processing.sound.*;
import java.util.List;
import java.util.Vector;

public pong_main() { sketch = this; }
static pong_main sketch;
static Ticker ticker = new Ticker();

static class Racket {
    double yPos, xPos;
    boolean leftSide; //1-left  0-right
    
    Racket(boolean s) {
        yPos = (sketch.height >> 1) - 22.5;
        leftSide = s;
        xPos = s ? 50 : sketch.width - 60;
    }
    
    void draw(PGraphics g) {
        g.push();
        g.stroke(#ffffff);
        g.rect((float)xPos, (float)yPos, 10, 45);
        g.pop();
    }
    
    void goUp(int amount) {
        yPos = yPos > 0 ? yPos - amount : yPos;
    }
    
    void goDown(int amount) {
        yPos = yPos < (sketch.height - 45) ? yPos + amount : yPos;
    }
    
    void aiMove() {       
        if(!ballList.isEmpty()) {
            Ball ball = ballList.get(0);
        
            double x = ball.xPos;

            for (Ball b : ballList) {
                if (leftSide ? b.xPos < x : b.xPos > x) {
                    ball = b;
                    x = b.xPos;
                }
            }
            
            double random = sketch.random(20);
            
            if(ball.yPos > yPos+22.5 - random)
                goDown(3);
            if(ball.yPos < yPos+22.5 + random)
                goUp(3);
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

static class Ball {
    double xPos,yPos;
    double angle;
    double speed;
    color colour;
                            
    Ball(double x, double y) {
        init();
        xPos = x;
        yPos = y;
    }
    
    void draw(PGraphics g) {
        g.push();
        g.fill(colour);
        g.circle((float)xPos, (float)yPos, 16);
        g.pop();
    }
    
    void move() {
        angle = (angle % 360 + 360) % 360;
        xPos += Math.cos(Math.toRadians(angle)) * speed;
        yPos += Math.sin(Math.toRadians(angle)) * speed;
    }
    
    void collisionCheck() {
        if (yPos+8 > sketch.height) {
            yPos--;        
            angle = 360 - angle;
            pingPong();
        }
            
        if (yPos-8 < 0) { 
            yPos++;
            angle = 360 - angle;
            pingPong();
        }
                            
        if (!racketMode) {
            if (xPos-8 < racketLeft.xPos+10 && xPos > racketLeft.xPos && yPos-8 < (racketLeft.yPos + 45) && yPos+8 > racketLeft.yPos) {
                angle = ((yPos - racketLeft.yPos - 22.5) * 56 / 30.5 + 360) % 360;
                pingPong();
            }
        
            if (xPos+8 > racketRight.xPos && xPos < racketRight.xPos+10 && yPos-8 < (racketRight.yPos + 45) && yPos+8 > racketRight.yPos) {
                angle = (racketRight.yPos + 22.5 - yPos) * 56 / 30.5 + 180;
                pingPong();
            }
        }
        else {
            
            if (xPos-8 < (racketLeft.xPos+10) && xPos+8 > racketLeft.xPos) {
                if (yPos+8 > racketLeft.yPos && yPos+8 < racketLeft.yPos + 5) {
                    yPos--;
                    angle = 360 - angle;
                    pingPong();
                }
                if (yPos-8 < (racketLeft.yPos+45) && yPos-8 > (racketLeft.yPos+40)) {
                    yPos++;
                    angle = 360 - angle;
                    pingPong();
                }
            }
            
            if (yPos-8 < (racketLeft.yPos+45) && yPos+8 > racketLeft.yPos) {
                if (xPos+8 > racketLeft.xPos && xPos+8 < racketLeft.xPos+5) {
                    xPos++;
                    angle = 180 - angle;
                    pingPong();
                }
                if (xPos-8 < racketLeft.xPos+10 && xPos-8 > racketLeft.xPos+5) {
                    xPos++;
                    angle = 180 - angle;
                    pingPong();
                }
            }
                                    
            if (xPos-8 < (racketRight.xPos+10) && xPos+8 > racketRight.xPos) {
                if (yPos+8 > racketRight.yPos && yPos+8 < racketRight.yPos + 5) {
                    yPos--;
                    angle = 360 - angle;
                    pingPong();
                }
                if (yPos-8 < (racketRight.yPos+45) && yPos-8 > (racketRight.yPos+40)) {
                    yPos++;
                    angle = 360 - angle;
                    pingPong();
            }
            
            if (yPos-8 < (racketRight.yPos+45) && yPos+8 > racketRight.yPos) {
                if (xPos+8 > racketRight.xPos && xPos+8 < racketRight.xPos+5) {
                    xPos--;
                    angle = 180 - angle;
                    pingPong();
                }
                if (xPos-8 < racketRight.xPos+10 && xPos-8 > racketRight.xPos+5) {
                    xPos--;
                    angle = 180 - angle;
                    pingPong();
                }
            } 
        }
    }

        for (Ball b : ballList) {
            if (b == this || (xPos - b.xPos) * (xPos - b.xPos) + (yPos - b.yPos) * (yPos - b.yPos) > 256) continue;
            double a = Math.toDegrees(Math.atan2(b.yPos - yPos, b.xPos - xPos)), dist = Math.sqrt((xPos - b.xPos) * (xPos - b.xPos) + (yPos - b.yPos) * (yPos - b.yPos)),
            xShift = ((b.xPos - xPos) / dist * 16 - b.xPos + xPos) / 2, yShift = ((b.yPos - yPos) / dist * 16 - b.yPos + yPos) / 2;
            angle = a * 2 - angle + 180;
            b.angle = a * 2 - b.angle + 180;
            xPos -= xShift;
            yPos -= yShift;
            b.xPos += xShift;
            b.yPos += yShift;
            double s = speed;
            speed = b.speed;
            b.speed = s;
        }
        
        for (Tile t : tileList) {
            if (xPos-8 < (t.xPos+t.wide) && xPos+8 > t.xPos) {
                if (yPos+8 > t.yPos && yPos+8 < t.yPos + 5) {
                    yPos--;
                    angle = 360 - angle;
                    pingPong();
                    destroyTileList.add(t);
                }
                if (yPos-8 < (t.yPos+t.high) && yPos-8 > (t.yPos+t.high-5)) {
                    yPos++;
                    angle = 360 - angle;
                    pingPong();
                    destroyTileList.add(t);
                }
            }
            
            if (yPos-8 < (t.yPos+t.high) && yPos+8 > t.yPos) {
                if (xPos+8 > t.xPos && xPos+8 < t.xPos+5) {
                    xPos--;
                    angle = 180 - angle;
                    pingPong();
                    destroyTileList.add(t);
                }
                if (xPos-8 < t.xPos+t.wide && xPos-8 > t.xPos+t.wide-5) {
                    xPos++;
                    angle = 180 - angle;
                    pingPong();
                    destroyTileList.add(t);
                }
            }
            
        }
                
        if (xPos+8 > sketch.width) {
            scoreLeft += 1;
            init();
        }
            
        if (xPos-8 < 0) {
            scoreRight += 1;
            init();
        }
    } //gaad damn...

    void init() {
        xPos = sketch.width >> 1;
        yPos = sketch.height >> 1;
        angle = sketch.random(70,250) - (180 * round(sketch.random(0,1)));
        speed = 1;
        sketch.colorMode(HSB);
        colour = sketch.color(sketch.random(256),200,200);
        sketch.colorMode(RGB);
    }
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

static class Tile {
    int xPos, yPos, wide, high;
    color colour;
    
    public Tile(int x, int y, int w, int h, color c) {
        xPos = x;
        yPos = y;
        wide = w;
        high = h;
        colour = c;
    }  
    
    void display(PGraphics g) {
        g.push();
        g.stroke(#ffffff);
        sketch.colorMode(HSB, 255);    
        g.fill(colour);
        g.rect(xPos, yPos, wide, high, 8);
        sketch.colorMode(RGB, 255);
        g.pop();
    }   
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

static class Button {
    int xPos, yPos, wide, high, tSize;
    String text;
    boolean pressed, visible;
    
    public Button(int x, int y, int w, int h, String t, int s) {
        xPos = x;
        yPos = y;
        text = t;
        wide = w;
        high = h;
        tSize = s;
        visible = true;
    }
    
    void draw(PGraphics g) {
        if(visible) {
        g.push();
        g.fill(150,150,150);
        g.stroke(100,100,100);
        g.strokeWeight(5);
        g.rect(xPos, yPos, wide, high);
        textDraw(g, xPos+(wide>>1), yPos+(high>>1), text, tSize, #000000, CENTER, CENTER);
        g.pop();
        }
    }   
    
    boolean mouseIsOver() {
        return sketch.mouseX > xPos && sketch.mouseX < xPos+wide && sketch.mouseY > yPos && sketch.mouseY < yPos+high;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

static double abs(double x) {
    return x > 0 ? x : -x;
}

static void textDraw(PGraphics g, int x, int y, String text, int size, color colour, int alignX, int alignY) {
    g.noStroke();
    g.textAlign(alignX, alignY);
    g.textSize(size-15);
    g.fill(colour);
    g.text(text, x, y);    
}

static boolean pingOrPong;

static void pingPong() {
    if(state == 0) 
        return;
    
    pingOrPong = pingOrPong ? false : true;
    
    if(pingOrPong)
        ping.play(1,0.02);
    else
        pong.play(1,0.02);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

static Racket racketRight, racketLeft;

static Button button1, buttonBallsUp, buttonBallsDown, buttonBlocks, buttonMaxScoreUp, buttonMaxScoreDown, buttonRacketMode, buttonVsBot;

static List<Ball> ballList = new Vector<>(); // the list of balls
static PGraphics balls; //layer for balls

static List<Tile> tileList = new Vector<>(), displayTileList, destroyTileList = new Vector<>(); // the list of tiles

static PFont stdFont;

static boolean wKey, aKey, sKey, dKey, upKey, downKey, rKey; //keys
static boolean winnerRight;
static boolean blocksActive; //0-no blocks 1-blocks
static boolean ballsCountChange; //when you selecting gamemode it tracks the change of ballsCount
static boolean racketMode; //0-normal 1-predictable
static boolean playVsAi;

static int state = 0; //state 0 choosing mode, state 1 game, state 2 end
static int ballsCount = 2;
static int maxScore = 4;
static int scoreRight, scoreLeft;

static int buttonsMoveDown = 130;
static int buttonsMoveRight = 114;

static int logoTimer;
static PImage JAKGAMES;

static SoundFile test, ping, pong, ost, silence;

void settings() {
    size(900, 600, P2D);
    //size(1200, 900, P2D);
    noSmooth();
}    

void setup() { 
    ((PGraphicsOpenGL)g).textureSampling(2);
    
    JAKGAMES = loadImage("data/JAK_GAMES.png");
    
    colorMode(RGB, 255);
    stdFont = createFont("data/stdFont4.ttf", 128);
    textFont(stdFont);   

    push();
    background(0);
    textDraw(g, sketch.width>>1, 128, "Loading!", 60, #ffffff, CENTER, CENTER);
    pop();
    
////////////////////////////////////////////////////////////////////////////
    
    button1 = new Button((sketch.width>>1)-50, (sketch.height>>1)-25, 100, 50, "Play!", 50);
    
    buttonBallsUp = new Button(266, 370+buttonsMoveDown, 40, 40, "+", 40);
    buttonBallsDown = new Button(170, 370+buttonsMoveDown, 40, 40, "-", 40);
    
    buttonBlocks = new Button(501+buttonsMoveRight, 370+buttonsMoveDown, 60, 40, "On/Off", 40);
        
    buttonMaxScoreUp = new Button(266, 420+buttonsMoveDown, 40, 40, "+", 40);
    buttonMaxScoreDown = new Button(170, 420+buttonsMoveDown, 40, 40, "-", 40); //+50
    
    buttonRacketMode = new Button(501+buttonsMoveRight, 420+buttonsMoveDown, 130, 40, "Change mode", 40);
    
    buttonVsBot = new Button((sketch.width>>1)-75, (sketch.height>>1)+40, 150, 40, "Play vs Bot", 40);
    
    racketRight = new Racket(false);
    racketLeft = new Racket(true);
    
    for (int i = 0; i < ballsCount; i++)
        ballList.add(new Ball(sketch.width>>1, sketch.height>>1));

////////////////////////////////////////////////////////////////////////////
    
    balls = createGraphics(width, height, P2D);
    balls.beginDraw();
    balls.noStroke();
    balls.background(0);
    balls.endDraw();
    
////////////////////////////////////////////////////////////////////////////    
    
    test = new SoundFile(this, "data/scan.wav");
    ping = new SoundFile(this, "data/ping.wav");
    pong = new SoundFile(this, "data/pong.wav");
    ost = new SoundFile(this, "data/pinballFantesiesOst.mp3");
    silence = new SoundFile(this, "data/silence.wav");
    
////////////////////////////////////////////////////////////////////////////

    ost.loop(1,0.01);    
    
    logoTimer = 300;
    
    frameRate(60);
    ticker.start();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

static int titleColor = 0;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

void draw() {   
    if (logoTimer == 0) {
        balls.beginDraw();
        balls.push();
        balls.fill(0,25);
        balls.noStroke();
        balls.rect(0,0,width,height);
        balls.pop();
        for (int i = 0; i < ballList.size(); i++)
            ballList.get(i).draw(balls);
        balls.endDraw();    
    }
    

    push();
    image(balls, 0, 0);
    //tint(random(255),random(255),random(255));
    //image(g, (width*1.01-width)/2, (height*1.01-height)/2, width/1.01, height/1.01);
    pop();    
    
    displayTileList = new ArrayList<>(tileList);
    for(Tile t : displayTileList)
        t.display(g);
            
    titleColor = titleColor < 256 ? titleColor+1 : 0;
    
    if (logoTimer != 0) {
        push();
        tint(255,255,255,min(logoTimer*2,255));
        image(JAKGAMES, (width >> 1)-128, (height >> 1)-128, 256, 256);
        
        pop();
    }
    
    if (state == 0 && logoTimer == 0) {
        push();                
        colorMode(HSB, 255);
        textDraw(g, width>>1, 128, "PIONG!", 220, color(titleColor, 255, 255), CENTER, CENTER);
        textDraw(g, 30, 385+buttonsMoveDown, "Balls:", 45, #ffffff, LEFT, CENTER);
        textDraw(g, ((buttonMaxScoreUp.xPos + 40) + buttonMaxScoreDown.xPos) / 2, 385+buttonsMoveDown, ""+ballsCount, 45, #ffffff, CENTER, CENTER);
        
        textDraw(g, 30, 435+buttonsMoveDown, "Win score:", 45, #ffffff, LEFT, CENTER);
        textDraw(g, ((buttonMaxScoreUp.xPos + 40) + buttonMaxScoreDown.xPos) / 2, 435+buttonsMoveDown, ""+maxScore, 45, #ffffff, CENTER, CENTER);
        
        textDraw(g, 336+buttonsMoveRight, 385+buttonsMoveDown, "Blocks:", 45, #ffffff, LEFT, CENTER);
        
        buttonBlocks.text = blocksActive ? "On" : "Off";
        
        textDraw(g, 336+buttonsMoveRight, 435+buttonsMoveDown, "Racket mode:", 45, #ffffff, LEFT, CENTER);
        
        buttonRacketMode.text = !racketMode ? "Positional" : "Reflective";
        
        textDraw(g, 0, 10, "Music: pinball fantasies OST main menu", 45, #ffffff, LEFT, CENTER);
        
        textDraw(g, 5, height>>1, "W/S", 45, #ffffff, LEFT, CENTER);
        textDraw(g, width-5, height>>1, "↑/↓", 45, #ffffff, RIGHT, CENTER);

        colorMode(RGB, 255);
        
        button1.draw(g);
        
        buttonBallsUp.draw(g);
        buttonBallsDown.draw(g);
        
        buttonBlocks.draw(g);
        
        buttonMaxScoreUp.draw(g);
        buttonMaxScoreDown.draw(g);
        
        buttonRacketMode.draw(g); 
        
        buttonVsBot.draw(g);
            
        pop();   
    }
    
    //if (state == 1) {
    //}
    
    if (state == 2) {
        push();
        colorMode(HSB, 255);
        textDraw(g, sketch.width>>1, 128, winnerRight == true ? "Right player wins!" : "Left player wins!", 60, color(titleColor, 255, 255), CENTER, CENTER);
        colorMode(RGB, 255);
        pop();
    }
    
    
    if (logoTimer == 0) {
        push();
        racketRight.draw(g);
        racketLeft.draw(g);
        textAlign(CENTER);
        textFont(stdFont);
        textSize(40);
        fill(255, 255, 255);
        text(String.format("%d | %d", scoreLeft, scoreRight), width>>1, 60); 
        pop();    
    }
    
    surface.setTitle(String.format("Piong [ticks: %d]", Ticker.tickCount));
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

void mouseClicked() {
    if (state == 0) {
        if (button1.mouseIsOver())
            gameStart();
            
        if (buttonBallsUp.mouseIsOver() && ballsCount < 99)
            ballsCount++;
        if (buttonBallsDown.mouseIsOver() && ballsCount > 1)
            ballsCount--;
            
        if (buttonBlocks.mouseIsOver()) {
            if(!blocksActive)
                blocksActive = true;
            else
                blocksActive = false;
        }
        
        if (buttonRacketMode.mouseIsOver()) {
            if(!racketMode)
                racketMode = true;
            else
                racketMode = false;
        }
        
        if (buttonMaxScoreUp.mouseIsOver() && maxScore < 99)
            maxScore++;            
        if (buttonMaxScoreDown.mouseIsOver() && maxScore > 1)
            maxScore--;
            
        if (buttonVsBot.mouseIsOver()) {
            gameStart();
            playVsAi = true;
        }
        
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

void keyPressed() {
    switch (keyCode) {
        case 'S':
            sKey = true;
            break;
        case 'W':
            wKey = true;
            break;
        case 'A':
            aKey = true;
            break;
        case 'D':
            dKey = true;
        case 'R':
            rKey = true;
            break;
        case UP:
            upKey = true;
            break;
        case DOWN:
            downKey = true;
            break;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

void keyReleased() {
    switch (keyCode) {
        case 'S':
            sKey = false;
            break;
        case 'W':
            wKey = false;
            break;
        case 'A':
            aKey = false;
            break;
        case 'D':
            dKey = false;
            break;
        case 'R':
            rKey = false;
            break;
        case UP:
            upKey = false;
            break;
        case DOWN:
            downKey = false;
            break;
    }
}
