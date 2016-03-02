
function hideMeSubContainer(){
    $('#div_me_news').style.display = 'none';
    $('#div_me_setting').style.display = 'none';
    var css = 'display:inline-block;width:50%;height:100%;line-height:40px;box-sizing:border-box;';
    $('#btn_news').style.cssText = css;
    $('#btn_setting').style.cssText = css;
}
function showNews(){
    hideMeSubContainer();
    //updateNews();
    $('#div_me_news').style.display = '';
    var css = 'background:#d8d9db;color:#2690FE;';
    $('#btn_news').style.cssText = css;
}
function showSetting(){
    hideMeSubContainer();
    //updateSetting();
    $('#div_me_setting').style.display = '';
    var css = 'background:#d8d9db;color:#2690FE;';
    $('#btn_setting').style.cssText = css;

}
function updateSetting(flag){
    ajax({
        'url': 'getUserInfo.jsp',
        'type': 'GET',
        'data': {},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                $('#setting_head_pic').src = '../img/'+xmler.getDirectNodeValue('head_pic');
                $('#setting_username').value = xmler.getDirectNodeValue('username');
                $('#setting_signature').value = xmler.getDirectNodeValue('signature');
                $('#setting_permission').innerHTML = xmler.getDirectNodeValue('username')==0? '管理员' : '普通用户';
                $('#setting_email').value = xmler.getDirectNodeValue('email');
                $('#setting_male').checked = true;
                $('#setting_female').checked = xmler.getDirectNodeValue('sex')==1? true : false;
                $('#setting_age').value = xmler.getDirectNodeValue('age');
                $('#setting_music').innerHTML = decodeURI(xmler.getDirectNodeValue('music'));
                if (flag!=undefined && flag==true){
                    if ($('#music')!=null){
                        $('#music').pause();
                    }
                    $('#div_bg_music').innerHTML = "<audio id=\"music\" src=\"../music/"+xmler.getDirectNodeValue('music')+"\" controls=\"controls\" loop=\"loop\"></audio>";
                    $('#music').play();
                }
                $('#setting_reg_time').innerHTML = xmler.getDirectNodeValue('reg_time');
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function showPasswordDiv(){
    if ($('#has_logined').innerHTML.trim()==0){
        Toast('还没登录呢...');
        return;
    }
    if ($('#btn_show_setting_password_div').innerHTML == '修改密码'){
        var lis = $('.setting_password');
        for (var i=0; i<lis.length; ++i){
            lis[i].style.display = '';
        }
        $('#btn_show_setting_password_div').innerHTML = '取消修改';
    }else{
        var lis = $('.setting_password');
        for (var i=0; i<lis.length; ++i){
            lis[i].style.display = 'none';
        }
        $('#btn_show_setting_password_div').innerHTML = '修改密码';
        $('#setting_hint').style.display = 'none';
    }
}
function selectHeadPic(){
    if ($('#has_logined').innerHTML.trim()==0){
        Toast('还没登录呢...');
        return;
    }
    $('#setting_img_file').click();
}
function imgFileSelected(){
    var file = document.getElementById('setting_img_file').files[0];
    if (file==null){
        return;
    }
    var URL = window.URL || window.webkitURL;
    $('#setting_head_pic').src = URL.createObjectURL(file);
}
function selectMusic(){
    if ($('#has_logined').innerHTML.trim()==0){
        Toast('还没登录呢...');
        return;
    }
    $('#setting_music_file').click();
}
function musicFileSelected(){
    var file = document.getElementById('setting_music_file').files[0];
    if (file==null){
        return;
    }
    $('#setting_music').innerHTML = file.name;
}
function settingCheckUsername(){
    var username = $('#setting_username').value;
    if (username == $('#head_username').innerHTML){
        $('#setting_hint').style.display = 'none';
        return;
    }
    ajax({
        'url': 'register.jsp',
        'type': 'POST',
        'data': {'username':username},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == -1){
                $('#setting_hint').innerHTML = '用户名已存在';
                $('#setting_hint').style.display = '';
            }else{
                $('#setting_hint').style.display = 'none';
            }
        },
        'error':function(){
        }
    });
}
function updateUserInfo(){
    if ($('#has_logined').innerHTML.trim()==0){
        Toast('还没登录呢...');
        return;
    }
    var imgFile = document.getElementById('setting_img_file').files[0];
    var musicFile = document.getElementById('setting_music_file').files[0];
    var fd = new FormData();
    if (imgFile!=null){
        fd.append(imgFile.name, imgFile);
    }
    if (musicFile!=null){
        fd.append(musicFile.name, musicFile);
    }
    var username = $('#setting_username').value;
    var signature = $('#setting_signature').value;
    var email = $('#setting_email').value;
    var sex = $('#setting_female').checked? 1 : 0;
    var age = $('#setting_age').value;
    $('#setting_hint').style.display = 'none';
    if (username==''){
        $('#setting_hint').style.display = '';
        $('#setting_hint').innerHTML = '请输入用户名';
        return;
    }
    if (email==''){
        $('#setting_hint').style.display = '';
        $('#setting_hint').innerHTML = '请输入常用邮箱';
        return;
    }
    if (!isEmail(email)){
        $('#setting_hint').style.display = '';
        $('#setting_hint').innerHTML = '邮箱不正确';
        return;
    }
    fd.append("username", username);
    fd.append("signature", signature);
    fd.append("email", email);
    fd.append("sex", sex);
    fd.append("age", age);

    if ($('#btn_show_setting_password_div').innerHTML == '取消修改'){
        var old_password = $('#setting_old_password').value;
        var new_password = $('#setting_new_password').value;
        var re_new_password = $('#setting_re_new_password').value;
        if (old_password==''){
            $('#setting_hint').style.display = '';
            $('#setting_hint').innerHTML = '请输入旧密码';
            return;
        }
        if (new_password==''){
            $('#setting_hint').style.display = '';
            $('#setting_hint').innerHTML = '请输入新密码';
            return;
        }
        if (re_new_password==''){
            $('#setting_hint').style.display = '';
            $('#setting_hint').innerHTML = '请输入确认密码';
            return;
        }
        if (new_password!=re_new_password){
            $('#setting_hint').style.display = '';
            $('#setting_hint').innerHTML = '两次密码输入不一致';
            $('#setting_re_new_password').value = '';
            return;
        }
        fd.append("cp", 1);
        fd.append("old_password", hex_md5(old_password));
        fd.append("new_password", hex_md5(new_password));
    }else{
        fd.append("cp", 0);
    }

    ajaxFileUpload({
        'url': 'updateUserInfo.jsp',
        'formData': fd,
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                Toast(xmler.getDirectNodeValue('msg'), 1000);
                $('#head_username').innerHTML = xmler.getDirectNodeValue('username');
                $('#signature').innerHTML = xmler.getDirectNodeValue('signature');
                $('#head_user_pic').src = '../img/'+xmler.getDirectNodeValue('head_pic');
                if ($('#music')!=null){
                    $('#music').pause();
                }
                $('#div_bg_music').innerHTML = "<audio id=\"music\" src=\"../music/"+xmler.getDirectNodeValue('music')+"\" controls=\"controls\" loop=\"loop\"></audio>";
                $('#music').play();
                $('#setting_old_password').value = '';
                $('#setting_new_password').value = '';
                $('#setting_re_new_password').value = '';
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
            }
        },
        'error':function(){
            Toast('嘘...网络开小差了...你是不是上传大文件了？我哭...');
        }
    });
}


