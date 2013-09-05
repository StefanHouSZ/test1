######Jetsen自动化测试自定义类，version 1.0.3######
##E-3媒资系统  统一用户管理-->分组管理相关测试##

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
input = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/Configuration/E-3-Config.xml")
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
#---------------------------------- 此处需要修改--------------------------------------#
#html_finish(reportname)，完成HTML页面，参数reportname为报告名，注意与createHtmlReport中的参数reportname保持一致 
   $html.html_finish($ReportName)   #判断是否需要录屏
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
    $log.descriptions='E-3-PT1'      
#输出日志：测试开始
    $log.logfile_start
#登录系统   
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 2
#定位到测试页面
    $helper.gotopageclass4('tree50000000-2-a')
    sleep 2       
#通过判断页面是否有"分组管理"目录树来间接判断是否进入到成功进入到了用户管理页面    
    if $ie.frame(:name,'JetsenMain').link(:id,'depart-tree-0-a').exists?
      then 
      $log.logfile_pass()
      $html.html_pass('E-3-PT1')
    else
      $log.logfile_fail
      $html.html_fail('E-3-PT1')
    end  #end if
#输出日志：测试结束 
    $log.logfile_finish
  end #end pt1
  def pt2
    $log.descriptions='E-3-PT2'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 2
    $helper.gotopageclass4('tree50000000-2-a')
    sleep 2     
#检查是否有"系统分组"
    if $ie.frame(:name,'JetsenMain').div(:id=>'divTree',:class=>'jetsen-pageframe-pageitem').link(:id,'depart-tree-0-a').exists?
      then 
      $log.logfile_pass()
      $html.html_pass('E-3-PT2')
    else
      $log.logfile_fail
      $html.html_fail('E-3-PT2')
    end  #end if
     $log.logfile_finish
  end # end pt2
  def pt3
     $log.descriptions='E-3-PT3'
     $log.logfile_start 
     $helper.loginsys($TestedURL,$UserName,$PassWord)
     sleep 2
     $helper.gotopageclass4('tree50000000-2-a')
     sleep 2
     @table1 = $ie.frame(:name,'JetsenMain').div(:id=>'divContainer',:class=>'jetsen-grid').table(:id,'grouplist-tab-head')
#全选，能全选，自然能反选，这是HTMLcheckbox的基本功能，肯定不会有错，因此不需要再判断反选的功能了
     @table1[0][0].div(:class,'jetsen-grid-head-inner').checkbox(:id,'chkUserGroup-all').click
#由于以下选择是用onclick调用一个js方法去实现的，因此无法用标准的watir的checkbox的checked?方法来判断是否被选中，在此处暂用人工判断
    $log.logfile_manual
    $html.html_manual('E-3-PT3')
#截图，高亮突出显示区域，方便人工判断    
    $screen.ScreenGot('E-3-PT3',x1=535,y1=336,x2=577,y2=457)
    $log.logfile_finish  
  end  #end pt3
  def pt4
    $log.descriptions='E-3-PT4'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 2
    $helper.gotopageclass4('tree50000000-2-a')
    sleep 2
#获取新建分组前的“系统分组”下的div的数目
    @divnum1 = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divLeft').div(:id,'depart-tree-0').divs.length
#点击“新建”
#   $helper.showimagesinframe
    $ie.frame(:name,'JetsenMain').div(:id=>'divRight',:class=>'jetsen-pageframe').div(:class,'list-title-right').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    sleep 2 
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_content',:class=>'jetsen-window-content').div(:id,'divUserGroup').table[0][1].table 
    @table[0][1].text_field(:id,'txtGroupName').set('autotest')
#点击“确定”保存新建的分组，其他配置保持默认，注意：这里有个小问题，value值为中文的元素目前没办法识别，由于“确定”与“取消”用的class的值相同，默认先选定第一个，刚好是“确定”按钮
    $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click 
#通过判断系统分组中是否有"autotest"来判断功能是否生效(此方法不行，因为每次生成的新组在左侧tree下的顺序不一样，没办法通过判断title是否为"autotest"来判断测试结果，只能间接使用div的数量数否增加1来判断新建成功了)
    @divnum2 = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divLeft').div(:id,'depart-tree-0').divs.length
    if @divnum2 - @divnum1 == 1
      then
      $log.logfile_pass
      $html.html_pass('E-3-PT4')
    else
      $log.logfile_fail
      $html.html_fail('E-3-PT4')
    end  #end if 
    $log.logfile_finish
#恢复测试环境
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRgihtBottom').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')
#点击刚才新建的"autotest"的删除按钮    
#    $helper.showimagesinframe
    @table[1][6].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'jetsen-confirm').div(:class=>'jetsen-window-bottom',:id=>'jetsen-confirm_button').button(:class,'jetsen-window-button').click         
  end  #end pt4
  def pt5
    $log.descriptions='E-3-PT5'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 2
    $helper.gotopageclass4('tree50000000-2-a')
    sleep 2
