######Jetsen自动化测试自定义类，version 1.0.2######
##项目描述##

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
########################################读取本地xml配置文件，此处需要修改(修改xml文件名)###################################################
inputlocal = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/Configuration/A-8-Config.xml")
doclocal = Document.new(inputlocal)
rootlocal = doclocal.root #定位根节点
$TestedURL = rootlocal.elements["URL"].text  #返回被测系统的URL
$UserName = rootlocal.elements["UserName"].text #返回被测系统的用户名
$PassWord = rootlocal.elements["PassWord"].text #返回被测系统的密码
$AviName = rootlocal.elements["AviName"].text #返回保存的录屏视频文件的名称
$Coder = rootlocal.elements["Coder"].text #返回HTML中脚本编写者
$MailSubject = rootlocal.elements["MailSubject"].text #返回邮件主题
$MailText = rootlocal.elements["MailText"].text #返回邮件内容

########################################读取web生成的xml配置文件，此处需要修改(修改xml文件名)##############################################
inputweb = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/A-8-Config.xml")
docweb = Document.new(inputweb)
rootweb = docweb.root
$RecordScreen = rootweb.elements["ScreenRecord"].text #返回是否需要录屏，返回值为"yes""no"
$TesterMailAddr = rootweb.elements["TesterEmail"].text #返回测试责任者Email地址
$DeveloperMailAddr = rootweb.elements["DeveloperEmail"].text #返回开发责任者Email地址
$ReportName = rootweb.elements["ReportName"].text #返回HTML报告名
$ReportDescription = rootweb.elements["ReportDescription"].text #返回HTML中的测试描述
$Tester = rootweb.elements["Tester"].text #返回HTML的测试执行者
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
#登录系统   
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1    
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
    $log.descriptions='A-8-PT1'      
#输出日志：测试开始
    $log.logfile_start 
#定位到测试页面
    $helper.gotopageclass2('tree10000000-7-a','tree10000000-7-0-a')
    sleep 1       
#通过判断页面是否有"所有分组"目录树来间接判断是否进入到成功进入到了用户管理页面    
    if $ie.div(:id=>'divFrameRight',:class=>'jetsen-pageframe').exists?
      then 
        $log.logfile_pass()
        $html.html_pass('A-8-PT1')
    else
      $log.logfile_fail
      $html.html_fail('A-8-PT1')
    end  #end if
#输出日志：测试结束 
    $log.logfile_finish
  end #end pt1
  def pt2
    $log.descriptions='A-8-PT2'
    $log.logfile_start 
    $helper.gotopageclass2('tree10000000-7-a','tree10000000-7-0-a')
    sleep 3
#点击“新建”
#    @table = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').table
#    table[0][0].div(:id,'divButtons').spans(:class,'jetsen-toolbox-item')[15].image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/create.gif').click         
    $at.WinWaitActive('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',277,215)  #有异常，不得已用AT代替操作
    $at.MouseClick('left',1014,201)  #先关闭一下
    sleep 1
    $at.MouseClick('left',277,215)  #用QT开发出来的插件总出现这种问题，必须要再点击一次“新建”才能生效
#导入图片
    $helper.fileImport('选择文件','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\A-8\createone\testpic.png')
#生成一个6位随机数并给图片名加后缀
    rand = $helper.randomchar(6).to_s
    @picname = 'testpic--' + rand
    table1 = $ie.frame(:name,'JetsenMain').div(:id,'divNewProgram').table
    sleep 1
    table1[0][1].text_field(:id,'txt_ProgramName').value = @picname
#点击“确定”
    $at.MouseClick('left',960,565)
    sleep 1      
    @table2 = $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-grid-body',:id=>'10500100-div-body').table(:id=>'tabProgram',:class=>'jetsen-grid-body')
    @data = @table2.row_count
#判断table的行数大于等于1来间接判断测试结果
    if @data >= 1
      then 
      $log.logfile_pass()
      $html.html_pass('A-8-PT2')
    else
      $log.logfile_fail
      $html.html_fail('A-8-PT2')
    end  #end if
     $log.logfile_finish
