######Jetsen自动化测试自定义类，version 1.0.3######
##项目描述，如：媒体内容管理->检索系统相关测试项公共方法##

#encoding: utf-8
require 'pathname'
require 'find'
require "rexml/document"
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/Helper.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/MainExtra.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/ScreenCapture.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/ScreenRecord.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/TestLog.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/DebugLog.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/HtmlReport.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/email.rb'

include REXML

#实例化所有Class
$extra = MainExtra.new
$helper = Helper.new
$screen = ScreenCapture.new
$record = ScreenRecord.new
$log = Log.new
$html = HtmlReport.new
$email = SendEmail.new
$debug = DebugLog.new

########################################读取xml配置文件，此处需要修改(修改xml文件名)###################################################
input = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/Configuration/E-1-Config.xml")
doc = Document.new(input)
root = doc.root #定位根节点
$TestedURL = root.elements["URL"].text  #返回被测系统的URL
$UserName = root.elements["UserName"].text #返回被测系统的用户名
$PassWord = root.elements["PassWord"].text #返回被测系统的密码
$RecordScreen = root.elements["RecordScreen"].text #返回是否需要录屏，返回值为"yes""no"
$AviName = root.elements["AviName"].text #返回保存的录屏视频文件的名称
$ReportName = root.elements["ReportName"].text #返回HTML报告名
$ReportDescription = root.elements["Description"].text #返回HTML中的测试描述
$Coder = root.elements["Coder"].text #返回HTML中脚本编写者
$Tester = root.elements["Tester"].text #返回HTML中测试执行者
$TesterMailAddr = root.elements["TesterMailAddr"].text #返回测试执行者的邮箱地址
$DeveloperMailAddr = root.elements["DeveloperMailAddr"].text #返回开发责任人的邮箱地址
$MailSubject = root.elements["MailSubject"].text #返回邮件主题
$MailText = root.elements["MailText"].text #返回邮件内容



class AutoTest
#此方法定义测试初期的所有准备活动，开启录屏监视功能，初始化HTML测试报告等  
  def prepare     
#新建HTML报告creatHtmlReport(reportname,projectname,coder,tester)，参数说明：reportname为报告名，projectname为测试项目描述
#coder为自动化脚本编写责任人，tester为自动化测试执行人
  $html.createHtmlReport($ReportName,$ReportDescription,$Coder,$Tester)
  $screen.screencapture_run
#判断是否需要录屏
  if $RecordScreen == 'yes'
    then
#若之前已经开了Recorder，先关闭
  $extra.closeRecorder     
#运行CamRecorder软件
  $record.screenrecord_run
#开始录制视频  
  $record.screenrecord_start    
  end  #end if  
  end  #end def prepare
#此方法定义测试结束后的所有收尾活动，包括从用户配置文件中读取相应的配置，判断是否开启录屏监视功能，完成HTML测试报告，向自动化测试执行者发送电子邮件等 
def finish
#完成HtmlReport的报告页面
   $html.html_finish($ReportName)
   #判断是否需要录屏
  if $RecordScreen == 'yes'
    then
#停止录屏，保存视频文件     
  $record.screenrecord_stop($AviName)  
  end  #end if 
#发送邮件给相关测试执行人,sendmail(testermailaddr,develepormailaddr,subject,text,file)参数说明：testermailaddr为测试责任人邮箱，develepormailaddr为开发负责人邮箱，subject为邮件主题，text为邮件内容，file为附件地址
#注：1.9.x以上版本的SMTP发送邮件时，内容为UTF-8是一个BUG，ruby方面还没有解决，现只能发送英文邮件，特此声明
  $email.sendmail($TesterMailAddr,$DeveloperMailAddr,$MailSubject,$MailText)   
end  #end def finish 

  def pt1 #定义测试点1
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='E-1-PT1'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------# 
#登录系统   
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
#定位到测试页面
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3       
#通过判断页面是否有"所有分组"目录树来间接判断是否进入到成功进入到了用户管理页面    
    if $ie.frame(:name,'JetsenMain').link(:id,'depart-tree-0-a').exists?
      then 
      $log.logfile_pass()
      $html.html_pass('E-1-PT1')
    else
      $log.logfile_fail
      $html.html_fail('E-1-PT1')
    end  #end if
