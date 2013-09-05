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
inputlocal = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/Configuration/E-4-Config.xml")
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
inputweb = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/E-4-Config.xml")
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
    $log.descriptions='E-4-PT1'      
#输出日志：测试开始
    $log.logfile_start 
#登录系统   
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
#定位到测试页面
    $helper.gotopageclass4('tree50000000-3-a')
    sleep 1       
#判断该页的标题栏是否存在来验证测试结果
    if $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'divListTitle').div(:class,'list-title-left').exists?
      then 
      $log.logfile_pass()
      $html.html_pass('E-4-PT1')
    else
      $log.logfile_fail
      $html.html_fail('E-4-PT1')
    end  #end if
#输出日志：测试结束 
    $log.logfile_finish
  end #end pt1
  def pt2
    $log.descriptions='E-4-PT2'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-3-a')
    sleep 1     
#点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:class,'list-title-right').span(:class,'jetsen-toolbox-item').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    @table = $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_content').div(:id,'tabPage').table.table(:id,'Table3')
    @table[0][1].text_field(:id,'txtRoleName').set('AutoTest')
    $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_button').button(:class,'jetsen-window-button').click
#判断新建角色名是否为“AutoTest”来完成测试判断
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'userrole-tabUserRole-div-body').table(:id,'tabUserRole')
    @data = @table1[0][1].to_s
    if @data == 'AutoTest'
      then 
      $log.logfile_pass()
      $html.html_pass('E-4-PT2')
    else
      $log.logfile_fail
      $html.html_fail('E-4-PT2')
    end  #end if
     $log.logfile_finish
#恢复测试环境
    @table1[0][4].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
    $at.MouseClick('left',930,565)     
  end # end pt2
  def pt3
    $log.descriptions='E-4-PT3'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-3-a')
    sleep 1
#点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:class,'list-title-right').span(:class,'jetsen-toolbox-item').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    @table = $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_content').div(:id,'tabPage').table.table(:id,'Table3')
    @table[0][1].text_field(:id,'txtRoleName').set('AutoTest')
    $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_button').button(:class,'jetsen-window-button').click    
#转向“用户管理”链接
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 1
#搜索出用户姓名为“侯俊光”的用户    
    $ie.frame(:name,'JetsenMain').text_field(:id,'txtSearchKey').value="侯俊光"
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table1[0][2].button(:class,'button').click
#点击“编辑”
    $at.MouseClick('left',1325,298)
    sleep 1
#点击到“隶属角色”   
    $at.MouseClick('left',848,377)
    sleep 1
    @table = $ie.frame(:name,'JetsenMain').div(:id,'edit-user').div(:id,'tabPage').table(:id,'Table3')
    @table[2][0].button(:id,'selRole').click
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'select-userrole').div(:id,'divSelectUserRoleList').table(:id,'tabSelectUserRole')         
    @data = @table1[0][1].to_s
#判断角色列表中是否有名为AutoTest的角色来判断测试结果
    if  @data == 'AutoTest'
      then 
        $log.logfile_pass
        $html.html_pass('E-4-PT3')
      else
        $log.logfile_fail
        $log.html_fail('E-4-PT3')  
    end  #end if
    $log.logfile_finish
#恢复测试环境，删除新建的角色AutoTest
#先关闭当前的窗口
    $at.Send("{ESC 2}")
#转向“角色管理”
    $helper.gotopageclass4('tree50000000-3-a')
    sleep 1
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:id,'userrole-tabUserRole-div-body').table(:id,'tabUserRole')
    @table2[0][4].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/drop.gif').click
    $at.MouseClick('left',919,564)          
  end  #end pt3
  def pt4
    $log.descriptions='E-4-PT4'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-3-a')
    sleep 1
#点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:class,'list-title-right').span(:class,'jetsen-toolbox-item').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    @table = $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_content').div(:id,'tabPage').table.table(:id,'Table3')
    @table[0][1].text_field(:id,'txtRoleName').set('AutoTest')
#点击“添加”
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'edit-role_content').div(:id,'tabPage').table
    @table1[3][0].button(:id,'btnAdd').click
#设置登录名，搜索结果准备添加
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'select-user').div(:id,'divSelectUser').table(:class,'tablepanel')
    @table2[0][0].text_field(:id,'txtLoginName').set('hjg')
    @table2[0][1].button(:class,'button').click      
#选择“用户”
    @table3 = $ie.frame(:name,'JetsenMain').div(:id,'select-user').div(:id,'divSelectUserList').table(:id,'tabSelectUser')   
    @table3[0][0].checkbox(:name,'chk_SelectUser').set    
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id=>'select-user_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click
#判断成员列表中是否新加了刚才选择的成员，成员名为“侯俊光”
    @table4 = $ie.frame(:name,'JetsenMain').div(:id,'edit-role_content').div(:id,'tabPage').table
    @data = @table4[2][0].select_list.option(:value,'78').value
    if  @data == '78'
      then
        $log.logfile_pass
        $html.html_pass('E-4-PT4')
      else
        $log.logfile_fail
        $html.html_fail('E-4-PT4')  
    end  #end if
    $log.logfile_finish
