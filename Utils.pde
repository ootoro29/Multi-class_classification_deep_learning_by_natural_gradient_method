int argmax(double[] a) {
  int index = 0;
  double max = a[0];
  for (int i = 0; i < a.length; i++) {
    if (max < a[i]) {
      max = a[i];
      index = i;
    }
  }
  return index;
}

double Max(Matrix a) {
  int index = 0;
  double max = a.Arr[0][0];
  for (int i = 0; i < a.c; i++) {
    if (max < a.Arr[i][0]) {
      max = a.Arr[i][0];
      index = i;
    }
  }
  return max;
}

int argmax(Matrix a) {
  int index = 0;
  double max = a.Arr[0][0];
  for (int i = 0; i < a.c; i++) {
    if (max < a.Arr[i][0]) {
      max = a.Arr[i][0];
      index = i;
    }
  }
  return index;
}

String folderName = "out/16";

void saveSetting() {
  String[] Save = new String[5];
  Save[0] = "データセット数："+P;
  Save[1] = "確率的勾配法";
  Save[2] = "学習率："+NN.alpha;
  Save[3] = "自然勾配法";
  Save[4] = "学習率："+GN.alpha;
  saveStrings(folderName+"/setting.txt", Save);
}
ArrayList<String>log = new ArrayList();

void saveLog(String s) {
  println(s);
  log.add(s);
  String[] Save = new String[log.size()];
  for (int i = 0; i < log.size(); i++) {
    Save[i] = log.get(i);
  }
  saveStrings(folderName+"/log.txt", Save);
}

ArrayList<String>historyN = new ArrayList();

void saveHistoryN(String s) {
  historyN.add(s);
  String[] Save = new String[historyN.size()];
  for (int i = 0; i < historyN.size(); i++) {
    Save[i] = historyN.get(i);
  }
  saveStrings(folderName+"/historyN.txt", Save);
}

ArrayList<String>historyG = new ArrayList();

void saveHistoryG(String s) {
  historyG.add(s);
  String[] Save = new String[historyG.size()];
  for (int i = 0; i < historyG.size(); i++) {
    Save[i] = historyG.get(i);
  }
  saveStrings(folderName+"/historyG.txt", Save);
}

void saveImage(int step) {
  save(folderName+"/Image"+step+".png");
}
