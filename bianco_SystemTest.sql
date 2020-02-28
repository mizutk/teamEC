set names utf8;
set foreign_key_checks=0;

drop database if exists bianco;
create database if not exists bianco;

use bianco;

create table user_info(
id int primary key not null auto_increment comment "ID",
user_id varchar(16) unique not null comment "ユーザーID",
password varchar(16) not null comment "パスワード",
family_name varchar(32) not null comment "姓",
first_name varchar(32) not null comment "名",
family_name_kana varchar(32) not null comment "姓かな",
first_name_kana varchar(32) not null comment "名かな",
sex tinyint default 0 comment "性別",
email varchar(32) comment "メールアドレス",
status tinyint default 0 comment "ステータス",
logined tinyint not null default 0 comment "ログインフラグ",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時"
)
default charset=utf8
comment="会員情報テーブル"
;

create table product_info(
id int primary key not null auto_increment comment "ID",
product_id int unique not null comment "商品ID",
product_name varchar(100) unique not null comment "商品名",
product_name_kana varchar(100) unique not null comment "商品名かな",
product_description varchar(255) comment "商品詳細",
category_id int not null comment "カテゴリID",
price int not null comment "値段",
image_file_path varchar(100) not null comment "画像ファイルパス",
image_file_name varchar(50) not null comment "画像ファイル名",
release_date datetime comment "発売年月",
release_company varchar(50) comment "発売会社",
status tinyint default 1 comment "ステータス",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時",
foreign key(category_id) references m_category(category_id)
)
default charset=utf8
comment="商品情報テーブル";

create table cart_info(
id int primary key not null auto_increment comment "ID",
user_id varchar(16) not null comment "ユーザーID",
product_id int not null comment "商品ID",
product_count int not null comment "個数",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時",
foreign key(product_id) references product_info(product_id)
)
default charset=utf8
comment="カート情報テーブル"
;

create table purchase_history_info(
id int primary key not null auto_increment comment "ID",
user_id varchar(16) not null comment "ユーザーID",
product_id int not null comment "商品ID",
product_count int not null comment "個数",
price int not null comment "値段",
destination_id int not null comment "宛先情報ID",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時",
foreign key(user_id) references user_info(user_id),
foreign key(product_id) references product_info(product_id)
)
default charset=utf8
comment="購入履歴情報テーブル"
;

create table destination_info(
id int primary key not null auto_increment comment "ID",
user_id varchar(16) not null comment "ユーザーID",
family_name varchar(32) not null comment "姓",
first_name varchar(32) not null comment "名",
family_name_kana varchar(32) not null comment "姓かな",
first_name_kana varchar(32) not null comment "名かな",
email varchar(32) comment "メールアドレス",
tel_number varchar(13) comment "電話番号",
user_address varchar(50) not null comment "住所",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時",
foreign key(user_id) references user_info(user_id)
)
default charset=utf8
comment="宛先情報テーブル"
;

create table m_category(
id int primary key not null auto_increment comment "ID",
category_id int not null unique comment "カテゴリID",
category_name varchar(20) not null unique comment "カテゴリ名",
category_description varchar(100) comment "カテゴリ詳細",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時"
)
default charset=utf8
comment="カテゴリマスタテーブル"
;

set foreign_key_checks=1;

insert into user_info values
(1,"guest","guest","インターノウス","ゲストユーザー","いんたーのうす","げすとゆーざー",0,"internous.guest@gmail.com",1,0,now(),now()),
(2,"guest2","guest2","インターノウス","ゲストユーザー2","いんたーのうす","げすとゆーざー2",0,"intenous.guest2@gmail.com",0,0,now(),now());

insert into m_category values
(1,1,"全てのカテゴリー","本、家電・パソコン、おもちゃ・ゲーム全てのカテゴリーが対象となります",now(), now()),
(2,2,"スポーツ用品","スポーツ用品に関するカテゴリーが対象となります",now(),now()),
(3,3,"家電・パソコン","家電・パソコンに関するカテゴリーが対象となります",now(),now()),
(4,4,"おもちゃ・ゲーム","おもちゃ・ゲームに関するカテゴリーが対象となります",now(),now()),
(5,5,"文房具","文房具に関するカテゴリーが対象となります",now(),now());

insert into product_info values
( 1, 1,"スノーボード","すのーぼーど","スノーボードの商品詳細",2,19800,"./images","snowboard.png",now(),"発売会社",1,now(),now()),
( 2, 2,"ゴルフバック","ごるふばっく","ゴルフバックの商品詳細",2,30000,"./images","golfbag.png",now(),"発売会社",1,now(),now()),
( 3, 3,"ダーツセット","だーつせっと","ダーツセットの商品詳細",2,5100,"./images","darts.png",now(),"発売会社",1,now(),now()),
( 4,4,"パソコン","ぱそこん","パソコンの商品詳細",3,58000,"./images","computer.png",now(),"発売会社",1,now(),now()),
( 5,5,"液晶テレビ","えきしょうてれび","液晶テレビの商品詳細",3,31200,"./images","tv.png",now(),"発売会社",1,now(),now()),
( 6,6,"冷蔵庫","れいぞうこ","冷蔵庫の商品詳細",3,158000,"./images","reizouko.png",now(),"発売会社",1,now(),now()),
( 7,7,"ランプ","らんぷ","ランプの商品詳細",3,26000,"./images","lamp.png",now(),"発売会社",1,now(),now()),
( 8,8,"将棋セット","しょうぎせっと","将棋セットの商品詳細",4,2000,"./images","syougi.png",now(),"発売会社",1,now(),now()),
( 9,9,"変形ロボット","へんけいろぼっと","変形ロボットの商品詳細",4,1200,"./images","robot.png",now(),"発売会社",1,now(),now()),
( 10,10,"クマのぬいぐるみ","くまのぬいぐるみ","クマのぬいぐるみの商品詳細",4,700,"./images","bear.png",now(),"発売会社",1,now(),now()),
( 11,11,"ジグソーパズル","じぐそーぱずる","ジグソーパズルの商品詳細",4,1000,"./images","puzzle.png",now(),"発売会社",1,now(),now()),
( 12,12,"ボードゲーム","ぼーどげーむ","ボードゲームの商品詳細",4,1600,"./images","boardgame.png",now(),"発売会社",1,now(),now()),
( 13,13,"鉛筆","えんぴつ","鉛筆の商品詳細",5,20,"./images","enpitsu.png",now(),"発売会社",1,now(),now());

insert into destination_info values
(1,"guest","インターノウス","ゲストユーザー","いんたーのうす","げすとゆーざー","internous.guest@gmail.com","09000000000","東京都千代田区霞が関3-6-15",now(),now());
