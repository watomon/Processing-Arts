//学籍番号:11671040 氏名:川崎智憲

//プレイヤーボールの各座標
int vx = 5;
int vy = 5;
int r = 50;
//プレイヤーボールの配列宣言
int []x = new int[15];
int []y = new int[15];

//自分と敵の体力
int hp_pl = 300;
int hp_en = 300;

//相手ボールの各座標
float x_en;
float y_en;
int speed = 4;

//弾幕の設定
float[]x_dan= new float [25];
float[]y_dan= new float [25];

//場面遷移を表す変数
int state;

//???
boolean comand=false;

void setup(){
  size(1250,700);//画面サイズ指定
  ellipseMode(CENTER);
  smooth();//なめらかに描写
  
  textAlign(CENTER);//文字の位置設定を中央指定にする
  
  //弾幕の初期位置設定
  for(int i = 0;i<x_dan.length;i++){
    x_dan[i]=random(1300,3000);
    y_dan[i]=random(75,685);
  }
  x_en=random(1300,1350);
  y_en=random(75,675);
  comand=false;
}



void draw(){
  int nextState= 0;//現在の場面変数を宣言し、最初は0
  if(state == 0){
    nextState = title();//０のとき、タイトル画面へ
  }else if(state == 1){
    nextState = game();//１のとき、ゲーム画面へ
  }else if(state == 2){
    nextState = ending(); //２のとき、ゲームオーバー画面へ
  }else if(state == 3){
    nextState = howto();//3のとき、説明画面へ
  }else if(state == 4){
    nextState = comp();//４のとき、クリア画面へ
  }
  state = nextState;//場面変数を保存
}


