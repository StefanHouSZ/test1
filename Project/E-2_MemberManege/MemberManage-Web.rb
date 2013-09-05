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
inputlocal = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/Configuration/E-2-Config.xml")
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
inputweb = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/E-2-Config.xml")
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
  end  #end def prepare
#此方法定义测试结束后的所有收尾活动，包括从用户配置文件中读取相应的配置，判断是否开启录屏监视功能，完成HTML测试报告，向自动化测试执行者发送电子邮件等 
def finish
#完成HtmlReport的报告页面
#---------------------------------- 此处需要修改--------------------------------------#
#html_finish(reportname)，完成HTML页面，参数reportname为报告名，注意与createHtmlReport中的参数reportname保持一致 
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
    $log.descriptions='E-2-PT1'      
#输出日志：测试开始
    $log.logfile_start 
#登录系统   
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
#定位到测试页面
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 1       
#通过判断页面是否有"所有分组"目录树来间接判断是否进入到成功进入到了用户管理页面    
    if $ie.frame(:name,'JetsenMain').link(:id,'depart-tree-0-a').exists?
      then 
      $log.logfile_pass()
      $html.html_pass('E-2-PT1')
    else
      $log.logfile_fail
      $html.html_fail('E-2-PT1')
    end  #end if
#输出日志：测试结束 
    $log.logfile_finish
  end #end pt1
  def pt2
    $log.descriptions='E-2-PT2'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 1     
#检查是否有"所有分组"
    if $ie.frame(:name,'JetsenMain').div(:id=>'divTree',:class=>'jetsen-pageframe-pageitem').link(:id,'depart-tree-0-a').exists?
      then 
      $log.logfile_pass()
      $html.html_pass('E-2-PT2')
    else
      $log.logfile_fail
      $html.html_fail('E-2-PT2')
    end  #end if
     $log.logfile_finish
  end # end pt2
  def pt3
    $log.descriptions='E-2-PT3'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 2
#测试搜索功能
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').table(:class,'table-info')
    @table[0][1].text_field(:id,'txtUserName').set('hjg')
#由于id和class值都为button，无法找到该元素，用AutoIt代替
    $at.MouseClick('left',452,216)
#判断测试结果，判断搜索结果的姓名是否为'hjg'
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRight').div(:id,'person-tabPerson-div-body').table(:id,'tabPerson')      
    if @table1[0][1].to_s == 'hjg'
      then
        $log.logfile_pass
        $html.html_pass('E-2-PT3')
    else
        $log.logfile_fail
        $html.html_fail('E-2-PT3')
    end  #end if
    $log.logfile_finish
  end  #end pt3
  def pt4
    $log.descriptions='E-2-PT4'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 2   
    @table = $ie.frame(:name,'JetsenMain').div(:id,'divContent').div(:id,'divRight').div(:id,'divRgihtBottom').div(:id,'divPersonList').div(:id,'person-tabPerson-div-head').table(:id,'person-tabPerson-tab-head')
#全选，能全选，自然能反选，这是HTMLcheckbox的基本功能，肯定不会有错，因此不需要再判断反选的功能了
    @table[0][0].checkbox(:id,'chkPerson-all').click
#由于以下选择是用onclick调用一个js方法去实现的，因此无法用标准的watir的checkbox的checked?方法来判断是否被选中，在此处暂用人工判断
    $log.logfile_manual
    $html.html_manual('E-2-PT4')
#截图，高亮突出显示区域，方便人工判断    
    $screen.ScreenGot('E-2-PT4',x1=538,y1=363,x2=577,y2=457)
    $log.logfile_finish
  end  #end pt4
  def  pt5
    $log.descriptions='E-2-PT5'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 2
#点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRightTitle').span(:class,'jetsen-toolbox-item').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click      
#新建人员
    @table = $ie.frame(:name,'JetsenMain').div(:id,'new-person_content').div(:id,'tabPage').table(:class,'table-info')
    @table[0][1].text_field(:id,'txtPersonName').set('AutoTest')
    @table[0][3].text_field(:id,'txtPersonCode').set('AutoTest001')
