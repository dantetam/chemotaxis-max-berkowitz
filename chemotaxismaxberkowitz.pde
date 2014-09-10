//Max Berkowitz, Chemotaxis, AP Comp Sci mods 6,7
//http://berko-java.webs.com//Chemotaxis/Chemotaxis.html

Bac[] bla=new Bac[524288];
Food fd=new Food();
Food fd2=new Food();
Cloud cd=new Cloud();
int num, num2;
int do1, do2;
int startCount=0;
boolean antibiotic=false;
boolean setFamin=false;
boolean famin=false;
boolean makeMore=true;
boolean showTrait=false;
void setup() {
  size(600, 600);
  smooth();
  background(0);
  frameRate(20);
  for (int i=0;i<524288;i++) bla[i]=new Bac();
  for (int n=1;n<524288;n++) bla[n].dead();
  do1=0;
  do2=0;
}
void draw() {
  if (startCount>=1) {
    stroke(0, 0, 0, 10);
    fill(0, 0, 0, 10);
    rect(0, 0, 600, 600);
    startCount++;
    if (startCount==100) {
      startCount=0;
      cd.activate=false;
      cd.rad=0;
      for (int ini=0;ini<524288;ini++) {
        bla[ini].dead();
        bla[ini].x=300;
        bla[ini].y=300;
        if (Math.random()<0.05) bla[ini].resistant=true;
        else bla[ini].resistant=false;
        if (Math.random()<0.005) bla[ini].quick=true;
        else bla[ini].quick=false;
        if (Math.random()<0.005) {
          bla[ini].stam=true;
          bla[ini].stamCheck=true;
        }
        else {
          bla[ini].stam=false;
          bla[ini].stamCheck=true;
        }
      }
      bla[0].ranColor();
      do1=0;
      do2=0;
      makeMore=true;
      background(0);
      fd.gone=true;
      fd2.gone=true;
      antibiotic=false;
    }
  }
  else {  
    cd.go();
    for (int intn=0;intn<524288;intn++) {
      if (antibiotic && !bla[intn].resistant) bla[intn].dead();
      if (bla[intn].alive && !famin) {
        if (dist(bla[intn].x, bla[intn].y, 300, 300)<cd.rad/2) {
          bla[intn].dead();
        }
        if (dist(bla[intn].x, bla[intn].y, fd.x, fd.y)<=fd.rad/2+5) {
          if (bla[intn].stam) bla[intn].stamCheck=true;
          bla[intn].hunger=false;
          fd.rad-=0.01;
        }
        if (dist(bla[intn].x, bla[intn].y, fd2.x, fd2.y)<=fd2.rad/2+5) {
          if (bla[intn].stam) bla[intn].stamCheck=true;
          bla[intn].hunger=false;
          fd2.rad-=0.01;
        }
      }
    }
    fd.depleted();
    fd2.depleted();
    doIt(do1);
    if (!famin) {
      fd.show();
      fd2.show();
    }
    do2++;
    if (do2==200) {
      for (int t=0;t<Math.pow(2,do1);t++) {
        if (bla[t].hunger) {
          if (bla[t].stam && bla[t].stamCheck) {
            bla[t].stamCheck=false;
          }
          else bla[t].dead();
        }
        else bla[t].hunger=true;
        if (makeMore) makeNew(t, do1);
      }
      if (makeMore) do1++;
      do2=0;
      if (setFamin) {
        setFamin=false;
        famin=true;
      }
      else if (famin) {
        famin=false;
        fd.newLocation();
        fd2.newLocation();
      }
    }
    if (do1==18) makeMore=false;
    if (!allDead() && !cd.activate) {
      startCount++;
    }
  }
}
boolean allDead() {
  for (int intt=0;intt<524288;intt++) {
    if (bla[intt].alive) return true;
  }
  return false;
}
void doIt(int i) {
  stroke(0, 0, 0, 10);
  fill(0, 0, 0, 10);
  rect(0, 0, 600, 600);
  for (int in=0;in<524288;in++) {
    bla[in].move();
    bla[in].show();
  }
}
void makeNew(int t, int i) {
  num=(int)(t+Math.pow(2, i));
  if (bla[t].alive) {
    if (bla[t].resistant) bla[num].resistant=true;
    if (bla[t].quick) bla[num].quick=true;
    if (bla[t].stam) bla[num].stam=true;
    if (bla[t].stamCheck) bla[num].stamCheck=true;
    bla[t].ranColor();
    bla[num].ranColor();
    bla[num].x=bla[t].x;
    bla[num].y=bla[t].y;
  }
}
void keyPressed() {
  if (key=='p') noLoop();
  if (key=='s') loop();
  if (key=='f') frameRate(100);
  if (key=='d') frameRate(20);
  if (key=='c') cd.activate=true;
  if (key==(char)32) {
    if (showTrait) showTrait=false;
    else showTrait=true;
  }
  if (key=='n' && !setFamin) setFamin=true;
}
void mousePressed() {
  antibiotic=true;
  fill(255, 0, 0);
  rect(0, 0, 600, 600);
}

