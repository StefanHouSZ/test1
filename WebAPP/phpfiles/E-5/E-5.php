<html>
<head>
<link href="basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php
$str1 = $_POST["prepare"];
$str2 = $_POST["AutoTestScript"];
$str3 = $_POST["finish"];
$filePath = "F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/E-1.rb";
$handle = fopen($filePath, "w");
fwrite($handle,$str1);
fwrite($handle,$str2);
fwrite($handle,$str3);
fclose($handle);
?>
</head>
<body>
<h1>自动化运行脚本已按您的配置在测试机上生成，请返回上一页... ...</h1>
<br />
<div><img src="back.png" border="0" onclick="javascript:history.back(-1);" title="返回上一页"></div>
</body>
</html>