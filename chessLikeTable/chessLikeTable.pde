boolean white;

//GridSquare[][] grid;

BlackSquare[][] blackArray;
WhiteSquare[][] whiteArray;

int rows;
int cols;
int gridSquareSize;

void setup() {

  size(400, 400);
  noStroke();
  rows = 8;
  cols = 8;
  gridSquareSize = 50;
  white = true;
  
  blackArray = new BlackSquare[cols][rows];
  whiteArray = new WhiteSquare[cols][rows];
  

  //grid = new GridSquare[cols][rows];
  
  // do a double for loop to run through the grid 2D array
  // creating new alternating black and white GridSquare objects
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      
      if(white){
        whiteArray[i][j] = new WhiteSquare(i,j,gridSquareSize);
      }
      else{
        blackArray[i][j] = new BlackSquare(i,j,gridSquareSize, white);
      }
      //grid[i][j] = new GridSquare(i, j, gridSquareSize, white);
      white = !white;
    }
    white = !white;
  }
}

void draw() {
  
  // every time draw runs, we want to go through the grid 2d array and update and render each GridSquare object
  // update represents getting hungry
  // render takes care of drawing
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++){
      if(blackArray[i][j] != null){
      blackArray[i][j].update();
      blackArray[i][j].render();
      }
      
      if(whiteArray[i][j] != null){
         whiteArray[i][j].update();
         whiteArray[i][j].render();
      }
    }
  }
  
  // determine which gid slot mouse is over
  int currentHorizSquare = mouseX / 50;
  int currentVertSquare = mouseY / 50;

  // do mouseOver-based feeding only on **valid** grid slots
  if (currentHorizSquare >= 0 && currentHorizSquare <= 7 && currentVertSquare >= 0 && currentVertSquare <= 7) {
    if(blackArray[currentHorizSquare][currentVertSquare] != null){
      blackArray[currentHorizSquare][currentVertSquare].feed();
    }
    else if(whiteArray[currentHorizSquare][currentVertSquare] != null){
     whiteArray[currentHorizSquare][currentVertSquare].feed();
    }
  }
}