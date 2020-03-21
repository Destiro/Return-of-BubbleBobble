//Game Variables
public int level = 1;
int gameState = 0;
int score = 0;
int rows = 18;
int cols = 20;
float radius = 30;
float colour = 0;
Button back;
float TILE_SIZE;

//Player Variables
int charWidth = 40;
PVector vel1, pos1, acc1, vel2, pos2, acc2;
PImage title, instructions;
PFont font, font2;
float bubbleTime1 = 0;
float bubbleTime2 = 0;
boolean death1 = false;
boolean death2 = false;

//Lists
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Item> items = new ArrayList<Item>();
ArrayList<Item> itemRemoval = new ArrayList<Item>();
ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Enemy> enemiesRemoval = new ArrayList<Enemy>();
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
ArrayList<Bubble> bubbleRemoval = new ArrayList<Bubble>();
Tile[][] tiles = new Tile[rows][cols];
boolean[] keys = { 
  false, false, false, false, false, false, false, false
};

//Setup the GUI and variables
void setup() {
  size(900, 900);
  TILE_SIZE = width/20;
  frameRate(60);
  font = createFont("Verdana Bold", width/18);
  font2 = createFont("Verdana Bold", width/24);

  //Loading Buttons
  Button oneplayer = new Button(width/2, height/2, height/11, width/3, 
    "oneplayer.png", "oneplayer_h.png", "onePlayer");
  Button twoplayer = new Button(width/2, height/1.6, height/11, width/3, 
    "twoplayer.png", "twoplayer_h.png", "twoPlayer");
  Button controls = new Button(width/2, height/1.33, height/11, width/3, 
    "controls.png", "controls_highlighted.png", "controls");
  Button quit = new Button(width/2, height/1.14, height/11, width/4, 
    "quit.png", "quit_highlighted.png", "quit");
  back = new Button(width/1.25, height/1.09, height/11, width/4, 
    "back.png", "back_h.png", "back");
  buttons.add(oneplayer);
  buttons.add(twoplayer);
  buttons.add(controls);
  buttons.add(quit);
  println("Home page");
}

