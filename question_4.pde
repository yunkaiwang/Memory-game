final int numCol=4;
final int numRow=3;
int numTilesLefted=12;
PFont font;
class tile
{
  int buttonX;
  int buttonY;
  final int buttonWidth=width/numCol;
  final int buttonHeight=height/numRow;
  final int imageWidth=width/numCol-6;
  final int imageHeight=height/numRow-6;
  int inWidth=width/numCol;
  int inHeight=height/numRow;
  int offWidth=0;
  int offHeight=0;
  boolean clickFirst;
  boolean clickSecond;
  boolean cleared;
  boolean pictureIn;
  boolean pictureOff;
  int imageIndex;
  //the images for this programming
  PImage[] images=
  {
    loadImage("animal.jpg"),
    loadImage("elephant.jpg"),
    loadImage("mouse.jpg"),
    loadImage("pig.jpg"),
    loadImage("rabbit.jpg"),
    loadImage("tiger.jpg"),
  };
  tile(int x,int y,boolean isClicked1,boolean isClicked2,boolean beenCleared,boolean in,boolean off)
  {
    buttonX=x;
    buttonY=y;
    imageIndex=-1;
    clickFirst=isClicked1;
    clickSecond=isClicked2;
    cleared=beenCleared;
    in=pictureIn;
    off=pictureOff;
  }
}
tile[][] value;
//the variable that is telling us which tile is clicked first and which is clicked second
tile clickFirst,clickSecond;
//the variable that tells us if a tile has been clicked first or a tile has been clicked second
boolean noFirstOneHaveBeenClicked;
boolean noSecondOneHaveBeenClicked;
//the array that used to control the maximum number of each image
int[] numberOfIndex=new int[6];
void setup()
{
  size(400,300);
  font=loadFont("Serif.plain-48.vlw");
  textFont(font,50);
  value=new tile[numRow][numCol];
  noFirstOneHaveBeenClicked=true;
  noSecondOneHaveBeenClicked=true;
  giveValue();
}

void draw()
{
  background(255);
  for (int m=0;m<numRow;m++)
  {
    for (int n=0;n<numCol;n++)
    {
      display(value[m][n]);
    }
  }
  //if win, show the win text
  if (numTilesLefted==0)
  {
    backgroundText();
  }
}
//the function that gives values
void giveValue()
{
  for (int m=0;m<numberOfIndex.length;m++)
  {
    numberOfIndex[m]=0;
  }
  for (int m=0;m<numRow;m++)
  {
    for (int n=0;n<numCol;n++)
    {
      value[m][n]=new tile(n*width/numCol,
                            m*height/numRow,
                            false,false,false,false,false);
      value[m][n].imageIndex=(int)random(6);
      int a=value[m][n].imageIndex;
      numberOfIndex[a]+=1;
      //keep the num of each number to 2
      while (numberOfIndex[a]>2)
      {
        if (a>0)
        {
          numberOfIndex[a]-=1;
          a-=1;
          value[m][n].imageIndex=a;
          numberOfIndex[a]+=1;
        }
        else
        {
          numberOfIndex[a]-=1;
          a=5;
          value[m][n].imageIndex=a;
          numberOfIndex[a]+=1;
        }
      }
    }
  }
}
//draw the tiles
void display(tile t)
  {
    //if the tile has been clicked or the tile has been cleared, show the tile
    fill(255);
    rectMode(CORNER);
    rect(t.buttonX,t.buttonY,t.buttonWidth,t.buttonHeight);
    if ((t.clickFirst||t.clickSecond)||t.cleared)
      image(t.images[t.imageIndex],t.buttonX+3,t.buttonY+3,t.imageWidth,t.imageHeight);
    if (t.pictureIn)
    {
      rectMode(CENTER);
      rect(t.buttonX+t.buttonWidth/2,t.buttonY+t.buttonHeight/2,t.inWidth,t.inHeight);
      t.inWidth=t.inWidth-1;
      t.inHeight=t.inHeight-1;
      if (t.inWidth==0)
      {
        t.pictureIn=false;
        t.inWidth=width/numCol;
        t.inHeight=height/numRow;
      }
    }
    if (t.pictureOff)
    {
      rectMode(CENTER);
      image(t.images[t.imageIndex],t.buttonX+3,t.buttonY+3,t.imageWidth,t.imageHeight);
      rect(t.buttonX+t.buttonWidth/2,t.buttonY+t.buttonHeight/2,t.offWidth,t.offHeight);
      t.offWidth=t.offWidth+1;
      t.offHeight=t.offHeight+1;
      if (t.offWidth==width/numCol)
      {
        t.pictureOff=false;
        t.offWidth=0;
        t.offHeight=0;
      }
    }
  }
void mouseClicked()
{
  if (numTilesLefted!=0)
  {
    int m=mouseY*numRow/height;
    int n=mouseX*numCol/width;
    checkTile(value[m][n]);
  }
  //if win, give a new value to the tiles
  else
  {
    giveValue();
    numTilesLefted=12;
  }
}
void checkTile(tile t)
{
  //click on the tile should make it visible and make the showed tile to be invisible if there are three tiles showing
  if (!t.clickFirst&&!t.clickSecond&&!t.cleared)
  {
    t.pictureIn=true;
    if (noFirstOneHaveBeenClicked&&noSecondOneHaveBeenClicked)
    {
      t.clickFirst=true;
      clickFirst=t;
      noFirstOneHaveBeenClicked=false;
    }
    else if (!noFirstOneHaveBeenClicked&&noSecondOneHaveBeenClicked)
    {
      t.clickSecond=true;
      clickSecond=t;
      noSecondOneHaveBeenClicked=false;
    } 
    else if (!noFirstOneHaveBeenClicked&&!noSecondOneHaveBeenClicked)
    {
      if (t.imageIndex==clickFirst.imageIndex)
      {
        t.cleared=true;
        clickFirst.cleared=true;
        noSecondOneHaveBeenClicked=true;
        clickSecond.clickSecond=false;
        clickSecond.clickFirst=true;
        clickFirst.clickFirst=false;
        clickFirst=clickSecond;
        clickSecond=null;
        numTilesLefted-=2;
      }
      else if (t.imageIndex==clickSecond.imageIndex)
      {
        t.cleared=true;
        clickSecond.cleared=true;
        noSecondOneHaveBeenClicked=true;
        clickSecond.clickSecond=false;
        clickSecond=null;
        numTilesLefted-=2;
      }
      else
      {
        clickFirst.pictureOff=true;
        clickFirst.clickFirst=false;
        clickSecond.clickSecond=false;
        clickSecond.clickFirst=true;
        t.clickSecond=true;
        clickFirst=clickSecond;
        clickSecond=t;
      }
    }
  }
  //if the two showing images are the same, remain them visible until the end
  if (checkTwoTiles())
  {
    clickFirst.cleared=true;
    clickSecond.cleared=true;
    noFirstOneHaveBeenClicked=true;
    noSecondOneHaveBeenClicked=true;
    clickFirst.clickFirst=false;
    clickSecond.clickSecond=false;
    numTilesLefted-=2;
  }
}
//check if these two tiles are the same
boolean checkTwoTiles()
{
  if (!noFirstOneHaveBeenClicked&&!noSecondOneHaveBeenClicked)
  {
    if (clickFirst.imageIndex==clickSecond.imageIndex)
    return true;
  }
  return false;
}
//the background text when the player win
void backgroundText()
{
  textSize(50);
  textAlign(CENTER,CENTER);
  fill(0);
  text("You Win",width/2,height/2);
}
