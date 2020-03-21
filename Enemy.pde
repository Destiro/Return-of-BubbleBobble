/**
 *  Enemy class, gotta draw, and move based
 *  on player pos and stuff 
 */
class Enemy {
  float TILE_SIZE = width/20;
  PImage b = loadImage("images/buster.png");
  PImage b_t = loadImage("images/buster_t.png");
  PImage g = loadImage("images/ghost.png");
  PImage g_t = loadImage("images/ghost_t.png");
  PImage m = loadImage("images/monsta.png");
  PImage m_t = loadImage("images/monsta_t.png");
  
  //Player variables
  String type;
  String side;
  PVector pos, vel, acc;
  float SIZE = width/12.8;
  float center = SIZE/2;

  //Constructor
  Enemy(String t, float x, float y, String s) {
    this.type =  t;
    this.pos = new PVector(x, y);
    this.side = s;
    if(t != "monsta"){this.vel = new PVector(0, 0);}
    else{ this.vel = new PVector(random(-4, 4), random(-4, 4)); }
    this.acc = new PVector(0, 0);
  }

  //Draws the player, in orientation
  void drawEnemy() {
    if(type != "monsta"){ checkEdge(); }
    if (type == "ghost" && side == "normal") image(g, pos.x-center, pos.y-center, SIZE, SIZE);
    if (type == "ghost" && side == "turned") image(g_t, pos.x-center, pos.y-center, SIZE, SIZE); 
    if (type == "buster" && side == "normal") image(b, pos.x-center, pos.y-center, SIZE, SIZE); 
    if (type == "buster" && side == "turned") image(b_t, pos.x-center, pos.y-center, SIZE, SIZE);
    if (type == "monsta" && side == "normal") image(m, pos.x-center, pos.y-center, SIZE, SIZE); 
    if (type == "monsta" && side == "turned") image(m_t, pos.x-center, pos.y-center, SIZE, SIZE);
  }

  //Checks if enemies are over an edge, if so stop them :D
  void checkEdge() {
    //If they touching a wall
    if ((pos.x+center)+3 > width-TILE_SIZE) { 
      pos.x = (width-TILE_SIZE-center)-3;
    }
    if ((pos.x-center)-3 < TILE_SIZE) { 
      pos.x = (TILE_SIZE+center)+3;
    }
    if ((pos.y+vel.y)-center > height-TILE_SIZE) { 
      pos.y = (height-TILE_SIZE-center)-1; 
      vel.y = 0;
    }
    if ((pos.y+vel.y)+center < TILE_SIZE*4) {
      pos.y = ((TILE_SIZE*4)-center)+1; 
      vel.y = 0;
    }
  }

  //Enemy movement for ghost/buster
  //movement takes into account player pos
  void move(float x1, float y1, float x2, float y2) {
    //Finding closest distance between 
    float dist1 = sqrt(sq(x1-pos.x)+sq(y1-pos.y));
    float dist2;
    if (x2 != 0) {
      dist2 = sqrt(sq(x2-pos.x)+sq(y2-pos.y));
    } else { 
      dist2 = 10000;
    }

    //Ghost movement, can go through platforms
    if (type == "ghost") {
      if (dist1<dist2) {
        if (pos.x > x1) { 
          pos.x -= width/600; 
          side="turned";
        } else if (pos.x < x1) { 
          pos.x += width/600; 
          side="normal";
        }
        if (pos.y > y1) { 
          pos.y -= height/600;
        } else if (pos.y < y1) { 
          pos.y += height/600;
        }
      } else {
        if (pos.x > x2) { 
          pos.x -= width/600; 
          side="turned";
        } else if (pos.x < x2) { 
          pos.x += width/600; 
          side="normal";
        }
        if (pos.y > y2) { 
          pos.y -= height/600;
        } else if (pos.y < y2) { 
          pos.y += height/600;
        }
      }
    }
  }
  
  //Monsta moves diagonally, 
  //If touching a wall, change direction
  void moveMonsta(){
    //If they touching a wall
    if ((pos.x+center)+3 > width-TILE_SIZE) { 
      pos.x = (width-TILE_SIZE-center)-3;
      vel.x = -vel.x;
      side = "turned";
    }
    if ((pos.x-center)-3 < TILE_SIZE) { 
      pos.x = (TILE_SIZE+center)+3;
      vel.x = -vel.x;
      side = "normal";
    }
    if ((pos.y+vel.y)+center > height-TILE_SIZE) { 
      pos.y = (height-TILE_SIZE-center)-1; 
      vel.y = -vel.y;
    }
    if ((pos.y+vel.y)-center < TILE_SIZE*3) {
      pos.y = ((TILE_SIZE*3)+center)+1; 
      vel.y = -vel.y;
    }
    
    pos.x += vel.x;
    pos.y += vel.y;
  }
  
  /**
  * Checks whether Enemy is overlapping a player
  */
  boolean isIntersect(float x, float y){
    if(x < pos.x+center && 
    x > pos.x-center && 
    y > pos.y-center && 
    y < pos.y+center){
      return true;
    }
    return false;
  }
    
  
  //Returns enemy type
  String getType(){ return type; }
    
}