//Main Function
void draw() {
  background(255, 100, 200);
  fill(250, 250, 250);
  strokeWeight(3);
  rect(width/7, 0, width*5/7, height-4);

  //Home Page gamestate
  if (gameState == 0) {
    image(loadImage("images/title.png"), width/6, height/20, width*4/6, height/3);
    for (int i=0; i<buttons.size(); i++) {
      buttons.get(i).drawButton();
      String press = buttons.get(i).isPress();
      if (press == "quit") { 
        exit();
      } else if (press == "controls") { 
        gameState = 1;
      } else if (press == "onePlayer") { 
        Player p1 = new Player(1, width/10, height*11/12, 4, "normal");
        players.add(p1);
        gameState = 2;
        doLoad();
      } else if (press == "twoPlayer") { 
        Player p1 = new Player(1, width/10, height*11/12, 3, "normal");
        players.add(p1);
        Player p2 = new Player(2, width*9/10, height*11/12, 3, "normal");
        players.add(p2);
        gameState = 2;
        doLoad();
      }
      if (press == "onePlayer" || press == "twoPlayer") { //Adding enemies
        enemies.add(new Enemy("ghost", random(width/2.3, width/1.7), height/5, "normal"));
        for (int h=0; h<3; h++) {
          enemies.add(new Enemy("monsta", random(width/2.3, width/1.7), height/5, "normal"));
        }
      }
    }
  //Controls menu gamestate
  } else if (gameState == 1) { 
    background(255, 100, 200);
    fill(250, 250, 250);
    strokeWeight(3);
    rect(0, height/7, width, height*5/7);
    image(loadImage("images/controls_menu.png"), width/5, height/35, width*3/5, height/10);
    image(loadImage("images/instructions.png"), 0, height/5, width, height*3/5);

    back.drawButton();
    if (back.isPress() == "back") { 
      gameState = 0;
    }
  //Playing game gamestate
  } else if (gameState == 2) {
    //Redraw Level
    if (level%3 == 0) { //Change BG colour based on lvl
      background(200, 240, 180);
      fill(20, 150, 20);
    } else if (level%3 == 1) {
      background(255, 220, 240);
      fill(250, 20, 20);
    } else {
      background(210, 210, 255);
      fill(20, 20, 250);
    }
    drawLevel();
    textFont(font);
    textAlign(CENTER);
    text("Level: "+level, width/2, height/15);

    //If all players run out of lives
    updateLives();

    //Player movement/Variables
    checkPlatform();
    for (Player p : players) {
      p.move();
      p.drawPlayer();
      p.displayLives();
    }

    //Enemy movement/Variables
    for (Enemy e : enemies) {
      //Moving enemies
      if (e.getType() == "monsta") {
        e.moveMonsta();
      } else {
        if (players.size() == 2) {
          e.move(players.get(0).getXpos(), players.get(0).getYpos(), 
            players.get(1).getXpos(), players.get(1).getYpos());
        } else {
          e.move(players.get(0).getXpos(), players.get(0).getYpos(), 
            0, 0);
        }
      }
      //Checking if intersect, reduce lives
      for (Player p : players) {
        if (e.isIntersect(p.getXpos(), p.getYpos())) {
          p.reduceLife();
        }
      }
      e.drawEnemy();
    }

    //Interact bubbles with players, enemies, items, walls
    for (Bubble b : bubbles) {
      b.drawBubble();
      if (b.getType() == "trapped") {
        for (Player p : players) {
          if (b.isIntersect(p.getXpos(), p.getYpos())) {
            items.add(new Item(b.getXpos(), b.getYpos(), (int)random(1, 4)));
            bubbleRemoval.add(b);
            if (b.getColour() == "green") {
              players.get(0).addKill();
            } else if (b.getColour() == "blue") {
              players.get(1).addKill();
            }
          }
        }
      } 
      if (b.checkEdge()) {
        bubbleRemoval.add(b);
        if (b.getType() == "trapped") {
          items.add(new Item(b.getXpos(), b.getYpos(), (int)random(1, 4)));
        }
        if (b.getColour() == "green" && b.getType() == "trapped") {
          players.get(0).addKill();
        } else if (b.getColour() == "blue" && b.getType() == "trapped") {
          players.get(1).addKill();
        }
      }
      if (b.getType() == "empty") {
        for (Enemy e : enemies) {
          if (e.isIntersect(b.getXpos(), b.getYpos())) {
            b.setEnemyTrapped();
            enemiesRemoval.add(e);
          }
        }
      }
    }
    bubbles.removeAll(bubbleRemoval);
    enemies.removeAll(enemiesRemoval);

    for (Item i : items) {
      i.checkEdge();
      i.drawItem();
      for (Player p : players) {
        if (i.isIntersect(p.getXpos(), p.getYpos())) {
          p.addItem();
          itemRemoval.add(i);
        }
      }
    }
    items.removeAll(itemRemoval);

    //If all enemies are killed then switch level
    updateLevel();
  //End screen gamestate
  } else if (gameState == 3) {
    //Drawing the background
    background(250, 250, 250);
    fill(255, 100, 200);
    strokeWeight(3);
    fill(143, 21, 183);
    rect(0, 0, width/7, height-4);
    rect(width*6/7, 0, width, height-4);
    fill(255, 100, 200);
    rect(0, 0, width, height/7);
    rect(0, height*6/7, width, height);
    
    //Displaying info from players
    image(loadImage("images/game_over.png"), width/5, height/35, width*3/5, height/10);
    textFont(font);
    fill(0);
    textAlign(CENTER);
    text("Level Reached: "+level, width/2, height*2/9);
    textFont(font2);
    text("Player 1 kills: "+players.get(0).getKills(), width/2, height*5/16);
    text("Player 1 items: "+players.get(0).getItems(), width/2, height*6/16);
    text("Player 1 deaths: "+players.get(0).getDeaths(), width/2, height*7/16);
    if (players.size() == 2) {
      text("Player 2 kills: "+players.get(1).getKills(), width/2, height*9/16);
      text("Player 2 items: "+players.get(1).getItems(), width/2, height*10/16);
      text("Player 2 deaths: "+players.get(1).getDeaths(), width/2, height*11/16);
    }
    textFont(font);
    text("Total Score: "+score, width/2, height*7/9);
    back.drawButton();
    if (back.isPress() == "back") { 
      reset();
      players.clear();
      gameState = 0;
      level = 1;
      score = 0;
    }
  }
}