//タイトル画面
int title(){
  textAlign(CENTER);//文字を中央揃えに
  background(0);//背景を黒に指定
  fill(255);//文字の色を白に指定
  textSize(70);
  text("DiskLaser ", width * 0.5, height * 0.3);
  textSize(40);
  text("Start:'s' Button", width * 0.5, height * 0.6);
  text("How to play:'h' Button", width * 0.5, height * 0.7);
  if(keyPressed && key == 's'){ // ｓキーを押すとゲームスタート
    return 1; // start game
  }
  if(keyPressed && key == 'h'){ //ｈキーを押すと説明画面へ
    return 3; // 
  }
  return 0;//再びタイトル画面へ
}
//ゲーム画面 
int game(){
  //ボールの移動範囲を制限
  mouseX=constrain(mouseX,25,1050);
  mouseY=constrain(mouseY,75,685);
  //残像を表現
  fill(0, 50);
  rect(0, 0, width, height);
  //上のHPバーの表示
  noStroke();
  fill(255);
  rect(0,0,width,50);
  fill(0,255,100);
  rect(12,12,hp_pl,30);
  fill(0);
  line(400,0,400,50);
  line(850,0,850,50);
  fill(255,255,0);
  rect(900,12,hp_en,30);
  
  
  //自分のボールの描写
  for(int i=x.length-1;i>0;i--){
    x[i] = x[i-1];//配列を一個前へ移動させる
    y[i] = y[i-1];//配列を一個前へ移動させる
  }
  x[0]=mouseX;//マウスに追従
  y[0]=mouseY;//マウスに追従
  for(int i=x.length-1;i>0;i--){
    fill(0,255,255,100-i*6.1);
    stroke(0,255,255);
    if(hp_pl<150){//HPが半分以下になると色が変わる
      fill(255,240,0,100-i*6.1);
      stroke(255,240,0);
    }
    if(hp_pl<75){//HPが1/4以下になると色が変わる
      fill(0,70);
      stroke(255,0,0);
    }
    ellipse(x[i],y[i],r,r);
    fill(0,125,255,100-i*6.1);
    
    if(hp_pl<150){//HPが半分以下になると色が変わる
      fill(255,180,0,100-i*6.1);
    }
    if(hp_pl<75){//HPが1/4以下になると色が変わる
      fill(255,0,0,100-i*6.1);
    }
    ellipse(x[i],y[i],r*0.8,r*0.8);
  }
  
  //敵ボールの追跡の描写
  stroke(255,125,0);  
  fill(255,125,0,50);
  ellipse(x_en,y_en,30,30);
  fill(255,125,0);
  ellipse(x_en,y_en,20,20);
  x_en-=8;
  //敵ボールが画面から出ると、また右から出現
  if(x_en+50<0){
    x_en=int(random(1300,1400));
  }
  y_en=constrain(y_en,76,675);//敵ボールのｙ座標を制限
  //自分と敵ボールのダメージ判定
  float d1 = dist(mouseX,mouseY,x_en,y_en);
  if(d1<40){//距離が一定以上縮まるとダメージを受ける
    hp_pl-=2;
    if(hp_pl<hp_pl*0.5){ //自分のHPが半分以下だと弾幕のダメージ2倍
        hp_pl-=4;
        if(hp_pl<hp_pl*0.25){//自分のHPが1/4以下だと弾幕のダメージ5倍
          hp_pl-=10;
        }
      }
  }
  hp_pl=constrain(hp_pl,0,300);//自分のHPを制限
  if(x_en+50>=mouseX){
    if(y_en<mouseY){//敵が自分より上にいる時、下へ移動
      y_en+=speed;
    }
    if(y_en>mouseY){//敵が自分より下にいる時、上へ移動
      y_en+=-speed;
    }
  }
  
  
  //レーザーの描写
  if(mousePressed){    
    if(mouseButton==LEFT){//マウスの左を押している時、
      stroke(0,255,255);
      if(hp_pl<150){//自分のHPが半分以下だとレーザーの色も変化
        stroke(255,240,0);
      }if(hp_pl<75){//自分のHPが1/4以下だとレーザーの色も変化
        stroke(255,0,0);
      }
      line(mouseX+30,mouseY-20,mouseX+350,mouseY-20);
      line(mouseX+30,mouseY+20,mouseX+350,mouseY+20);
      
      fill(0,255,255,70);
      if(hp_pl<150){//自分のHPが半分以下だとレーザーの色も変化
        fill(255,240,0,70);
      }
      if(hp_pl<75){//自分のHPが1/4以下だとレーザーの色も変化
        fill(255,0,0,70);
      }
      noStroke();
      rect(mouseX+30,mouseY-20,320,40);
      arc(mouseX+350,mouseY,40,40,radians(270),radians(450));
      fill(0,80);
      arc(mouseX+30,mouseY,40,40,radians(270),radians(450));
    }
  }
  //敵ボスのダメージ判定
  if(mousePressed){
    if(mouseY>200&&mouseY<500){//レーザーが当たると敵ボスにダメージ
      if(mouseX+30<1125&&mouseX+30>775||1125<mouseX+370&&mouseX+370<1375){
        hp_en-=0.0001;
      }
    }
  }
  
  //弾幕の描写
  if(hp_pl<150){
    comand=true;
  }
  for(int i = 0;i<x_dan.length;i++){
    x_dan[i]-=int(random(2,15));//弾幕のスピードをランダムに
    if(comand){
      if(keyPressed&&key=='g'){
      x_dan[i]=int(random(1250,2500));
      }
    }
    fill(0);
    stroke(255,0,102);
    ellipse(x_dan[i],y_dan[i],15,15);
    fill(255,0,102,50);
    ellipse(x_dan[i],y_dan[i],10,10);
    y_dan[i]=constrain(y_dan[i],45,685);
    if(x_dan[i]+5<0){
      x_dan[i]=random(1300,3000);//弾幕が画面外に出ると、また右から出現
    }
    float d2 =dist(mouseX,mouseY,x_dan[i],y_dan[i]);
    if(d2<30){//弾幕に当たると、ダメージを受ける
      hp_pl-=0.1;
      if(hp_pl<hp_pl*0.5){ //自分のHPが半分以下だと弾幕のダメージ2倍
        hp_pl-=0.2;
        if(hp_pl<hp_pl*0.25){//自分のHPが1/4以下だと弾幕のダメージ5倍
          hp_pl-=0.5;
        }
      }
    }
  }
  
  
  //敵ボスの描写
  fill(125,0,225);
  noStroke();
  ellipse(1250,350,300,300);
  if(hp_en<225){//ボスのHPが3/4以下になるとダメージバリア発生
    fill(125,0,225,60);
    ellipse(1250,350,600,600);
    float d3 =dist(mouseX,mouseY,1250,350);
    if(d3<300){//バリアはプレイヤーのHPを吸収する
      hp_pl-=2;
      hp_en+=2;
    }
  }
  //歯車の描写 
  stroke(0);
  translate(1250,350);//四角形を回転させるため、中心座標を移動させる
  
  rotate(radians(frameCount));//フレームのカウント数に合わせて回転
  rect(-175,-20,350,40);
  rect(-20,-175,40,350);
  rotate(radians(45));
  rect(-175,-20,350,40);
  rotate(radians(90));
  rect(-175,-20,350,40);
  fill(0);
  ellipse(0,0,250,250);
  fill(125,0,255);
  ellipse(0,0,100,100);
  
  
  
  if(hp_pl==0){//自分のHPが0になるとゲームオーバー
    return 2;
  }
  if(hp_en==0){//敵ボスのHPが0になるとゲームクリア
    return 4;
  }
  return 1;//再びゲーム画面に戻る
}


