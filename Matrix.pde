PApplet app = new PApplet();
public static class Matrix {
  int c = 0, r = 0;
  double Arr[][];
  Matrix(int c, int r) {
    this.c = c;
    this.r = r;
    Arr = new double[c][r];
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        Arr[i][j] = 0;
      }
    }
  }
  Matrix(double X[]) {
    this.c = X.length;
    this.r = 1;
    Arr = new double[c][r];
    for (int i = 0; i < c; i++) {
      Arr[i][0] = X[i];
    }
  }
  Matrix(Matrix X) {
    this.c = X.c;
    this.r = X.r;
    Arr = new double[c][r];
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        Arr[i][j] = X.Arr[i][j];
      }
    }
  }
  void show() {
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        print(Arr[i][j], " ");
      }
      print("\n");
    }
  }
  void set_random() {
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        Arr[i][j] = (double)(Math.random()-0.5)*3;
      }
    }
  }
  void equal_Mat(Matrix M) {
    if (c != M.c || r != M.r) {
      println("AAAAAAA");
      return;
    }
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        Arr[i][j] = M.Arr[i][j];
      }
    }
  }
  Matrix add_Mat(Matrix M) {
    if (c != M.c || r != M.r)return new Matrix(0, 0);
    Matrix ans = new Matrix(c, r);
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        ans.Arr[i][j] = Arr[i][j]+M.Arr[i][j];
      }
    }
    return ans;
  }
  Matrix sub_Mat(Matrix M) {
    if (c != M.c || r != M.r)return new Matrix(0, 0);
    Matrix ans = new Matrix(c, r);
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        ans.Arr[i][j] = Arr[i][j]-M.Arr[i][j];
      }
    }
    return ans;
  }
  Matrix mul_Mat(Matrix M) {
    if (r != M.c)return new Matrix(0, 0);
    Matrix ans = new Matrix(c, M.r);
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < M.r; j++) {
        double x = 0;
        for (int k = 0; k < r; k++) {
          x += Arr[i][k] * M.Arr[k][j];
        }
        ans.Arr[i][j] = x;
      }
    }
    return ans;
  }

  Matrix t_Mat() {
    Matrix ans = new Matrix(r, c);
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        ans.Arr[j][i] = Arr[i][j];
      }
    }
    return ans;
  }

  Matrix inv_Mat() {
    if (c != r) {
      System.out.println("Inverse can only be computed for square matrices.");
      return new Matrix(0, 0);
    }

    Matrix augmented = new Matrix(c, 2 * r);

    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        augmented.Arr[i][j] = Arr[i][j];
      }
      augmented.Arr[i][i + r] = 1;
    }

    for (int i = 0; i < c; i++) {
      double pivot = augmented.Arr[i][i];
      if (pivot == 0) {
        System.out.println("Matrix is singular and cannot be inverted.");
        return new Matrix(0, 0);
      }

      for (int j = 0; j < 2 * r; j++) {
        augmented.Arr[i][j] /= pivot;
      }

      for (int k = 0; k < c; k++) {
        if (k != i) {
          double factor = augmented.Arr[k][i];
          for (int j = 0; j < 2 * r; j++) {
            augmented.Arr[k][j] -= factor * augmented.Arr[i][j];
          }
        }
      }
    }

    //augmented.show();

    Matrix inverse = new Matrix(c, r);
    for (int i = 0; i < c; i++) {
      for (int j = 0; j < r; j++) {
        inverse.Arr[i][j] = augmented.Arr[i][j + r];
      }
    }

    return inverse;
  }
  
  
}
