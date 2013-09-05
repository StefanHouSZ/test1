#encoding:utf-8
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Project\A-8_PictureFolder\PictureFolder-Local.rb'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\DebugLog.rb'
$debug = DebugLog.new
######AutoTestCase######
##Testing for A-8##
begin #开始监测异常
test=AutoTest.new
#测试准备工作
test.prepare
test.pt1
test.pt2
test.pt3
test.pt4
test.pt5
#测试收尾工作
test.finish
rescue #抛出异常并记录异常到DebugLog中，writedebug(casenum)，参数为测试集编号
  $debug.writedebug('A-8')
ensure #出现异常后关闭IE，如果开启了录屏功能，录屏软件也会被关闭
  $ie.close
  $extra.closeRecorder
end #结束异常监测
