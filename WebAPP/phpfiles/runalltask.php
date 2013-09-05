<html>
<head>
<link href="CSS/basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php
  $response = exec("F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/RunningAll.bat",$status);
  if ($status = 1){
  echo "Hi，亲，让您久等了...经过不懈的努力，SmartJetsen已经帮您运行完了所有默认的自动化测试集，请您去查看测试结果！";
  }else {
  echo "Sorry，测试过程可能出错了！请您联系自动化测试负责人... ...";
  }
?>
</head>
<body>
<h1>当您看到此页面时,说明自动化测试在测试机上已经完成了测试,如果收不到邮件,则说明测试过程出现异常,请在结果反馈页面查看Debug日志或联系自动化测试负责人！</h1>
<br />
<div><img src="images/back.png" border="0" onclick="javascript:history.back(-1);" title="返回上一页"></div>
<br />
<br />
<div>
<a href = "http://192.168.8.132:10006/monitor.html" target = "_blank">
<img src="images/links_64.png" title="直接转向结果反馈页面" />
直接转向结果反馈页面</a>
</div>
</body>
</html>