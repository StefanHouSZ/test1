#encoding: utf-8
require 'win32ole'
require 'pathname'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\email.rb'


#关闭EXCEL的进程
def closeEXCEL
 mgmt = WIN32OLE.connect('winmgmts:\\\\.') 
 processes=mgmt.instancesof("win32_process")
 processes.each do |process|
   #puts process
   if process.name =="EXCEL.EXE"
     then process.terminate()
   end
 end
end

#打开excel，并对其中的sheet进行访问
excel = WIN32OLE::new('excel.Application')
#是否可视excel应用
excel.visible = false
#----------------------此处需要修改-----------------------#
workbook = excel.Workbooks.Open('F:\Jetsen_AutoTest_project\SmartJetsen\TestSuits\ExcelTestCase\SearchSys\Config.xlsx')
worksheet = workbook.Worksheets(1) #定位到第一个sheet
worksheet.Select

@data1 = worksheet.Range('C2').value #读取c2单元格的数据，查看设置的测试用例名称
@data2 = worksheet.Range('H2').value #读取h2单元格的数据，查看是否需要给责任人发送邮件
@data3 = worksheet.Range('C4').value #读取c4单元格的数据，获取自动化测试执行rb文件的头部文件信息
@data4 = worksheet.Range('C5').value #读取c5单元格的数据，获取自动化测试执行rb文件的require代码信息
@data5 = worksheet.Range('L1').value #读取l1单元格的数据，获取自动化测试执行rb文件的核心代码信息
@data6 = worksheet.Range('H2').value #读取h2单元格的数据，查看是否需要发送通知邮件给测试责任人

excel.Quit()
closeEXCEL
puts @data1
=begin
project = @data1



#检查并确认测试工程名
($*[0].nil?)?(project = project):(project = $*[0])
if project=~/^[a-zA-Z]/
  project = project.capitalize
else
  puts "测试工程名输入有误！"
  exit
end


#基本变量的定义
#filePath = Pathname.new(File.dirname(__FILE__)).realpath
filePath = Pathname.new(File.join(File.dirname(__FILE__),"../../../TestSuits/AutoTestCase")).realpath
templatePath = Pathname.new(File.join(File.dirname(__FILE__),"../../../template/")).realpath

#生成测试工程的文件夹
if not FileTest::exist?(File.join(filePath , "/#{project}"))
  Dir.mkdir(File.join(filePath , "/#{project}"))
else
  puts "存放#{project}.rb的文件夹已存在！"
  exit
end

#定义testcase的rb文件的格式
def getRbStr(project)
  return tempRbStr = @data3 + "\n" + @data4 + "\n" + @data5 + "\n"
end

#生成testcase的rb文件
if not File::exists?(File.join(templatePath,"temp.rb")) 
  tempRbStr = getRbStr("Temp")
  File.open(File.join(templatePath,"temp.rb"),"w"){|f| f.puts(tempRbStr)}
end
File.copy_stream File.join(templatePath,"temp.rb"), File.join(filePath , "/#{project}","/#{project}.rb")
File.open(File.join(filePath , "/#{project}","/#{project}.rb"),"r") do |lines|
  buffer = lines.read.gsub(/Temp/i,project)
  File.open(File.join(filePath , "/#{project}","/#{project}.rb"),"w"){|all| all.write(buffer)}
end

puts "自动化测试用例脚本：#{project}已生成！template文件夹下备份文件也已建立!"

#判断是否需要发送邮件通知给责任人
mail = SendEmail.new
if @data6 == 'yes'
then
mail.sendmail("houjunguang@jetsen.cn","SmartJetsen跟踪信息反馈","亲：\n这是SmartJetsen发给您的邮件，简单的劳烦您配置了一下，SmartJetsen已经帮您新建了一个您命名的自动化测试名的文件夹在\\TestSuits\\AutoTestCase下，请浏览此文件夹，您将会看到我们帮您自动生成的.rb文件，附件为自动生成的rb文件的备份。\nFrom:Jetsen AutoTest TEAM-------We make Testing more smart!","F:\\Jetsen_AutoTest_project\\SmartJetsen\\template\\temp.rb")
end
=end