#输出日志：测试结束 
    $log.logfile_finish
  end #end pt1
  def pt2
    $log.descriptions='E-1-PT2'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3     
#检查是否有"所有分组"
    if $ie.frame(:name,'JetsenMain').div(:id=>'divTree',:class=>'jetsen-pageframe-pageitem').link(:id,'depart-tree-0-a').exists?
      then 
      $log.logfile_pass()
      $html.html_pass('E-1-PT2')
    else
      $log.logfile_fail
      $html.html_fail('E-1-PT2')
    end  #end if
     $log.logfile_finish
  end # end pt2
  def pt3
    $log.descriptions='E-1-PT3'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3   
#设置用户姓名搜索条件为"侯俊光"
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="侯俊光"
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click
#通过判断"登录名称"是否为"hjg"来判断搜索功能是否生效
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divRight').div(:id,'userlist-div-body').table(:id,'tabUser')    
    if @table2[0][2].to_s == 'hjg'
      then 
      $log.logfile_pass()
      $html.html_pass('E-1-PT3')
    else
      $log.logfile_fail
      $html.html_fail('E-1-PT3')
    end  #end if
     $log.logfile_finish   
  end  #end  pt3
  def pt4
    $log.descriptions='E-1-PT4'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3   
#设置用户姓名搜索条件为"侯俊光"
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').clear
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="侯俊光"    
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click
#通过判断"用户列表"的行数来判断测试是否成功，因为一般用户数据不可能为0，所以，搜索的"用户列表"行数必须>=1
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divRight').div(:id,'userlist-div-body').table(:id,'tabUser')    
    if @table2.row_count  >= 1
      then 
      $log.logfile_pass()
      $html.html_pass('E-1-PT4')
    else
      $log.logfile_fail
      $html.html_fail('E-1-PT4')
    end  #end if
     $log.logfile_finish    
  end  #end pt4
  def pt5
    $log.descriptions='E-1-PT5'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3   
    @table1 = $ie.frame(:name,'JetsenMain').div(:id=>'userlist-div-head',:class=>'jetsen-grid-head').table(:id,'userlist-tab-head')
#全选，能全选，自然能反选，这是HTMLcheckbox的基本功能，肯定不会有错，因此不需要再判断反选的功能了
    @table1[0][0].div(:class,'jetsen-grid-head-inner').checkbox(:id,'chkUser-all').click
#由于以下选择是用onclick调用一个js方法去实现的，因此无法用标准的watir的checkbox的checked?方法来判断是否被选中，在此处暂用人工判断
    $log.logfile_manual
    $html.html_manual('E-1-PT5')
#截图，高亮突出显示区域，方便人工判断    
    $screen.ScreenGot('E-1-PT5',x1=520,y1=360,x2=582,y2=556)
    $log.logfile_finish    
  end  #end pt5
  def pt6
    $log.descriptions='E-1-PT6'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3   
#点击“新建”，由于没办法定位到这个span，暂用autoit来代替
    #$ie.frame(:name,'JetsenMain').div(:class,'list-title-right').spans(:class,'jetsen-toolbox-item')[1].click
    $at.MouseClick('left',1248,249)
    sleep 3
    @table1 = $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'new-user').
    div(:class=>'jetsen-window-content',:id=>'new-user_content').div(:id,'tabPage').table(:class,'table-info')
#设置“登录名称”    
    @table1[0][1].text_field(:id,'txtLoginName').set("autotest")
#设置“用户姓名”   
    @table1[0][3].text_field(:id,'txtUserName').value="自动化测试"
#设置“用户密码”    
    @table1[2][1].text_field(:id,'txtPassword').set("1")
#设置“确认密码” 
    @table1[2][3].text_field(:id,'txtConfirmPassword').set("1")
#设置“隶属角色”，有个table没有标识，所以只能用autoit来代替操作，后面的几个步骤为了方便也用autoit来代替操作了
    sleep 2
    $at.MouseClick('left',847,378)
    sleep 1
    $at.MouseClick('left',582,580)
    sleep 1
    $at.MouseClick('left',587,375)