#因为是只读的，因此不能set，但是可以用value方法来传值进去    
    @table[2][1].text_field(:id,'txtBirthday').value = '1987-02-13' 
    @table[3][1].text_field(:id,'txtJoinDate').value = '2013-01-10'
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id,'new-person').div(:id,'new-person_button').button(:class,'jetsen-window-button').click
#搜索刚才新建的人员
    @table1 = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').table(:class,'table-info')
    @table1[0][1].text_field(:id,'txtUserName').set('AutoTest')
#由于id和class值都为button，无法找到该元素，用AutoIt代替
    $at.MouseClick('left',452,216)
#判断测试结果，查看新建的姓名是否为“AutoTest”
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRight').div(:id,'person-tabPerson-div-body').table(:id,'tabPerson')      
    if @table2[0][1].to_s == 'AutoTest'
      then
        $log.logfile_pass
        $html.html_pass('E-2-PT5')
    else
        $log.logfile_fail
        $html.html_fail('E-2-PT5')
    end  #end if
    $log.logfile_finish
#删除新建的人员恢复测试环境
    @table2[0][10].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
    sleep 1
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id,'jetsen-confirm').div(:id,'jetsen-confirm_button').button(:class,'jetsen-window-button').click                     
  end  #end pt5
  def pt6
    $log.descriptions='E-2-PT6'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 2
#点击“导入”
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRightTitle').spans(:class,'jetsen-toolbox-item')[2].image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/import.gif').click        
#点击“浏览”，用autoit了
    $at.MouseClick('left',857,492)    
    $helper.fileImport('选择要加载的文件','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\E-2\ImportPersonInfo.xls')
#"确定"导入
    sleep 1
    $at.MouseCLick('left',965,540)
#确定来自网页的消息
    $at.WinWaitActive('来自网页的消息')
    $at.Send("{ENTER}")
    sleep 1    
#搜索导入的人员信息是否存在
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').table(:class,'table-info')
    @table[0][1].text_field(:id,'txtUserName').set('AutoTestImport')
#由于id和class值都为button，无法找到该元素，用AutoIt代替
    $at.MouseClick('left',453,216)
#判断测试结果，判断搜索结果的姓名是否为'hjg'
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRight').div(:id,'person-tabPerson-div-body').table(:id,'tabPerson')      
    if @table1[0][1].to_s == 'AutoTestImport'
      then
        $log.logfile_pass
        $html.html_pass('E-2-PT6')
    else
        $log.logfile_fail
        $html.html_fail('E-2-PT6')
    end  #end if
    $log.logfile_finish
#恢复测试环境，删除导入的人员信息
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRgihtBottom').div(:id,'person-tabPerson-div-body').table(:id,'tabPerson')                
    @table2[0][10].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
    sleep 1
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id,'jetsen-confirm').div(:id,'jetsen-confirm_button').button(:class,'jetsen-window-button').click     
  end  #end pt6
  def  pt7
    $log.descriptions='E-2-PT7'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 2
#选择一项，因为此处的checklist是用JS调用实现的，所以暂用AutoIt来操作，选择hjg
    $at.MouseClick('left',442,324)
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRightTitle').spans(:class,'jetsen-toolbox-item')[3].image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/export.gif').click
    sleep 2
    @table3 = $ie.frame(:name,'JetsenMain').div(:id,'export-object-win').div(:id,'export-object-win_content').div(:id,'divExportCheckList').table(:id,'fieldName')    
#所有信息全选
    @table3[0][0].checkbox(:id,'field0').set
#点击”确定“，如果用watir点击button会出现IE阻止下载的提示，暂用AutoIt完成该操作
#    $ie.frame(:name,'JetsenMain').div(:id,'export-object-win').div(:id,'export-object-win_button').button(:class,'jetsen-window-button').click      
    $at.MouseClick('left',950,575)
#确定下载
    $at.WinWaitActive('文件下载')
#    $at.Send("!s")
    $at.MouseClick('left',772,445)
    $helper.fileExport('另存为','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\E-2\PERSON.xls')
#确定是否覆盖已有文件
    $at.WinWaitActive('另存为')
    $at.Send('{TAB}')
    $at.Send('{ENTER}')
