#encoding: utf-8
require 'watir'
require 'win32ole'
require 'pathname'
require 'uri'
require "rexml/document"
require "iconv"
include REXML 


@at = WIN32OLE.new('AutoItX3.Control')
#从config.txt中读取URL
@data = IO.readlines("./config.txt")
lines = 0
testnum = 0
while testnum < 38
=begin
#生成随机数
def randomchar( len )
  chars = ("0".."38").to_a
  newpass = ""
  1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
  return newpass
end

@num = randomchar(1).to_i
=end  #以前是随机在A2到A40的单元格中读取URL数据，现改为循环从A2到A40读取URL数据

#@data1 = @data[testnum].to_s
#删除url中的[]和"符号
#@urlold = @data1.delete"\[]\""
#强制转换成utf-8的编码
@urlold = @data[lines].force_encoding('utf-8')  

#将读取到的URL地址转换成URL编码的格式
@url = URI.encode(@urlold)
puts @url
@ie = Watir::IE.new
@ie.maximize
@ie.goto(@url)
sleep 2

#判断测试结果
puts 'TestedUrl:' + @url
#服务器返回结果时先保存页面的xml文件，供测试结果判断
@at.Send('!f')
sleep 2
@at.Send('A')
@at.WinWait('另存为')
#保存在D盘
@at.MouseClick('left',50,228)
sleep 2
@at.MouseClick('left',150,121)
@at.Send('{ENTER}')
@at.Send('jtsetest')
@at.Send('{ENTER}')
#点击保存
@at.MouseClick('left',513,396)
sleep 2
@at.Send('{TAB}')
@at.Send('{ENTER}')
#@at.MouseClick('left',682,488)
#给新建的xml文件一定的处理时间，再交给程序去读取
sleep 3
#读取xml
input = IO.read("D:/jtsetest/search.xml")
doc = Document.new(input)

root = doc.root #定位根节点

@responseTatal = root.attributes["total"]  #返回搜索总数
@items = doc.elements["Response/Records"].attributes["items"]  #返回每页记录数

puts @responseTatal
puts @items
#判断测试结果
f=File.new(File.join("./TestResult.log"), "a+")  #写入测试日志
f.puts "原始URL：" + @urlold
f.puts "转码后URL：" +@url
f.puts "搜索返回条目数：" + @responseTatal
f.puts "单页显示数目：" + @items
if @responseTatal == 0
  then 
  f.puts '测试失败!'
  f.puts '========================================================================================================='
else
  f.puts '测试成功!'
  f.puts '========================================================================================================='
end
f.close
@ie.close
lines+=1
testnum+=1
end #endloop
