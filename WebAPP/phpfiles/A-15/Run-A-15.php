<html>
<head>
<?php
function RunningTestScript()
  {
  $response = exec("rubyw F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/A-15.rb",$status);
  echo $response;
  if ($status = 1){
  echo "测试脚本已经完成运行，请注意查看邮件通知！";
  echo $response;
  }else {
  echo "测试脚本运行失败，请联系自动化测试负责人！";
  }
  }
  RunningTestScript();
?>  
<body>
<h1>收到邮件通知后可转向"测试结果反馈页面"查看测试结果！</h1>
<div>
<input type="button" onclick="javascript:history.back(-1);" title="返回上一页" value = "返回上一页">
<input type="button" href="http://192.168.8.132:10006/monitor.html" target = "_blank" title="直接转向结果反馈页面" value = "去结果反馈页面查看结果">
</div>
</body>
</html>