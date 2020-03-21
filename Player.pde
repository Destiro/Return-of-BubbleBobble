/**
 *  Player class, to control / draw player & lives
 */
class Player {
  String name;
  float TILE_SIZE = width/20;
  
  //Loading images
  PImage p1 = loadImage("images/player1.png");
  PImage p2 = loadImage("images/player2.png");
  PImage p1_t = loadImage("images/player1_t.png");
  PImage p2_t = loadImage("images/player2_t.png");
  PImage heart = loadImage("images/heart.png");
  
  //Player variables
  String side;
  PVector pos, vel, acc;
  int player, lives;
  float SIZE = width/12.8;
  float cSize = SIZE/2;
  float graceTime;
  int kills, items, deaths;
  
  //Constructor
  Player(int p, float x, float y, int l, String s) {
    this.player =  p;
    this.pos = new PVector(x, y);
    this.lives = l;
    this.side = s;
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.graceTime = 0;
    this.kills = 0;
    this.deaths = 0;
    this.items = 0;
  }

  //Draws the player, in orientation
  void drawPlayer() {
    checkEdge();
    if (player == 1 && side == "normal") image(p1, pos.x-cSize, (pos.y-cSize)+2, SIZE, SIZE);
    if (player == 1 && side == "turned") image(p1_t, pos.x-cSize, (pos.y-cSize)+2, SIZE, SIZE); 
    if (player == 2 && side == "normal") image(p2, pos.x-cSize, (pos.y-cSize)+2, SIZE, SIZE); 
    if (player == 2 && side == "turned") image(p2_t, pos.x-cSize, (pos.y-cSize)+2, SIZE, SIZE);
  }

  //Displays lives of both players 
  void displayLives() {
    if (player == 1) {
      for (int i=0; i<lives; i++) {
        image(heart, 10+(SIZE*0.9*i), height/30, SIZE*0.75, SIZE*0.75);
      }
    } else {
      for (int i=0; i<lives; i++) {
        image(heart, width-(SIZE*0.9*(i+1)), height/30, SIZE*0.75, SIZE*0.75);
      }
    }
  }

  //Checks if players are over an edge of the map
  void checkEdge() {
    //If they touching a wall
    if (lives > 0) {
      if ((pos.x+cSize)+3 > width-TILE_SIZE) { 
        pos.x = (width-TILE_SIZE-cSize)-3;
      }
      if ((pos.x-cSize)-3 < TILE_SIZE) { 
        pos.x = (TILE_SIZE+cSize)+3;
      }
      if ((pos.y+vel.y)-cSize > height-TILE_SIZE) { 
        pos.y = (height-TILE_SIZE-cSize)-1; 
        vel.y = 0;
      }
      if ((pos.y+vel.y)+cSize < TILE_SIZE*4) {
        pos.y = ((TILE_SIZE*4)-cSize)+1; 
        vel.y = 0;
      }
    }
  }

  //Move players with velocity acting
  //Gives sliding effect
  void move() {
    //X velocity
    if (vel.x > -0.01 && vel.x < 0.01) {
      vel.x = 0;
    } else if (vel.x < 0) { 
      vel.x += 0.05;
    } else if (vel.x > 0) { 
      vel.x -= 0.05;
    } 

    //Acceleration
    if (vel.y == 0) { 
      acc.y = 0;
    } else {
      acc.y += 0.05;
    }

    pos.x += vel.x;
    pos.y += vel.y;
    vel.y += acc.y;
  }

  //Live reducing methods
  void reduceLife() {
    //Only lose life, if 3seconds after last hit
    if (millis() > graceTime+3000) {
      lives --;
      setGraceTime();
    }
  }

  void addLife() {
    lives ++;
  }

  //Sets last time of being hit
  void setGraceTime() {
    graceTime = millis();
  }

  //Getters & Setters
  float getYvel() { return vel.y; }

  float getYpos() { return pos.y; }

  float getXpos() { return pos.x; }

  float getCharSize() { return cSize; }

  String getSide() { return side; }

  void setYvel(float y) { vel.y = y; }

  void addYvel(float y) { vel.y += y; }

  void setXvel(float x) {
    vel.x = x;
    //Change player side
    if (vel.x > 0) { 
      side = "normal";
    }
    if (vel.x < 0) { 
      side = "turned";
    }
  }

  void setYpos(float y) { pos.y = y; }

  void setXpos(float x) { pos.x = x; }

  void addKill() { kills ++; }

  int getKills() { return kills; }
  
  void addDeath() { deaths ++; }

  int getDeaths() { return deaths; }

  int getLives() { return lives; }
  
  int getItems() { return items; }
  
  void addItem(){ items++; }
}