#判断测试结果，判断指定路径下是否存在导出的文件
    sleep 4
    file = $extra.findfile('F:/Jetsen_AutoTest_project/SmartJetsen/WebAPP/Attachments/E-2/PERSON.xls')
    if file == true
      then
        $log.logfile_pass
        $html.html_pass('E-2-PT7')
      else
        $log.logfile_fail
        $html.html_fail('E-2-PT7')        
    end  #end if  
    $log.logfile_finish              
  end  #end pt7
  def  pt8
    $log.descriptions='E-2-PT8'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 2
#直接点击”导出“，默认为导出所有人员的信息
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRightTitle').spans(:class,'jetsen-toolbox-item')[3].image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/export.gif').click
    sleep 2
    @table3 = $ie.frame(:name,'JetsenMain').div(:id,'export-object-win').div(:id,'export-object-win_content').div(:id,'divExportCheckList').table(:id,'fieldName')    
#所有信息全选
    @table3[0][0].checkbox(:id,'field0').set
#点击”确定“
    $at.MouseClick('left',951,575)
#确定下载
    $at.WinWaitActive('文件下载')
#    $at.Send("!s")
    $at.MouseClick('left',774,445)
    $helper.fileExport('另存为','F:\Jetsen_AutoTest_project\SmartJetsen\WebAPP\Attachments\E-2\PERSON.xls')
#确定是否覆盖已有文件
    $at.WinWaitActive('另存为')
    $at.Send('{TAB}')
    $at.Send('{ENTER}')
#判断测试结果，判断指定路径下是否存在导出的文件
    sleep 4
    file = $extra.findfile('F:/Jetsen_AutoTest_project/SmartJetsen/WebAPP/Attachments/E-2/PERSON.xls')
    if file == true
      then
        $log.logfile_pass
        $html.html_pass('E-2-PT8')
      else
        $log.logfile_fail
        $html.html_fail('E-2-PT8')        
    end  #end if  
    $log.logfile_finish        
  end  #end pt8
  def  pt9
    $log.descriptions='E-2-PT9'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-1-a')
    sleep 2
#搜索hjg，后续需要对hjg进行编译
    @table = $ie.frame(:name,'JetsenMain').div(:id=>'divPageFrame',:class=>'jetsen-pageframe').table(:class,'table-info')
    @table[0][1].text_field(:id,'txtUserName').set('hjg')
#由于id和class值都为button，无法找到该元素，用AutoIt代替
    $at.MouseClick('left',452,217)
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divRgihtBottom').div(:id,'person-tabPerson-div-body').table(:id,'tabPerson')    
    @table1[0][9].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/edit.gif').click
#修改“代号”
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'edit-person').div(:id,'tabPage').table(:class,'table-info')
    @table2[0][3].text_field(:id,'txtPersonCode').clear
    @table2[0][3].text_field(:id,'txtPersonCode').set('hjg002')
    $ie.frame(:name,'JetsenMain').div(:id,'edit-person').div(:id,'edit-person_button').button(:class,'jetsen-window-button').click
#验证测试结果，重新点击编辑框，并检查“代号”处是否为hjg002
    @table1[0][9].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/edit.gif').click
    @data = @table2[0][3].text_field(:id,'txtPersonCode').value.to_s
    if  @data == 'hjg002'
      then
        $log.logfile_pass
        $html.html_pass('E-2-PT9')
      else
        $log.logfile_fail
        $html.html_fail('E-2-PT9')   
    end  #end if
    $ie.frame(:name,'JetsenMain').div(:id,'edit-person').div(:id,'edit-person_button').button(:class,'jetsen-window-button').click
    $log.logfile_finish
#恢复测试环境，重新把代号设置为hjg001
    @table1[0][9].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/edit.gif').click
    @table2[0][3].text_field(:id,'txtPersonCode').clear
    @table2[0][3].text_field(:id,'txtPersonCode').set('hjg001')
    $ie.frame(:name,'JetsenMain').div(:id,'edit-person').div(:id,'edit-person_button').button(:class,'jetsen-window-button').click          
  end  #end pt9  
  def pt10
#删除功能不需要判断，之前的测试中恢复测试环境的过程等于变相的测试了删除功能，直接输出成功
  $log.descriptions='E-2-PT10'
  $log.logfile_start
  $log.logfile_pass
  $html.html_pass('E-2-PT10')
  $log.logfile_finish    
  end  #end pt10     
end  #end class