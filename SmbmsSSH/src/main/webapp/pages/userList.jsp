<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page language="java" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>超市账单管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/pages/css/public.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/pages/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/easyui/themes/icon.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/easyui/themes/default/easyui.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/easyui/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-migrate-1.2.0.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/easyui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript">
        function  getinfo() {
            $.messager.confirm('确认','确认进入修改界面？',function (row) {
                if (row) {
                    var selectedRow = $('#test').datagrid('getSelected');  //获取选中行
                    window.location=("/getinfo?id="+selectedRow.id);
                }
            })
        }
        //批量删除
        function deletedata() {
            //返回选中多行
            var selRow = $('#test').datagrid('getSelections')
            //判断是否选中行  
            if (selRow.length==0) {
                $.messager.alert("提示", "请选择要删除的用户！", "info");
                return;
            }else{
                var temID="";
                //批量获取选中行的id,用，隔开
                for (i = 0; i < selRow.length;i++) {
                    if (temID =="") {
                        temID = selRow[i].id;
                    } else {
                        temID = selRow[i].id + "," + temID;
                    }
                }
                /*alert(temID) */ //打印选中行的id

                $.messager.confirm('提示', '是否删除选中的用户?', function (r) {
                    if (!r) {
                        return;
                    }
                    //提交  
                    $.ajax({
                        type: "POST",
                        async: false,
                        url: "${pageContext.request.contextPath}/userDel?id=" + temID,
                        data: temID,
                        success: function (result) {
                            if (result==true) {
                                $('#test').datagrid('clearSelections');
                                $.messager.alert("提示", "恭喜您，信息删除成功！", "info");
                                $('#test').datagrid('reload');
                            } else {
                                $.messager.alert("提示", "删除失败，请重新操作！", "info");
                                return;
                            }
                        }
                    });
                });

            }
        };
        //添加用户
        function save() {
            var user=$("#user").serializeArray();
            $.post('${pageContext.request.contextPath}/userAdd',user,function (data) {
                if (data=false)
                    alert("添加失败！")
                else (data=true)
                alert("添加成功！")
            });
        }
        //添加的关闭按钮
        function cloe() {
            $("#addUser").dialog("close")
        }
        //显示添加弹框
        function open1() {
            $('#addUser').show();
            $('#addUser').dialog();
        }
        function del(index){  //删除操作
            $.messager.confirm('确认','确认删除?',function(row){
                if(row){
                    var selectedRow = $('#test').datagrid('getSelected');  //获取选中行
                    $.ajax({
                        url:'${pageContext.request.contextPath}/userDel?id='+selectedRow.id,
                        //加了个type，作用是以后不管什么删除，都可以转到这个ashx中处理
                        success:function(){alert('删除成功');}
                    });
                    $('#test').datagrid('deleteRow',index);
                }
            })
        }
        function load() {
            $('#test').datagrid({
                title:'用户列表',
                iconCls:'icon-save',
                width:1190,
                height:450,
                nowrap: true,
                striped: true,
                url:'${pageContext.request.contextPath}/finUser?userName='+$("[name=uname]").val(),
                sortName: 'code',
                sortOrder: 'desc',
                idField:'id',   //指定哪些字段是标识字段
                pageNumber:1,  //初始化页面
                frozenColumns:[[  //冻结列
                    {field:'ck',checkbox:true}, //控制复选框是否显示
                    {title:'用户编号',field:'userCode',width:80,sortable:true}
                ]],
                columns:[[
                    {field:'userName',title:'用户名称',width:120},
                    {field:'address',title:'用户地址',width:200,rowspan:2,sortable:true},
                    {field:'birthday',title:'年龄',width:150,rowspan:2,
                       formatter: function birthday(strBirthday)
                    {
                        var returnAge;
            var strBirthdayArr=strBirthday.split("-");
            var birthYear = strBirthdayArr[0];

            var birthMonth = strBirthdayArr[1];
            var birthDay = strBirthdayArr[2];

            var d = new Date();
            var nowYear = d.getFullYear();
            var nowMonth = d.getMonth() + 1;
            var nowDay = d.getDate();

            if(nowYear == birthYear)
            {

                returnAge = 0;//同年 则为0岁
            }
            else
            {

                var ageDiff = nowYear - birthYear ; //年之差
                if(ageDiff > 0)
                {
                    if(nowMonth == birthMonth)
                    {

                        var dayDiff = nowDay - birthDay;//日之差
                        if(dayDiff < 0)
                        {
                            returnAge = ageDiff - 1;
                        }
                        else
                        {
                            returnAge = ageDiff ;
                        }
                    }
                    else
                    {
                        var monthDiff = nowMonth - birthMonth;//月之差
                        if(monthDiff < 0)
                        {
                            returnAge = ageDiff - 1;
                        }
                        else
                        {
                            returnAge = ageDiff ;
                        }
                    }
                }
                else
                {
                    returnAge = -1;//返回-1 表示出生日期输入错误 晚于今天
                }
            }
            return returnAge;//返回周岁年龄
        }
                    },
                    {field:'gender',title:'性别',width:120,
                        formatter:function (value) {
                            if (value==0){
                                return '女';
                            }else if (value==1){
                                return '男';
                            }
                        }
                    },
                    {field:'userRole',title:'用户类型',width:120,
                        formatter:function (gender) {
                            if (gender==1){
                                return '系统管理员';
                            }else if (gender==2){
                                return '经理';
                            }else if (gender==3){
                                return '普通用户';
                            }
                        }
                    },
                    {field:'clo4',title:'操作',width:120,
                    formatter:function (value,rec,index) {
                        var str="<a href='userView.html'><img src='/pages/img/read.png' alt='查看' title='查看'/></a>"+"&nbsp;&nbsp;&nbsp;<a href='javascript:getinfo()'><img src='/pages/img/xiugai.png' alt='修改' title='修改'/></a>"+"&nbsp;&nbsp;&nbsp;<a href='#' class='removeUser' onclick='del("+index+")'><img src='/pages/img/schu.png' alt='删除' title='删除'/></a>"
                        return str;
                    }
                    }
                ]],
                pagination:true,
                rownumbers:true,
                pageSize: 2,
                pageList: [2, 3, 5, 10],
                singleSelect:false,
                toolbar:[{
                    text:'添加用户',
                    iconCls:'icon-add',
                    handler:function(){
                        open1();
                    }
                },'-',{
                    text:'批量删除',
                    iconCls:'icon-cut',
                    handler:function(){
                        deletedata();
                    }
                }]
            });
        }
        //模糊查询
        var btnSelect=function() {
            load();
        };
        $(function () {
            load();
        });
    </script>
