#encoding:utf-8
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Project\E-1_UserManagement\usermanagement-l.rb'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\DebugLog.rb'
$debug = DebugLog.new
######AutoTestCase######
##Testing for E-1##
begin #开始监测异常
test=AutoTest.new
#测试前的准备工作 ，prepare(excelpath)，参数描述：excelpath为读取的excel配置文件的路径
test.prepare
test.pt1
test.pt2
test.pt3
test.pt4
test.pt5
test.pt6
test.pt7
test.pt8
test.pt9
test.pt10
test.pt11
test.pt12
#测试收尾工作
test.finish
rescue #抛出异常并记录异常到DebugLog中，writedebug(casenum)，参数为测试集编号
  $debug.writedebug('E-1')
ensure #出现异常后关闭IE
  $ie.close
  $extra.closeRecorder
end #结束异常监测