class Bac {
  int x, y, col1, col2, col3;
  boolean alive, hunger, resistant, quick, stam, stamCheck;
  Bac() {
    x=300;
    y=300;
    col1=(int)(Math.random()*226);
    col2=(int)(Math.random()*226);
    col3=(int)(Math.random()*226);
    alive=true;
    hunger=true;
    if (Math.random()<0.001) resistant=true;
    else resistant=false;
    if (Math.random()<0.001) quick=true;
    else quick=false;
    if (Math.random()<0.001) {
      stam=true;
      stamCheck=true;
    }
    else {
      stam=false;
      stamCheck=true;
    }
  }
  void ranColor() {
    col1=(int)(Math.random()*226);
    col2=(int)(Math.random()*226);
    col3=(int)(Math.random()*226);
    if (!resistant) {
      if (Math.random()<0.001) resistant=true;
      else resistant=false;
    }
    if (!quick) {
      if (Math.random()<0.001) quick=true;
      else quick=false;
    }
    if (!stam) {
      if (Math.random()<0.001) {
        stam=true;
        stamCheck=true;
      }
      else {
        stam=false;
        stamCheck=true;
      }
    }
    alive=true;
  }
  void move() {
    if (alive) {
      if (famin) {
        x+=(int)(Math.random()*9)-4;
        y+=(int)(Math.random()*9)-4;
      }
      else {
        if (dist(x, y, fd.x, fd.y)+fd.rad/2 <= dist(x, y, fd2.x, fd2.y)+fd2.rad/2) {
          if (quick) {
            if (x<fd.x) x+=(int)(Math.random()*4)+1;
            else x-=(int)(Math.random()*4)+1;
            if (y<fd.y) y+=(int)(Math.random()*4)+1;
            else y-=(int)(Math.random()*4)+1;
          }
          else if (Math.random()>0.8) {
            if (x<fd.x) x+=(int)(Math.random()*4)+1;
            else x-=(int)(Math.random()*4)+1;
            if (y<fd.y) y+=(int)(Math.random()*4)+1;
            else y-=(int)(Math.random()*4)+1;
          }
          else {
            x+=(int)(Math.random()*9)-4;
            y+=(int)(Math.random()*9)-4;
          }
        }
        else {
          if (quick) {
            if (x<fd2.x) x+=(int)(Math.random()*4)+1;
            else x-=(int)(Math.random()*4)+1;
            if (y<fd2.y) y+=(int)(Math.random()*4)+1;
            else y-=(int)(Math.random()*4)+1;
          }
          else if (Math.random()>0.8) {
            if (x<fd2.x) x+=(int)(Math.random()*4)+1;
            else x-=(int)(Math.random()*4)+1;
            if (y<fd2.y) y+=(int)(Math.random()*4)+1;
            else y-=(int)(Math.random()*4)+1;
          }
          else {
            x+=(int)(Math.random()*9)-4;
            y+=(int)(Math.random()*9)-4;
          }
        }
      }
      if (x>600) x=600;
      if (x<0) x=0;
      if (y>600) y=600;
      if (y<0) y=0;
    }
  }
  void show() {
    if (alive) {
      if (showTrait) {
        if (resistant && quick && stam) {
          stroke(255, 0, 255);
          fill(255, 0, 255);
        }
        else if (resistant && quick) {
          stroke(255, 125, 0);
          fill(255, 125, 0);
        }
        else if (resistant && stam) {
          stroke(125, 0, 225);
          fill(125, 0, 255);
        }
        else if (quick && stam) {
          stroke(0, 255, 0);
          fill(0, 255, 0);
        }
        else if (resistant) {
          stroke(255, 0, 0);
          fill(255, 0, 0);
        }
        else if (quick) {
          stroke(255, 255, 0);
          fill(255, 255, 0);
        }
        else if (stam) {
          stroke(0, 0, 255);
          fill(0, 0, 255);
        }
        else {
          stroke(255, 255, 255);
          fill(255, 255, 255);
        }
      }
      else {
        stroke(col1, col2, col3);
        fill(col1, col2, col3);
      }
      ellipse(x, y, 10, 10);
      stroke(0);
      point(x, y);
    }
  }
  void dead() {
    alive=false;
  }
}

class Food {
  int x, y, count, count2;
  float rad;
  boolean gone;
  Food() {
    x=(int)(Math.random()*601);
    y=(int)(Math.random()*601);
    rad=0;
    gone=false;
    count=0;
  }
  void show() {
    stroke(255, 255, 255, 50);
    fill(13, 250, 38, 50);
    if (count<5) {
      count++;
      rad+=20;
    }
    count2++;
    if (count2%10==0) rad-=0.1;
    ellipse(x, y, rad, rad);
    if (rad<=10) gone=true;
  }
  void depleted() {
    if (gone) {
      x=(int)(Math.random()*601);
      y=(int)(Math.random()*601);
      rad=0;
      gone=false;
      count=0;
      count2=0;
    }
  }
  void newLocation() {
    x=(int)(Math.random()*601);
    y=(int)(Math.random()*601);
    rad=0;
    gone=false;
    count=0;
    count2=0;
  }
}

class Cloud {
  int rad;
  boolean activate;
  Cloud() {
    rad=0;
  }
  void go() {
    if (activate && rad<849) {
      rad+=5;
      stroke(255);
      fill(0);
      ellipse(300, 300, rad, rad);
    }
    else activate=false;
  }
}