#恢复测试环境
    $at.MouseClick('left',985,714)          
  end  #end pt4
  def  pt5
    $log.descriptions='E-4-PT5'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-3-a')
    sleep 1
#点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:class,'list-title-right').span(:class,'jetsen-toolbox-item').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    @table = $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_content').div(:id,'tabPage').table.table(:id,'Table3')
    @table[0][1].text_field(:id,'txtRoleName').set('AutoTest')
#点击“添加”
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'edit-role_content').div(:id,'tabPage').table
    @table1[3][0].button(:id,'btnAdd').click
#设置登录名，搜索结果准备添加
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'select-user').div(:id,'divSelectUser').table(:class,'tablepanel')
    @table2[0][0].text_field(:id,'txtLoginName').set('hjg')
    @table2[0][1].button(:class,'button').click      
#选择“用户”
    @table3 = $ie.frame(:name,'JetsenMain').div(:id,'select-user').div(:id,'divSelectUserList').table(:id,'tabSelectUser')   
    @table3[0][0].checkbox(:name,'chk_SelectUser').set    
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id=>'select-user_button',:class=>'jetsen-window-bottom').button(:class,'jetsen-window-button').click
#选中新添加的成员
    @table4 = $ie.frame(:name,'JetsenMain').div(:id,'edit-role_content').div(:id,'tabPage').table
    @table4[2][0].select_list.option(:value,'78').select
#点击“删除”，
    @table1[3][0].button(:id,'btnDel').click
#判断成员列表的LIST是否还存在来判断测试结果
    @data = @table4[2][0].select_list.getAllContents.to_s
#判断测试结果，因为被删除了新加成员，因此返回值应该是一个空的数组       
    if  @data == '[]'
      then 
        $log.logfile_pass
        $html.html_pass('E-4-PT5')
      else
        $log.logfile_fail
        $html.html_fail('E-4-PT5')  
    end  #end if
    $log.logfile_finish
#恢复测试环境
    $at.MouseClick('left',985,682)      
  end  #end pt5
  def  pt6
    $log.descriptions='E-4-PT6'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
    $helper.gotopageclass4('tree50000000-3-a')
    sleep 1
#点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:class,'list-title-right').span(:class,'jetsen-toolbox-item').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    @table = $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_content').div(:id,'tabPage').table.table(:id,'Table3')
    @table[0][1].text_field(:id,'txtRoleName').set('AutoTest')
#转向“所属权限”页面
    $at.MouseClick('left',800,327)
#选择一个权限，这里以“媒体内容管理”为例
    $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'divRole').div(:id,'role-tree-0').checkbox(:id,'role-tree-0-chk').set
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_button').button(:class,'jetsen-window-button').click
#点击“编辑”，重新查看“所属权限”页面下的“媒体内容管理”是否是选中状态
    @table = $ie.frame(:name,'JetsenMain').div(:id,'divContent').div(:id,'userrole-tabUserRole-div-body').table(:id,'tabUserRole')                
#    @table[0][3].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/edit.gif').click
    $at.MouseClick('left',1310,268)   #编辑图片点不了，暂用AT代替
    $at.MouseClick('left',800,327)
#因为此处有些问题，每次新建的“角色”在前端的显示顺序不一样，前端开发没有做处理，因此这里暂用手工确认
    $log.logfile_manual
    $html.html_manual('E-4-PT6')
#截图，高亮突出显示区域，方便人工判断    
    $screen.ScreenGot('E-4-PT6',x1=752,y1=443,x2=813,y2=466)
    $log.logfile_finish
#测试环境恢复
    $at.MouseClick('left',990,685)  #点击“取消”
    $at.MouseClick('left',1363,268) #点击“删除”
    $ie.frame(:name,'JetsenMain').div(:id,'jetsen-confirm').div(:id,'jetsen-confirm_button').button(:class,'jetsen-window-button').click        
  end  #end pt6
  def  pt7
    $log.descriptions='E-4-PT7'
    $log.logfile_start 
    $helper.loginsys($TestedURL,$UserName,$PassWord)
    sleep 1
#新建一个名为"AutoTest"的用户名
    $helper.gotopageclass4('tree50000000-0-a')
    #点击“新建”，由于没办法定位到这个span，暂用autoit来代替
    #$ie.frame(:name,'JetsenMain').div(:class,'list-title-right').spans(:class,'jetsen-toolbox-item')[1].click
    $at.MouseClick('left',1250,249)
    sleep 3
    @table = $ie.frame(:name,'JetsenMain').div(:class=>'jetsen-window',:id=>'new-user').
    div(:class=>'jetsen-window-content',:id=>'new-user_content').div(:id,'tabPage').table(:class,'table-info')
    @table[0][1].text_field(:id,'txtLoginName').set("autotest")
    @table[0][3].text_field(:id,'txtUserName').value="自动化测试"
    @table[2][1].text_field(:id,'txtPassword').set("1")
    @table[2][3].text_field(:id,'txtConfirmPassword').set("1")
    sleep 2
    $at.MouseClick('left',843,379)
    sleep 1
    $at.MouseClick('left',582,580)
    sleep 1
    $at.MouseClick('left',585,375)