#恢复测试环境
#    @table3 = $ie.frame(:name,'JetsenMain').div(:id,'divProgramList').table(:id,'10500100-tab-head')
#    @table3[0][0].checkbox(:id=>'chkAll',:name=>'chkAll').set
    $at.MouseClick('left',232,653)
    sleep 2
    @table = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').table
    @table[0][0].div(:id,'divButtons').spans(:class,'jetsen-toolbox-item')[3].image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/delete.gif').click     
#点击“确定”
    $at.MouseClick('left',930,565)  
  end # end pt2
  def pt3
    $log.descriptions='A-8-PT3'
    $log.logfile_start 
    $helper.gotopageclass2('tree10000000-7-a','tree10000000-7-0-a')
    sleep 3
#点击“新建”
    $at.WinWaitActive('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',277,215)  #有异常，不得已用AT代替操作
    $at.MouseClick('left',1014,201)  #先关闭一下
    sleep 1
    $at.MouseClick('left',277,215)  #用QT开发出来的插件总出现这种问题，必须要再点击一次“新建”才能生效
#导入图片
    $helper.fileImport('选择文件','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\A-8\createone\testpic.png')
#生成一个6位随机数并给图片名加后缀
    rand = $helper.randomchar(6).to_s
    @picname = 'testpic--' + rand
    table = $ie.frame(:name,'JetsenMain').div(:id,'divNewProgram').table
    sleep 1
    table[0][1].text_field(:id,'txt_ProgramName').value = @picname
#点击“确定”
    $at.MouseClick('left',960,565)
#判断图片正命题
    sleep 1
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divCatalogInfo').div(:class,'jetsen-tabtable').table(:class,'xdata-table') 
    @data = @table1[0][1].text_field.value.to_s
    if @data == @picname
      then
        $log.logfile_pass
        $html.html_pass('A-8-PT3')
      else
        $log.logfile_fail
        $html.html_fail('A-8-PT3')  
    end  #end if
    $log.logfile_finish
#恢复测试环境
    $at.MouseClick('left',232,653)
    @table = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').table
    @table[0][0].div(:id,'divButtons').spans(:class,'jetsen-toolbox-item')[3].image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/delete.gif').click     
#点击“确定”
    $at.MouseClick('left',930,565)                 
  end  #end pt3
  def  pt4
#完成一个完整的图片入库流程
    $log.descriptions='A-8-PT4'
    $log.logfile_start 
    $helper.gotopageclass2('tree10000000-7-a','tree10000000-7-0-a')
    sleep 3
#点击“新建”
    $at.WinWaitActive('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',277,215)  #有异常，不得已用AT代替操作
    $at.MouseClick('left',1014,201)  #先关闭一下
    sleep 1
    $at.MouseClick('left',277,215)  #用QT开发出来的插件总出现这种问题，必须要再点击一次“新建”才能生效
#导入图片
    $helper.fileImport('选择文件','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\A-8\createone\testpic.png')
#生成一个6位随机数并给图片名加后缀
    rand = $helper.randomchar(6).to_s
    @picname = 'testpic--' + rand
    table = $ie.frame(:name,'JetsenMain').div(:id,'divNewProgram').table
    sleep 1
    table[0][1].text_field(:id,'txt_ProgramName').value = @picname
#点击“确定”
    $at.MouseClick('left',960,565)
#选择自动化新添加的项目进行提交
    @table1 = $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-pageframe',:id=>'divLeftBottom').div(:id,'10500100-div-body').table(:id,'tabProgram')    
    sleep 1
    @table1[0][0].checkbox(:name,'chk_program').set
    sleep 1
#点击“提交”
    #$ie.frame(:name,'JetsenMain').div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/jetsenclient/themes/icon/commit.gif']/").click
    $at.MouseClick('left',586,214)
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id,'jetsen-confirm').div(:id,'jetsen-confirm_button').button(:class,'jetsen-window-button').click
#定位到 “图片文件审核”
    $helper.gotopageclass2('tree10000000-7-a','tree10000000-7-1-a')