</head>
<body>
<!--头部-->
    <header class="publicHeader">
        <h1>超市账单管理系统</h1>
        <div class="publicHeaderR">
            <p><span>下午好！</span><span style="color: #fff21b"> Admin</span> , 欢迎你！</p>
            <a href="login.html">退出</a>
        </div>
    </header>
<!--时间-->
    <section class="publicTime">
        <span id="time">2015年1月1日 11:11  星期一</span>
        <a href="#">温馨提示：为了能正常浏览，请使用高版本浏览器！（IE10+）</a>
    </section>
<!--主体内容-->
    <section class="publicMian ">
        <div class="left">
            <h2 class="leftH2"><span class="span1"></span>功能列表 <span></span></h2>
            <nav>
                <ul class="list">
                    <li><a href="billList.html">账单管理</a></li>
                    <li><a href="providerList.html">供应商管理</a></li>
                    <li  id="active"><a href="userList.html">用户管理</a></li>
                    <li><a href="password.html">密码修改</a></li>
                    <li><a href="login.html">退出系统</a></li>
                </ul>
            </nav>
        </div>
        <div class="right">
            <div class="location">
                <strong>你现在所在的位置是:</strong>
                <span>用户管理页面</span>
            </div>
            <div class="search">
                <span>用户名：</span>
                <input type="text" name="uname" placeholder="请输入用户名"/>
                <input type="button" onclick="btnSelect()" value="查询"/>
                <a href="${pageContext.request.contextPath}/pages/userAdd.jsp">添加用户</a>
            </div>
            <!--用户-->
            <table id="test">
            </table>
        </div>
    </section>
<!--点击删除按钮后弹出的页面-->
<div class="zhezhao"></div>
<div class="remove" id="removeUse">
    <div class="removerChid">
        <h2>提示</h2>
        <div class="removeMain">
            <p>你确定要删除该用户吗？</p>
            <a href="#" id="yes">确定</a>
            <a href="#" id="no">取消</a>
        </div>
    </div>
</div>
<div  id="addUser" style="width:700px;padding:30px 60px;font-size: 17px;display: none">
    <form id="user" onsubmit="/*return validateUser()*/">
        <div>
            <label for="userId">用户编码：</label>
            <input type="text"  name="userCode" id="userId"/>
            <span id="userIdMsg"></span>
        </div>
        <div>
            <label for="userName">用户名称：</label>
            <input type="text" class="easyui-textbox" name="userName" id="userName"/>
            <span >*请输入用户名称</span>
        </div>
        <div>
            <label for="userpassword">用户密码：</label>
            <input type="text" class="easyui-textbox" name="userPassword" id="userpassword"/>
            <span>*密码长度必须大于6位小于20位</span>

        </div>
        <div>
            <label for="userRemi">确认密码：</label>
            <input type="text" class="easyui-textbox"  id="userRemi"/>
            <span>*请输入确认密码</span>
        </div>
        <div>
            <label >用户性别：</label>
            <select name="gender">
                <option value="1">男</option>
                <option value="0">女</option>
            </select>
                    <span></span>
        </div>
        <div>
            <label for="data">出生日期：</label>
            <input type="text" name="birthday" id="data"/>
            <span >*</span>
        </div>
        <div>
            <label for="userphone">用户电话：</label>
            <input type="text" class="easyui-textbox" name="phone" id="userphone"/>
            <span >*</span>
        </div>
        <div>
            <label for="userAddress">用户地址：</label>
            <input type="text" class="easyui-textbox" name="address" id="userAddress"/>
        </div>
        <div>
            <label >用户类别：</label>
            <input type="radio" name="userRole" value="1"/>管理员
            <input type="radio" name="userRole" value="2"/>经理
            <input type="radio" name="userRole" value="3"/>普通用户
        </div>
        <a href="javascript:save();" class="easyui-linkbutton" iconCls="icon-save">添加</a>
        <a href="javascript:cloe();" class="easyui-linkbutton" iconCls="icon-search">关闭</a>
    </form>
</div>
    <footer class="footer">
        版权归北大青鸟
    </footer>
</body>
</html>