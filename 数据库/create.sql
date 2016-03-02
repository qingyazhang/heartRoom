DROP DATABASE IF EXISTS `13354218`;
CREATE DATABASE `13354218`;
USE `13354218`;

DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Shows;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS LikeShows;
DROP TABLE IF EXISTS LikeComments;
DROP TABLE IF EXISTS CommentShows;
DROP TABLE IF EXISTS ReplyComments;
DROP TABLE IF EXISTS Messages;

#用户表
CREATE TABLE Users(
user_id int auto_increment,
username varchar(50) not null, # 用户名
password varchar(50) not null, # 密码 MD5
permission int default 1, # 权限 0管理员 1普通用户
email varchar(255), #邮箱
sex int default 1, # 性别 0 男 1 女
age int default 20, # 年龄
head_pic varchar(255), # 头像图片名
bg_pic varchar(255), # 背景图片名
signature text, # 个人签名
music varchar(255), # 背景音乐路径
reg_time TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
restriction int default 0, # 限制 0无限制 1禁止登陆 2被屏蔽
UNIQUE(username), #用户名唯一
primary key(user_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

#用户发表的show
CREATE TABLE Shows(
show_id int auto_increment,
user_id int, # 发表的用户
content text not null, # 文本内容
mode int default 0, #模式 0公开不匿名 1公开匿名 2不公开
comment_num int default 0, # 被评论次数
show_time TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
restriction int default 0, # 限制 0无限制 1被管理员屏蔽
primary key(show_id),
foreign key(user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

#所有评论内容
CREATE TABLE Comments(
comment_id int auto_increment,
content text, # 内容
comment_num int default 0, # 被直接评论次数
belong_show int, #属于哪一个show的，最原始那个show
type int default 0, #评论类型 0评论show 1评论评论
comment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, #评论时间，默认赋值
primary key(comment_id),
foreign key(belong_show) references Shows(show_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


#对Show点赞联系 一个用户对一条show进行点赞
CREATE TABLE LikeShows(
from_user_id int, # 点赞用户
to_show_id int, # 被点赞show
like_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, # 赞时间 ，默认赋值
primary key(from_user_id,to_show_id),
foreign key(from_user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(to_show_id) references Shows(show_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

#对Comment点赞联系 一个用户对一条comment进行点赞
CREATE TABLE LikeComments(
from_user_id int, # 点赞用户
to_comment_id int, # 被点赞comment
like_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, # 赞时间 ，默认赋值
primary key(from_user_id,to_comment_id),
foreign key(from_user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(to_comment_id) references Comments(comment_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 评论show 一个用户对另一个用户发表的show进行评论
CREATE TABLE CommentShows(
from_user_id int, # 评论用户
to_show_id int, # 被评论show
comment_id int, # 评论内容id
primary key(from_user_id,comment_id,to_show_id),
foreign key(from_user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(to_show_id) references Shows(show_id) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(comment_id) references Comments(comment_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 回复评论 一个用户对另一个用户的评论作出回复
CREATE TABLE ReplyComments(
from_user_id int, # 回复用户
to_comment_id int, # 被回复的评论
comment_id int, # 回复内容 属于评论
primary key(from_user_id,to_comment_id,comment_id),
foreign key(from_user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(to_comment_id) references Comments(comment_id) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(comment_id) references Comments(comment_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

#信息表 系统信息 赞信息 评论信息 回复信息 屏蔽信息
CREATE TABLE Messages(
message_id int auto_increment,
from_user_id int default 0, # 来自哪里 0表示来自系统
to_user_id int not null, # 发往哪里
content text, # 内容
rid int, # 相关id
msg_type int default 0, # 信息类别 0系统信息 1Show被赞信息 2Comment被赞信息 3被评论信息 4被回复信息 5用户被屏蔽信息 6发表的Show被屏蔽信息
has_read int default 0, # 是否已经被用户读取 0未读 1已读
create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, # 信息生成时间 ，默认赋值
primary key(message_id),
foreign key(from_user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(to_user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

#保存的会话信息 默认7天
CREATE TABLE Sessions(
session_id varchar(255), # 随机
user_id int, # 会话用户
valid_time TIMESTAMP, # 有效截止日期 自1970年1月1日 00:00:00 GMT开始到现在所表示的毫秒数
login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, #登陆时间，默认赋值
primary key(session_id, user_id),
foreign key(user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;




