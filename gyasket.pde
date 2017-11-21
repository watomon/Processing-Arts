//学籍番号:11671040　氏名　川崎 智憲

int n = 201;//大きさ201

int y=0;//行のｙ座標

//int t=1;//行の数

int[] a = new int[n];//配列Aの宣言
int[] b = new int[n];//配列Bの宣言





void setup(){
  size(402,402);//背景サイズ指定
  background(0);//背景を黒色に
  a[100]=1;//中央に1をセット
  //それ以外は0をセット
  for(int i=0;i<100;i++){
    a[i]=0;
  }
  for(int i=101;i<201;i++){
    a[i]=0;
  }
  
  for(int i=0;i<n;i++){
    if(a[i]==0){//セルが０なら黒
      fill(0);
    }
    if(a[i]==1){//セルが１なら白
      fill(255);
    }
    
    rect(0+i*2,y,2,2);//一列目に配列を表示
  }
}

void draw(){
  y+=2;//一行配列を表示するたびに次の配列のｙ座標を加算
  for(int i=1;i<n-1;i++){//色分け条件分岐
    if(a[i-1]==0&&a[i+1]==0||a[i-1]==1&&a[i+1]==1){//両隣が同じなら次の行の真ん中は0（黒）
      b[i]=0;
    }
    if(a[i-1]==1&&a[i+1]==0||a[i-1]==0&&a[i+1]==1){//両隣が異なる数字なら次の行の真ん中は１（白）
      b[i]=1;
    }
  }
  
  for(int i =0; i<n;i++){
    if(i==0){//左端は0（黒）
      b[i]=0;
    }
    if(i==200){//右端は１（白）
      b[i]=0;
    }
    
    if(b[i]==0){
      fill(0);//０なら黒色に
    }
    if(b[i]==1){
      fill(255);//１なら白色に
    }
    rect(0+i*2,y,2,2);//二行目以降の配列
    
    
    a[i]=b[i];//配列Bを配列Aにコピー
  }
  
}