/*News*/

function addNewsToHead(data){
    var div = document.createElement('div');
    div.innerHTML = data;
    div = div.children;
    var parent = $('#div_me_news_container');
    var children = parent.children;
    for (var i=div.length-1; i>=0; --i){
        if (children.length==0){
            parent.appendChild(div[i]);
        }else{
            parent.insertBefore(div[i], children[0]);
        }
    }
}
function addNewsToTail(data){
    var div = document.createElement('div');
    div.innerHTML = data;
    div = div.children;
    var parent = $('#div_me_news_container');
    for (var i=0; i<div.length; ++i){
        parent.appendChild(div[i]);
    }
}
function clearNews(){
    $('#div_me_news_container').innerHTML = '';
}
function updateNews(){
    ajax({
        'url': 'getUserMsg.jsp',
        'type': 'POST',
        'data': {'type':'new'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length);
            if (data.trim().length > 100){
                clearNews();
                addNewsToHead(data);
            }else if (data.trim().length == 0){

            }else{
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function loadMoreNews(now){
    var lastChild = $('#div_me_news_container').lastChild;
    var message_id;
    if (lastChild==null){
        message_id = 0;
    }else if (lastChild.querySelector('.btn_news_has_unread')!=null){
        message_id = 0;
    }else{
        message_id = lastChild.querySelector('.message_id').innerHTML.trim();
    }
    ajax({
        'url': 'getUserMsg.jsp',
        'type': 'POST',
        'data': {'type':'old', 'message_id':message_id, 'n':10},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length);
            if (data.trim().length > 100){
                addNewsToTail(data);
            }else if (data.trim().length == 0){
                Toast('没有更多消息了...');
            }else{
                Toast('没有更多消息了...');
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function deleteNews(now){
    var message_id = now.parentNode.querySelector('.message_id').innerHTML.trim();
    ajax({
        'url': 'deleteMsg.jsp',
        'type': 'POST',
        'data': {'message_id':message_id},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                $('#div_me_news_container').removeChild(now.parentNode);
                getUnreadMsgNum();
                Toast(xmler.getDirectNodeValue('msg'), 500);
            }else{
                Toast(xmler.getDirectNodeValue('msg'), 500);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function setHasRead(now){
    var message_id = now.parentNode.querySelector('.message_id').innerHTML.trim();
    ajax({
        'url': 'setMsgHasRead.jsp',
        'type': 'POST',
        'data': {'message_id':message_id},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                var btn = now.parentNode.querySelector('.btn_news_has_unread');
                btn.setAttribute('class', 'btn_news_has_read');
                btn.innerHTML = '已读';
                decUnreadMsgNumText();
                //Toast(xmler.getDirectNodeValue('msg'), 500);
            }else{
                Toast(xmler.getDirectNodeValue('msg'), 500);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function showNewsFromUser(now){
    var user_id = now.parentNode.parentNode.querySelector('.from_user_id').innerHTML.trim();
    showUserInfo(user_id);
}
function jumpNewsDetail(now){
    var message_id = now.parentNode.querySelector('.message_id').innerHTML.trim();
    ajax({
        'url': 'getMsgDetail.jsp',
        'type': 'POST',
        'data': {'message_id':message_id},
        'dataType': 'text',
        'success':function(data){
            if (data.trim().length > 500){
                addPublicChildToHead(data);
                showPublicContainerWitoutFlush();
                checkPublicShowDumplicate();
                returnTop();
            }else if (data.trim().length==0){
                Toast('已查不到相关信息', 1000);
            }else{
                Toast(data);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function checkPublicShowDumplicate(){
    var parent = $('#div_public_show');
    var childs = parent.children;
    var show_id = childs[0].querySelector('.show_id').innerHTML.trim();
    for (var i=1; i<childs.length; ++i){
        var child = childs[i];
        if (child.querySelector('.show_id').innerHTML.trim() == show_id){
            parent.removeChild(child);
        }
    }
    childs[0].style.border = "2px solid #2690FE";
}
