/**
 * Class for tile types, drawing tiles from .txt files
 */
class Tile {
  String type;
  float centerX, centerY;
  boolean touch;
  PImage wall1 = loadImage("images/wall1.png");
  PImage wall2 = loadImage("images/wall2.png");
  PImage wall0 = loadImage("images/wall0.png");

  //Constructor
  Tile(String t, boolean to, float x, float y) {
    this.type = t;
    this.touch = to;
    this.centerX = x;
    this.centerY = y;
  }

  //Drawing the tile
  void drawTile(float left, float top, float size) {
    if (type != "empty") {
      if(level%3 == 0){
        image(wall0, left, top, size, size);
      } else if(level%3 == 1){
        image(wall1, left, top, size, size);
      } else {
        image(wall2, left, top, size, size);
      }
    }
  }

  //checks both sides of tile if player character is on
  //Checks if pos + vel is on the tile, if so they are inside on next tick
  boolean onTopTile(float left, float top, float size, float yPos, float xPos, float yVel, float cSize) {
    if (type != "empty") {
      if (xPos-(cSize-2) < left+size && xPos+(cSize+2) > left && yPos+cSize+yVel > top && yPos+cSize+yVel < top+size) {
        touch = true;
        return true;
      } else { 
        touch = false;
      }
    }
    return false;
  }
}
