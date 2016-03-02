<%@page import="com.web.Lmj.SessionCounter"%>
<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.User"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
Integer user_id = (Integer)session.getAttribute("user_id");

System.out.println("user_id: "+user_id);
User user = new User();
if (user_id!=null){
	user = DAO.getUser(user_id);
}
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <script type="text/javascript" src="../js/myJquery.js">
        </script>
        <script type="text/javascript" src="../js/md5.js">
        </script>
        <script type="text/javascript" src="../js/me.js">
        </script>
        <script type="text/javascript" src="../js/public.js">
        </script>
        <script type="text/javascript" src="../js/personal.js">
        </script>
        <script type="text/javascript" src="../js/index.js">
        </script>

        <link rel="stylesheet" href="../css/index.css" type="text/css" />
        <link rel="stylesheet" href="../css/me.css" type="text/css" />
        <link rel="stylesheet" href="../css/public.css" type="text/css" />
        <link rel="stylesheet" href="../css/personal.css" type="text/css" />
        <title>
            心灵小阁
        </title>
    </head>
    <body>
    	<div id="div_head_title">
            <p id="head_title">我的小阁</p>
        </div>
        <!-- 头部背景图片 -->
        <div id="div_head">
            <img id="div_head_bg" src="../img/bg_user.jpg" />
            <!-- 头部用户头像，用户名，签名，登陆，退出，注册 -->
            <div id="div_head_user">
                <a id="btn_unread_msg_num" style="display:none;" onclick="showMeContainerToNews();">-100</a>
                <span id="has_logined" style="display:none;" ><%=user.getUser_id()==0? 0 : 1 %></span>
                <span id="userMusic" style="display:none;"><%=user.getMusic()%></span>
                <img id="head_user_pic" src="../img/<%=user.getHead_pic()%>" onclick="showFun();"/>
                <br/>
                <h1 id="head_username">
                   <%=user.getUsername() %>
                </h1>
                <p id="signature">
                    <%=user.getSignature() %>
                </p>
                <a id="login" onclick="showLogin();" style="display:<%=user.getUser_id()==0? "" : "none" %>;">
                    登录
                </a>
                <a id="logout" onclick="toLogout();" style="display:<%=user.getUser_id()==0? "none" : "" %>;">
                    退出
                </a>
                <a id="register" onclick="showRegister();" style="display:<%=user.getUser_id()==0? "" : "none" %>;">
                    注册
                </a>
            </div>
        </div>

        <!-- 登录浮动层 -->
        <div class="div_float" id="div_login"  onkeydown="keyLogin();" style="display:none;">
            <div class="div_float_head">
                <h2>
                    登录
                </h2>
                <a class="div_float_head_close" onclick="closeFloat();">
                    X
                </a>
            </div>
            <form id="form_login" action="login.jsp" onsubmit="return false;">
                <input type="text" name="username" id="login_username" placeholder="用户名"/>
                <br/>
                <input type="password" name="password" id="login_password" placeholder="密码"/>
                <br/>
                <div id="div_remember">
                    <input type="checkbox" id="remember" name="remember" />
                    <label id="remember_text" for="remember">
                        7天内免登录
                    </label>
                </div>
                <a id="btn_login" onclick="toLogin();">登录</a>
                <br/>
                <p id="login_hint" style="display:none;">请输入用户名...</p>
                <a class="turn_resetPassword" onclick="showResetPassword();">忘记密码了吗???</a>
                <br/>
                <a class="turn_regester" onclick="showRegister();">还是先注册个账号吧...</a>
        </form>
    </div>
    <!-- 注册浮动层 -->
    <div class="div_float" id="div_register" onkeydown="keyRegister();" style="display: none;">
            <div class="div_float_head">
                <h2>
                    注册
                </h2>
                <a class="div_float_head_close" onclick="closeFloat();">
                    X
                </a>
            </div>
            <form id="form_register" action="register.jsp" onsubmit="return false;">
                <input type="text" name="username" id="register_username" placeholder="用户名" onpropertychange="checkUsername();" oninput="checkUsername();"/>
                <br/>
                <input type="password" name="password" id="register_password" placeholder="密码"/>
                <br/>
                <input type="password" name="re_password" id="register_re_password" placeholder="确认密码"/>
                <br/>
                <input type="email" name="email" id="register_email" placeholder="常用邮箱"/>
                <br/>
                <input type="radio" name="sex" value="0" id="male" checked/> <label for="male">男</label>
                <input type="radio" name="sex" value="1" id="female" /> <label for="female">女</label>
                <br/>
                <a id="btn_register" onclick="toRegister();">注册</a>
                <br/>
                <p id="register_hint" style="display:none;">请输入用户名...</p>
                <a class="turn_login" onclick="showLogin();">突然想起，已经有账号了呐...</a>
        </form>
    </div>
    <!-- 重置密码层 -->
    <div class="div_float" id="div_reset_password" onkeydown="keyResetPassword();" style="display: none;">
            <div class="div_float_head">
                <h2>
                    重置密码
                </h2>
                <a class="div_float_head_close" onclick="closeFloat();">
                    X
                </a>
            </div>
            <form id="form_reset_password" action="resetPassword.jsp" onsubmit="return false;">
                <input type="text" name="username" id="reset_password_username" placeholder="用户名"/>
                <br/>
                <input type="email" name="email" id="reset_password_email" placeholder="注册邮箱"/>
                <br/>
                <input type="password" name="password" id="reset_password_password" placeholder="密码"/>
                <br/>
                <input type="password" name="password" id="reset_password_re_password" placeholder="确认密码"/>
                <br/>
                <a id="btn_reset_password" onclick="toResetPassword();">重置密码</a>
                <br/>
                <p id="reset_password_hint" style="display:none;">请输入用户名...</p>
                <a class="turn_login" onclick="showLogin();">突然想起了密码...</a>
                <a class="turn_regester" onclick="showRegister();;">不好意思，开了个玩笑，其实我还没注册...</a>
        </form>
    </div>
    <!-- 头部切换按钮 -->
    <div id="div_head_tab">
        <div id="div_head_btn">
            <a class="btn_tab" id="btn_public" onclick="showPublicContainer();">Public</a>
            <a class="btn_tab" id="btn_me" onclick="showMeContainer();">Me</a>
            <a class="btn_tab" id="btn_personal" onclick="showPersonalContainer();">Personal</a>
        </div>
    </div>
    <!-- 分割线 -->
