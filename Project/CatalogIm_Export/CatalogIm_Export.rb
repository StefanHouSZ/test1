######Jetsen自动化测试自定义类，version 1.0.1######
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
#require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/DebugLog.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/HtmlReport.rb'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/email.rb'

#实例化所有Class
$extra = MainExtra.new
$helper = Helper.new
$screen = ScreenCapture.new
$record = ScreenRecord.new
$log = Log.new
$html = HtmlReport.new
$email = SendEmail.new

class AutoTest
#此方法定义测试初期的所有准备活动，开启录屏监视功能，初始化HTML测试报告等  
  def prepare  
#新建HTML报告creatHtmlReport(reportname,projectname,coder,tester)，参数说明：reportname为报告名，projectname为测试项目描述
#coder为自动化脚本编写责任人，tester为自动化测试执行人
#------------------------------------- 此处需要修改-------------------------------------#
  $html.createHtmlReport('用户定制编目导入导出.html','媒资46系统编目导入导出相关第一轮测试','侯俊光','侯俊光')
  $screen.screencapture_run
#读取A-15.config文件判断是否需要使用录屏
  $data = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/RunningTest/USERS/A-15.config") 
#判断是否需要录屏
  if $data == 'yes'
    then
#若之前已经开了Recorder，先关闭
 $extra.closeRecorder     
#运行CamRecorder软件
  $record.screenrecord_run
#开始录制视频  
  $record.screenrecord_start    
  end  #end if
  end  #end def prepare
#此方法定义测试结束后的所有收尾活动，包括从Excel中读取相应的配置，判断是否开启录屏监视功能，完成HTML测试报告等 
def finish
#完成HtmlReport的报告页面
#---------------------------------- 此处需要修改--------------------------------------#
#html_finish(reportname)，完成HTML页面，参数reportname为报告名，注意与createHtmlReport中的参数reportname保持一致
   $html.html_finish('用户定制编目导入导出.html')
#保存视频录制
   if $data == 'yes'
     then
#screenrecord_stop的参数说明，参数为保存AVI视频的文件名
   $record.screenrecord_stop('A-15')      
   end  #end if
#发送邮件给相关测试执行人,sendmail(to1,subject,text,file)参数说明：to1为收件人邮箱，subject为邮件主题，test为邮件内容，file为附件地址
#注：1.9.x以上版本的SMTP发送邮件时，内容为UTF-8是一个BUG，ruby方面还没有解决，现只能发送英文邮件，特此声明
   $email.sendmail('houjunguang@jetsen.cn','SmartJetsen测试执行反馈','Dear Tester:The testsuite A-15 has already finished,please check the feedback on SmartJestsen webpage.The mail is sent by:Jetsen AutoTest TEAM---We make Testing more smart!')   
end  #end def finish
  def pt1
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT1'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------# 
#登录系统   
    $helper.loginsys('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm','hjg','1')
#定位到测试页面
    $helper.gotopageclass1('tree10000000-14-a')        
#通过判断页面是否有ID为spanWindowName的DIV存在来判断是否进入到了编目导入导出页面    
    if $ie.div(:id,'spanWindowName').exists? 
    then
#输出日志：测试成功  
    $log.logfile_pass
#html_pass(casenum)，输出测试通过的HTML信息，参数casenum为测试用例编号    
    $html.html_pass('A-15-PT1')
    else
    $log.logfile_fail
    $html.html_fail('A-15-PT1')
    end
#输出日志：测试结束 
    $log.logfile_finish
  end #end pt1
  def pt2
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT2'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
#登录系统   
    $helper.loginsys('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm','hjg','1')
#定位到测试页面
    $helper.gotopageclass1('tree10000000-14-a')
#定位到FRAME下的一个table里    
    @t1=$ie.frame(:name,'JetsenMain').table(:class,'table-info')
#获取该选择下拉框的已选值    
    @sl = @t1[1][3].select_list(:id,'ddlMediaType').getSelectedItems
    puts "节目类型默认选择：" 
    puts @sl    
#日志输出：需要人工再次确认一下
    $log.logfile_manual
