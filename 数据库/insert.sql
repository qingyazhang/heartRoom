use `13354218`;

insert into Users(username, password, permission, email, sex, age, head_pic, bg_pic, signature, music)
    values('admin', md5(123), 0, 'admin@qq.com', 0, 21, 'head_admin.jpg', 'bg_admin', '我是管理员，我为我自己带盐！', '往日时光.mp3'),
        ('user', md5(123), 1, 'user@qq.com', 1, 20, 'head_user.gif', 'bg_user', '我是用户，我没带盐，但我带人来了！', 'InThere.mp3');