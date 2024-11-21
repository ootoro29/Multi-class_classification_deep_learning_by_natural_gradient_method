abstract class Glayor {
  Matrix[] z, a, d, in;
  Matrix w, I;
  int l;
  int state;
  int NSIZE = 0;
  double alpha = 0.24;
  Glayor(int x, int NSIZE) {
    l = x;
    this.NSIZE = NSIZE;
    state = 0;
    z = new Matrix[NSIZE];
    a = new Matrix[NSIZE];
    d = new Matrix[NSIZE];
    in = new Matrix[NSIZE];
    I = new Matrix(x, x);
    for (int n = 0; n < NSIZE; n++) {
      z[n] = new Matrix(x, 1);
      a[n] = new Matrix(x, 1);
      d[n] = new Matrix(x, 1);

      for (int i = 0; i <x; i++) {
        z[n].Arr[i][0] = 0;
        a[n].Arr[i][0] = 0;
      }
    }
  }
  void set_W(int l1) {
    w = new Matrix(l, l1+1);
    w.set_random();
  }
  Matrix[] fw(Matrix F[]) {
    for (int n = 0; n < NSIZE; n++) {
      in[n] = new Matrix(F[n].c+1, F[n].r);
      for (int i = 0; i < F[n].c; i++) {
        in[n].Arr[i][0] = F[n].Arr[i][0];
      }
      in[n].Arr[F[n].c][0] = 1;
      z[n].equal_Mat(w.mul_Mat(in[n]));
      /*
      for (int i = 0; i < l; i++) {
       a.Arr[i][0] = f(z.Arr[i][0]);
       }
       */
      a[n].equal_Mat(f(z[n]));
    }
    return a;
  }
  Matrix[] bc(Matrix[] D, Matrix W) {
    for (int n = 0; n < NSIZE; n++) {
      for (int i = 0; i < l; i++) {
        double sum = 0;
        for (int k = 0; k < D[n].c; k++) {
          sum += D[n].Arr[k][0]*W.Arr[k][i];
        }
        d[n].Arr[i][0] = sum;
      }
      /*
      for (int i = 0; i < l; i++) {
       d.Arr[i][0] *= df(z.Arr[i][0]);
       }
       */

      d[n].equal_Mat(df(z[n]).mul_Mat(d[n]));
    }
    return d;
  }
  void reset_W() {
    Matrix DW = new Matrix(w.c, w.r);
    Matrix[] IM = new Matrix[NSIZE];

    for (int n = 0; n < NSIZE; n++) {
      Matrix dC_dW = new Matrix(w.c, w.r);
      IM[n] = new Matrix(w.c, w.c);
      for (int i = 0; i < l; i++) {
        for (int j  =0; j < in[n].c; j++) {
          dC_dW.Arr[i][j] = d[n].Arr[i][0]*in[n].Arr[j][0];
          DW.Arr[i][j] += dC_dW.Arr[i][j];
        }
      }
      IM[n].equal_Mat(dC_dW.mul_Mat(dC_dW.t_Mat()));
      //IM[n].equal_Mat(DW.mul_Mat(DW.t_Mat()));
    }
    for (int i = 0; i < w.c; i++) {
      for (int j  =0; j < w.c; j++) {
        I.Arr[i][j] = 0;
      }
    }
    for (int n = 0; n < NSIZE; n++) {
      for (int i = 0; i < w.c; i++) {
        for (int j  =0; j < w.c; j++) {
          I.Arr[i][j] += IM[n].Arr[i][j]/NSIZE;
        }
      }
    }
    for (int i = 0; i < w.c; i++) {
      for (int j  =0; j < w.c; j++) {
        if (i == j) I.Arr[i][j] += 0.00001;
      }
    }
    /*
    println("--------------------------");
     I.inv_Mat().show();
     println("--------------------------");
     */

    //I.inv_Mat().show();
    for (int i = 0; i < l; i++) {
      for (int j  =0; j < DW.r; j++) {
        DW.Arr[i][j] /= NSIZE;
      }
    }
    DW.equal_Mat(I.inv_Mat().mul_Mat(DW));
    for (int i = 0; i < l; i++) {
      for (int j  =0; j < DW.r; j++) {
        w.Arr[i][j] -= this.alpha*DW.Arr[i][j];
      }
    }
  }
  void act_fun() {
    for (int n = 0; n < NSIZE; n++) {
      a[n].equal_Mat(f(z[n]));
    }
  }
  abstract Matrix f(Matrix x);
  abstract Matrix df(Matrix x);
}
class GhideLayor extends Glayor {
  GhideLayor(int x, int NSIZE) {
    super(x, NSIZE);
  }
  Matrix f(Matrix x) {
    Matrix ans = new Matrix(x);
    for (int i = 0; i < x.c; i++) {
      ans.Arr[i][0] = 1/(1+Math.exp(-x.Arr[i][0]));
    }
    return ans;
  }
  Matrix df(Matrix x) {
    Matrix F = f(x);
    Matrix ans = new Matrix(x.c, x.c);
    for (int i = 0; i < x.c; i++) {
      for (int j = 0; j < x.c; j++) {
        double A = 0;
        if (i == j) {
          A = F.Arr[i][0]*(1-F.Arr[i][0]);
        }
        ans.Arr[i][j] = A;
      }
    }
    return ans;
  }
}
class GoutLayor extends Glayor {
  GoutLayor(int x, int NSIZE) {
    super(x, NSIZE);
  }
  Matrix f(Matrix x) {
    Matrix ans = new Matrix(x);
    double max = -9999999;
    for (int i = 0; i < x.c; i++) {
      if (x.Arr[i][0] > max) {
        max = x.Arr[i][0];
      }
    }
    double sum = 0;
    for (int i = 0; i < x.c; i++) {
      sum += Math.exp(x.Arr[i][0]);
    }
    for (int i = 0; i < x.c; i++) {
      ans.Arr[i][0] = Math.exp(x.Arr[i][0])/sum;
    }
    return ans;
  }
  Matrix df(Matrix x) {
    Matrix F = f(x);
    Matrix ans = new Matrix(x.c, x.c);
    for (int i = 0; i < x.c; i++) {
      for (int j = 0; j < x.c; j++) {
        double A = 0;
        if (i == j) {
          A = F.Arr[i][0]*(1-F.Arr[i][0]);
        } else {
          A = -F.Arr[i][0]*F.Arr[j][0];
        }
        ans.Arr[i][j] = A;
      }
    }
    return ans;
  }
}
class GNeural {
  int N;
  int NSIZE = 0;
  double alpha = 0.4;
  ArrayList<Glayor>net = new ArrayList();
  Matrix ans[], in[], out[];
  GNeural(int []size, int NSIZE,double alpha) {
    this.NSIZE = NSIZE;
    this.alpha = alpha;
    N = size.length;
    ans = new Matrix[NSIZE];
    in = new Matrix[NSIZE];
    out = new Matrix[NSIZE];
    for (int n = 0; n < NSIZE; n++) {
      out[n] = new Matrix(size[N-1], 1);
      ans[n] = new Matrix(size[N-1], 1);
      in[n] = new Matrix(size[0], 1);
    }
    for (int i = 0; i < N-1; i++) {
      net.add(new GhideLayor(size[i], NSIZE));
      net.get(net.size()-1).alpha = this.alpha;
    }
    net.add(new GoutLayor(size[N-1], NSIZE));
    net.get(0).state = -1;
    net.get(N-1).state = 1;
    for (int i = 1; i< N; i++) {
      net.get(i).set_W(size[i-1]);
    }
  }
  void learning(double [][]inx, double [][] anx) {
    for (int n = 0; n < NSIZE; n++) {
      for (int i = 0; i < net.get(0).l; i++) {
        in[n].Arr[i][0] = inx[n][i];
      }
      for (int i = 0; i < net.get(N-1).l; i++) {
        ans[n].Arr[i][0] = anx[n][i];
      }
      keisan(inx);
    }
    fix();
  }
  void func(double [][]inx) {
    for (int n = 0; n < NSIZE; n++) {
      for (int i = 0; i < net.get(0).l; i++) {
        in[n].Arr[i][0] = inx[n][i];
      }
    }

    keisan(inx);
    dis_Out();
  }
  double loss(double [][] anx) {
    double ans = 0;
    for (int n = 0; n < NSIZE; n ++) {
      for (int i = 0; i < net.get(N-1).l; i++) {
        ans += -anx[n][i]*Math.log(out[n].Arr[i][0]);
      }
    }
    ans /= NSIZE;
    return ans;
  }
  double[][] fun_out(double [][]inx) {
    for (int n = 0; n < NSIZE; n++) {
      for (int i = 0; i < net.get(0).l; i++) {
        in[n].Arr[i][0] = inx[n][i];
      }
    }

    keisan(inx);
    int C = out[0].c;
    double ans[][] = new double [NSIZE][C];
    for (int n = 0; n < NSIZE; n++) {
      for (int i = 0; i < C; i++) {
        ans[n][i] = out[n].Arr[i][0];
      }
    }
    return ans;
  }
  double[][] keisan(double [][]inx) {
    double ans[][] = new double[NSIZE][net.get(N-1).l];
    ArrayList<Matrix[]>X = new ArrayList();
    Matrix[] XM = new Matrix[NSIZE];
    for (int n = 0; n < NSIZE; n++) {
      XM[n] = new Matrix(inx[n]);
    }
    X.add(XM);
    for (int i = 1; i < N; i++) {
      //print(i+"->");
      //X.get(X.size()-1).show();
      X.add(net.get(i).fw(X.get(X.size()-1)));
    }
    for (int n = 0; n < NSIZE; n++) {
      for (int i = 0; i < X.get(X.size()-1)[n].c; i++) {
        out[n].Arr[i][0] = X.get(X.size()-1)[n].Arr[i][0];
        ans[n][i] = out[n].Arr[i][0];
      }
    }
    return ans;
  }
  void dis_Out() {
    for (int n = 0; n < NSIZE; n++) {
      for (int i = 0; i < in[n].c; i++) {
        print(in[n].Arr[i][0], " ");
      }
      print(":-> ");
      for (int i = 0; i < out[n].c; i++) {
        print(out[n].Arr[i][0], " ");
      }
      print("\n");
    }
  }
  void fix() {

    ArrayList<Matrix[]>C = new ArrayList();
    Matrix[] CrossEN = new Matrix[NSIZE];
    for (int n = 0; n < NSIZE; n++) {
      CrossEN[n] = new Matrix(net.get(N-1).l, 1);
      for (int i = 0; i < net.get(N-1).l; i++) {
        CrossEN[n].Arr[i][0] = -ans[n].Arr[i][0]/net.get(N-1).a[n].Arr[i][0];
      }
    }
    C.add(CrossEN);

    for (int n = 0; n < NSIZE; n++) {
      Matrix DF = new Matrix(net.get(N-1).df(net.get(N-1).z[n]));
      Matrix D = new Matrix(DF.mul_Mat(C.get(0)[n]));
      for (int i = 0; i < net.get(N-1).l; i++) {
        C.get(0)[n].Arr[i][0] = D.Arr[i][0];
      }
      for (int i = 0; i < net.get(N-1).l; i++) {
        net.get(N-1).d[n].Arr[i][0] = C.get(0)[n].Arr[i][0];
      }
    }
    ArrayList<Matrix>W = new ArrayList();
    W.add(new Matrix(net.get(N-1).w));

    for (int i = 0; i < N-1; i++) {
      int index = N-i-2;
      C.add(net.get(index).bc(C.get(C.size()-1), W.get(W.size()-1)));
      //println(" ", new Matrix(net.get(index).w).c);
      if (index != 0)W.add(new Matrix(net.get(index).w));
    }


    for (int i = 1; i < N; i++) {
      net.get(i).reset_W();
    }
  }
}