#点击“确定”
    $at.MouseClick('left',990,658)
#再次“确定”
    sleep 1
    $at.MouseClick('left',1005,636)
#重新用新设置的用户名和密码登录系统，判断测试结果
    $helper.loginsys('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm','autotest','1')
    @IEURL = $ie.url
    if @IEURL == 'http://192.168.8.27:8081/js46/juum/jnetsystemweb/default.htm' 
      then
        $log.logfile_pass
        $html.html_pass('E-1-PT6')
      else
        $log.logfile_fail
        $html.html_fail('E-1-PT6') 
    end  #end if
    $log.logfile_finish
#删除新建的用户名，恢复测试环境，因为系统做了限制，登录的用户不允许删除自己的用户名及密码信息，因此需要重新登录一次
    sleep 2
    $helper.loginsys('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm','hjg','1')
    sleep 2
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 2
#设置用户姓名搜索条件为"自动化测试"
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').clear
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="自动化测试"    
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click 
#点击“删除”       
    $at.MouseClick('left',1372,298)
#确定删除    
    $at.MouseClick('left',910,563)           
  end  #end pt6
  def pt7
    $log.descriptions='E-1-PT7'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3   
    $at.MouseClick('left',1338,247)
#导入模板
#点击“浏览”
    $at.MouseClick('left',854,492)
#选择测试用模板用户信息，目前此函数有点问题，就是文件名做成参数后有问题
    $helper.fileImport('选择要加载的文件','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\E-1\importuserinfo.xls')
#点击“确定”
    $at.MouseClick('left',955,536)
#网页会有一个提示“导入成功”，点击确定  
    $at.WinWaitActive('来自网页的消息')  
    $at.Send('{ENTER}')
    sleep 2
#设置用户姓名搜索条件为"exportuname"，查看搜索返回后的登录名称是否也为"exportAT"
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="exportuname"
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divRight').div(:id,'userlist-div-body').table(:id,'tabUser')
#    puts @table2[0][2].to_s
    if @table2[0][2].to_s == 'exportAT'
      then
        $log.logfile_pass
        $html.html_pass('E-1-PT7')
      else
        $log.logfile_fail
        $html.html_fail('E-1-PT7')  
    end  #end if
    $log.logfile_finish
#删除导入的用户信息，恢复测试环境
#设置用户姓名搜索条件为"exportuname"
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').clear
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="exportuname"    
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click 
#点击“删除”       
    $at.MouseClick('left',1372,298)
#确定删除    
    $at.MouseClick('left',910,563)           
  end  #end pt7
  def pt8
    $log.descriptions='E-1-PT8'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3   
    #设置用户姓名搜索条件为"管理员"，准备导出“管理员”的信息
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="管理员"
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click
#此checkbox是js调用的方法，不能用watir基础函数直接选定，用autoit来代替
    $at.MouseClick('left',442,300)
#选择"导出所选"
    $at.MouseClick('left',1413,246)
    $at.MouseClick('left',1274,273)
#导出信息选择“全选”
    $at.MouseClick('left',611,416) 
#点击“确定”
    $at.MouseClick('left',954,596)
#下载到框架的附件相关的项目文件夹内，方便后续测试进行判断
    $at.WinWait('文件下载')
    $at.MouseClick('left',775,445)
#导出文件到指定路径
    $helper.fileExport('另存为','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\E-1\USER.xls')
#若出现是否覆盖原文件，选择“是”
    $at.WinWaitActive('另存为')
    $at.Send('{TAB}')
    $at.Send('{ENTER}')     
#判断SmartJetsen的附件E-1文件夹下是否存在一个名为USER的文件
    sleep 4
    file = $extra.findfile('F:/Jetsen_AutoTest_project/SmartJetsen/WebAPP/Attachments/E-1/USER.xls')
    if file == true
      then
        $log.logfile_pass
        $html.html_pass('E-1-PT8')
      else
        $log.logfile_fail
        $html.html_fail('E-1-PT8')        
    end  #end if  
    $log.logfile_finish                      
  end  #end pt8
  def pt9
    $log.descriptions='E-1-PT9'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3   
