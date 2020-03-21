/**
 *  Bubble class, detects if enemy touched
 *  draws, changes state to trapped
 */
class Bubble {
  float TILE_SIZE = width/20;
  PImage blueb = loadImage("images/blueb.png");
  PImage blueb_t = loadImage("images/blueb_t.png");
  PImage greenb = loadImage("images/greenb.png");
  PImage greenb_t = loadImage("images/greenb_t.png");

  //Movement variables
  String type;
  String colour;
  PVector pos, vel, acc;
  float SIZE = width/15;

  //Constructor
  Bubble(float x, float y, String s, String c) {
    this.type =  "empty";
    this.pos = new PVector(x, y);
    if(s == "turned"){ this.vel = new PVector(-5, 0); }
    else{ this.vel = new PVector(5, 0); }
    this.colour = c;
  }

  //Draws the bubble
  void drawBubble() {
    //checkEdge();  
    if (type == "empty" && colour == "green") 
    image(greenb, pos.x-SIZE/2, (pos.y-SIZE/2), SIZE, SIZE); 
    if (type == "trapped" && colour == "green") 
    image(greenb_t, pos.x-SIZE/2, (pos.y-SIZE/2), SIZE, SIZE);
    if (type == "empty" && colour == "blue") 
    image(blueb, pos.x-SIZE/2, (pos.y-SIZE/2), SIZE, SIZE); 
    if (type == "trapped" && colour == "blue") 
    image(blueb_t, pos.x-SIZE/2, (pos.y-SIZE/2), SIZE, SIZE);
  }
  
  //If touching an edge, delete bubble
  boolean checkEdge() {
    moveBubble();
    
    //If they touching a wall
    if ((pos.x+SIZE/2)+3 > width-TILE_SIZE) {
      return true;
    }
    if ((pos.x-SIZE/2)-3 < TILE_SIZE) { 
      return true;
    }
    if ((pos.y+vel.y)-SIZE/2 > height-TILE_SIZE) { 
      return true;
    }
    if ((pos.y+vel.y)+SIZE/2 < TILE_SIZE*4) {
      return true;
    }
    return false;
  }
  
  //Checks whether Player popped bubble
  boolean isIntersect(float x, float y){
    if(x < pos.x+SIZE/2 && 
    x > pos.x-SIZE/2 && 
    y > pos.y-SIZE/2 && 
    y < pos.y+SIZE/2){
      return true;
    }
    return false;
  }
  
  //Gets and sets methods
  void setEnemyTrapped(){ 
    type = "trapped"; 
    vel.y = -3;
    vel.x = 0;
  }
  
  float getXpos(){ return pos.x; }
  
  float getYpos(){ return pos.y; }
  
  float getCharSize(){ return SIZE/2; }
  
  String getType(){ return type; }
  
  String getColour(){ return colour; }
  
  void moveBubble(){
    pos.x += vel.x;
    pos.y += vel.y;
  }
}
