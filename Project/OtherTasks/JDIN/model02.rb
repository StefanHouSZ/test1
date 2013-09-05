####################收录转码模板#####################




#encoding: utf-8
require 'watir'
require 'win32ole'

require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\MainExtra.rb'
$extra = MainExtra.new

#调用关闭所有IE窗口的方法
$extra.close_all_IE(1,5)#此处以最多已经打开了5个IE为例

def creatmodel02
#定义变量
@ie = Watir::IE.new
@ie.maximize
@at = WIN32OLE.new('AutoItX3.Control')  
#打开excel，并对其中的sheet进行访问
excel = WIN32OLE::new('excel.Application')
#是否可视excel应用
excel.visible = false
#----------------------此处需要修改-----------------------#
workbook = excel.Workbooks.Open('F:\Jetsen_AutoTest_project\SmartJetsen\Project\OtherTasks\JDIN\model02.xlsx')
worksheet = workbook.Worksheets(1) #定位到第一个sheet
worksheet.Select
#读取“模板名称”
@name1 = worksheet.Range('A3:A10').value
#读取“模板类型”
@mode1 = worksheet.Range('F3:F10').value
excel.Quit()
$extra.closeEXCEL
#关闭Excel

@ie.goto('http://192.168.9.21:8080/jdin2/juum/jnetsystemweb/login.htm')
@ie.text_field(:id,'txtUserName').clear
@ie.text_field(:id,'txtUserName').set('admin')
@ie.text_field(:id, 'txtPassword').set('1')
@ie.link(:class,'login-button').click
@ie.wait  
if
 @ie.div(:xpath,"//img[@src='http://192.168.9.21:8080/jdin2/juum/jnetsystemweb/images/icons/din.gif']/").exist?()
 @ie.div(:xpath,"//img[@src='http://192.168.9.21:8080/jdin2/juum/jnetsystemweb/images/icons/din.gif']/").click
else
 @ie.div(:xpath,"//img[@src='images/icons/din.gif']/").exist?()
 @ie.div(:xpath,"//img[@src='images/icons/din.gif']/").click
end
 @ie.div(:xpath,"//img[@src='images/tree-close.gif']/").click
 @ie.link(:id,"tree30000000-0-3-a").click
 sleep 2
 
 num = 0
 while num < 7
 @at.WinWait('JetsenNet网络系统 - Windows Internet Explorer') 
 @at.MouseClick('left',1369,219)
 sleep 2
#采用正则表达式来替换掉原来to_s后的多余符号 " " []  
 @text1 = @name1[num].to_s
 @raplace1 = @text1.gsub(/"/,'')
 @raplace2 = @raplace1.gsub(/\[/,'')
 @newtext1 = @raplace2.gsub(/\]/,'')  
 puts '模板名：' + @newtext1
 @text2 = @mode1[num].to_s
 @raplace3 = @text2.gsub(/"/,'')
 @raplace4 = @raplace3.gsub(/\[/,'')
 @newtext2 = @raplace4.gsub(/\]/,'')
 puts '格式：' + @newtext2  
 @at.MouseClick('left',651,437)
 @at.Send(@newtext1)  #填写“模板名称”
 @at.MouseClick('left',739,462)
 @at.MouseClick('left',679,500) #选择收录转码模板
 @at.MouseClick('left',655,489)
 @at.Send(@newtext2)  #填写“拓展名”
 @at.MouseClick('left',1010,577)
 num+=1
 end 
end
creatmodel02

