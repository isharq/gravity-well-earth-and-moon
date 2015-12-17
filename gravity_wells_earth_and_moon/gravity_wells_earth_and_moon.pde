void setup()
{
  size(1066,600);
  background(0);
  noStroke();
  smooth();
}

  float y = 90000; // initiate variables
  float x = 90000;
  float velY = 0;
  float velX = 0;
  
  float direction = 0;
  float distance = 0;
    
  float gravityReach = 255;
  
  float gravX[] = new float[1000];
  float gravY[] = new float[1000];
  
  float dotX[] = new float[90000];
  float dotY[] = new float[90000];
  float dotStrength[] = new float[90000];
  
  float moonPos = 0; 

  
  float deltaY = 0;
  float deltaX = 0;
  
  int wells = 2;
  
  int stepcounter = 0;
  
  int randomside = 0;  
  
void checkLive()  // if it's gone off the screen, let's create a new dot. 
{
   if (y > height)      { randomside = 5; }
   if (x > width)       { randomside = 5; }
   if (y < 0)           { randomside = 5; }
   if (x < 0)           { randomside = 5; }
 
   if (randomside == 5) // if it needs to be reset..
   {
     randomside = round(random(2)); randomside++; 
     float startvelocity = random(20,30)/10;

     if (randomside == 1)
     {
       x = 0; y = random(height)/3 + height*0.33 ;        velY = 0; velX = startvelocity; 
       print ("Launching from Left... with velocity "); 
       print (velX); print("\n");
       stepcounter = 0;
     }
     if (randomside == 2)
     {
       x = width; y = random(height)/3 + height*0.33;   velY = 0; velX = startvelocity*(-1); 
       print ("Launching from Right... with velocity "); 
       print (velX); print("\n");
       stepcounter = 0;
     }       
   }
   
}

void draw()
{
  
      createEarth();
      createMoon();
      drawWells();
      
      
    noStroke();
   if (stepcounter++ > 20000)
     {
       print ("Self Descructing \n");
       x = 30000;
       y = 30000;
       stepcounter = 0; 
     }
   if (stepcounter%1000 == 0) { print(stepcounter, " steps \n"); }  
      
// Let's check if the dot is still on screen
   checkLive();
   
int maxgravity = 0;    

// Loop through all the gravity wells
for (int i = 1; i < 3; i++)
  {
// LET'S CHECK HOW FAR THE DOT IS FROM THIS GRAVITY WELL
      float distance = 0;
      distance = sqrt(sq(gravX[i]-x) + sq(gravY[i]-y)); 
      
      
      // Collision detection for Earth
      if ((sqrt(sq(gravX[1]-x) + sq(gravY[1]-y)) < 20))
      {
        noLoop();
      }
      
      if ((sqrt(sq(gravX[2]-x) + sq(gravY[2]-y)) < 10))
      {
        noLoop();
      }
        


      
      
      if (maxgravity > round (distance-gravityReach))
       { 
         maxgravity =  round (distance - gravityReach);
       } 
      
// LET'S CHECK if if the dot is affected by gravity
    if (distance < gravityReach)
      {
        if (gravY[i] < y) { velY = velY - (gravityReach/sq(distance))/3; } 
        if (gravY[i] > y) { velY = velY + (gravityReach/sq(distance))/3; } 
        if (gravX[i] < x) { velX = velX - (gravityReach/sq(distance))/3; } 
        if (gravX[i] > x) { velX = velX + (gravityReach/sq(distance))/3; } 
      }
  }

      // Going too fast? Let's chuck the brakes on... 
   if (velX > 30) { velX = 30 ; print ("capping speed from ", velX , "... \n"); }
   if (velY > 30) { velY = 30; print ("capping speed from ", velX , "... \n"); }
   if (velX < -30) { velX = -30; print ("capping speed from ", velX , "... \n"); }
   if (velY < -30) { velY = -30; print ("capping speed from ", velX , "... \n"); }


   x = x + velX;
   y = y + velY;
   
   dotX[stepcounter] = x;
   dotY[stepcounter] = y;
   if (maxgravity > 255)
     {   dotStrength[stepcounter] = 255; }
   else
     {   dotStrength[stepcounter] = maxgravity; }

     
   
   float velocity = 0;
   velocity = sqrt(sq(velX) + sq(velY)); 
   
   clear();
   drawPaths();
   drawWells();
}

void drawWells()
{
      
     // draw earth
      noStroke();
      int size = 40;
      fill(0,0,255);
      ellipse(gravX[1],gravY[1],size,size);

    // draw moon
      fill(255);
      size = 20;
      ellipse(gravX[2],gravY[2],size,size);
      noStroke();
}


void drawPaths()
{
  for (int i = 1; i < stepcounter+1; i++)
    {
     // fill(255,0,0,255); // red
     fill (255,255+dotStrength[i],255+dotStrength[i],255); // Redder when gravity
     ellipse(dotX[i],dotY[i],4,4);
    }
}

void createEarth()
{
      gravX[1] = width/2;
      gravY[1] = height/2;
}

void createMoon()
{      
      float moonDist = 200;

      if (moonPos > 359)
        { moonPos = 0; }
      else
        { moonPos = moonPos + 1; }
        
      float moonRads = radians(moonPos);

      gravX[2] = width/2 + moonDist * sin(moonRads);
      gravY[2] = height/2 + moonDist * cos(moonRads);
}

void keyTyped()
{
  loop();
  x = 50000;
  y = 50000;
  clear();
  drawWells();
}