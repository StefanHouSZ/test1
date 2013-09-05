<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/basestyle.css" />
<?php
  exec("F:/Jetsen_AutoTest_project/SmartJetsen/PageLoadingTest/A-8/PageLoadTest.bat",$status);
  if ($status = 1){
  echo "SmartJetsen已经帮您完成了A-8（媒体内容管理-->视频文件夹）的全部页面加载的性能测试！";
  }else {
  echo "Sorry，性能测试过程可能出错了！请您联系自动化测试负责人... ...";
  }
?>  
<body>
<h1>性能测试结果反馈：</h1>
<div>
<div><img src="images/back.png" border="0" onclick="javascript:history.back(-1);" title="返回上一页"></div>
</div>
<br />
<div>
<a href = "http://192.168.8.132:10006/PerformanceData/PerformanceData.txt" target = "_blank">
<img src="images/ShowPerformanceLog_64.png" title="页面性能测试结果打印" />
页面性能测试结果打印</a>
</div>
</body>
</html>