//Resets the world and variables
void reset() {
  enemies.clear();
  bubbles.clear();
  bubbleRemoval.clear();
  enemiesRemoval.clear();
  items.clear();
  doLoad();
}

//Sets key as pressed
void keyPressed() {
  if (keyCode == UP) keys[0] = true; 
  if (keyCode == LEFT) keys[1] = true; 
  if (keyCode == RIGHT) keys[2] = true;
  if (key == 'w') keys[3] = true;
  if (key == 'a') keys[4] = true;
  if (key == 'd') keys[5] = true;
  if (key == 'c') keys[6] = true;
  if (key == ' ') keys[7] = true;
  activatedKeys();
}

//Unsets key as pressed
void keyReleased() {
  if (keyCode == UP) keys[0] = false; 
  if (keyCode == LEFT) keys[1] = false; 
  if (keyCode == RIGHT) keys[2] = false;
  if (key == 'w') keys[3] = false;
  if (key == 'a') keys[4] = false;
  if (key == 'd') keys[5] = false;
  if (key == 'c') keys[6] = false;
  if (key == ' ') keys[7] = false;
  activatedKeys();
}

//Moves the pressed keys from list
//Allows the user to hold keys, and press others simultaneosly
void activatedKeys() {
  if (players.size() == 2) {
    if (keys[0]) {
      if (players.get(1).getYvel() == 0) {
        players.get(1).setYvel(-height/60);
      }
    }
    if (keys[1]) {
      players.get(1).setXvel(-width/257);
    }
    if (keys[2]) {
      players.get(1).setXvel(width/257);
    }
    if (keys[7]) {
      if (millis() > bubbleTime2+500) {
        bubbles.add(new Bubble(players.get(1).getXpos(), 
          players.get(1).getYpos(), players.get(1).getSide(), "blue"));
        bubbleTime2 = millis();
      }
    }
  }
  if (keys[3]) {
    if (players.get(0).getYvel() == 0) {
      players.get(0).setYvel(-height/60);
    }
  }
  if (keys[4]) {
    players.get(0).setXvel(-width/257);
  }
  if (keys[5]) {
    players.get(0).setXvel(width/257);
  }
  if (keys[6]) {
    if (millis() > bubbleTime1+500) {
      bubbles.add(new Bubble(players.get(0).getXpos(), 
        players.get(0).getYpos(), players.get(0).getSide(), "green"));
      bubbleTime1 = millis();
    }
  }
}

//Checks if players have died, adds deaths and creates score
void updateLives() {
  if (players.size() == 2) {
    if (players.get(0).getLives() <= 0 && players.get(1).getLives() <= 0) {
      gameState = 3;
      if (!death2) {
        players.get(1).addDeath();
        death2 = true;
      }
      if (!death1) {
        players.get(0).addDeath();
        death1 = true;
      }
      score = millis()/10000 + players.get(0).getKills() + players.get(1).getKills() 
        + players.get(0).getItems() + players.get(1).getItems()
        - players.get(0).getDeaths() - players.get(1).getDeaths();
    } else if (players.get(0).getLives() <= 0) { 
      players.get(0).setXpos(10000);
      if (!death1) {
        players.get(0).addDeath();
        death1 = true;
      }
    } else if (players.get(1).getLives() <= 0) {
      players.get(1).setXpos(10000);
      if (!death2) {
        players.get(1).addDeath();
        death2 = true;
      }
    }
  } else {
    if (players.get(0).getLives() <= 0) {
      gameState = 3;
      players.get(0).addDeath();
      score = millis()/100000 + players.get(0).getKills() 
        + players.get(0).getItems() - 1;
    }
  }
}

