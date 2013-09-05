<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="CSS/basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php
/**
 * SMTP邮件发送
 *
 * @author  StefanHOU  <houjunguang@jetsen.cn>
 **/


function Encode($str){//对中文进行编码的函数
   $str=base64_encode($str);
   $str= "=?"."UTF-8?B?".$str."?=";
    return $str;
   }

$receiveemail = $_POST['mailto'];
$subjectold = $_POST['mailsubject'];
$subject = "=?UTF-8?B?".base64_encode($subjectold)."?=";  //放置中文乱码，做一个转码处理，UTF-8编码
$body = $_POST['mailbody'];
//$body = "=?UTF-8?B?".base64_encode($bodyold)."?=";

//包含SMTP类文件
include 'smtp.php';

$smtpserver   = "mail.jetsen.cn";	//SMTP服务器 
$smtpport     = 25;						//SMTP服务器端口 
$smtpusermail = "SmartJetsen@jetsen.cn";		//SMTP服务器的用户邮箱 
$smtpuser     = "SmartJetsen@jetsen.cn";		//SMTP服务器的用户帐号 
$smtppass     = "Jetsentest123";				//SMTP服务器的用户密码 

$mailfrom     =	"SmartJetsen";			//发送者名称
$mailto       = $receiveemail;		//发送给谁 
$mailsubject  = $subject;	//邮件主题 
$mailbody     = $body;//邮件内容，支持HTML和TXT格式
$mailtype     = "HTML";					//邮件格式（HTML/TXT）,TXT为文本邮件 
########################################## 
//这里面的一个true是表示使用身份验证,否则不使用身份验证. 
$smtp = new Smtp($smtpserver,$smtpport,true,$smtpuser,$smtppass);//实例化SMTP类
//是否显示调试信息 
$smtp->debug = 1;
//发送邮件
$res = $smtp->sendmail($mailto, $mailfrom, $mailsubject, $mailbody, $mailtype);
if($res){
	echo '您的邮件已经成功发送给指定人！';
}else{
	echo '邮件发送失败，请联系自动化测试负责人！';
}
?>
</head>
<body>
<div><img src="images/back.png" border="0" onclick="javascript:history.back(-1);" title="返回上一页"></div>
</body>
</html>