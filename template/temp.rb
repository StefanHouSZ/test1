#encoding:utf-8
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Project\UserManagement\usermanagement-l.rb'
######AutoTestCase######
##Testing for C-1##
begin #��ʼ����쳣
test=AutoTest.new
#����ǰ��׼������ ��prepare(excelpath)������������excelpathΪ��ȡ��excel�����ļ���·��
test.prepare
test.pt1
#���ݲ�����Ҫ����ѡ����Լ���ȫ���򲿷ֲ��Ե���в���
#test.ptx
#������β����
test.finish
rescue #�׳��쳣����¼�쳣��DebugLog�У�writedebug(casenum)������Ϊ���Լ����
  $debug.writedebug('C-1')
ensure #�����쳣��ر�IE
  $ie.close
end #�����쳣���
