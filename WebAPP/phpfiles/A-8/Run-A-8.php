<html>
<head>
<link href="basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php
function RunningTestScript()
  {
  $response = exec("rubyw F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/A-8.rb",$status);
  echo $response;
  if ($status = 1){
  echo "测试脚本已经完成运行，请注意查看邮件通知！";
  }else {
  echo "测试脚本运行失败，请联系自动化测试负责人！";
  }
  }
  RunningTestScript();
?>  
<body>
<h1>当您看到此页面时,说明自动化测试在测试机上已经完成了测试,如果收不到邮件,则说明测试过程出现异常,请在结果反馈页面查看Debug日志或联系自动化测试负责人！</h1>
<br />
<div><img src="back.png" border="0" onclick="javascript:history.back(-1);" title="返回上一页"></div>
<br />
<br />
<div>
<a href = "http://192.168.8.132:10006/monitor.html" target = "_blank">
<img src="links_64.png" title="直接转向结果反馈页面" />
直接转向结果反馈页面</a>
</div>
</body>
</html>