#选择自动化提交的图片
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divLeftBottom').div(:id,'10500200-div-body').table(:id,'tabProgram')
    @table2[0][0].checkbox(:name,'chk_program').set
#点击“通过”
    $at.MouseClick('left',427,214)
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id,'jetsen-confirm').div(:id,'jetsen-confirm_button').button(:class,'jetsen-window-button').click                   
#定位到“图片编目系统”
    $helper.gotopageclass2('tree10000000-7-a','tree10000000-7-2-a')
#选择自动化提交的图片
    @table3 = $ie.frame(:name,'JetsenMain').div(:id,'divLeftBottom').div(:id,'10500300-div-body').table(:id,'tabProgram')
    @table3[0][0].checkbox(:name,'chk_program').set
#点击“提交”
    $at.MouseClick('left',475,215)
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id,'jetsen-confirm').div(:id,'jetsen-confirm_button').button(:class,'jetsen-window-button').click              
#定位到检索系统，搜索已通过提交的图片来判断测试结果
    $helper.gotopageclass1('tree10000000-15-a')
    @table3 = $ie.frame(:name,'JetsenMain').table[2][0].div(:id,'divFullQuery').table(:class,'table-info')
    @table3[0][0].select_list(:id,'ddlFullMediaType').option(:value, '20').select
    @table3[0][1].text_field(:id,'txtKeyword').set(@picname)
    @table3[0][1].button(:class,'button').click
#测试判断，无法判断实际文字描述，只能通过判断table行数为1来间接反馈测试结果的正确性
    @table4 = $ie.frame(:name,'JetsenMain').div(:id,'searchResult').div(:id,'resultPic').table
#    p @table4[0][2].span(:id,'sp_pic_1377')
    @data = @table4.row_count
    if @data == 3
      then
        $log.logfile_pass
        $html.html_pass('A-8-PT4')
      else
        $log.logfile_fail
        $html.html_fail('A-8-PT4')  
    end  #end if
    $log.logfile_finish          
  end  #end pt4
  def  pt5
#测试批量入库功能
    $log.descriptions='A-8-PT5'
    $log.logfile_start 
    $helper.gotopageclass2('tree10000000-7-a','tree10000000-7-0-a')
    sleep 3
#点击“批量入库”
    $at.MouseClick('left',345,214)    
    @table = $ie.frame(:name,'JetsenMain').div(:id,'divNewBatchProgram').table
    @table[0][1].text_field(:class=>'input22',:id=>'txt_ExportFolder').value="F:/Jetsen_AutoTest_project/SmartJetsen/WebAPP/Attachments/A-8/batchcreate/"        
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:class,'jetsen-window-bottom').button(:class,'jetsen-window-button').click
#选择所有需要批量的项目
    @table1 = $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window-content',:id=>'checkin-batchlist_content').div(:id,'divBatchlist').table
    @table1[0][0].checkbox(:id,'chkbAll').set
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window-bottom',:id=>'checkin-batchlist_button').button(:class,'jetsen-window-button').click          
#先关闭一下批量窗口
    $at.MouseClick('left',1313,255)
    sleep 1
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divLeftBottom').div(:id,'divProgramContent').div(:class,'jetsen-grid-body').table(:id,'tabProgram')
    @data = @table2.row_count
#判断table的行数等于3来间接判断测试结果(因为批量文件由三个，如果之前已经有一些图片项目，会影响测试结果)
    if @data == 3
      then 
      $log.logfile_pass()
      $html.html_pass('A-8-PT5')
    else
      $log.logfile_fail
      $html.html_fail('A-8-PT5')
    end  #end if
     $log.logfile_finish
#恢复测试环境
    $at.MouseClick('left',232,653)
    @table = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').table
    @table[0][0].div(:id,'divButtons').spans(:class,'jetsen-toolbox-item')[3].image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/delete.gif').click     
#点击“确定”
    $at.MouseClick('left',930,565)           
  end  #end pt5   
end  #end class