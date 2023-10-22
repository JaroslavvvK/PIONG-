static void gameStart() {
    
    racketLeft.yPos = (sketch.height >> 1) - 22.5;
    racketRight.yPos = (sketch.height >> 1) - 22.5;
    
    ballList.clear();  
    tileList.clear();
    
    scoreRight = 0;
    scoreLeft = 0;
    balls.beginDraw();
    balls.background(0);
    balls.endDraw();
    
    for (int i = 0; i < ballsCount; i++)
        if (ballsCount == 2) {
        ballList.add(new Ball(i == 0 ? racketLeft.xPos+100 : racketRight.xPos-100, sketch.height>>1));
        }
        else
        ballList.add(new Ball(sketch.width>>1, sketch.height>>1));
        
    if(blocksActive)
        for(int i=0; i < sketch.height/30; i++) {
            sketch.colorMode(HSB, 255);  
            tileList.add(new Tile((sketch.width>>1)-15, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            tileList.add(new Tile((sketch.width>>1)+15, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            tileList.add(new Tile((sketch.width>>1)-45, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            //tileList.add(new Tile((sketch.width>>1)-85, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            //tileList.add(new Tile((sketch.width>>1)+65, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            sketch.colorMode(RGB, 255);  
        }
    state = 1;    
}

static void gameEnd(int winner) {
    racketLeft.yPos = (sketch.height >> 1) - 22.5;
    racketRight.yPos = (sketch.height >> 1) - 22.5;
   
    ballList.clear();  
    tileList.clear();
    playVsAi = false;
    
    for (int i = 0; i < ballsCount; i++)
        ballList.add(new Ball(sketch.width>>1, sketch.height>>1));
       
   if(blocksActive)
        for(int i=0; i < sketch.height/30; i++) {
            sketch.colorMode(HSB, 255);  
            tileList.add(new Tile((sketch.width>>1)-15, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            tileList.add(new Tile((sketch.width>>1)+15, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            tileList.add(new Tile((sketch.width>>1)-45, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            //tileList.add(new Tile((sketch.width>>1)-85, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            //tileList.add(new Tile((sketch.width>>1)+65, i*30, 30, 30, sketch.color(sketch.random(256),200,200)));
            sketch.colorMode(RGB, 255);  
        }
       
    if (winner < 2) {
        winnerRight = winner == 1;
        state = 2;
        sketch.delay(3000);
    }
   
    state = 0;
}