#截图，函数ScreenGot(picname)，参数picname为图片保存的名称
    $screen.ScreenGot('A-15-PT2')    
    $html.html_manual('A-15-PT2')
    $log.logfile_finish   
  end #end pt2
  def pt3
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT3'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
#定位到FRAME下的一个table里    
    @t2 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')

    if @t2[1][3].exists?
      then 
      @t2[1][3].flash
      $log.logfile_pass
      $html.html_pass('A-15-PT3')
    else 
      $log.logfile_fail
      $html.html_fail('A-15-PT3') 
    end
      $log.logfile_finish
            
  end #end pt3
  def pt4
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT4'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait    
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
    if @t4.exist?()
      then
      $log.logfile_pass
      $html.html_pass('A-15-PT4')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT4')
    end
    $log.logfile_finish    
  end #end pt4
  def pt5
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT5'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')  
#节目类型选择为“音频”
    @t3[2][4].flash
#此种方式的函数不可用，估计是Watir版本问题，暂用AUTOIT代替实现    
#@t3[2][4].select_list(:id,'ddlMediaType').select_value('音频')
    $at.MouseClick('left',694,251)
    sleep 2 
    $at.Send('{DOWN}')   
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
if  @t4.exist?()
      then
      $log.logfile_pass
      $html.html_pass('A-15-PT5')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT5')    
    end
    $log.logfile_finish              
  end #end pt5
  def pt6
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT6'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')  
#节目类型选择为“图片”
    @t3[2][4].flash
    $at.MouseClick('left',694,251)
    sleep 2 
    $at.Send('{DOWN}')
    $at.Send('{DOWN}')   
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
if  @t4.exist?()
      then
      $log.logfile_pass
      $html.html_pass('A-15-PT6')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT6')     
    end
    $log.logfile_finish    
  end #end pt6
  def pt7
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT7'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')  
#节目类型选择为“文稿”
    @t3[2][4].flash
    $at.MouseClick('left',694,251)
    sleep 2 
    $at.Send('{DOWN}')
    $at.Send('{DOWN}')
    $at.Send('{DOWN}')   
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
if  @t4.exist?()
      then
      $log.logfile_pass
      $html.html_pass('A-15-PT7')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT7')     
    end
    $log.logfile_finish       
  end #end pt7
  def pt8
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT8'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait    
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”HJG_AUTOTEST_001“    
    $at.MouseClick('left',414,213)
    $at.Send('HJG_AUTOTEST_001')
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
    @t4[1][2].flash
#读取第2列的值，即为节目名称，判断此值来断定测试是否成功    
    @programname = @t4.column_values(2)
#为方便判断，先将@programname转换为字符串    
    @a = @programname.to_s
#正则表达式示例，输出为2，说明从第二个字符开始，与正则表达式中的字符串匹配
#   puts @a =~ /HJG_AUTOTEST_001/
    if @a == '["HJG_AUTOTEST_001 [323]"]'
      then 
      $log.logfile_pass
      $html.html_pass('A-15-PT8')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT8')
    end
    $log.logfile_finish    
  end #end pt8
  def pt9
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT9'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”HJG_AUTOTEST_AUDIO_001“    
    $at.MouseClick('left',414,213)
    $at.Send('HJG_AUTOTEST_AUDIO_001') 
#节目类型选择为“音频”
    @t3[2][4].flash
#此种方式的函数不可用，估计是Watir版本问题，暂用AUTOIT代替实现    
#@t3[2][4].select_list(:id,'ddlMediaType').select_value('音频')
    $at.MouseClick('left',694,251)
    sleep 2 
    $at.Send('{DOWN}')   
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
    @t4[1][2].flash
#读取第2列的值，即为节目名称，判断此值来断定测试是否成功    
    @programname = @t4.column_values(2)
#为方便判断，先将@programname转换为字符串    
    @a = @programname.to_s
    if @a == '["HJG_AUTOTEST_AUDIO_001 [27]"]'
      then 
      $log.logfile_pass
      $html.html_pass('A-15-PT9')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT9')
    end
    $log.logfile_finish  
  end #end pt9
  def pt10
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT10'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”HJG_AUTOTEST_IMAGE_001“    
    $at.MouseClick('left',414,213)
    $at.Send('HJG_AUTOTEST_IMAGE_001') 
