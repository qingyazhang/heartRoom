
function addPersonalChildToHead(data){
    var div = document.createElement('div');
    div.innerHTML = data;
    div = div.children;
    var parent = $('#div_personal_show');
    var children = parent.children;
    for (var i=div.length-1; i>=0; --i){
        if (children.length==0){
            parent.appendChild(div[i]);
        }else{
            parent.insertBefore(div[i], children[0]);
        }
    }
}
function updatePersonal(){
    getPersonalShow(0, 10, '', true);
}
function getPersonalShow(show_id, n, turn, clear){
    ajax({
        'url': 'getShow.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'n':n, 'turn':turn, 'from':'personal'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.trim().length);
            if (data.trim().length > 500){
                var before_id = -1;
                if ($('#div_personal_show').children.length!=0){
                    before_id = $('#div_personal_show').children[0].children[0].innerHTML.trim();
                }
                if(clear){
                    clearPersonalShow();
                }
                addPersonalChildToHead(data.trim());
                var now_id = $('#div_personal_show').children[0].children[0].innerHTML.trim();
                if (turn=='last' && before_id!=-1 && before_id == now_id){
                    Toast('已经是第一页了');
                }else{
                    returnTop();
                }
                if (turn == 'next'){
                    returnTop();
                }
            }else if (data.trim().length == 0){
                if(turn == 'last'){
                    Toast('已经是第一页了');
                }else if (turn!=''){
                    Toast('没有更多可以展示的了');
                }
            }else{
                if(turn == 'last'){
                    Toast('已经是第一页了');
                }else if (turn!=''){
                    Toast('没有更多可以展示的了');
                }
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function clearPersonalShow(){
    var parent = $('#div_personal_show');
    parent.innerHTML = '';
    return;
}
/*翻页*/
function turnLastPersonalShow(){
    var parent = $('#div_personal_show');
    if (parent.children.length==0){
        updatePersonal();
        return;
    }
    var show_id = parent.children[0].children[0].innerHTML.trim();
    getPersonalShow(show_id, 10, 'last', true);
    //returnTop();
}

function turnNextPersonalShow(){
    var parent = $('#div_personal_show');
    if (parent.children.length==0){
        updatePersonal();
        return;
    }
    var show_id = parent.lastChild.children[0].innerHTML.trim();
    show_id = parseInt(show_id);
    getPersonalShow(show_id, 10, 'next', true);
    //returnTop();
}
function keyPushPersonalShow(){
    if(window.event.keyCode == 13){
        pushPersonalShow();
    }
}
function pushPersonalShow(){
    if ($('#has_logined').innerHTML.trim()==0){
        Toast('还没登录呢...');
        return;
    }
    var content = $('#personal_form_textarea').value;
    if (content == ''){
        Toast('好像空着也是挺好玩的...');
        return;
    }
    var obj = $('#personal_form_mode');
    var mode = obj.options[obj.selectedIndex].value; // 选中值

    ajax({
        'url': 'pushShow.jsp',
        'type': 'POST',
        'data': {'content':content, 'mode':mode, 'from':'personal'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.trim().length);
            if (data.trim().length > 500){
                addPersonalChildToHead(data.trim());
                $('#personal_form_textarea').value = '';
                Toast('发表成功', 1000);
            }else{
                Toast(data);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}

function deletePersonalShow(now){
    var show_id = now.parentNode.children[0].innerHTML.trim();
    ajax({
        'url': 'deleteShow.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'from':'personal'},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                $('#div_personal_show').removeChild(now.parentNode);
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

function pushPersonalShowLike(now){
    var show_id = now.parentNode.parentNode.parentNode.children[0].innerHTML.trim();
    ajax({
        'url': 'pushShowLike.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'from':'personal'},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                var n = xmler.getDirectNodeValue('n');
                now.parentNode.parentNode.children[1].firstChild.innerHTML = n+' 个人赞了！';
                var nodes = now.parentNode.getElementsByClassName('personal_show_like_left');
                nodes[0].setAttribute('class', 'personal_show_like_left personal_show_like_has');
                nodes = now.parentNode.getElementsByClassName('personal_show_like_right');
                nodes[0].setAttribute('class', 'personal_show_like_right personal_show_like_has');
            }else if (xmler.getDirectNodeValue('code') == 2){
                var n = xmler.getDirectNodeValue('n');
                now.parentNode.parentNode.children[1].firstChild.innerHTML = n+' 个人赞了！';
                var nodes = now.parentNode.getElementsByClassName('personal_show_like_left');
                nodes[0].setAttribute('class', 'personal_show_like_left');
                nodes = now.parentNode.getElementsByClassName('personal_show_like_right');
                nodes[0].setAttribute('class', 'personal_show_like_right');
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}

/*评论*/
function addPersonalShowCommentToHead(showDiv, data){
    var div = document.createElement('div');
    div.innerHTML = data;
    div = div.children;
    var children = showDiv.children;
    for (var i=div.length-1; i>=0; --i){
        if (children.length==0){
            showDiv.appendChild(div[i]);
        }else{
            showDiv.insertBefore(div[i], children[0]);
        }
    }
}
function addPersonalShowCommentToTail(showDiv, data){
    var div = document.createElement('div');
    div.innerHTML = data;
    div = div.children;
    var children = showDiv.children;
    for (var i=0; i<div.length; ++i){
        showDiv.appendChild(div[i]);
    }
}
function incBtnPersonalShowNum(btn){
    var text = btn.innerHTML.trim();
    var n = text.charAt(text.length-1);
    n = parseInt(n);
    n = n+1;
    btn.innerHTML = text.substr(0, text.length-1)+n;
}
function decBtnPersonalShowNum(btn){
    var text = btn.innerHTML.trim();
    var n = text.charAt(text.length-1);
    n = parseInt(n);
    n = n-1;
    btn.innerHTML = text.substr(0, text.length-1)+n;
}
function pushPersonalShowComment(now){
    var content = now.parentNode.querySelector('.personal_show_comment_content').value.trim();
    if (content == ''){
        Toast('别玩，评论是空的...');
        return;
    }
    var show_id = now.parentNode.parentNode.parentNode.querySelector('.show_id').innerHTML.trim();
    ajax({
        'url': 'pushShowComment.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'content':content, 'from':'personal'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length)
            if (data.length > 500){
                addPersonalShowCommentToHead(now.parentNode.parentNode.querySelector('.div_personal_show_subcomment'), data);
                Toast('评论成功！');
                incBtnPersonalShowNum(now.parentNode.parentNode.parentNode.querySelector('.btn_personal_show_comment'));
                now.parentNode.querySelector('.personal_show_comment_content').value = '';
            }else if (data.length==0){
                Toast('评论失败！');
            }else{
                Toast(data);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function clearPersonalShowComments(subCommentDiv){
    subCommentDiv.innerHTML = '';
}
function updatePersonalShowComments(subCommentDiv){
    var show_id = subCommentDiv.parentNode.parentNode.querySelector('.show_id').innerHTML.trim();;
    ajax({
        'url': 'getShowComment.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'n':10, 'from':'personal'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length)
            if (data.length > 500){
                addPersonalShowCommentToHead(subCommentDiv, data);
            }else if (data.trim().length == 0){
                Toast('没有评论哦,你来评一下也可以的...');
            }else{
                Toast('获取失败！');
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function showPersonalCommentDiv(now){
    var commentDiv = now.parentNode.parentNode.parentNode.querySelector('.div_personal_show_subcomment');
    var moreComment = now.parentNode.parentNode.parentNode.querySelector('.btn_personal_show_more_subcomment');
    var text = now.innerHTML.trim();
    if (text.startWith('查看')){
        commentDiv.style.display = '';
        moreComment.style.display = '';
        now.innerHTML = '隐藏'+text.substr(2);
        clearPersonalShowComments(commentDiv);
        updatePersonalShowComments(commentDiv);

    }else if (text.startWith('隐藏')){
        commentDiv.style.display = 'none';
        moreComment.style.display = 'none';
        now.innerHTML = '查看'+text.substr(2);
    }
}
function loadMorePersonalComment(now){
    var subCommentDiv = now.parentNode.querySelector('.div_personal_show_subcomment');
    var show_id = subCommentDiv.parentNode.parentNode.querySelector('.show_id').innerHTML.trim();
    if (subCommentDiv.lastChild == null){
        Toast('没有评论哦...');
        return;
    }
    var comment_id = subCommentDiv.lastChild.querySelector('.comment_id').innerHTML.trim();
    ajax({
        'url': 'getShowComment.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'n':10, 'comment_id':comment_id, 'from':'personal'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length)
            if (data.length > 500){
                addPersonalShowCommentToTail(subCommentDiv, data);
            }else{
                Toast('没有了，不要再点了哦');
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function deletePersonalShowComment(now){
    var comment_id = now.parentNode.querySelector('.comment_id').innerHTML.trim();
    ajax({
        'url': 'deleteComment.jsp',
        'type': 'POST',
        'data': {'comment_id':comment_id},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                decBtnPersonalShowNum(now.parentNode.parentNode.parentNode.parentNode.querySelector('.btn_personal_show_comment'));
                now.parentNode.parentNode.removeChild(now.parentNode);
                Toast(xmler.getDirectNodeValue('msg'));
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
            }
        },
        'error':function(){
            decBtnPersonalShowNum(now.parentNode.parentNode.parentNode.parentNode.querySelector('.btn_personal_show_comment'));
            now.parentNode.parentNode.removeChild(now.parentNode);
            //Toast('嘘...好像网络开小差了...');
        }
    });
}
function replyPersonalShowComment(now){
    var content = now.parentNode.querySelector('.personal_show_subcomment_reply_content').value.trim();
    if (content == ''){
        Toast('别玩，回复是空的...');
        return;
    }
    var comment_id = now.parentNode.parentNode.parentNode.querySelector('.comment_id').innerHTML.trim();
    ajax({
        'url': 'pushReplyComment.jsp',
        'type': 'POST',
        'data': {'comment_id':comment_id, 'content':content, 'from':'personal'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length)
            if (data.length > 500){
                incBtnPersonalShowNum(now.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.querySelector('.btn_personal_show_comment'));
                Toast('回复成功！');
                now.parentNode.querySelector('.personal_show_subcomment_reply_content').value = '';

                var subComment = now.parentNode.parentNode.parentNode;
                if (subComment.nextSibling == null){
                    addPersonalShowCommentToTail(subComment.parentNode, data);
                }else{
                    var div = document.createElement('div');
                    div.innerHTML = data;
                    div = div.children[0];
                    subComment.parentNode.insertBefore(div,subComment.nextSibling);
                }
            }else if (data.length==0){
                Toast('回复失败！');
            }else{
                Toast(data);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function likePersonalShowComment(now){
    var comment_id = now.parentNode.parentNode.parentNode.querySelector('.comment_id').innerHTML.trim();
    ajax({
        'url': 'pushCommentLike.jsp',
        'type': 'POST',
        'data': {'comment_id':comment_id, 'from':'personal'},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                var n = xmler.getDirectNodeValue('n');
                now.parentNode.querySelector('.personal_show_subcomment_like_num').innerHTML = n;
                now.setAttribute('class', 'personal_show_subcomment_like personal_show_like_has');
            }else if (xmler.getDirectNodeValue('code') == 2){
                var n = xmler.getDirectNodeValue('n');
                now.parentNode.querySelector('.personal_show_subcomment_like_num').innerHTML = n;
                now.setAttribute('class', 'personal_show_subcomment_like');
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}

function showPersonalShowUserInfo(now){
    var user_id = now.parentNode.parentNode.querySelector('.show_user_id').innerHTML.trim();
    showUserInfo(user_id);
}
function showPersonalShowCommentUserInfo(now){
    var user_id = now.parentNode.parentNode.querySelector('.comment_user_id').innerHTML.trim();
    showUserInfo(user_id);
}

function personal_show_mode_change(now){
    var mode = now.options[now.selectedIndex].value; // 选中值
    var show_id = now.parentNode.parentNode.parentNode.parentNode.querySelector('.show_id').innerHTML.trim();
    ajax({
        'url': 'changeShowMode.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'mode':mode, 'from':'personal'},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                now.selectedIndex = mode;
                Toast(xmler.getDirectNodeValue('msg'), 1000);
            }else{
                Toast(xmler.getDirectNodeValue('msg'), 1000);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}