#点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id=>'divRight',:class=>'jetsen-pageframe').div(:class,'list-title-right').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    sleep 2 
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_content',:class=>'jetsen-window-content').div(:id,'divUserGroup').table[0][1].table 
    @table[0][1].text_field(:id,'txtGroupName').set('autotest')
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click    
#查看新建的分组中的名称返回值是否为'autotest'来判断测试结果
    @table = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRgihtBottom').div(:id,'divContainer').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')
    @data = @table[1][1].to_s
    if @data == 'autotest'
      then
      $log.logfile_pass
      $html.html_pass('E-3-PT5')
    else
      $log.logfile_fail
      $html.html_fail('E-3-PT5')
    end  #end if
    $log.logfile_finish
#恢复测试环境
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRgihtBottom').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')            
    @table[1][6].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
    $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'jetsen-confirm').div(:class=>'jetsen-window-bottom',:id=>'jetsen-confirm_button').button(:class,'jetsen-window-button').click
  end  #end pt5
  def pt6
    $log.descriptions='E-3-PT6'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 2
    $helper.gotopageclass4('tree50000000-2-a')
    sleep 2
    #点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id=>'divRight',:class=>'jetsen-pageframe').div(:class,'list-title-right').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    sleep 2 
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_content',:class=>'jetsen-window-content').div(:id,'divUserGroup').table[0][1].table 
    @table[0][1].text_field(:id,'txtGroupName').set('autotest')
#设置代号
    @table[1][1].text_field(:id=>'txtGroupCode',:class=>'input2').set('autotest001')    
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click
#查看新建的分组中的代号返回值是否为'autotest001'来判断测试结果
    @table = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRgihtBottom').div(:id,'divContainer').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')
    @data = @table[1][2].to_s
    if @data == 'autotest001'
      then
      $log.logfile_pass
      $html.html_pass('E-3-PT6')
    else
      $log.logfile_fail
      $html.html_fail('E-3-PT6')
    end  #end if
    $log.logfile_finish  
#恢复测试环境
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRgihtBottom').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')            
    @table[1][6].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
    $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'jetsen-confirm').div(:class=>'jetsen-window-bottom',:id=>'jetsen-confirm_button').button(:class,'jetsen-window-button').click      
  end  #end pt6
  def pt7
   $log.descriptions='E-3-PT7'
   $log.logfile_start 
   $helper.loginsys($TestedURL,$UserName,$PassWord)
   sleep 2
   $helper.gotopageclass4('tree50000000-2-a')
   sleep 2
#点击“新建”
   $ie.frame(:name,'JetsenMain').div(:id=>'divRight',:class=>'jetsen-pageframe').div(:class,'list-title-right').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
   sleep 2 
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_content',:class=>'jetsen-window-content').div(:id,'divUserGroup').table[0][1].table 
   @table[0][1].text_field(:id,'txtGroupName').set('autotest')
#选择所属分组，测试时选择的分组为“测试部”   
   @table[3][1].select_list(:id,'ddlParentGroup').option(:value,'7').select
#点击“确定”
   $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click   
#人工判断，查看左侧是否有新加的分组“测试部”，并且查看是否隶属于系统分组下，由于判断比较复杂，所以选择人工判断的方式
   $log.logfile_manual
   $html.html_manual('E-3-PT7')
#截图，高亮突出显示区域，方便人工判断    
   $screen.ScreenGot('E-3-PT7',x1=331,y1=332,x2=471,y2=500)
   $log.logfile_finish
#恢复测试环境
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRgihtBottom').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')            
    @table[0][6].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
    $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'jetsen-confirm').div(:class=>'jetsen-window-bottom',:id=>'jetsen-confirm_button').button(:class,'jetsen-window-button').click       
  end  #end pt7
  def pt8
   $log.descriptions='E-3-PT8'
   $log.logfile_start 
   $helper.loginsys($TestedURL,$UserName,$PassWord)
   sleep 2
   $helper.gotopageclass4('tree50000000-2-a')
   sleep 2
#点击“新建”
   $ie.frame(:name,'JetsenMain').div(:id=>'divRight',:class=>'jetsen-pageframe').div(:class,'list-title-right').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
   sleep 2 
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_content',:class=>'jetsen-window-content').div(:id,'divUserGroup').table[0][1].table 
   @table[0][1].text_field(:id,'txtGroupName').set('autotest')
#选择一个分组  ，测试时选择“分组”
   @table[4][1].select_list(:id,'ddlGroupType').option(:value,'2').select
#点击“确定”
   $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click       
#因为是中文的，所以通过自动化没法判断结果，暂用手工确认
   $log.logfile_manual
   $html.html_manual('E-3-PT8')
#截图，高亮突出显示区域，方便人工判断    
   $screen.ScreenGot('E-3-PT8',x1=1344,y1=381,x2=1403,y2=402)
   $log.logfile_finish
#恢复测试环境
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRgihtBottom').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')            
   @table[1][6].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
   $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'jetsen-confirm').div(:class=>'jetsen-window-bottom',:id=>'jetsen-confirm_button').button(:class,'jetsen-window-button').click 
  end  #end pt8
  def pt9
   $log.descriptions='E-3-PT9'
   $log.logfile_start 
   $helper.loginsys($TestedURL,$UserName,$PassWord)
   sleep 2
   $helper.gotopageclass4('tree50000000-2-a')
   sleep 2