<!--     <div class="line"></div> -->
    <!-- container -->
    <!-- Public -->
    <div id="div_public_container" class="container" style="display:none">
        <!-- show表单 -->
        <div id="div_public_form" onkeydown="keyPushPublicShow();">
            <textarea name="content" id="public_form_textarea" autofocus="autofocus" style="resize:none;" placeholder="想说点什么"></textarea>
            <select name="mode" id="public_form_mode">
                <option value="0" selected="selected">公开</option>
                <option value="1">公开匿名</option>
                <option value="2">不公开</option>
            </select>
            <a id="btn_public_push_show" onclick="pushPublicShow();">发表</a>
        </div>
        <!-- Public Show -->
        <div id="div_public_show">

            <div class="public_show_container">
                <span class="show_id" style="display:none;"></span>
                <span class="show_user_id" style="display:none;"></span>
                <a class="public_show_delete" style="display:;" onclick="deletePublicShow(this);">X</a>
                <div class="public_show_left">
                    <img src="../img/head_admin.jpg" class="public_show_head_pic" />
                    <a class="public_show_username" onclick="showPublicShowUserInfo(this);">小狼</a>
                </div>
               <div class="public_show_right">
                    <p class="public_show_text">Hello，大家好好好啊好好好好啊好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好</p>
                    <div style="width:100%;"><span class="publie_show_like_text">30 个人赞了！</span><span class="public_show_time">2012-02-02 02:02:01</span></div>
                    <img src="../img/like_left.png" class="public_show_like_left " onclick="pushPublicShowLike(this);">
                    <a class="btn_public_show_comment" onclick="showPublicCommentDiv(this);">隐藏评论 2</a>
                    <img src="../img/like_right.png" class="public_show_like_right" onclick="pushPublicShowLike(this);">
                </div>
                <!-- 评论 -->
                <div class="public_show_bottom">
                    <div class="div_public_show_comment">
                        <input type="text" class="public_show_comment_content" name="content" />
                        <a class="btn_public_show_push_comment" onclick="pushPublicShowComment(this);">评论</a>
                    </div>
                    <!-- 子评论 -->
                    <div class="div_public_show_subcomment" style="display:;">

                    <!-- 一条评论 -->
                        <div class="div_public_show_subcomment_container">
                            <span class="comment_id" style="display:none;"></span>
                            <span class="comment_user_id" style="display:none;"></span>
                            <a class="public_show_comment_delete" style="display:;" onclick="deletePublicShowComment(this);">X</a>
                            <img class="public_show_subcomment_head_pic" src="../img/head_user.gif">
                            <div class="public_show_subcomment_detail">
                                <a class="public_show_subcomment_from" onclick="showPublicShowCommentUserInfo(this);">from</a>
                                <span class="public_show_subcomment_text">回复</span>
                                <a class="public_show_subcomment_to" onclick="showPublicShowCommentUserInfo(this);">to</a>
                                <span class="public_show_subcomment_text">：</span>
                                <p class="public_show_subcomment_content">评论评论</p>
                                <p>
                                    <span class="public_show_subcomment_time">2016-01-26 22:27:33</span>
                                    <input type="text" class="public_show_subcomment_reply_content">
                                    <a class="btn_public_show_subcomment_reply" onclick="replyPublicShowComment(this);">回复</a>
                                    <span class="public_show_subcomment_like_num">100</span>
                                    <img class="public_show_subcomment_like" onclick="likePublicShowComment(this);" src="../img/like_left.png">
                                </p>
                            </div>
                        </div>
                        <!-- 一条comment end -->


                    </div>
                    <a class="btn_public_show_more_subcomment" onclick="loadMoreComment(this);" style="display:;">查看更多...</a>
                </div>
            </div>
            <!-- 一条show end -->
        </div>
        <!-- 翻页 -->
        <div id="div_public_page_turn">
            <a id="btn_public_show_turn_last" class="btn_show_turn" onclick="turnLastPublicShow();" style="display:'';">上一页</a>
            <a id="btn_public_show_turn_next" class="btn_show_turn" onclick="turnNextPublicShow();" style="display:'';">下一页</a>
        </div>
    </div>
    <!-- Me -->
    <div id="div_me_container" class="container" style="">
        <div id="div_me_head">
        <a class="btn_me_head" id="btn_news" onclick="showNews();">News</a><a class="btn_me_head" id="btn_setting" onclick="showSetting();">Setting</a>
        </div>
        <!-- News -->
        <div id="div_me_news" class="div_me_subcontainer" style="display:none;">
            <div id="div_me_news_container">
                <!-- one news begin -->
                <div class="div_me_news_subcontainer">
                    <span class="message_id" style="display:none;"></span>
                    <span class="msg_type" style="display:none;"></span>
                    <span class="from_user_id" style="display:none;"></span>
                    <span class="btn_news_delete" onclick="deleteNews(this);">X</span>
                    <span class="btn_news_has_unread" onclick="setHasRead(this);">标记为已读</span>
                    <p class="news_title">于 <span class="news_time">2016-01-27 21:44:08</span> from <span class="news_from_user" onclick="showNewsFromUser(this);">hello</span></p>
                    <p class="news_content">很不幸的告诉你，你被管理员屏蔽了!</p>
                    <a class="btn_news_detail" style="display:none;" onclick="jumpNewsDetail(this);">查看详细</a>
                </div>
                <!-- one news end -->

            </div>
            <a class="btn_news_more" onclick="loadMoreNews(this);" style="display:;">查看更多...</a>
        </div>

        <!-- Setting -->
        <div id="div_me_setting" class="div_me_subcontainer" style="">
            <form id="form_setting" id="form_setting" action="uploadHeadPic.jsp" method="POST" ENCTYPE="multipart/form-data">
                <img src="../img/head_user.gif" id="setting_head_pic" onclick="selectHeadPic();" />
                <input type="file" accept="image/*" style="display:none;" name="file" id="setting_img_file" onchange="imgFileSelected();"/>
                <table id="setting_table">
                    <tr>
                        <td> <span class="setting_field">昵称：</span></td>
                        <td><input class="setting_value" value="神一般的男人" name="username" id="setting_username" type="text" onpropertychange="settingCheckUsername();" oninput="settingCheckUsername();"/></td>
                    </tr>
                    <tr>
                        <td> <span class="setting_field">签名：</span></td>
                        <td><input class="setting_value" value="神一般的男人在这里" name="signature" id="setting_signature" type="text" /></td>
                    </tr>
                    <tr>
                        <td> <span class="setting_field">身份：</span></td>
                        <td><span id="setting_permission">管理员</span></td>
                    </tr>
                    <tr>
                        <td> <span class="setting_field">邮箱：</span></td>
                        <td><input class="setting_value" value="123@qq.com" style="font-size: 20px;" id="setting_email" name="email" type="email" /></td>
                    </tr>
                    <tr>
                        <td> <span class="setting_field">性别：</span></td>
                        <td><input name="sex" value='0' type="radio" id="setting_male" checked/><label for="setting_male" class="setting_text">男</label><input name="sex" value='1' type="radio" id="setting_female" /><label for="setting_female" class="setting_text">女</label></td>
                    </tr>
                    <tr>
                        <td> <span class="setting_field">年龄：</span></td>
                        <td><input class="setting_value" value="20" id="setting_age" style="font-size: 20px;" name="age" type="number" step="1" min="5" max="200"/></td>
                    </tr>
                    <tr>
                        <td> <span class="setting_field">音乐：</span></td>
                        <td><span id="setting_music">InThere.mp3</span><a id="btn_select_music" onclick="selectMusic();">Change</a>
                        <input type="file" accept="audio/*" style="display:none;" name="file" id="setting_music_file"  onchange="musicFileSelected();"/></td>
                    </tr>
                    <tr>
                        <td> <span class="setting_field">入住：</span></td>
                        <td><span id="setting_reg_time">2015-01-01 01:01:01</span></td>
                    </tr>

                    <tr class="setting_password" style="display:none;">
                        <td> <span class="setting_field">旧密码：</span></td>
                        <td><input class="setting_value" value="" name="old_password" id="setting_old_password" type="password" /></td>
                    </tr>
                    <tr class="setting_password" style="display:none;">
                        <td> <span class="setting_field">新密码：</span></td>
                        <td><input class="setting_value" value="" name="new_password" id="setting_new_password" type="password" /></td>
                    </tr>
                    <tr class="setting_password" style="display:none;">
                        <td> <span class="setting_field">确认密码：</span></td>
                        <td><input class="setting_value" value="" name="password" id="setting_re_new_password" type="password" /></td>
                    </tr>
                    <tr><td colspan="2"><a id="btn_show_setting_password_div" onclick="showPasswordDiv();">修改密码</a></td></tr>

                    <tr><td colspan="2"><p id="setting_hint" style="display:none;">提示</p></td></tr>
                    <tr><td colspan="2"><a id="btn_settion_modify" onclick="updateUserInfo();">修改</a></td></tr>
                </table>
            </form>
        </div>
    </div>
    <!-- Personal -->
    <div id="div_personal_container" class="container" style="display:none">

        <!-- show表单 -->
        <div id="div_personal_form" onkeydown="keyPushPersonalShow();">
            <textarea name="content" id="personal_form_textarea" autofocus="autofocus" style="resize:none;" placeholder="想说点什么" ></textarea>
            <select name="mode" id="personal_form_mode">
                <option value="0">公开</option>
                <option value="1" selected="selected">公开匿名</option>
                <option value="2">不公开</option>
            </select>
            <a id="btn_personal_push_show" onclick="pushPersonalShow(this);">发表</a>
        </div>
        <!-- Personal Show -->
        <div id="div_personal_show">

            <div class="personal_show_container">
                <span class="show_id" style="display:none;"></span>
                <span class="show_user_id" style="display:none;"></span>
                <a class="personal_show_delete" style="display:;" onclick="deletePublicShow(this);">X</a>
                <div class="personal_show_left">
                    <img src="../img/head_admin.jpg" class="personal_show_head_pic" />
                    <a class="personal_show_username" onclick="showPersonalShowUserInfo(this);">小狼</a>
                </div>
               <div class="personal_show_right">
                    <p class="personal_show_text">Hello，大家好好好啊好好好好啊好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好好</p>
                    <div style="width:100%;">
                        <span class="personal_show_like_text">30 个人赞了！
                        </span>
                        <select name="mode" class="personal_show_mode" onchange="personal_show_mode_change(this);">
                            <option value="0">公开</option>
                            <option value="1" selected>公开匿名</option>
                            <option value="2">不公开</option>
                        </select>
                        <span class="personal_show_time">2012-02-02 02:02:01</span>
                    </div>
                    <div style="clear:both;">
                        <img src="../img/like_left.png" class="personal_show_like_left " onclick="pushPersonalShowLike(this);">
                        <a class="btn_personal_show_comment" onclick="showPersonalCommentDiv(this);">隐藏评论 2</a>
                        <img src="../img/like_right.png" class="personal_show_like_right" onclick="pushPersonalShowLike(this);">
                    </div>
                </div>
                <!-- 评论 -->
                <div class="personal_show_bottom">
                    <div class="div_personal_show_comment">
                        <input type="text" class="personal_show_comment_content" name="content" />
                        <a class="btn_personal_show_push_comment" onclick="pushPersonalShowComment(this);">评论</a>
                    </div>
                    <!-- 子评论 -->
                    <div class="div_personal_show_subcomment" style="display:;">

                    <!-- 一条评论 -->
                        <div class="div_personal_show_subcomment_container">
                            <span class="comment_id" style="display:none;"></span>
                            <span class="comment_user_id" style="display:none;"></span>
                            <a class="personal_show_comment_delete" style="display:;" onclick="deletePersonalShowComment(this);">X</a>
                            <img class="personal_show_subcomment_head_pic" src="../img/head_user.gif">
                            <div class="personal_show_subcomment_detail">
                                <a class="personal_show_subcomment_from" onclick="showPersonalShowCommentUserInfo(this);">from</a>
                                <span class="personal_show_subcomment_text">回复</span>
                                <a class="personal_show_subcomment_to" onclick="showPersonalShowCommentUserInfo(this);">to</a>
                                <span class="personal_show_subcomment_text">：</span>
                                <p class="personal_show_subcomment_content">评论评论</p>
                                <p>
                                    <span class="personal_show_subcomment_time">2016-01-26 22:27:33</span>
                                    <input type="text" class="personal_show_subcomment_reply_content">
                                    <a class="btn_personal_show_subcomment_reply" onclick="replyPersonalShowComment(this);">回复</a>
                                    <span class="personal_show_subcomment_like_num">100</span>
                                    <img class="personal_show_subcomment_like" onclick="likePersonalShowComment(this);" src="../img/like_left.png">
                                </p>
                            </div>
                        </div>
                        <!-- 一条comment end -->


                    </div>
                    <a class="btn_personal_show_more_subcomment" onclick="loadMorePersonalComment(this);" style="display:;">查看更多...</a>
                </div>
            </div>
            <!-- 一条show end -->
        </div>
        <!-- 翻页 -->
        <div id="div_personal_page_turn">
            <a id="btn_personal_show_turn_last" class="btn_show_turn" onclick="turnLastPersonalShow();" style="display:'';">上一页</a>
            <a id="btn_personal_show_turn_next" class="btn_show_turn" onclick="turnNextPersonalShow();" style="display:'';">下一页</a>
        </div>
    </div>

    <!-- 用户信息层 -->
    <div class="div_float" id="div_user_info" style="display: none;">
        <div class="div_float_head">
            <h2 id="user_info_title">
                用户信息
            </h2>
            <a class="div_float_head_close" onclick="closeFloat();">
                X
            </a>
        </div>
        <div id="div_user_info_container">
            <img src="../img/head_user.gif" id="user_info_head_pic">
            <p id="user_info_username">用户名</p>
            <table id="user_info_table">
                <tr>
                    <td>年龄：</td><td id="user_info_age">20</td>
                </tr>
                <tr>
                    <td>性别：</td><td id="user_info_sex">女</td>
                </tr>
                <tr>
                    <td>身份：</td><td id="user_info_permission">普通用户</td>
                </tr>
                <tr>
                    <td>邮箱：</td><td id="user_info_email">123@qq.com</td>
                </tr>
                <tr>
                    <td>个人签名：</td><td style="text-align: left;" id="user_info_signature">姐姐急急急急急急急急急急急急急急急急姐急急急急急急急急急急急急急急急急急急</td>
                </tr>
                <tr>
                    <td>入住时间：</td><td id="user_info_reg_time">20</td>
                </tr>
            </table>
            <div id="div_user_info_shield" style="display:none;"><span id="user_info_shield_text">合计被屏蔽次数：</span> <span id="user_info_shield_num">10</span> <a id="btn_user_info_shield">屏蔽ta</a></div>
        </div>
    </div>

    <!-- 提交bug层 -->
    <div class="div_float" id="div_submit_bug"  onkeydown="keySubmitBug();" style="display: none;">
        <div class="div_float_head">
            <h2>
                提交 Bug
            </h2>
            <a class="div_float_head_close" onclick="closeFloat();">
                X
            </a>
        </div>
        <div id="div_submit_bug_form">
            <textarea name="content" id="bug_textarea" autofocus="autofocus" style="resize:none;" placeholder="Bug！其实不仅是一只小虫子。"></textarea>
            <input type="text" id="buger_contact" placeholder="你的联系方式">
            <a id="btn_submit_bug" onclick="submit_bug();">很严肃地提交</a>
        </div>
    </div>

    <!-- 左下角背景音乐 -->
    <div id="div_bg_music">
        <%-- <audio id="music" draggable="true" src="../music/<%=user.getMusic()%>" controls="controls" loop="loop" autoplay="autoplay" >
        </audio> --%>
    </div>
    <!-- 全屏掩盖层 -->
    <div id="div_mask" style="display: none;">
    </div>

    <!-- 页脚 -->
    <footer>
    	<div id="footer_alive"><span>在线人数：</span><span id="alive_num"><%=SessionCounter.getActiveSessions() %></span></div>
        <div id="footer_group">
            <table>
                <caption>各组员学号:</caption>
                <tr><td>组长：</td><td>13354218</td></tr>
                <tr><td>组员：</td><td>13354420</td></tr>
                <tr><td>组员：</td><td>13354472</td></tr>
                <tr><td>组员：</td><td>13354427</td></tr>
            </table>
        </div>
        <div id="footer_contact">
            <table>
                <caption>联系方式:</caption>
                <tr><td><img id="footer_contact_img_qq" src="../img/qq.png"></td><td>247271565</td></tr>
                <tr><td><img id="footer_contact_img_phone" src="../img/phone.png"></td><td>665881</td></tr>
                <tr><td><img id="footer_contact_img_email" src="../img/email.png"></td><td>247271565@qq.com</td></tr>
            </table>
        </div>
        <div id="footer_friend_link">
            <table>
                <caption>友情链接(寻找中...):</caption>
            </table>
        </div>
        <a id="footer_submit_bug" onclick="showSubmitBug();">提交Bug！</a>
    </footer>
</body>
</html>
