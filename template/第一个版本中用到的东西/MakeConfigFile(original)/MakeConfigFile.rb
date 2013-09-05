#encoding: utf-8

require 'win32ole'
#关闭EXCEL的进程
def closeEXCEL
 mgmt = WIN32OLE.connect('winmgmts:\\\\.') 
 processes=mgmt.instancesof("win32_process")
 processes.each do |process|
   if process.name =="EXCEL.EXE"
     then process.terminate()
   end
 end
end

#列出所有非继承的实例方法
#############################此处需要修改##############################
require './你的自动化工程脚本'
@Method = AutoTest.instance_methods(false).sort
@data = @Method.to_s
#获取当前.rb文件的路径，这个方法行不通，返回的路径是带反斜杠的
#@path = Pathname.new(File.dirname(__FILE__)).realpath
#############################此处需要修改##############################
@require = 'require \'F:\Jetsen_AutoTest_project\SmartJetsen\Project\你的自动化工程脚本文件夹\\'
#-------------------------------此处需要修改，根据实际的rb文件名而定---------------------------#
@rb = '你的自动化工程脚本文件名\''
#-------------------------------测试点描述，需要根据实际状况修改-------------------------------#
@description = "prepare:执行该测试集时的准备工作\nfinish:执行该测试集时的收尾工作\npt1:测试能否进入到用户管理页面\n"


#####################往Excel中写数据
excel = WIN32OLE::new('excel.Application')
#程序运行时Excel是否可见
excel.visible = false
#开始添加一个workbook
workbook = excel.Workbooks.Add('F:\Jetsen_AutoTest_project\SmartJetsen\template\Config.xlsx');
#选择一个sheet
worksheet = workbook.Worksheets(1)
#选择sheet下的具体单元格来进行数值的输入
worksheet.Range("C5").value = @require + @rb 
worksheet.Range("C6").value = @data
worksheet.Range("C8").value = @description
workbook.SaveAs'F:\Jetsen_AutoTest_project\SmartJetsen\TestSuits\ExcelTestCase\Config.xlsx'
excel.Quit()
closeEXCEL