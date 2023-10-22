static class Ticker extends Thread {
    static int tickCount;
    static long tickLast;
    static boolean paused;

    synchronized void run() {
        tickLast = System.nanoTime();
        while (true) {
            while (System.nanoTime() - tickLast < 10000000)
            try {
                Thread.sleep((System.nanoTime() - tickLast) / 1000000, (int)((System.nanoTime() - tickLast) % 1000000));
            }
            catch (InterruptedException e) {
                e.printStackTrace();
            }
            tickLast += 10000000;
            if (paused)
                continue;
            tick();
            tickCount++;
        }
    }

    static void tick() {///////////////////////////////////////////

        if (state == 1) {
            
            if (playVsAi)
                racketRight.aiMove();

            if (sKey) {
                racketLeft.goDown(3);
            }

            if (wKey) {
                racketLeft.goUp(3);
            }

            if (aKey) {
                //racketLeft.xPos--;
            }

            if (dKey) {
                //racketLeft.xPos++;
            }

            if (downKey && !playVsAi) {
                racketRight.goDown(3);
            }

            if (upKey && !playVsAi) {
                racketRight.goUp(3);
            }

            if (rKey) {
                gameEnd(2);
            }
                      
            if (scoreRight >= maxScore)
                gameEnd(1);

            if (scoreLeft >= maxScore)
                gameEnd(0);                               
        }
        
        if (state == 0) {
            racketLeft.aiMove();
            racketRight.aiMove();
        }
        
        for (Ball b : ballList) {
            b.move();
            b.collisionCheck();
            if (tickCount % 10 == 0)
                b.speed += 0.005;
            }
            
        for (Tile t : destroyTileList)
            tileList.remove(t);
            destroyTileList.clear();
                        
        if(logoTimer != 0) {logoTimer--;}
            
        //if (tickCount % 100 ==  0) {
        //    button1.xPos = (int)sketch.random(sketch.width);
        //    button1.yPos = (int)sketch.random(sketch.height);
        //}

        //if (tickCount % 10 == 0) {
        //    //ball1.angle = 90;
        //    ball1.speed = 1;
        //}
    }////////////////////////////////////////////////////////////////
}
