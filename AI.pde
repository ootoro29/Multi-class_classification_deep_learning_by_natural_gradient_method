Neural N = new Neural(ilist(2, 8, 5, 4));
int P = 1000;
NNeural NN = new NNeural(ilist(2, 16, 8, 4), P, 1);
GNeural GN = new GNeural(ilist(2, 16, 8, 4), P, 0.1);
DataSet DS = new DataSet(2, 4, 1000);
DataSet DNS = new DataSet(2, 4, P);
DataSet DGS = new DataSet(2, 4, P);
void setup() {
  randomSeed(0);


  size(600, 300);
  saveSetting();
  /*
  for (int i = 0; i < 100; i++) {
   N.learning(dlist(0, 0), dlist(0, 1, 0));
   N.learning(dlist(0, 1), dlist(1, 0, 0));
   N.learning(dlist(1, 0), dlist(1, 0, 0));
   N.learning(dlist(1, 1), dlist(0, 0, 1));
   }
   N.func(dlist(0, 0));
   N.func(dlist(0, 1));
   N.func(dlist(1, 0));
   N.func(dlist(1, 1));
   */

  /*
  for (int i = 0; i < 100; i++) {
   if (i % 1 == 0)DS.sample();
   for (int k = 0; k < 1; k++) {
   N.learning(DS.X[k], DS.Y[k]);
   }
   }
   println("DONE");
   */
  plot2DC();
}
int O = 0;
int X = 0;
double LOSS = 0;
int step = 0;

int O_N = 0;
int X_N = 0;
double LOSS_N = 0;
int step_N = 0;

int O_G = 0;
int X_G = 0;
double LOSS_G = 0;
int step_G = 0;
void draw() {
  /*
  for (int k = 0; k < 10; k++) {
   DS.sample1();
   //N.func(DS.x);
   if (argmax(N.keisan(DS.x)) == argmax(DS.y)) {
   O ++;
   } else {
   X ++;
   }
   LOSS += N.loss(DS.y);
   step++;
   N.learning(DS.x, DS.y);
   }
   */

  for (int j = 0; j < 30; j++) {
    DNS.sample();
    NN.learning(DNS.X, DNS.Y);
    step_N++;
    double[][] NANS = NN.keisan(DNS.X);
    for (int k = 0; k < P; k++) {
      if (argmax(NANS[k]) == argmax(DNS.Y[k])) {
        O_N ++;
      } else {
        X_N ++;
      }
    }
    double lN = NN.loss(DNS.Y);
    LOSS_N += lN;
    //println("LOSSN:"+lN);

    DGS.sample();
    GN.learning(DNS.X, DNS.Y);
    step_G++;
    double[][] GANS = GN.keisan(DNS.X);
    for (int k = 0; k < P; k++) {
      if (argmax(GANS[k]) == argmax(DNS.Y[k])) {
        O_G ++;
      } else {
        X_G ++;
      }
    }
    double gN = GN.loss(DNS.Y);
    LOSS_G += gN;
    //println("LOSSG:"+gN);
  }
  LOSS_N /= 30;
  LOSS_G /= 30;


  if (frameCount % 1 == 0) {
    saveLog("-------------");
    println("正答率:"+(((float)O)/(O+X))*100+"% ("+O+","+X+")");
    println("ステップ:"+step+"回");
    println("誤差:"+LOSS/3000+"");

    saveLog("正答率:"+(((float)O_N)/(O_N+X_N))*100+"% ("+O_N+","+X_N+")");
    saveLog("ステップ:"+step_N+"回");
    saveLog("誤差:"+LOSS_N+"");

    saveLog("正答率:"+(((float)O_G)/(O_G+X_G))*100+"% ("+O_G+","+X_G+")");
    saveLog("ステップ:"+step_G+"回");
    saveLog("誤差:"+LOSS_G+"");

    saveHistoryN(step_N+","+LOSS_N+","+str((((float)O_N)/(O_N+X_N))*100)+","+O_N+","+X_N);
    saveHistoryG(step_G+","+LOSS_G+","+str((((float)O_G)/(O_G+X_G))*100)+","+O_G+","+X_G);
    saveLog("-------------");
    O = 0;
    X = 0;
    LOSS = 0;
    O_N = 0;
    X_N= 0;
    LOSS_N = 0;
    O_G = 0;
    X_G= 0;
    LOSS_G = 0;
    if (step_N % 300 == 0) {
    }
    plot2DG();
    plot2D();
    saveImage(step_N);
    //plot2DC();
  }
}
void plot2D() {
  loadPixels();
  int W = 300;
  int H = 300;
  for (int i = 0; i < W; i++) {
    for (int j = 0; j < H; j++) {
      float x = ((i-W/2.0)/(W/2.0)+0.2)*2;
      float y = ((j-H/2.0)/(H/2.0)+0.4)*2;
      double [][] input = {dlist(x, y)};
      NN.NSIZE = 1;
      for (Nlayor l : NN.net) {
        l.NSIZE = 1;
      }
      double[][]ANS = NN.keisan(input);
      NN.NSIZE = P;
      for (Nlayor l : NN.net) {
        l.NSIZE = P;
      }
      int ans = argmax(ANS[0]);

      if (ans == 0) {
        pixels[(i+W)+j*width] = color(255, 0, 0);
      } else if (ans == 1) {
        pixels[(i+W)+j*width] = color(0, 0, 255);
      } else if (ans == 2) {
        pixels[(i+W)+j*width] = color(0, 255, 0);
      } else if (ans == 3) {
        pixels[(i+W)+j*width] = color(0, 255, 255);
      }
    }
  }
  updatePixels();
}

void plot2DG() {
  int W = 300;
  int H = 300;
  loadPixels();
  for (int i = 0; i < W; i++) {
    for (int j = 0; j < H; j++) {
      float x = ((i-W/2.0)/(W/2.0)+0.2)*2;
      float y = ((j-H/2.0)/(H/2.0)+0.4)*2;
      double [][] input = {dlist(x, y)};
      GN.NSIZE = 1;
      for (Glayor l : GN.net) {
        l.NSIZE = 1;
      }
      double[][]ANS = GN.keisan(input);
      GN.NSIZE = P;
      for (Glayor l : GN.net) {
        l.NSIZE = P;
      }
      int ans = argmax(ANS[0]);
      if (ans == 0) {
        pixels[i+j*width] = color(255, 0, 0);
      } else if (ans == 1) {
        pixels[i+j*width] = color(0, 0, 255);
      } else if (ans == 2) {
        pixels[i+j*width] = color(0, 255, 0);
      } else if (ans == 3) {
        pixels[i+j*width] = color(0, 255, 255);
      }
    }
  }
  updatePixels();
}

void plot2DC() {
  int W = 300;
  int H = 300;
  loadPixels();
  for (int i = 0; i < W; i++) {
    for (int j = 0; j < H; j++) {
      float x = ((i-W/2.0)/(W/2.0)+0.2)*2;
      float y = ((j-H/2.0)/(H/2.0)+0.4)*2;

      double dist1 = Math.abs(x-1) + Math.abs(y-1);
      double dist2 = (x-0.5)*(x-0.5) + (y-1)*(y-1);

      if (dist1 < 1) {
        pixels[i+j*width] = color(255, 0, 0);
      } else if (y > -1 && y < 2*x+1 && y < -2*x+1) {
        pixels[i+j*width] = color(0, 0, 255);
      } else if (dist2 < 1.5*1.5) {
        pixels[i+j*width] = color(0, 255, 0);
      } else {
        pixels[i+j*width] = color(0, 255, 255);
      }
    }
  }
  updatePixels();
}
