<html>
<head>
<link href="CSS/basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php
  exec("F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/ShowProject.bat",$res,$status);
  if ($status = 1){
  echo "Hi，亲，测试机上已有以下默认测试任务，请您仔细查看！";
  }else {
  echo "Sorry，性能测试过程可能出错了！请您联系自动化测试负责人... ...";
  }
  echo "<br />";
  echo $res[7];
  echo "<br />";
  echo $res[8];
  echo "<br />";
  echo $res[9];
  echo "<br />";
  echo $res[10];
  echo "<br />";
  echo $res[11];
?>
</head>
<body>
<h1>查看完任务后，现在您可以运行所有任务了... ...</h1>
<div>
<a href = "http://192.168.8.132:10006/phpfiles/runalltask.php" >
<img src="images/runalltestsuite_64.png" title="我要运行所有默认的自动化测试" /></a>
</div>
</body>
</html>