//Update Level, checks if all enemies/bubbles gone
//then creates new world & resets variables
void updateLevel() {
  if (enemies.size() <= 0) {
    int trapped = 0;
    for (Bubble b : bubbles) {
      if (b.getType() == "trapped") trapped++;
    }
    if (trapped == 0) {
      level ++;
      reset();
      death1 = false;
      death2 = false;
      if (players.size() == 2) {
        players.get(1).setXpos(width*9/10); 
        players.get(1).setYpos(height*11/12);
        if (players.get(1).getLives() <= 0) { 
          players.get(1).addLife();
        }
      }
      players.get(0).setXpos(width/10); 
      players.get(0).setYpos(height*11/12);
      if (players.get(0).getLives() <= 0) { 
        players.get(0).addLife();
      }

      enemies.add(new Enemy("ghost", random(width/2.3, width/1.7), height/5, "normal"));
      for (int h=0; h<3+level; h++) {
        enemies.add(new Enemy("monsta", random(width/2.3, width/1.7), height/5, "normal"));
      }
    }
  }
}


//Reads a file to get level layout, stores tile type as Tile
void doLoad() {
  ArrayList<String> lines = new ArrayList<String>();
  try {
    BufferedReader b = createReader("levels/level" + level%5 + ".txt");
    String line;
    while ((line = b.readLine()) != null) {
      lines.add(line);
    }
    b.close();
  } 
  catch(IOException e) {
    println("File error: " + e);
  }

  for (int row = 0; row < rows; row++) {
    String line = lines.get(row);
    for (int col = 0; col < cols; col++) {
      char ch = line.charAt(col);
      if (ch=='.') tiles[row][col] = new Tile("empty", false, TILE_SIZE*(row+2)+(TILE_SIZE/2), col*TILE_SIZE+(TILE_SIZE/2));
      else if (ch=='#') tiles[row][col] = new Tile("wall", false, TILE_SIZE*(row+2)+(TILE_SIZE/2), col*TILE_SIZE+(TILE_SIZE/2));
      else { 
        throw new RuntimeException( "Invalid char at "+row+","+col+"="+ch);
      }
    }
  }
} 

//Checks if the player is over a platform
//if they are, dont fall through, pos = platform top
void checkPlatform() {
  for (Player p : players) {
    boolean under = false;
    for (int row = 0; row<rows; row++) {
      for (int col = 0; col<cols; col++) {
        //They are over a platform from jumping
        if ( p.getYvel() > 0 && tiles[row][col].onTopTile(TILE_SIZE*col, TILE_SIZE*(row+2), 
          TILE_SIZE, p.getYpos(), p.getXpos(), p.getYvel(), p.getCharSize())) {
          p.setYpos(TILE_SIZE*(row+2)-p.getCharSize());
          p.setYvel(0);
          under = true;

          //They are over platform whilst standing on platform
        } else if (tiles[row][col].onTopTile(TILE_SIZE*col, TILE_SIZE*(row+2), 
          TILE_SIZE, p.getYpos(), p.getXpos(), p.getCharSize(), p.getCharSize())) {
          under = true;
        }

        //Checks items
        for (Item i : items) {
          if ( i.getYvel() > 0 && tiles[row][col].onTopTile(TILE_SIZE*col, TILE_SIZE*(row+2), 
            TILE_SIZE, i.getYpos(), i.getXpos(), i.getYvel(), i.getCharSize())) {
            i.setYpos(TILE_SIZE*(row+2)-i.getCharSize());
            i.setYvel(0);
          }
        }
      }
    }

    //They arent over a platform, increase falling
    if ((!under) && p.getYvel() >= 0) {
      p.addYvel(0.1);
    }
  }
}

//Draws the level
void drawLevel() {
  for (int row = 0; row<rows; row++) 
    for (int col = 0; col<cols; col++) 
      tiles[row][col].drawTile(TILE_SIZE*col, TILE_SIZE*(row+2), TILE_SIZE);
}
