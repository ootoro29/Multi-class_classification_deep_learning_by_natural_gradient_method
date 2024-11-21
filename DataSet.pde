class DataSet {
  int inDim = 0;
  int outDim = 0;
  int N = 0;
  double X[][];
  double Y[][];
  double x[];
  double y[];
  DataSet(int inDim, int outDim, int N) {
    this.inDim = inDim;
    this.outDim = outDim;
    this.N = N;
    X = new double[N][inDim];
    Y = new double[N][outDim];
    x = new double[inDim];
    y = new double[outDim];
  }

  void sample() {
    double r = 2.5;
    for (int n = 0; n < N; n++) {
      X[n][0] = random(-1.6, 2.4);
      X[n][1] = random(-1.2, 2.8);
    }
    for (int n = 0; n < N; n++) {
      double dist1 = Math.abs(X[n][0]-1) + Math.abs(X[n][1]-1);
      double dist2 = (X[n][0]-0.5)*(X[n][0]-0.5) + (X[n][1]-1)*(X[n][1]-1);
      if (dist1 < 1) {
        Y[n] = dlist(1, 0, 0, 0);
      } else if (X[n][1] > -1 && X[n][1] < 2*X[n][0]+1 && X[n][1] < -2*X[n][0]+1) {
        Y[n] = dlist(0, 1, 0, 0);
      } else if (dist2 < 1.5*1.5) {
        Y[n] = dlist(0, 0, 1, 0);
      } else {
        Y[n] = dlist(0, 0, 0, 1);
      }
    }
  }

  void sample1() {

    for (int n = 0; n < N; n++) {
      for (int i = 0; i < this.inDim; i++) {
        x[i] = random(-pow(2*PI/3.0, 1.0/3), pow(2*PI/3.0, 1.0/3));
      }
    }
    for (int n = 0; n < N; n++) {
      double dist = x[0]*x[0] + x[1]*x[1];
      if (dist < 1) {
        y = dlist(1, 0, 0, 0);
      } else if (dist < 1.5) {
        y = dlist(0, 1, 0, 0);
      } else if (dist < 2.5) {
        y = dlist(0, 0, 1, 0);
      } else {
        y = dlist(0, 0, 0, 1);
      }
    }
  }

  void show_sample() {
    for (int n = 0; n < N; n++) {
      print("(");
      for (int i = 0; i < this.inDim; i++) {
        if (i != this.inDim-1)print(X[n][i] + ",");
        else print(X[n][i] + "): ");
      }

      print("ANS:(");
      for (int i = 0; i < this.outDim; i++) {
        if (i != this.outDim-1)print(Y[n][i] + ",");
        else print(Y[n][i] + ")");
      }
      print("\n");
    }
  }
}
