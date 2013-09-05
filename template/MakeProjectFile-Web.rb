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

#打开excel，并对其中的sheet进行访问
excel = WIN32OLE::new('excel.Application')
#是否可视excel应用
excel.visible = false
workbook = excel.Workbooks.Open('F:\Jetsen_AutoTest_project\SmartJetsen\template\WebProjectCodeModel.xlsx')
worksheet = workbook.Worksheets(1) #定位到第一个sheet
worksheet.Select

$data1 = worksheet.Range('A1').value #读取a1单元格的数据
$data2 = worksheet.Range('A34').value 
$data3 = worksheet.Range('J1').value 
excel.Quit()
closeEXCEL

project = 'ProjectModle'
#基本变量的定义
#filePath = Pathname.new(File.join(File.dirname(__FILE__),"../../../TestSuits/AutoTestCase")).realpath

#定义ProjectModel的rb文件的格式
@tempRbStr = $data1 + "\n" + $data2 + "\n" + $data3 + "\n"
f=File.new(File.join("F:\\Jetsen_AutoTest_project\\SmartJetsen\\Project","ProjectModel-Web.rb"), "w+")   # 文件名和格式任意
f.puts(@tempRbStr)
