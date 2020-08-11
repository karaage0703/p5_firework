import ddf.minim.*;

Minim minim;
AudioSample sound;

PVector gravity = new PVector(0.0, 0.1);
ArrayList<Firework> Firework;

void setup() {
  // for audio
  minim = new Minim(this);
  sound = minim.loadSample("firework_sound.mp3", 2048);

//  size(960, 540);
  size(1600, 800);
  colorMode(HSB, 360, 100, 100, 100);
  smooth();
  Firework = new ArrayList<Firework>();
  background(51);
}

void draw() {
  fill(51, 50);
  noStroke();
  rect(0, 0, width, height);

  for (int i = 0; i < Firework.size(); i++) {
    Firework fw = Firework.get(i);
    fw.run();
    if (fw.done()) {
      Firework.remove(fw);
    }
  }
}


class FireBall {
  PVector pos;
  PVector vel;
  PVector acc;

  float lifeBall = 100;

  float lifeFlower = 100;
  float lifeSpan = random(lifeFlower/50, lifeFlower/30);
  boolean seed = false;
  color c;

  FireBall(float x, float y, float hue) {
    pos = new PVector(x, y);
    vel = new PVector(0, random(-12, -6));
    acc = new PVector(0, 0.1);
    c = color(hue, 255, 255);
    seed = true;
  }

  FireBall(PVector _pos, float hue, int flowerSize) {
    pos = new PVector(_pos.x, _pos.y);
    vel = PVector.random2D();
    vel.mult(random(3, 6));
    acc = new PVector(0, 0.1);
    c = color(hue, 255, 255);

    if (flowerSize == 1){
      lifeSpan = random(lifeFlower/50, lifeFlower/30);
    }
    if (flowerSize == 2) {
      lifeSpan = random(lifeFlower/100, lifeFlower/60);
    }
    if (flowerSize == 3) {
      lifeSpan = random(lifeFlower/200, lifeFlower/120);
    }
    if (flowerSize == 4) {
      lifeSpan = random(lifeFlower/400, lifeFlower/240);
    }
  }

  void update() {
    pos.add(vel);
    vel.add(acc);
    if (seed) {
      lifeBall -= 1;
    } else {
      lifeFlower -= lifeSpan;
      vel.mult(0.98);
    }
    acc.mult(0);
  }
  void draw() {
    if (seed) {
      stroke(c, lifeBall);
      strokeWeight(10);
    } else {
      stroke(c, lifeFlower);
      strokeWeight(8);
    }
    point(pos.x, pos.y);
  }
  void applyForce(PVector force) {
    acc.add(force);
  }
  void run() {
    update();
    draw();
  }

  boolean isDead() {
    if (lifeFlower < 0) {
      return true;
    }
    return false;
  }

  boolean explode() {
    if (seed && vel.y > 0) {
      lifeSpan = 0;
      return true;
    }
    return false;
  }
}

class Firework {
  ArrayList<FireBall> fireBalls;
  FireBall ball;
  float hue;

  int flowerSize = 0;
  int ballNumb = 100;

  Firework() {
  }

  Firework(int _flowerSize) {
    hue = random(360);
    ball = new FireBall(random(width), height, hue);
    fireBalls = new ArrayList<FireBall>();
    flowerSize = _flowerSize;
    if (_flowerSize == 1 ){
      ballNumb = 100;
    }
    if (_flowerSize == 2 ){
      ballNumb = 200;
    }
    if (_flowerSize == 3 ){
      ballNumb = 300;
    }
    if (_flowerSize == 4 ){
      ballNumb = 400;
    }
  }

  boolean done() {
    if (ball == null && fireBalls.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

  void run() {
    if (ball != null) {
      ball.applyForce(gravity);
      ball.update();
      ball.draw();
      if (ball.explode()) {
        for (int i = 0; i < ballNumb; i++) {
          fireBalls.add(new FireBall(ball.pos, hue, flowerSize));
        }
        ball = null;
      }
    }

    for (int i = 0; i < fireBalls.size(); i++) {
      FireBall child = fireBalls.get(i);
      child.applyForce(gravity);
      child.run();
      if (child.isDead()) {
        fireBalls.remove(child);
      }
    }
  }
}


void keyPressed() {
  if (key == '1'){
    sound.trigger();
    Firework.add(new Firework(1));
  }

  if (key == '2'){
    sound.trigger();
    Firework.add(new Firework(2));
  }

  if (key == '3'){
    sound.trigger();
    Firework.add(new Firework(3));
  }

  if (key == '4'){
    sound.trigger();
    Firework.add(new Firework(4));
  }

}


void stop() {
  sound.close();
  minim.stop();

  super.stop();
}