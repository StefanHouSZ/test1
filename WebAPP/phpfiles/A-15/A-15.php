<html>
<head>
<?php
$str1 = $_POST["prepare"];
$str2 = $_POST["AutoTestScript"];
$str3 = $_POST["finish"];
$filePath = "F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/A-15.rb";
$handle = fopen($filePath, "w");
fwrite($handle,$str1);
fwrite($handle,$str2);
fwrite($handle,$str3);
fclose($handle);
//定义函数
function RunningTestScript()
  {
  exec("rubyw F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/A-15.rb");
  }
?>
</head>
<body>
<h1><font color="#FF0000">配</font><font color="#FF9900">置</font><font color="#FFCC00">信</font><font color="#66CC00">息</font><font color="#00FFCC">已</font><font color="#66CCFF">提</font><font color="#9900CC">交</font><font color="#FF0000">，</font><font color="#FF9900">请</font><font color="#FFCC00">您</font><font color="#66CC00">返</font><font color="#00FFCC">回</font><font color="#66CCFF">上</font><font color="#9900CC">一</font><font color="#FF0000">页</font><font color="#FF9900">！</font></h1>
<div>
<input type="button" onclick="javascript:history.back(-1);" title="返回上一页" value = "返回上一页">
</div>
</body>
</html>