<html><head><link href="basestyle.css" rel="stylesheet" type="text/css" media="screen" />  <?php    $str1 = $_POST["recordstatus"];	$str2 = $_POST["testeraddr"];	$str3 = $_POST["developeraddr"];	$str4 = $_POST["testername"];	$str5 = $_POST["reportname"];	$str6 = $_POST["reportdescription"];    $xmlstr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n        <WebConfig>\n</WebConfig>";    $xml = new SimpleXMLElement($xmlstr);    $ScreenRecord = $xml->addchild('ScreenRecord',$str1);	$TesterEmail = $xml->addchild('TesterEmail',$str2);	$DeveloperEmail = $xml->addchild('DeveloperEmail',$str3);	$Tester = $xml->addchild('Tester',$str4);	$ReportName = $xml->addchild('ReportName',$str5);	$ReportDescription = $xml->addchild('ReportDescription',$str6);    $xml->asXML("F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/A-8-Config.xml");?></head><body><h1>测试基础配置请求已发送至自动化测试机，SmartJetsen将在测试机上为您生成一个xml配置文件... ...</h1><div><div><img src="back.png" border="0" onclick="javascript:history.back(-1);" title="返回上一页"></div></div></body></html>