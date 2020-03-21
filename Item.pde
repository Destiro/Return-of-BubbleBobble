/**
 *  Enemy class, gotta draw, and move based
 *  on player pos and stuff 
 */
class Item {
  float TILE_SIZE = width/20;
  PImage item3 = loadImage("images/item1.png");
  PImage item2 = loadImage("images/item2.png");
  PImage item1 = loadImage("images/item3.png");

  //Player variables
  String type;
  PVector pos, vel, acc;
  float SIZE = width/18;
  float charSize = SIZE/2;

  //Constructor
  Item(float x, float y, int t) {
    if(t == 1){ this.type =  "item1"; }
    else if(t == 2){ this.type =  "item2"; }
    else if(t == 3){ this.type =  "item3"; }
    this.pos = new PVector(x, y-width/30);
    this.vel = new PVector(random(-4, 4), 0.1);
    this.acc = new PVector(0, 0);
  }

  //Draws the Item
  void drawItem() {
    if (type == "item1") 
      image(item1, pos.x-SIZE/1.5, (pos.y-charSize), SIZE*1.5, SIZE); 
    if (type == "item2") 
      image(item2, pos.x-charSize, (pos.y-charSize), SIZE, SIZE);
    if (type == "item3") 
      image(item3, pos.x-charSize, (pos.y-charSize), SIZE, SIZE);
  }

  //Checks if Item touching a wall
  void checkEdge() {
    moveItem();
    //If they touching a wall
    if ((pos.x+charSize)+3 > width-TILE_SIZE) { 
      pos.x = (width-TILE_SIZE-charSize)-3;
    }
    if ((pos.x-charSize)-3 < TILE_SIZE) { 
      pos.x = (TILE_SIZE+charSize)+3;
    }
    if ((pos.y+vel.y)-charSize > height-TILE_SIZE) { 
      pos.y = (height-TILE_SIZE-charSize)-1; 
      vel.y = 0;
    }
  }

  //Moves Item with velocities acting
  void moveItem() {
    //X velocity
    if (vel.x > -0.03 && vel.x < 0.03) {
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
  
  //Checks whether Player picked up item
  boolean isIntersect(float x, float y){
    if(x < pos.x+charSize && 
    x > pos.x-charSize && 
    y > pos.y-charSize && 
    y < pos.y+charSize){
      return true;
    }
    return false;
  }
  
  //Getters & Setters
  float getYvel() { return vel.y; }

  float getYpos() { return pos.y; }

  float getXpos() { return pos.x; }

  float getCharSize() { return charSize; }

  void setYvel(float y) { vel.y = y; }
  
  void setYpos(float y) { pos.y = y; }
}
