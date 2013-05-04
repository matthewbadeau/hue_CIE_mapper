import processing.net.*;

Client c;
String data;
PImage bg;

float bx;
float by;
int circleSize = 10;
boolean overBox = false;
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0;

float CIEx;
float CIEy;
String CIEmap;

String apiKey = "helloworld";
String light = "2";

void setup() {
  size(588, 609);
  bx = width/2.0;
  by = height/2.0;
  rectMode(RADIUS);

  bg = loadImage("cie-colorspace.png");
  background(bg);
}

void draw() {
  background(bg);
  if (mouseX > bx-circleSize && mouseX < bx+circleSize && 
    mouseY > by-circleSize && mouseY < by+circleSize) {
    overBox = true;  
    if (!locked) { 
      stroke(255); 
      fill(153);
    }
  } 
  else {
    stroke(153);
    fill(0);
    overBox = false;
  }

  // Draw the box
  ellipse(bx, by, circleSize, circleSize);
}

void mousePressed() {
  if (overBox) { 
    locked = true; 
    fill(255, 255, 255);
  } 
  else {
    locked = false;
  }
  xOffset = mouseX-bx; 
  yOffset = mouseY-by;
}

void mouseDragged() {
  if (locked) {
    bx = mouseX-xOffset; 
    by = mouseY-yOffset; 

    CIEx = map(bx, 0, width, -0.04, 0.82);
    CIEy = map(by, height, 0, -0.04, 1.03);
    CIEmap = "{\"xy\": [" + String.format("%.2f", CIEx) +"," + String.format("%.2f", CIEy) + "]}";

    c = new Client(this, "192.168.2.118", 80); // Connect to server on port 80
    c.write("PUT /api/" + apiKey +"/lights/" + light + "/state HTTP/1.1\r\n"); // Use the HTTP "GET" command to ask for a Web page
    c.write("Content-Length: " + CIEmap.length() + "\r\n\r\n");
    c.write(CIEmap +"\r\n");
    sendHTTPData();
  }
}

void mouseReleased() {
  locked = false;
}

void sendHTTPData() {
  if (c.available() > 0) { // If there's incoming data from the client...
    data = c.readString(); // ...then grab it and print it
    println(data);
  }
}

