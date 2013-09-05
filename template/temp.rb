#encoding:utf-8
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Project\UserManagement\usermanagement-l.rb'
######AutoTestCase######
##Testing for C-1##
begin #开始监测异常
test=AutoTest.new
#测试前的准备工作 ，prepare(excelpath)，参数描述：excelpath为读取的excel配置文件的路径
test.prepare
test.pt1
#根据测试需要，可选择测试集的全部或部分测试点进行测试
#test.ptx
#测试收尾工作
test.finish
rescue #抛出异常并记录异常到DebugLog中，writedebug(casenum)，参数为测试集编号
  $debug.writedebug('C-1')
ensure #出现异常后关闭IE
  $ie.close
end #结束异常监测
