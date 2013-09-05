<html>
<head>
<link href="CSS/basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php
echo "测试机器的操作系统信息为：";
$systeminfo = php_uname();
echo $systeminfo;
echo "<br />";
echo "自动化测试服务器IP为：";
$hostip = GetHostByName($_SERVER['SERVER_NAME']);
echo $hostip;
echo "<br />";
echo "服务器解译引擎为：";
$engine = $_SERVER['SERVER_SOFTWARE'];
echo $engine;
echo "<br />";
echo "服务器语言为:";
$language = $_SERVER['HTTP_ACCEPT_LANGUAGE'];
echo $language;
echo "<br />";
echo "Ruby版本为：";
$a = exec("ruby -v");
echo $a;
echo "<br />";
echo "Gem包版本为：";
$b = exec("gem -v");
echo $b;
echo "<br />";
echo "本地安装的所有GEM包：";
$c = passthru("gem list");
echo "<br />";
echo "<br />";
echo $c;
?>
</head>
<body>
  <h1>以上为自动化测试机的基本环境信息,请尤其注意ruby版本和gem包的信息!</h1>
</body>
</html>