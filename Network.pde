double alpha = 0.01;
double [] dlist(double ... a) {
  return a;
}
int [] ilist(int ... a) {
  return a;
}
abstract class layor {
  Matrix z, a, w, d, in;
  int l;
  int state;
  layor(int x) {
    l = x;
    state = 0;
    z = new Matrix(x, 1);
    a = new Matrix(x, 1);
    d = new Matrix(x, 1);
    for (int i = 0; i <x; i++) {
      z.Arr[i][0] = 0;
      a.Arr[i][0] = 0;
    }
  }
  void set_W(int l1) {
    w = new Matrix(l, l1+1);
    w.set_random();
  }
  Matrix fw(Matrix F) {
    in = new Matrix(F.c+1, F.r);
    for (int i = 0; i < F.c; i++) {
      in.Arr[i][0] = F.Arr[i][0];
    }
    in.Arr[F.c][0] = 1;
    z.equal_Mat(w.mul_Mat(in));

    /*
    for (int i = 0; i < l; i++) {
     a.Arr[i][0] = f(z.Arr[i][0]);
     }
     */
    a.equal_Mat(f(z));


    return a;
  }
  Matrix bc(Matrix D, Matrix W) {
    for (int i = 0; i < l; i++) {
      double sum = 0;
      for (int k = 0; k < D.c; k++) {
        sum += D.Arr[k][0]*W.Arr[k][i];
      }
      d.Arr[i][0] = sum;
    }
    /*
    for (int i = 0; i < l; i++) {
     d.Arr[i][0] *= df(z.Arr[i][0]);
     }
     */

    d.equal_Mat(df(z).mul_Mat(d));
    return d;
  }
  void reset_W() {
    for (int i = 0; i < l; i++) {
      for (int j  =0; j < in.c; j++) {
        w.Arr[i][j] -= alpha*d.Arr[i][0]*in.Arr[j][0];
      }
    }
  }
  void act_fun() {
    a.equal_Mat(f(z));
  }
  abstract Matrix f(Matrix x);
  abstract Matrix df(Matrix x);
}
class hideLayor extends layor {
  hideLayor(int x) {
    super(x);
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
class outLayor extends layor {
  outLayor(int x) {
    super(x);
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
class Neural {
  int N;
  double eta = 1;
  ArrayList<layor>net = new ArrayList();
  Matrix ans, in, out;
  Neural(int []size) {
    N = size.length;
    out = new Matrix(size[N-1], 1);
    ans = new Matrix(size[N-1], 1);
    in = new Matrix(size[0], 1);
    for (int i = 0; i < N-1; i++) {
      net.add(new hideLayor(size[i]));
    }
    net.add(new outLayor(size[N-1]));
    net.get(0).state = -1;
    net.get(N-1).state = 1;
    for (int i = 1; i< N; i++) {
      net.get(i).set_W(size[i-1]);
    }
  }
  void learning(double []inx, double [] anx) {
    for (int i = 0; i < net.get(0).l; i++) {
      in.Arr[i][0] = inx[i];
    }
    for (int i = 0; i < net.get(N-1).l; i++) {
      ans.Arr[i][0] = anx[i];
    }
    keisan(inx);
    fix();
  }
  void func(double []inx) {
    for (int i = 0; i < net.get(0).l; i++) {
      in.Arr[i][0] = inx[i];
    }

    keisan(inx);
    dis_Out();
  }
  double loss(double [] anx){
    double ans = 0;
    for (int i = 0; i < net.get(N-1).l; i++) {
      ans += -anx[i]*Math.log(out.Arr[i][0]); 
    }
    return ans;
  }
  double[] fun_out(double []inx) {
    for (int i = 0; i < net.get(0).l; i++) {
      in.Arr[i][0] = inx[i];
    }

    keisan(inx);
    int C = out.c;
    double ans[] = new double [C];
    for (int i = 0; i < C; i++) {
      ans[i] = out.Arr[i][0];
    }
    return ans;
  }
  double[] keisan(double []inx) {
    double ans[] = new double[net.get(N-1).l];
    ArrayList<Matrix>X = new ArrayList();
    X.add(new Matrix(inx));
    for (int i = 1; i < N; i++) {

      //print(i+"->");
      //X.get(X.size()-1).show();
      X.add(net.get(i).fw(X.get(X.size()-1)));
    }
    for (int i = 0; i < X.get(X.size()-1).c; i++) {
      out.Arr[i][0] = X.get(X.size()-1).Arr[i][0];
      ans[i] = out.Arr[i][0]; 
    }
    return ans;
  }
  void dis_Out() {
    for (int i = 0; i < in.c; i++) {
      print(in.Arr[i][0], " ");
    }
    print(":-> ");
    for (int i = 0; i < out.c; i++) {
      print(out.Arr[i][0], " ");
    }
    print("\n");
  }
  void fix() {
    ArrayList<Matrix>C = new ArrayList();
    Matrix CrossEN = new Matrix(net.get(N-1).l, 1);
    for (int i = 0; i < net.get(N-1).l; i++) {
      CrossEN.Arr[i][0] = -ans.Arr[i][0]/net.get(N-1).a.Arr[i][0];
    }
    //C.add(net.get(N-1).a.sub_Mat(ans));
    C.add(CrossEN);
    Matrix DF = new Matrix(net.get(N-1).df(net.get(N-1).z));
    Matrix D = new Matrix(DF.mul_Mat(C.get(0)));
    for (int i = 0; i < net.get(N-1).l; i++) {
      C.get(0).Arr[i][0] = D.Arr[i][0];
    }
    for (int i = 0; i < net.get(N-1).l; i++) {
      net.get(N-1).d.Arr[i][0] = C.get(0).Arr[i][0];
    }
    ArrayList<Matrix>W = new ArrayList();
    W.add(new Matrix(net.get(N-1).w));

    for (int i = 0; i < N-1; i++) {
      int index = N-i-2;
      C.add(new Matrix(net.get(index).bc(C.get(C.size()-1), W.get(W.size()-1))));
      //println(" ", new Matrix(net.get(index).w).c);
      if (index != 0)W.add(new Matrix(net.get(index).w));
    }
    for (int i = 1; i < N; i++) {
      net.get(i).reset_W();
    }
  }
}