#节目类型选择为“音频”
    @t3[2][4].flash
    $at.MouseClick('left',694,251)
    sleep 2 
    $at.Send('{DOWN}')
    $at.Send('{DOWN}')   
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
    @t4[1][2].flash
#读取第2列的值，即为节目名称，判断此值来断定测试是否成功    
    @programname = @t4.column_values(2)
#为方便判断，先将@programname转换为字符串    
    @a = @programname.to_s
    if @a == '["HJG_AUTOTEST_IMAGE_001 [341]"]'
      then 
      $log.logfile_pass
      $html.html_pass('A-15-PT10')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT10')
    end
    $log.logfile_finish    
  end #end pt10
  def pt11
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT11'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”HJG_AUTOTEST_DOCUMENT_001“    
    $at.MouseClick('left',414,213)
    $at.Send('HJG_AUTOTEST_DOCUMENT_001') 
#节目类型选择为“音频”
    @t3[2][4].flash
    $at.MouseClick('left',694,251)
    sleep 2 
    $at.Send('{DOWN}')
    $at.Send('{DOWN}')
    $at.Send('{DOWN}')    
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
    @t4[1][2].flash
#读取第2列的值，即为节目名称，判断此值来断定测试是否成功    
    @programname = @t4.column_values(2)
#为方便判断，先将@programname转换为字符串    
    @a = @programname.to_s
    if @a == '["HJG_AUTOTEST_DOCUMENT_001 [62]"]'
      then 
      $log.logfile_pass
      $html.html_pass('A-15-PT11')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT11')
    end
    $log.logfile_finish
  end #end pt11
  def pt12
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT12'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”#“    
    $at.MouseClick('left',414,213)
    $at.Send('{#}')    
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
#统计ID为 tabQueryResult的行数来判断测试结果并将返回值转换为string   
    @t = @t4.row_count
    @row = @t.to_s       
if  @row == '0'
      then
      $log.logfile_pass
      $html.html_pass('A-15-PT12')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT12')     
    end
    $log.logfile_finish           
  end #end pt12 
  def pt13
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT13'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”!@#$%^&*“等特殊字符    
    $at.MouseClick('left',414,213)
    $at.Send('{!}{@}{#}{$}{%}{^}{&}{*}')    
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
#统计ID为 tabQueryResult的行数来判断测试结果并将返回值转换为string   
    @t = @t4.row_count
    @row = @t.to_s       
if  @row == '0'
      then
      $log.logfile_pass
      $html.html_pass('A-15-PT13')
    else
      $log.logfile_fail
      $html.html_fail('A-15-PT13')    
    end
    $log.logfile_finish    
  end #end pt13
  def pt14
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT14'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”%@“等特殊字符    
    $at.MouseClick('left',414,213)
    $at.Send('{%}{@}')
#鼠标右键操作
    $at.MouseClick('right',464,214)
    $at.Send('{UP}')
    $at.Send('{ENTER}')
    sleep 4
    $at.Send('{BS}')        
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
#统计ID为 tabQueryResult的行数来判断测试结果并将返回值转换为string   
    @t = @t4.row_count
    @row = @t.to_s      
if  @row == '0'
      then
      $log.logfile_fail
      $html.html_fail('A-15-PT14')
    else
      $log.logfile_pass
      $html.html_pass('A-15-PT14')     
    end
    $log.logfile_finish   
  end #end pt14
  def pt15
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT15'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”123456789asdfghjkl“
    $at.MouseClick('left',414,213)
    $at.Send('123456789asdfghjkl')
#快捷键ctrl+a全选输入框
    $at.MouseClick('left',414,213)
    $at.Send('^a')
    sleep 4
    $at.Send('{BS}')        
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#判断测试结果
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
#统计ID为 tabQueryResult的行数来判断测试结果并将返回值转换为string   
    @t = @t4.row_count
    @row = @t.to_s      
if  @row == '0'
      then
      $log.logfile_fail
      $html.html_fail('A-15-PT15')
    else
      $log.logfile_pass
      $html.html_pass('A-15-PT15')     
    end
    $log.logfile_finish    
  end #end pt15
  def pt16
#---------------------------------- 此处需要修改--------------------------------------#
#description写测试项编号   
    $log.descriptions='A-15-PT16'      
#输出日志：测试开始
    $log.logfile_start
