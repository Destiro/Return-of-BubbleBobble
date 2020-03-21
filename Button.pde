/**
 *  Button class for homepage / controls
 */
class Button {
  String name;
  PImage img, img_h;
  float centerX, centerY, buttonWidth, buttonHeight;
  int gameState = 0;
  int players = 0;

  //Constructor
  Button(float x, float y, float h, float w, String i, String ih, String name) {
    this.centerX =  x;
    this.centerY = y;
    this.buttonWidth = w;
    this.buttonHeight = h;
    this.img = loadImage("images/"+i);
    this.img_h = loadImage("images/"+ih);
    this.name = name;
  }

  //Draws the Button
  void drawButton() {
    image(img, centerX-(buttonWidth/2), centerY-(buttonHeight/2), 
      buttonWidth, buttonHeight);
  }

  //Checks if hovering over button, if so draw hovered button
  String isPress() {
    if (mouseX >= centerX-(buttonWidth/2) && mouseX <= centerX+buttonWidth/2
      && mouseY >= centerY-(buttonHeight/2) && mouseY <= centerY+buttonHeight/2) {
      image(img_h, centerX-(buttonWidth/2), centerY-(buttonHeight/2), 
        buttonWidth, buttonHeight);
      if (mousePressed) {
        println("Menu " + name);
        return name;
      }
    }
    return "";
  }
  
}