#点击“确定”
    $at.MouseClick('left',990,657)
#再次“确定”
    sleep 1
    $at.MouseClick('left',1005,635)
#转到“角色管理”页面        
    $helper.gotopageclass4('tree50000000-3-a')
    sleep 1
#点击“新建”
    $ie.frame(:name,'JetsenMain').div(:id,'divPageFrame').div(:class,'list-title-right').span(:class,'jetsen-toolbox-item').image(:src,'http://192.168.8.27:8081/js46/jetsenclient/themes/icon/new.gif').click
    @table1 = $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_content').div(:id,'tabPage').table.table(:id,'Table3')
    @table1[0][1].text_field(:id,'txtRoleName').set('AutoTest')
#转向“所属权限”页面
    $at.MouseClick('left',798,328)
#选择一个权限，这里以“媒体内容管理”为例
    $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'divRole').div(:id,'role-tree-0').checkbox(:id,'role-tree-0-chk').set
#点击“确定”
    $ie.frame(:name,'JetsenMain').div(:id,'edit-role').div(:id,'edit-role_button').button(:class,'jetsen-window-button').click
#转向“用户管理”
    $helper.gotopageclass4('tree50000000-0-a')
#修改登录名为"hjg"的角色，删除“系统管理员”，添加“AutoTest”的角色
    @table2 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table2[0][1].text_field(:id,'txtSearchKey').value="自动化测试"
    @table2[0][2].button(:class,'button').click  #点击“查找”
    @table3 = $ie.frame(:name,'JetsenMain').div(:id,'divContent').div(:id,'divRgihtBottom').div(:id,'userlist-div-body').table(:id,'tabUser')            
    @table3[0][5].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/edit.gif').click  #点击“编辑”
    $at.MouseClick('left',845,378)  #转向“隶属角色”
    $at.MouseClick('left',704,430)
    $at.MouseClick('left',642,586)  #删除“系统管理员”的角色
    $at.MouseClick('left',584,586)
    $at.MouseClick('left',585,378)
    $at.MouseClick('left',979,659)
    $ie.frame(:name,'JetsenMain').div(:id,'edit-user').div(:id,'edit-user_button').button(:class,'jetsen-window-button').click  #点击“确定”
#重新登录系统，检查是否只有访问“媒体内容管理”的权限，以检查“磁带管理系统”为例
    $helper.loginsys($TestedURL,'autotest','1')
    @data = $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/tsm.gif']/").exist?.to_s
    if @data == 'false'
      then
        $log.logfile_pass
        $html.html_pass('E-4-PT7')
      else
        $log.logfile_fail
        $html.html_fail('E-4-PT7')  
    end  #end if
    $log.logfile_finish
#恢复测试环境
    $helper.loginsys($TestedURL,'admin','1')
    sleep 1
    $helper.gotopageclass4('tree50000000-3-a') #转向“角色管理” 
    sleep 1
#删除"AutoTest"角色
    $at.MouseClick('left',1362,267)
    $at.MouseClick('left',921,563)
    $helper.gotopageclass4('tree50000000-0-a')  #转向“用户管理”    
    @table4 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table4[0][1].text_field(:id,'txtSearchKey').value="自动化测试"
    @table4[0][2].button(:class,'button').click  #点击“查找”
    @table5 = $ie.frame(:name,'JetsenMain').div(:id,'divContent').div(:id,'divRgihtBottom').div(:id,'userlist-div-body').table(:id,'tabUser')            
    @table5[0][5].image(:src,'http://192.168.8.27:8081/js46/juum/juumsystemweb/images/edit.gif').click  #点击“编辑”
    $at.MouseClick('left',845,378)  #转向“隶属角色”
    $at.MouseClick('left',583,587)  #点击“添加”
    $at.MouseClick('left',585,378)
    $at.MouseClick('left',981,658)
    $ie.frame(:name,'JetsenMain').div(:id,'edit-user').div(:id,'edit-user_button').button(:class,'jetsen-window-button').click  #点击“确定”       
#删除“AutoTest”用户
    $helper.gotopageclass4('tree50000000-0-a')
    sleep 2
    @table6 = $ie.frame(:name,'JetsenMain').div(:id,'divTop').table(:class,'table-info')
    @table6[0][1].text_field(:id,'txtSearchKey').value="自动化测试"
    @table6[0][2].button(:class,'button').click
    $at.MouseClick('left',1372,298)
#确定删除    
    $at.MouseClick('left',919,564)  
  end  #end pt7    
end  #end class