<html>
<head>
<link href="CSS/basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php
function dir_path($path) {
	$path = str_replace('\\', '/', $path);
	if (substr($path, -1) != '/') $path = $path . '/';
	return $path;
}
/**
 * 列出目录下的所有文件
 *
 * @param str $path 目录
 * @param str $exts 后缀
 * @param array $list 路径数组
 * @return array 返回路径数组
 */
function dir_list($path, $exts = '', $list = array()) {
	$path = dir_path($path);
	$files = glob($path . '*');
	foreach($files as $v) {
		if (!$exts || preg_match("/\.($exts)/i", $v)) {
			$list[] = $v;
			if (is_dir($v)) {
				$list = dir_list($v, $exts, $list);
			}
		}
	}
	return $list;
}
$r =dir_list("F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS");
printf("<p>返回一个数组，包含内容为路径+文件名：</p><pre>%s</pre>\n", var_export($r , true));
?>
</head>
<body>
<div><img src="images/back.png" border="0" onclick="javascript:history.back(-1);" title="返回上一页"></div>
</body>
</html>