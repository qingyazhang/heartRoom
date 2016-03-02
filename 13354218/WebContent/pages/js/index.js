var timer = null;
window.onload = function(){
    showMeContainer(true);
    if (isIE()){
        alert("sorry, 你使用的浏览器是IE.\n由于IE已经被微软抛弃，我们的网站也没有为IE做适配，所以你的浏览效果会差很多，建议使用谷歌Chrome浏览器浏览...\n由此对你造成的打扰，我们对此再次深感抱歉！");
    }
    // myDrag.init($('#div_bg_music'));
    if ($('#has_logined').innerHTML.trim()==0){
        console.log('未登录');
       autoLogin();
   }else if ($('#has_logined').innerHTML.trim()==1){
        console.log('已登录');
        setUpdateUnreadMsgNum();
   }
   //showMeContainer();
   getUnreadMsgNum();
   clearAll();
    //showMeContainer();
    //showPublicContainer();
    //showPersonalContainer();
    //updateSetting();
    //updatePublic();
    setTimeout(setMusic(), 2000);
}
function setMusic(){
    console.log($('#userMusic').innerHTML.trim());
    console.log($('#div_bg_music').innerHTML);
    $('#div_bg_music').innerHTML = "<audio id=\"music\" src=\"../music/"+$('#userMusic').innerHTML.trim();+"\" controls=\"controls\" loop=\"loop\" autoplay=\"autoplay\"></audio>";
    console.log($('#div_bg_music').innerHTML);
}
function isIE(){
    var navigatorName = "Microsoft Internet Explorer";
       if( navigator.appName == navigatorName ){
            return true;
       }else{
            return false;
       }
}
function clearAll(){
    clearPublicShow();
    clearNews();
    clearPersonalShow();
}
function setUpdateUnreadMsgNum(){
    getUnreadMsgNum();
    if (timer!=null){
        clearInterval(timer);
        timer = setInterval(getUnreadMsgNum, 10000);
    }
}
function updateAll(){
    if ($('#has_logined').innerHTML.trim()==1){
        updateNews();
        updatePersonal();
        updatePublic();
        updateSetting();
        setUpdateUnreadMsgNum();

    }
}
function test(){
    ajax({
        'url': 'test.jsp',
        'type': 'POST',
        'data': {'type':'auto'},
        'dataType': 'text',
        'success':function(data){
            $('#div_public_show').innerHTML = data;
        },
        'error':function(){
        }
    });
}
function showPublicContainerWitoutFlush(){
    hideContainer();
    $('#div_public_container').style.display = '';
    var css = 'color: #2690FE;border-top:2px solid #2690FE;border-bottom:2px solid #2690FE;letter-spacing:2px;';
    $('#btn_public').style.cssText = css;
    setUpdateUnreadMsgNum();
}
function showPublicContainer(){
    hideContainer();
    $('#div_public_container').style.display = '';
    var css = 'color: #2690FE;border-top:2px solid #2690FE;border-bottom:2px solid #2690FE;letter-spacing:2px;';
    $('#btn_public').style.cssText = css;
    clearPublicShow();
    if ($('#has_logined').innerHTML.trim()==1){
        updatePublic();
    }
    setUpdateUnreadMsgNum();
}
function showMeContainerToNews(){
    showMeContainer();
    showNews();
    setUpdateUnreadMsgNum();
}
function showMeContainer(flag){
    hideContainer();
    $('#div_me_container').style.display = '';
    var css = 'color: #2690FE;border-top:2px solid #2690FE;border-bottom:2px solid #2690FE;letter-spacing:2px;';
    $('#btn_me').style.cssText = css;
    clearNews();
    //showNews();
    showSetting();
    if ($('#has_logined').innerHTML.trim()==1){
        updateNews();
        updateSetting(flag);
    }
}
function showPersonalContainer(){
    hideContainer();
    $('#div_personal_container').style.display = '';
    var css = 'color: #2690FE;border-top:2px solid #2690FE;border-bottom:2px solid #2690FE;letter-spacing:2px;';
    $('#btn_personal').style.cssText = css;
    clearPersonalShow();
    if ($('#has_logined').innerHTML.trim()==1){
      updatePersonal();
    }

}
function hideContainer(){
    $('#div_public_container').style.display = 'none';
    $('#div_me_container').style.display = 'none';
    $('#div_personal_container').style.display = 'none';
    var css = 'display:inline-block;vertical-align:middle;width:115px;text-align:center;padding-top:4px;padding-bottom:6px;';
    $('#btn_public').style.cssText = css;
    $('#btn_me').style.cssText = css;
    $('#btn_personal').style.cssText = css;
}
function autoLogin(){
    ajax({
        'url': 'login.jsp',
        'type': 'POST',
        'data': {'type':'auto'},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                $('#head_username').innerHTML = xmler.getDirectNodeValue('username');
                $('#signature').innerHTML = xmler.getDirectNodeValue('signature');
                $('#head_user_pic').src = '../img/'+xmler.getDirectNodeValue('head_pic');
                if ($('#music')!=null){
                    $('#music').pause();
                }
                $('#div_bg_music').innerHTML = "<audio id=\"music\" src=\"../music/"+xmler.getDirectNodeValue('music')+"\" controls=\"controls\" loop=\"loop\"></audio>";
                $('#music').play();
                $('#login').style.display = 'none';
                $('#logout').style.display = '';
                $('#register').style.display = 'none';
                $('#has_logined').innerHTML = 1;
                updateAll();
            }else{
                if ($('#music')!=null){
                    $('#music').pause();
                }
                $('#div_bg_music').innerHTML = "<audio id=\"music\" src=\"../music/"+xmler.getDirectNodeValue('music')+"\" controls=\"controls\" loop=\"loop\"></audio>";
                $('#music').play();
            }
        },
        'error':function(){
            Toast('sorry，自动登录出错了。');
        }
    });
}
function closeFloat(){
    closeFloatMask();
    closeFloatDiv();
}
function closeFloatMask(){
    $('#div_mask').style.display = 'none';
}
function closeFloatDiv(){
    $('#div_login').style.display = 'none';
    $('#div_register').style.display = 'none';
    $('#div_reset_password').style.display = 'none';
    $('#div_user_info').style.display = 'none';
    $('#div_submit_bug').style.display = 'none';

}
function showSubmitBug(){
    closeFloat();
    $('#div_mask').style.display = '';
    $('#div_submit_bug').style.display = '';
}
function showLogin() {
    closeFloat();
    $('#div_mask').style.display = '';
    $('#div_login').style.display = '';
    var username = $('#login_username').value;
    var password = $('#login_password').value;
    if (username==''){
        $('#login_username').focus();
    }else if (password==''){
        $('#login_password').focus();
    }else{
        $('#btn_login').focus();
    }
}
function showUserInfoDiv(){
    closeFloat();
    $('#div_mask').style.display = '';
    $('#div_user_info').style.display = '';
}

