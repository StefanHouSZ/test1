#encoding:utf-8
require 'win32ole'
#初始化xml相关的数据
   $xml = WIN32OLE.new('Msxml2.DOMDocument.3.0')
   $xml.async = false
#加载XML，并将XML头写好，然后将root名定义好   
   $xml.loadXML('<?xml version="1.0" encoding="UTF-8"?><Config></Config>')  
def MakeConfigXml()
   ele1 = $xml.createElement('URL') #建立第一个二级节点，并赋予名称
   ele2 = $xml.createElement('UserName') 
   ele3 = $xml.createElement('PassWord') 
   ele4 = $xml.createElement('RecordScreen') 
   ele5 = $xml.createElement('AviName') 
   ele6 = $xml.createElement('ReportName') 
   ele7 = $xml.createElement('Description') 
   ele8 = $xml.createElement('Coder') 
   ele9 = $xml.createElement('Tester')
   ele10 = $xml.createElement('TesterMailAddr')
   ele11 = $xml.createElement('DeveloperMailAddr')
   ele12 = $xml.createElement('MailSubject')
   ele13 = $xml.createElement('MailText')

   dirNode1 = $xml.documentElement().appendChild(ele1) #将第一个二级节点加入根节点
   dirNode2 = $xml.documentElement().appendChild(ele2) 
   dirNode3 = $xml.documentElement().appendChild(ele3) 
   dirNode4 = $xml.documentElement().appendChild(ele4) 
   dirNode5 = $xml.documentElement().appendChild(ele5)
   dirNode6 = $xml.documentElement().appendChild(ele6)
   dirNode7 = $xml.documentElement().appendChild(ele7)
   dirNode8 = $xml.documentElement().appendChild(ele8)
   dirNode9 = $xml.documentElement().appendChild(ele9)
   dirNode10 = $xml.documentElement().appendChild(ele10)
   dirNode11 = $xml.documentElement().appendChild(ele11)
   dirNode12 = $xml.documentElement().appendChild(ele12)
   dirNode13 = $xml.documentElement().appendChild(ele13)
     
   dirNode1.text = 'http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm' #给第一个二级节点赋予text值
   dirNode2.text = 'hjg' 
   dirNode3.text = '1'
   dirNode4.text = 'no'
   dirNode5.text = 'X-X测试集名称'
   dirNode6.text = '测试报告名称.html'  
   dirNode7.text = 'HTML报告中的测试描述'  
   dirNode8.text = '编码者：侯俊光'  
   dirNode9.text = 'SmartJetsen测试框架执行'  
   dirNode10.text = 'tester@jetsen.cn'  
   dirNode11.text = 'develepor@jetsen.cn'  
   dirNode12.text = 'SmartJetsen测试执行反馈'  
   dirNode13.text = 'Dear Tester:The testsuite X-X has already finished,please check the feedback on SmartJestsen webpage,here is the link: http://192.168.11.66:10006/monitor.html  The mail is sent by:Jetsen AutoTest TEAM---We make Testing more smart!'    
end  #end def
MakeConfigXml() #写xml文件
$xml.save('./X-X-Config.xml')