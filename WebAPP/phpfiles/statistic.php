<html>
<head>
<link href="CSS/basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php
function RunningStatisticScript()
  {
  $response = exec("F:/Jetsen_AutoTest_project/SmartJetsen/Statistics/statistic.bat",$status);
  echo "TestResult.log的字符串长度为：";
  echo $response;
  echo "字节";
  echo "<br />";
  echo "<br />";
  echo "<br />";
  echo "<br />";
  if ($status = 1){
  echo "SmartJetsen已经帮您完成了测试结果统计！";
  }else {
  echo "Sorry，统计过程可能出错了！请您联系自动化测试负责人... ...";
  }
  }
  RunningStatisticScript();
?>  
<body>
<h1>测试统计结果反馈：</h1>
<div><img src="images/back.png" border="0" onclick="javascript:history.back(-1);" title="返回上一页"></div>
<br />
<br />
<h2>根据您的个人读图习惯，SmartJetsen可统计成柱状图和饼图方式</h2> 
<br />
    <div>
		<a href="./showbar.php" target= "_blank ">
		<img border="0" src="images/bar_48.png" title="输出自动化测试统计柱状图" />输出自动化测试统计柱状图 </a>
	</div>
<br />
<br />
<br />	
	<div>
		<a href="./showpie.php" target= "_blank ">
		<img border="0" src="images/pie_48.png" title="输出自动化测试统计饼图" />输出自动化测试统计饼图 </a>
	</div>
</body>
</html>