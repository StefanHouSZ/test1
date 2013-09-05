#encoding: utf-8
require 'win32ole'
require '../Lib/MainExtra.rb'

    $extra = MainExtra.new
#利用IO方法从TestResult.log中读取字符串
    $str = IO.read("F:/Jetsen_AutoTest_project/SmartJetsen/WebAPP/TestLog/TestResult.log")
#显示字符串长度  
    puts $str.length
#通过一个数组存储读取到的字符串输出在控制台上  

#通过读符号“$”的数量，统计测试用例总数
    $start = $str.count "$"
#通过读符号“#”的数量，统计成功的结果数 
    $pass = $str.count "#"
#通过读符号“*”的数量，统计失败的结果数 
    $fail = $str.count "*"
#通过读符号“&”的数量，统计完成的结果数 
    $finish = $str.count "&"
#统计异常测试用例数量,这里的统计信息其实并不是特别合适，异常出现后，其之后的所有测试点都被认为是异常点
    $error = $start - $finish
#统计人工确认的测试用例数量
    $manual = $str.count "%"
    
#初始化xml相关的数据
   $xml = WIN32OLE.new('Msxml2.DOMDocument.3.0')
   $xml.async = false
#加载XML，并将XML头写好，然后将root名定义好   
   $xml.loadXML('<?xml version="1.0" encoding="UTF-8"?><Statistics></Statistics>')

class Statistics
  def stat#目前不使用这个统计方式，此方法用于统计结果到一个Excel文件中并柱状图化
#####################往Excel统计表中写数据
    excel = WIN32OLE::new('excel.Application')
#程序运行时Excel是否可见
    excel.visible = false
#开始添加一个workbook
    workbook = excel.Workbooks.Add()
#选择一个sheet
    worksheet = workbook.Worksheets(1)
#选择sheet下的具体单元格来进行数值的输入
    worksheet.Range("A1:D1").value = ["测试通过数","测试失败数","测试完成数","测试异常数"]
    worksheet.Range("A2:D2").value = [$pass,$fail,$finish,$error]
#被操作单元格区间范围
    range = worksheet.Range("A1:D2")
    range.select
#将数据图表化展现
    chart = workbook.Charts.Add
#文件另存为，并设置路径
    workbook.SaveAs('F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\Statistics\\统计测试结果.xlsx')
    excel.Quit()
    $extra.closeEXCEL
  end  #end def

#生成xml文件，用于辅助web页面来完成统计测试结果反馈
  def WriteXmlFile(eleValueStart,eleValuePass,eleValueFail,eleValueManual,eleValueFinish,eleValueError)
     ele1 = $xml.createElement('Start') #建立第一个二级节点，并赋予名称
     ele2 = $xml.createElement('Pass')
     ele3 = $xml.createElement('Fail')
     ele4 = $xml.createElement('Manual')
     ele5 = $xml.createElement('Finish')
     ele6 = $xml.createElement('Error')

     dirNode1 = $xml.documentElement().appendChild(ele1) #将第一个二级节点加入根节点
     dirNode2 = $xml.documentElement().appendChild(ele2)
     dirNode3 = $xml.documentElement().appendChild(ele3)
     dirNode4 = $xml.documentElement().appendChild(ele4)
     dirNode5 = $xml.documentElement().appendChild(ele5)
     dirNode6 = $xml.documentElement().appendChild(ele6)
     
     dirNode1.text = eleValueStart #给第一个二级节点赋予text值
     dirNode2.text = eleValuePass 
     dirNode3.text = eleValueFail
     dirNode4.text = eleValueManual
     dirNode5.text = eleValueFinish
     dirNode6.text = eleValueError
     
  end  #end def
end  #end class

t = Statistics.new
#t.stat  不生成Excel测试结果的统计文件，转为web页面呈现的方式
t.WriteXmlFile($start,$pass,$fail,$manual,$finish,$error) #写xml文件
$xml.save('./Statistics.xml')  