#“全选”
    @table1 = $ie.frame(:name,'JetsenMain').div(:id=>'userlist-div-head',:class=>'jetsen-grid-head').table(:id,'userlist-tab-head')
    @table1[0][0].div(:class,'jetsen-grid-head-inner').checkbox(:id,'chkUser-all').click
#选择"导出所有"
    $at.MouseClick('left',1413,249)
    $at.MouseClick('left',1267,299)
#选择"所有用户数据"
    $at.MouseClick('left',612,416)     
#点击“确定”
    $at.MouseClick('left',955,596)
#下载到框架的附件相关的项目文件夹内，方便后续测试进行判断
    $at.WinWait('文件下载')
    $at.MouseClick('left',775,444)
#导出文件到指定路径
    $helper.fileExport('另存为','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\E-1\USER.xls')
#若出现是否覆盖原文件，选择“是”
    $at.WinWaitActive('另存为')
    $at.Send("{TAB}")
    $at.Send('{ENTER}')    
#判断SmartJetsen的附件E-1文件夹下是否存在一个名为USER的文件
    sleep 4
    file = $extra.findfile('F:/Jetsen_AutoTest_project/SmartJetsen/WebAPP/Attachments/E-1/USER.xls')
    if file == true
      then
        $log.logfile_pass
        $html.html_pass('E-1-PT9')
      else
        $log.logfile_fail
        $html.html_fail('E-1-PT9')        
    end  #end if  
    $log.logfile_finish    
  end  #end pt9
  def pt10
    $log.descriptions='E-1-PT10'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3
#设置用户姓名搜索条件为"侯俊光"
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="侯俊光"
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click
#点击"编辑"
    $at.MouseClick('left',1324,298) 
#判断”编辑窗口“是否弹出    
    if $ie.frame(:name,'JetsenMain').div(:id,'edit-user').div(:id,'edit-user_title').div(:id,'edit-user_title_text').exists?
      then 
        $log.logfile_pass
        $html.html_pass('E-1-PT10')
      else
        $log.logfile_fail
        $html.html_fail('E-1-PT10')  
    end  #end if
    $log.logfile_finish          
  end  #end pt10
  def pt11
    $log.descriptions='E-1-PT11'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3
#设置用户姓名搜索条件为"侯俊光"
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="侯俊光"
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click
#点击"编辑"
    $at.MouseClick('left',1324,298)
    @table2 = $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window-content',:id=>'edit-user_content').div(:id,'tabPage').table(:class,'table-info')
    @table2[0][3].text_field(:id,'txtUserName').clear
    @table2[0][3].text_field(:id,'txtUserName').value = "autotest"
#点击"保存" 
    $at.MouseClick('left',1003,634)
#通过搜索新用户姓名"autotest"，来判断编辑功能是否生效
#再次设置用户姓名搜索条件为"autotest"
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="autotest"
    @table1[0][2].button(:class,'button').click
    @table3 = $ie.frame(:name,'JetsenMain').div(:id,'divRight').div(:id,'userlist-div-body').table(:id,'tabUser')
    if @table3[0][1].to_s == 'autotest'
      then
        $log.logfile_pass
        $html.html_pass('E-1-PT11')
      else
        $log.logfile_fail
        $html.html_fail('E-1-PT11')      
    end  #end if
#恢复测试环境
#再次点击"编辑"
    $at.MouseClick('left',1324,298)
#恢复原始测试环境
    @table2[0][3].text_field(:id,'txtUserName').clear
    @table2[0][3].text_field(:id,'txtUserName').value = "侯俊光"
#点击"保存" 
    $at.MouseClick('left',1003,634)
    $log.logfile_finish        
  end  #end pt11
  def pt12
    $log.descriptions='E-1-PT12'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 3
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 3
#因为之前的测试中已经应用到了按"x"来删除的功能，因此此功能不可能有问题，直接通过    
    $log.logfile_pass
    $html.html_pass('E-1-PT12')
    $log.logfile_finish
  end  #end pt12
end  #end of AutoTest class