#----------------------------------- 此处需要修改-------------------------------------#    
    $ie.goto('http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm')
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set('hjg')
    $ie.text_field(:id, 'txtPassword').set('1')
    $ie.link(:class,'login-button').click
    $ie.wait  
#用AUTOIT代替XPATH定位元素     
    $at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    $at.MouseClick('left',97,254)
    sleep 2
    $at.MouseClick('left',97,254)
    sleep 2   
    $ie.link(:id,"tree10000000-14-a").click
    $ie.wait
    @t3 = $ie.frame(:name,'JetsenMain').table(:class,'table-info')
    @t3[1][2].flash   
#设置节目名称中的过滤条件包含”HJG_AUTOTEST_001“
    $at.MouseClick('left',414,213)
    $at.Send('HJG_AUTOTEST_001')       
#点击”查找“按钮
    @t3[2][5].flash  
    $at.MouseClick('left',795,250)
    sleep 2 
#选择一个节目进行导出操作
    @t4 = $ie.frame(:name,'JetsenMain').table(:id,'tabQueryResult')
    @t4[1][1].checkbox(:name,'chk_Program').set
#点击”导出“按钮    
    $at.MouseClick('left',251,773)
    sleep 4
#选择导出的目标目录
    $at.MouseClick('left',910,489) 
    $at.MouseClick('left',591,426)
    sleep 2
    $at.MouseClick('left',797,366)
    $at.Send('Jetsen_AutoTest_project')
    $at.Send('{RIGHT}')
    $at.Send('SmartJetsen')
    $at.Send('{RIGHT}')
    $at.Send('Attachments')
    $at.Send('{RIGHT}')
    $at.Send('catalog')
    $at.Send('{ENTER}')
    sleep 2
    $at.MouseClick('left',925,541)
#判断catalog下是否有编目文件导出了    
#读取制定目录下的文件名在此不能用，不知道原因，用其他方式判断   
#   puts "查找附件目录下是否有导出的xml文件"
#   $extra.findfile('F:/Jetsen_AutoTest_project/SmartJetsen/Attachments/catalog')


#测试结果判断，通过读取页面的状态是否为”成功“来判断   
   @t4[1][5].flash
   status = @t4.column_values(5)
   @status = status.to_s  
   if @status == '["\u6210\u529F"]'
     then
     $log.logfile_pass
     $html.html_pass('A-15-PT16') 
   else
     $log.logfile_fail
     $html.html_fail('A-15-PT16')    
   end   
   $log.logfile_finish      
end #end pt16
  def pt17
#description写测试项编号   
    $log.descriptions='A-15-PT17'      
#输出日志：测试开始
    $log.logfile_start 
#通过读取导出的编目xml信息来判断信息的准确性
   doc = REXML::Document.new(File.open("F:\\Jetsen_AutoTest_project\\SmartJetsen\\Attachments\\catalog\\323(HJG_AUTOTEST_001).xml"))
#读取素材编号
   content1 = doc.root.elements[1][0]
   @c1 = content1.text
#   puts @c1
#读取素材名
   content2 = doc.root.elements[1][4]
   @c2 = content2.text
#   puts @c2
#读取素材创建者所在机器的IP地址
   content3 = doc.root.elements[1][13]
   @c3 = content3.text
#   puts @c3
#读取素材创建人 
   content4 = doc.root.elements[1][14]
   @c4 = content4.text
#   puts @c4
   if @c1 == '323'
     puts 'XML Element1 OK!value = 323'
   end  
   if @c2 == 'HJG_AUTOTEST_001'
     puts 'XML Element2 OK!value = HJG_AUTOTEST_001'
   end  
   if @c3 == '192.168.8.132'
     puts 'XML Element3 OK!value = 192.168.8.132'
   end  
   if @c4 == '侯俊光'        
     then
     $log.logfile_pass
     $html.html_pass('A-15-PT17')
   else
     $log.logfile_fail
     $html.html_fail('A-15-PT17')
   end
   $log.logfile_finish
   $ie.close     
  end #end pt17
end  #end of AutoTest class

test = AutoTest.new
test.prepare
test.pt2
test.finish
=begin
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
test.pt13
test.pt14
test.pt15
test.pt16
test.pt17
=end