function showRegister() {
    closeFloat();
    $('#div_mask').style.display = '';
    $('#div_register').style.display = '';
    $('#register_username').focus();
}

function showResetPassword() {
    closeFloat();
    $('#div_mask').style.display = '';
    $('#div_reset_password').style.display = '';
    $('#reset_password_username').focus();
}
function keyLogin(){
    if(window.event.keyCode == 13){
        toLogin();
    }
}
function toLogin(){
    var username = $('#login_username').value;
    var password = $('#login_password').value;
    if (username==''){
        $('#login_hint').style.display = '';
        $('#login_hint').innerHTML = '请输入用户名';
        return;
    }
    if (password==''){
        $('#login_hint').style.display = '';
        $('#login_hint').innerHTML = '请输入密码';
        return;
    }
    var remember = 'no';
    if ($('#remember').checked){
        remember = 'yes';
    }
    $('#login_hint').style.display = 'none';
    ajax({
        'url': 'login.jsp',
        'type': 'POST',
        'data': {'username':username, 'password':hex_md5(password), 'remember':remember},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                $('#head_username').innerHTML = xmler.getDirectNodeValue('username');
                $('#signature').innerHTML = xmler.getDirectNodeValue('signature');
                $('#head_user_pic').src = '../img/'+xmler.getDirectNodeValue('head_pic');
                Toast(xmler.getDirectNodeValue('msg'));
                if ($('#music')!=null){
                    $('#music').pause();
                }
                $('#div_bg_music').innerHTML = "<audio id=\"music\" src=\"../music/"+xmler.getDirectNodeValue('music')+"\" controls=\"controls\" loop=\"loop\"></audio>";
                $('#music').play();
                $('#login_password').value = '';
                closeFloat();
                $('#login').style.display = 'none';
                $('#logout').style.display = '';
                $('#register').style.display = 'none';
                $('#has_logined').innerHTML = 1;
                updateAll();
            }else{
                $('#login_hint').style.display = '';
                $('#login_hint').innerHTML = xmler.getDirectNodeValue('msg');
                $('#login_password').value = '';
                Toast(xmler.getDirectNodeValue('msg'), 1000);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function toLogout(){
    $('#login').style.display = '';
    $('#logout').style.display = 'none';
    $('#register').style.display = '';
    $('#head_username').innerHTML = '曾经有名氏';
    $('#signature').innerHTML = '晚饭吃什么呢？';
    $('#head_user_pic').src = '../img/head_user.gif';
    $('#has_logined').innerHTML = 0;
    Toast('退出成功，走好，Welcome come back...')
    ajax({
        'url': 'logout.jsp',
        'type': 'GET',
        'data': {},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            updateSetting(true);
        },
        'error':function(){
        }
    });
}
function checkUsername(){
    var username = $('#register_username').value;
    ajax({
        'url': 'register.jsp',
        'type': 'POST',
        'data': {'username':username},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == -1){
                $('#register_hint').innerHTML = '用户名已存在';
                $('#register_hint').style.display = '';
            }else{
                $('#register_hint').style.display = 'none';
            }
        },
        'error':function(){
        }
    });
}
function keyRegister(){
    if(window.event.keyCode == 13){
        toRegister();
    }
}
function toRegister(){
    var username = $('#register_username').value;
    var password = $('#register_password').value;
    var rePassword = $('#register_re_password').value;
    var email = $('#register_email').value;
    var sex = $('#female').checked? 1 : 0;
    if (username==''){
        $('#register_hint').style.display = '';
        $('#register_hint').innerHTML = '请输入用户名';
        return;
    }
    if (password==''){
        $('#register_hint').style.display = '';
        $('#register_hint').innerHTML = '请输入密码';
        return;
    }
    if (rePassword==''){
        $('#register_hint').style.display = '';
        $('#register_hint').innerHTML = '请输入二次确认密码';
        return;
    }
    if (email==''){
        $('#register_hint').style.display = '';
        $('#register_hint').innerHTML = '请输入注册邮箱';
        return;
    }
    if (!isEmail(email)){
        $('#register_hint').style.display = '';
        $('#register_hint').innerHTML = '请输入正确邮箱';
        return;
    }
    if (password != rePassword){
        $('#register_hint').style.display = '';
        $('#register_hint').innerHTML = '两次输入的密码不一致';
        $('#register_re_password').value = '';
        return;
    }
    $('#register_hint').style.display = 'none';
    ajax({
        'url': 'register.jsp',
        'type': 'POST',
        'data': {'username':username, 'password':hex_md5(password), 'email':email, 'sex':sex},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                username = xmler.getDirectNodeValue('username');
                Toast(xmler.getDirectNodeValue('msg'));
                $('#register_password').value = '';
                $('#register_re_password').value = '';
                $('#login_username').value = username;
                showLogin();
            }else{
                Toast(xmler.getDirectNodeValue('msg'), 1000);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function keyResetPassword(){
    if(window.event.keyCode == 13){
        toResetPassword();
    }
}
function toResetPassword(){
    var username = $('#reset_password_username').value;
    var password = $('#reset_password_password').value;
    var rePassword = $('#reset_password_re_password').value;
    var email = $('#reset_password_email').value;
    if (username==''){
        $('#reset_password_hint').style.display = '';
        $('#reset_password_hint').innerHTML = '请输入用户名';
        return;
    }
    if (email==''){
        $('#reset_password_hint').style.display = '';
        $('#reset_password_hint').innerHTML = '请输入注册邮箱';
        return;
    }
    if (password==''){
        $('#reset_password_hint').style.display = '';
        $('#reset_password_hint').innerHTML = '请输入密码';
        return;
    }
    if (rePassword==''){
        $('#reset_password_hint').style.display = '';
        $('#reset_password_hint').innerHTML = '请输入二次确认密码';
        return;
    }
    if (password != rePassword){
        $('#reset_password_hint').style.display = '';
        $('#reset_password_hint').innerHTML = '两次输入的密码不一样';
        $('#reset_password_re_password').value = '';
        return;
    }
    $('#reset_password_hint').style.display = 'none';
    ajax({
        'url': 'resetPassword.jsp',
        'type': 'POST',
        'data': {'username':username, 'password':hex_md5(password), 'email':email},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                username = xmler.getDirectNodeValue('username');
                Toast(xmler.getDirectNodeValue('msg'));
                $('#reset_password_password').value = '';
                $('#reset_password_re_password').value = '';
                $('#login_username').value = username;
                showLogin();
            }else{
                Toast(xmler.getDirectNodeValue('msg'), 1000);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}

function showUserInfo(user_id){
    if (user_id==0){
        return;
    }

    ajax({
        'url': 'getUserInfo.jsp',
        'type': 'POST',
        'data': {'user_id':user_id},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                showUserInfoDiv();
                $('#user_info_head_pic').src = '../img/'+xmler.getDirectNodeValue('head_pic');
                $('#user_info_username').innerHTML = xmler.getDirectNodeValue('username');
                $('#user_info_signature').innerHTML = xmler.getDirectNodeValue('signature');
                $('#user_info_permission').innerHTML = xmler.getDirectNodeValue('permission')==0? '管理员' : '普通用户';
                $('#user_info_email').innerHTML = xmler.getDirectNodeValue('email');
                $('#user_info_sex').innerHTML = xmler.getDirectNodeValue('sex')==1? '女' : '男';
                $('#user_info_age').innerHTML = xmler.getDirectNodeValue('age');
                $('#user_info_reg_time').innerHTML = xmler.getDirectNodeValue('reg_time');

                $('#user_info_shield_num').innerHTML = xmler.getDirectNodeValue('sheild');
                if (xmler.getDirectNodeValue('admin')==1){
                    $('#div_user_info_shield').style.display = '';
                }else{
                    $('#div_user_info_shield').style.display = 'none';
                }
                var hasSheild = xmler.getDirectNodeValue('hasSheild')==1? true : false;
                if (hasSheild){
                    $('#btn_user_info_shield').innerHTML = '取消屏蔽';
                }else{
                    $('#btn_user_info_shield').innerHTML = '屏蔽ta';
                }
                (function() {
                    $('#btn_user_info_shield').onclick = function() {
                      shieldUser(user_id)
                    }
                })();
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
                $('#user_info_shield_num').onclick = '';
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function shieldUser(user_id){
    ajax({
        'url': 'shieldUser.jsp',
        'type': 'POST',
        'data': {'user_id':user_id},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                Toast(xmler.getDirectNodeValue('msg'));

                var hasSheild = $('#btn_user_info_shield').innerHTML.startWith('取消')? false : true;
                if (hasSheild){
                    $('#btn_user_info_shield').innerHTML = '取消屏蔽';
                }else{
                    $('#btn_user_info_shield').innerHTML = '屏蔽ta';
                }
                (function() {
                    $('#btn_user_info_shield').onclick = function() {
                      shieldUser(user_id)
                    }
                })();
            }else{
                Toast(xmler.getDirectNodeValue('msg'), 1000);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}

function updateUnreadMsgNumText(n){
    var btn = $('#btn_unread_msg_num');
    if (n<=0){
        btn.style.display = 'none';
        return;
    }
    btn.style.display = '';
    btn.innerHTML = n;
}
function incUnreadMsgNumText(){
    var btn = $('#btn_unread_msg_num');
    var n = btn.innerHTML.trim();
    n = parseInt(n);
    n += 1;
    if(n > 0){
        btn.style.display = '';
        btn.innerHTML = n;
    }else{
        btn.style.display = 'none';
        btn.innerHTML = n;
    }
}
function decUnreadMsgNumText(){
    var btn = $('#btn_unread_msg_num');
    var n = btn.innerHTML.trim();
    n = parseInt(n);
    n -= 1;
    if(n > 0){
        btn.style.display = '';
        btn.innerHTML = n;
    }else{
        btn.style.display = 'none';
        btn.innerHTML = n;
    }
}
function getUnreadMsgNum(){
    if ($('#has_logined').innerHTML.trim() == 0){
        var btn = $('#btn_unread_msg_num');
        btn.style.display = 'none';
        return;
    }
    ajax({
        'url': 'getUnreadMsgNum.jsp',
        'type': 'POST',
        'data': {},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                updateUnreadMsgNumText(xmler.getDirectNodeValue('n').trim());
                $('#alive_num').innerHTML = xmler.getDirectNodeValue('alive');
            }else{
            }
        },
        'error':function(){
        }
    });
}
function keySubmitBug(){
    if(window.event.keyCode == 13){
        submit_bug();
    }
}
function submit_bug(){
    var bug = $('#bug_textarea').value.trim();
    if (bug==''){
        Toast('空，也是一种Bug！');
        return;
    }
    var contact = $('#buger_contact').value.trim();
    var username = $('#head_username').innerHTML.trim();
    ajax({
        'url': 'submitBug.jsp',
        'type': 'POST',
        'data': {'bug':bug, 'contact':contact, 'username':username},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                Toast(xmler.getDirectNodeValue('msg').trim(), 2000);
                closeFloat();
            }else{
                Toast(xmler.getDirectNodeValue('msg').trim(), 2000);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...这不会就是一个Bug吧....', 2000);
        }
    });
}
function showFun(){
    Toast("别玩...");
}