#点击“新建”
   $ie.frame(:name,'JetsenMain').div(:id=>'divRight',:class=>'jetsen-pageframe').div(:class,'list-title-right').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
   sleep 2 
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_content',:class=>'jetsen-window-content').div(:id,'divUserGroup').table[0][1].table 
   @table[0][1].text_field(:id,'txtGroupName').set('autotest')
#“添加”成员
   sleep 1
   @table = $ie.frame(:id,'JetsenMain').div(:id,'new-group').div(:id,'new-group_content').div(:id,'divUserGroup').table
   @table[2][0].button(:id,'btnAdd').click
   @table1 = $ie.frame(:id,'JetsenMain').div(:id,'select-user').div(:id,'select-user_content').div(:id,'divSelectUserList').div(:id,'selectuserlist-div-body').table(:id,'tabSelectUser')    
   @table1[3][0].checkbox(:name,'chk_SelectUser').set
#点击“确定”，选择成员
   $ie.frame(:id,'JetsenMain').div(:id=>'select-user_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click 
#点击“确定”，新增分组
   $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click     
#双击autotest进入编辑页面，查看用户成员列表中是否有新添加的成员“侯俊光”    
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRight').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')
   @table[1][1].fire_event('ondblclick')  #双击操作
   @table2 = $ie.frame(:id,'JetsenMain').div(:id,'edit-group').div(:id,'edit-group_content').div(:id,'divUserGroup').table
   @data =  @table2[1][0].select_list(:id,'selMember').getAllContents.to_s
#判断用户列表中的值是否为“侯俊光”，由于编码问题，判断值为["\x{BAEE}\x{BFA1}\x{B9E2}"]
   if @data == '["\x{BAEE}\x{BFA1}\x{B9E2}"]' 
     then 
       $log.logfile_pass 
       $html.html_pass('E-3-PT9')
     else
       $log.logfile_fail
       $html.html_fail('E-3-PT9') 
   end  #end if   
   $log.logfile_finish
#恢复测试环境
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRgihtBottom').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')            
   @table[1][6].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
   $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'jetsen-confirm').div(:class=>'jetsen-window-bottom',:id=>'jetsen-confirm_button').button(:class,'jetsen-window-button').click    
  end  #end pt9
  def pt10
   $log.descriptions='E-3-PT10'
   $log.logfile_start 
   $helper.loginsys($TestedURL,$UserName,$PassWord)
   sleep 2
   $helper.gotopageclass4('tree50000000-2-a')
   sleep 2
#先重复pt9的操作，新建添加一个用户
#点击“新建”
   $ie.frame(:name,'JetsenMain').div(:id=>'divRight',:class=>'jetsen-pageframe').div(:class,'list-title-right').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
   sleep 2 
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_content',:class=>'jetsen-window-content').div(:id,'divUserGroup').table[0][1].table 
   @table[0][1].text_field(:id,'txtGroupName').set('autotest')
#“添加”成员
   sleep 1
   @table = $ie.frame(:id,'JetsenMain').div(:id,'new-group').div(:id,'new-group_content').div(:id,'divUserGroup').table
   @table[2][0].button(:id,'btnAdd').click
   @table1 = $ie.frame(:id,'JetsenMain').div(:id,'select-user').div(:id,'select-user_content').div(:id,'divSelectUserList').div(:id,'selectuserlist-div-body').table(:id,'tabSelectUser')    
   @table1[3][0].checkbox(:name,'chk_SelectUser').set
#点击“确定”，选择成员
   $ie.frame(:id,'JetsenMain').div(:id=>'select-user_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click 
#点击“确定”，新增分组
   $ie.frame(:name,'JetsenMain').div(:id=>'new-group',:class=>'jetsen-window').div(:id=>'new-group_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click     
#双击autotest进入编辑页面，查看用户成员列表中是否有新添加的成员“侯俊光”    
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRight').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')
   @table[1][1].fire_event('ondblclick')  #双击操作
#删除新增用户”侯俊光“，方便起见用AutoIt来做
   $at.MouseClick('left',818,535)
   $at.MouseClick('left',664,634)   
   @table2 = $ie.frame(:id,'JetsenMain').div(:id,'edit-group').div(:id,'edit-group_content').div(:id,'divUserGroup').table
   @data =  @table2[1][0].select_list(:id,'selMember').getAllContents.to_s
#判断用户列表处是否为空，即返回一个空数组来判断是否删除成功
   if @data == '[]'
     then 
       $log.logfile_pass 
       $html.html_pass('E-3-PT10')
     else
       $log.logfile_fail
       $html.html_fail('E-3-PT10') 
   end  #end if   
   $log.logfile_finish
#恢复测试环境
   @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').div(:id,'divRgihtBottom').div(:id,'grouplist-div-body').table(:id=>'tabUserGroup',:class=>'jetsen-grid-body')            
   @table[1][6].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
   $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'jetsen-confirm').div(:class=>'jetsen-window-bottom',:id=>'jetsen-confirm_button').button(:class,'jetsen-window-button').click    
  end  #end pt10
end  #end of AutoTest class