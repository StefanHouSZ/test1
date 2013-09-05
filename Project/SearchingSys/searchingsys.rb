#########################Jetsen自动化测试自定义类，version 1.0.1########################################
###########媒体内容管理->检索系统相关测试项公共方法############

#encoding: utf-8
require 'watir'
require 'win32ole'
require 'pathname'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\MainExtra.rb'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\ScreenCapture.rb'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\ScreenRecord.rb'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\TestLog.rb'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\DebugLog.rb'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\HtmlReport.rb'

#实例化所有Class
$extra = MainExtra.new
$record = ScreenRecord.new
$log = Log.new
$html = HtmlReport.new

#调用关闭所有IE窗口的方法
$extra.close_all_IE(1,5)#此处以最多已经打开了5个IE为例
      
class AutoTest
  def initialize()  
    @ie = Watir::IE.new
    @at = WIN32OLE.new('AutoItX3.Control')
    @ie.maximize  
  end
#此方法定义测试初期的所有准备活动，包括从Excel中读取相应的配置，判断是否开启录屏监视功能，初始化HTML测试报告等  
  def prepare(excelpath)
    @EXCELPATH = excelpath
#判断是否需要对用例执行过程录制视频
#打开excel，并对其中的sheet进行访问
    excel = WIN32OLE::new('excel.Application')
#是否可视excel应用
    excel.visible = false
    workbook = excel.Workbooks.Open(@EXCELPATH)
    worksheet = workbook.Worksheets(1) #定位到第一个sheet
    worksheet.Select

    $data1 = worksheet.Range('E2').value #读取e2单元格的数据，查看是否需要对用例执行过程录制视频
    $data2 = worksheet.Range('C2').value #读取e2单元格的数据，查看设置的测试用例名称
    
    excel.Quit()
#关闭Excel的进程
    $extra.closeEXCEL
#定义一个新建视频文件夹的方法
def creatvideofolder
  filePath = Pathname.new(File.join(File.dirname(__FILE__),"../../TestVideo/")).realpath
  videofolder = $data2
  if not FileTest::exist?(File.join(filePath , "/#{videofolder}"))
  Dir.mkdir(File.join(filePath , "/#{videofolder}"))
else
  puts "存放视频文件的#{videofolder}的文件夹已存在！"
  exit
end
end
#判断是否配置了录制视频的功能
if $data1 == 'yes'
  then
#在TestVideo文件夹下新建一个和用例相关的文件夹
  creatvideofolder
  #运行CamRecorder软件
  $record.screenrecord_run
#开始录制视频  
  $record.screenrecord_start
else
  puts '没有选择视频录制功能！'
end
#新建HTML报告creatHtmlReport(reportname,projectname,coder,tester)，参数说明：reportname为报告名，projectname为测试项目描述
#coder为自动化脚本编写责任人，tester为自动化测试执行人
#------------------------------------- 此处需要修改-------------------------------------#
    $html.createHtmlReport('检索系统.html','媒资46系统检索系统相关第一轮测试','侯俊光','侯俊光')
  end
#此方法定义测试结束后的所有收尾活动，包括从Excel中读取相应的配置，判断是否开启录屏监视功能，完成HTML测试报告等    
  def finish
#关闭视频录制
  if $data1 == 'yes'
#screenrecord_stop的参数说明，第一个参数为存放AVI视频的路径；第二个参数为保存AVI视频的文件名，此处都用从配置的EXCEL文件中读到的测试用例名称  
    then $record.screenrecord_stop($data2,$data2)
  end
    $record.screenrecord_down
#完成HtmlReport的报告页面
#---------------------------------- 此处需要修改--------------------------------------#
#html_finish(reportname)，完成HTML页面，参数reportname为报告名，注意与createHtmlReport中的参数reportname保持一致
   $html.html_finish('检索系统.html')    
  end
  def pt1
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-9-PT1'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    @ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    @ie.text_field(:id,'txtUserName').clear
    @ie.text_field(:id,'txtUserName').set('hjg')
    @ie.text_field(:id, 'txtPassword').set('1')
    @ie.link(:class,'login-button').click   
    if
    @ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").exist?()
    @ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").click
    else
    @ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").exist?()
    @ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").click
    end  
    @ie.link(:id,"tree10000000-15-a").click
#输出日志：测试成功 
    $log.logfile_pass
#html_pass(casenum)，输出测试通过的HTML信息，参数casenum为测试用例编号    
    $html.html_pass('A-9-PT1')
    sleep 6
#输出日志：测试结束 
    $log.logfile_finish
  end #end pt1  

end