//リトライ画面
int  ending(){
  textAlign(CENTER);//文字を中央に揃える
  fill(255);
  background(0);//背景を黒に
  textSize(70);
  text("Gameover", width * 0.5, height * 0.3);
  textSize(40);
  text("Press 'r' to restart", width * 0.5, height * 0.6);
  text("Press 't' to title", width * 0.5, height * 0.7);
  if(keyPressed && key == 'r'){//rキーを押すとリスタート
    hp_pl=300;
    hp_en=300;
    return 1;
  }
  if(keyPressed && key == 't'){//tキーを押すとタイトル画面へ
    hp_pl=300;
    hp_en=300;
    return 0;
  }
  return 2;//再びリトライ画面へ
}

//クリア画面
int  comp(){
  textAlign(CENTER);//文字を中央に揃える
  fill(255);
  background(0);//背景を黒に
  textSize(70);
  text("Game Clear!", width * 0.5, height * 0.3);
  textSize(40);
  text("Press 'r' to restart", width * 0.5, height * 0.6);
  text("Press 't' to title", width * 0.5, height * 0.7);
  if(keyPressed && key == 'r'){//rキーを押すとリスタート
    hp_pl=300;
    hp_en=300;
    return 1;
  }
  if(keyPressed && key == 't'){//tキーを押すとタイトル画面へ
    return 0;
  }
  return 4;//再びクリア画面へ
}

//説明画面
int howto(){
  textAlign(LEFT);//文字を左に揃える
  //自分のボール説明
  background(0);
  fill(255);
  text("Yourself", 180, 150);
  fill(0,255,255,50);
  stroke(0,255,255);
  ellipse(200,200,50,50);
  fill(0,255,255);
  ellipse(200,200,40,40);
  
  textAlign(LEFT);//文字を左に揃える
  textSize(40);
  fill(255);
  text("Please control by mouse pointer", 250, 210);
  text("You have a Laser rifle.", 250, 250);
  
  //敵の説明
  fill(255);
  text("Enemys", 180, 300);
  fill(255,125,0,50);
  stroke(255,125,0);
  ellipse(250,340,40,40);
  fill(255,125,0);
  ellipse(250,340,30,30);
  fill(0);
  stroke(255,0,102);
  ellipse(300,340,30,30);
  fill(255,0,102);
  ellipse(300,340,20,20);
  
  fill(255);
  text("They are invulnerable...Please avoid them!",250,410);
  
  fill(255);
  text("Start:'s' Button", width*0.75, 650);
  if(keyPressed && key == 's'){ //ｓキーを押すとゲームスタート
    return 1; 
  }
  //ボスの説明
  fill(255);
  text("Boss", 180, 450);
  text("Be careful..maybe,the boss can have barrier.",350,520);
  fill(125,0,225);
  noStroke();
  ellipse(250,550,300*0.5,300*0.5);
  if(hp_en<225){//ボスのHPが3/4以下になるとダメージバリア発生
    fill(125,0,225,60);
    ellipse(1250,350,600,600);
    float d3 =dist(mouseX,mouseY,1250,350);
    if(d3<300){//バリアはプレイヤーのHPを吸収する
      hp_pl-=2;
      hp_en+=2;
    }
  }
  stroke(0);
  translate(250,550);//四角形を回転させるため、中心座標を移動させる
  
  rotate(radians(frameCount));//フレームのカウント数に合わせて回転
  rect(-175*0.5,-20*0.5,350*0.5,40*0.5);
  rect(-20*0.5,-175*0.5,40*0.5,350*0.5);
  rotate(radians(45));
  rect(-175*0.5,-20*0.5,350*0.5,40*0.5);
  rotate(radians(90));
  rect(-175*0.5,-20*0.5,350*0.5,40*0.5);
  fill(0);
  ellipse(0,0,250*0.5,250*0.5);
  fill(125,0,255);
  ellipse(0,0,100*0.5,100*0.5);
  return 3;//再び説明画面に戻る
}


  