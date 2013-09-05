######################JDIN 任务审核 ##########################

#encoding: utf-8
require 'watir'
require 'win32ole'
require 'pathname'
require '../../../Lib/MainExtra.rb'

path = Pathname.new(File.dirname(__FILE__)).realpath.to_s
puts path
#实例化所有Class
$extra = MainExtra.new

#调用关闭所有IE窗口的方法
$extra.close_all_IE(1,5)#此处以最多已经打开了5个IE为例
#从Excel中读取数据

excel = WIN32OLE::new('excel.Application')
excel.visible = false
workbook = excel.Workbooks.Open(path + '/taskreview.xlsx')
worksheet = workbook.Worksheets(1) #定位到第一个sheet
worksheet.Select
#读取“收录格式”
$mode = worksheet.Range('B2:B17').value
excel.Quit()
$extra.closeEXCEL
#关闭Excel

class AutoTest
  def initialize()  
    @ie = Watir::IE.new
    @at = WIN32OLE.new('AutoItX3.Control')
    @ie.maximize  
  end
  def pt1 
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
    @ie.link(:id,"tree30000000-2-a").click
    

    num = 0
#开始循环操作
    while num < 1  
    @at.WinWait('JetsenNet网络系统 - Windows Internet Explorer')
    @at.MouseClick('left',1280,252)  
#生成随机数
    def randomchar( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
    end
    @text1 = $mode[num].to_s
    @raplace1 = @text1.gsub(/"/,'')
    @raplace2 = @raplace1.gsub(/\[/,'')
    @newtext = @raplace2.gsub(/\]/,'')
    @name = randomchar(6) + '-' + @newtext
    
    @tb = @ie.frame(:id,'JetsenMain').div(:id,'divTask').table(:class,'table-info') 

#任务名称
    @tb[0][1].text_field(:id,'txt_TASK_NAME').value= @name
#信源名称  
    text1 = '134信号源1'
    p = text1.encoding
    puts p
    @tb[1][1].text_field(:id,'txt_DDL_SOURCE').value= '134信号源1'
#频道名称    
    @tb[2][1].text_field(:id,'txt_CHAN_NAME').value= '109频道1'
#收录设备    
#    @tb[3][1].text_field(:id,'ddl_INGEST_DEVID').value= '134收录服务器'
#收录通道    
#    @tb[4][1].text_field(:id,'ddl_INGEST_IOID').value= '134收录服务器--I_0'
#收录日期，注必须要为明天，不然会提示过期任务
    t = Time.now #获取当前时间
    day = t.day + 1
    strDay = '0' + day.to_s
    strMonth = '0' + t.month.to_s
    strYear = t.year.to_s
    data = strYear + '-' + strMonth + '-' + strDay
    @tb[5][1].text_field(:id,'txtStartDate1').value= data
    sleep 2
#配置时间
    minute1 = 1
    minutestr1 = minute1.to_s
    minute2 = minute1 + 1
    minutestr2 = minute2.to_s

    @at.MouseClick('left',639,410)
    @at.Send("000" + minutestr1 + "01")
    @at.MouseClick('left',740,410)
    @at.Send("000" + minutestr2 + "01")
    @at.MouseClick('left',1000,479)
#收录格式 
    @tb[11][1].text_field(:id,'ddl_FORMAT').value= @newtext
#收录路径
   @tb[12][1].text_field(:id,'ddl_PATH').value= '收录Win根路径1 - H:\\'   
#确定        
#   @at.MouseClick('left',995,760)
   num+=1
   minute1 = minute1 + 2   
   end #end loop   
  end #end pt1
end  #end of AutoTest class


test = AutoTest.new
test.pt1
