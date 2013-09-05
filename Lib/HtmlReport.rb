#########################Jetsen自动化测试自定义类，version 1.0.1########################################
###########HTML报告公共方法############

require 'win32ole'

class HtmlReport
  def createHtmlReport(reportname,projectname,coder,tester)
#获取时间信息
    t = Time.now
# “日”格式
#如果字符串只有一位，则显示格式为0x，如02号
    if(t.day.to_s.length == 1)
      strDay = '0' + t.day.to_s
#否则全部显示，如12号  
    else
      strDay = t.day.to_s
    end
# “月”格式，格式判断方式同上
    if(t.month.to_s.length == 1)
      strMonth = '0' + t.month.to_s
    else
      strMonth = t.month.to_s
    end
# “年”格式，全部输出，不需要判断字符串位数
    strYear = t.year.to_s
# “小时”格式，判断方式同上
    if(t.hour.to_s.length == 1)
      strHour = '0' + t.hour.to_s
    else
      strHour = t.hour.to_s
    end
# “分钟”格式，判断方式同上
    if(t.min.to_s.length == 1)
      strMinutes = '0' + t.min.to_s
    else
      strMinutes = t.min.to_s
    end
# “秒”格式，判断方式同上，多了一个为0位的情况
    if(t.sec.to_s.length == 1)
      strSeconds = '0' + t.sec.to_s
    elsif (t.sec.to_s.length == 0)
      strSeconds = '00'
    else
      strSeconds = t.sec.to_s
    end 
    @REPORTPATH = 'F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\TestReport\\'
    @REPORTNAME = reportname
    @PROJECTNAME = projectname
    @CODER = coder
    @TESTER = tester
    @RUNTIME = strYear + '-' + strMonth + '-' + strDay + ' @ ' + strHour + ':' + strMinutes + ':' + strSeconds 
#在TestReport下新建一个名为TestReport.html的HTML自动化测试报告    
    @HtmlReport = File.new(File.join(@REPORTPATH,@REPORTNAME), "w+")
    @HTMLCODE =  '<html>
      <head>
      <meta content=text/html; charset=utf-8 http-equiv=content-type>
      <title>Jetsen自动化测试报告单</title>
      <style type=text/css>
      .title { font-family: verdana; font-size: 30px;  font-weight: bold; align: left; color: #626262;}
      .bold_text { font-family: verdana; font-size: 14px;  font-weight: bold;color:#ffb100;}
      .normal_text { font-family: verdana; font-size: 14px;  font-weight: normal;}
      .small_text { font-family: verdana; font-size: 12px;  font-weight: normal; }
      .border { border: 1px solid #078446;}
      .border_left { border-top: 1px solid #078446; border-left: 1px solid #078446; border-right: 1px solid #078446;}
      .border_right { border-top: 1px solid #078446; border-right: 1px solid #078446;}
      .casenum{ font-family: verdana; font-size: 14px;  font-weight: bold; text-align: center; color: blue;}
      .result_ok { font-family: verdana; font-size: 14px;  font-weight: bold; text-align: center; color: green;}
      .result_nok { font-family: verdana; font-size: 14px;  font-weight: bold; text-align: center; color: red;}
      .result_ng { font-family: verdana; font-size: 14px;  font-weight: bold; text-align: center; color: ;yellow}
      .overall_ok { font-family: verdana; font-size: 14px;  font-weight: bold; text-align: left; color: green;}
      .overall_nok { font-family: verdana; font-size: 14px;  font-weight: bold; text-align: left; color: red;}
      .bborder_left { border-top: 1px solid #078446; border-left: 1px solid #078446; border-bottom: 1px solid #078446; background-color:#078446;font-family: verdana; font-size: 12px;  font-weight: bold; text-align: center; color: white;}
      .bborder_right { border-right: 1px solid #078446; background-color:#078446;font-family: verdana; font-size: 12px;  font-weight: bold; text-align: center; color: white;}
      </style>
      </head>
      <body>
      <center>
      <table width=800 border=0 cellpadding=2 cellspacing=2>
      <tbody>
      <tr>
      <td>
      <table width=100% border=0 cellpadding=2 cellspacing=2>
      <tbody>
      <tr>
      <td style=width: 150px;> </td>
      <td align=right><p class=title>Jetsen自动化测试报告单</p></td>
      </tr>
      </tbody>
      </table>
      <hr width=100% class=border size=1px>
      <center>
      <table border=0 width=95% cellpadding=2 cellspacing=2>
      <tbody>
      <tr>
      <td width=25%><p class=bold_text>测试项目名称：</p></td>
      <td width=5%><p class=bold_text>:</p></td>
      <td width=70%><p class=normal_text>'+@PROJECTNAME+'</p></td>
      </tr>
      <tr>
      <td width=25%><p class=bold_text>测试执行日期：</p></td>
      <td width=5%><p class=bold_text>:</p></td>
      <td width=70%><p class=normal_text>'+@RUNTIME+'</p></td>
      </tr>
      <tr>
      <td width=25%><p class=bold_text>自动化测试脚本编写人：</p></td>
      <td width=5%><p class=bold_text>:</p></td>
      <td width=70%><p class=normal_text>'+@CODER+'</p></td>
      </tr>
      <tr>
      <td width=25%><p class=bold_text>自动化测试脚本执行人：</p></td>
      <td width=5%><p class=bold_text>:</p></td>
      <td width=70%><p class=normal_text>'+@TESTER+'</p></td>
      </tr>
      </tbody>
      </table>
      </center>

      <center>
      <table width=95% cellpadding=2 cellspacing=0>
      <tbody>
      <tr>
      <td class=bborder_left width=30%><p>用例编号</p></td>
      <td class=bborder_right width=20%><p>测试结果</p></td>
      <td class=bborder_right width=50%><p>测试点完成时间</p></td>
      </tr>
      '
#将HTML代码写入文件中
    @HtmlReport.puts(@HTMLCODE) 
    @HtmlReport.close       
  end
  def html_pass(casenum)
#获取时间信息
    t = Time.now
# “日”格式
#如果字符串只有一位，则显示格式为0x，如02号
    if(t.day.to_s.length == 1)
      strDay = '0' + t.day.to_s
#否则全部显示，如12号  
    else
      strDay = t.day.to_s
    end
# “月”格式，格式判断方式同上
    if(t.month.to_s.length == 1)
      strMonth = '0' + t.month.to_s
    else
      strMonth = t.month.to_s
    end
# “年”格式，全部输出，不需要判断字符串位数
    strYear = t.year.to_s
# “小时”格式，判断方式同上
    if(t.hour.to_s.length == 1)
      strHour = '0' + t.hour.to_s
    else
      strHour = t.hour.to_s
    end
# “分钟”格式，判断方式同上
    if(t.min.to_s.length == 1)
      strMinutes = '0' + t.min.to_s
    else
      strMinutes = t.min.to_s
    end
# “秒”格式，判断方式同上，多了一个为0位的情况
    if(t.sec.to_s.length == 1)
      strSeconds = '0' + t.sec.to_s
    elsif (t.sec.to_s.length == 0)
      strSeconds = '00'
    else
      strSeconds = t.sec.to_s
    end 
    @CASENUM = casenum
    @RUNTIME1 = strYear + '-' + strMonth + '-' + strDay + ' @ ' + strHour + ':' + strMinutes + ':' + strSeconds
    @HTMLCODE1 = '
      <table width=95% cellpadding=2 cellspacing=0>
      <tbody>
      <tr>
      <td class=border_left width=30%><p class=casenum>' + @CASENUM + '</p></td>
      <td class=border_right width=20%><p class=result_ok>通过</p></td>
      <td class=border_right width=50%><p class=normal_text>' + @RUNTIME1 + '</p></td>
      </tr>
      </tbody>
      </table>
      '
    @HtmlReport = File.new(File.join(@REPORTPATH,@REPORTNAME), "a+")
    @HtmlReport.puts(@HTMLCODE1)
    @HtmlReport.close
  end
  def html_fail(casenum)
#获取时间信息
    t = Time.now
# “日”格式
#如果字符串只有一位，则显示格式为0x，如02号
    if(t.day.to_s.length == 1)
      strDay = '0' + t.day.to_s
#否则全部显示，如12号  
    else
      strDay = t.day.to_s
    end
# “月”格式，格式判断方式同上
    if(t.month.to_s.length == 1)
      strMonth = '0' + t.month.to_s
    else
      strMonth = t.month.to_s
    end
# “年”格式，全部输出，不需要判断字符串位数
    strYear = t.year.to_s
# “小时”格式，判断方式同上
    if(t.hour.to_s.length == 1)
      strHour = '0' + t.hour.to_s
    else
      strHour = t.hour.to_s
    end
# “分钟”格式，判断方式同上
    if(t.min.to_s.length == 1)
      strMinutes = '0' + t.min.to_s
    else
      strMinutes = t.min.to_s
    end
# “秒”格式，判断方式同上，多了一个为0位的情况
    if(t.sec.to_s.length == 1)
      strSeconds = '0' + t.sec.to_s
    elsif (t.sec.to_s.length == 0)
      strSeconds = '00'
    else
      strSeconds = t.sec.to_s
    end
    @CASENUM = casenum
    @RUNTIME2 = strYear + '-' + strMonth + '-' + strDay + ' @ ' + strHour + ':' + strMinutes + ':' + strSeconds    
    @HTMLCODE2 = '
      <table width=95% cellpadding=2 cellspacing=0>
      <tbody>
      <tr>
      <td class=border_left width=30%><p class=casenum>' + @CASENUM + '</p></td>
      <td class=border_right width=20%><p class=result_nok>失败</p></td>
      <td class=border_right width=50%><p class=normal_text>' + @RUNTIME2 + '</p></td>
      </tr>
      </tbody>
      </table>
      '
    @HtmlReport = File.new(File.join(@REPORTPATH,@REPORTNAME), "a+")  
    @HtmlReport.puts(@HTMLCODE2)
    @HtmlReport.close         
  end
  def html_ng(casenum)
#获取时间信息
    t = Time.now
# “日”格式
#如果字符串只有一位，则显示格式为0x，如02号
    if(t.day.to_s.length == 1)
      strDay = '0' + t.day.to_s
#否则全部显示，如12号  
    else
      strDay = t.day.to_s
    end
# “月”格式，格式判断方式同上
    if(t.month.to_s.length == 1)
      strMonth = '0' + t.month.to_s
    else
      strMonth = t.month.to_s
    end
# “年”格式，全部输出，不需要判断字符串位数
    strYear = t.year.to_s
# “小时”格式，判断方式同上
    if(t.hour.to_s.length == 1)
      strHour = '0' + t.hour.to_s
    else
      strHour = t.hour.to_s
    end
# “分钟”格式，判断方式同上
    if(t.min.to_s.length == 1)
      strMinutes = '0' + t.min.to_s
    else
      strMinutes = t.min.to_s
    end
# “秒”格式，判断方式同上，多了一个为0位的情况
    if(t.sec.to_s.length == 1)
      strSeconds = '0' + t.sec.to_s
    elsif (t.sec.to_s.length == 0)
      strSeconds = '00'
    else
      strSeconds = t.sec.to_s
    end
    @CASENUM = casenum
    @RUNTIME3 = strYear + '-' + strMonth + '-' + strDay + ' @ ' + strHour + ':' + strMinutes + ':' + strSeconds    
    @HTMLCODE3 = '
      <table width=95% cellpadding=2 cellspacing=0>
      <tbody>
      <tr>
      <td class=border_left width=30%><p class=casenum>' + @CASENUM + '</p></td>
      <td class=border_right width=20%><p class=result_ng>未知结果</p></td>
      <td class=border_right width=50%><p class=normal_text>' + @RUNTIME3 + '</p></td>
      </tr>
      </tbody>
      </table>
      '
    @HtmlReport = File.new(File.join(@REPORTPATH,@REPORTNAME), "a+")  
    @HtmlReport.puts(@HTMLCODE3)
    @HtmlReport.close      
  end
  def html_manual(casenum)
   #获取时间信息
    t = Time.now
# “日”格式
#如果字符串只有一位，则显示格式为0x，如02号
    if(t.day.to_s.length == 1)
      strDay = '0' + t.day.to_s
#否则全部显示，如12号  
    else
      strDay = t.day.to_s
    end
# “月”格式，格式判断方式同上
    if(t.month.to_s.length == 1)
      strMonth = '0' + t.month.to_s
    else
      strMonth = t.month.to_s
    end
# “年”格式，全部输出，不需要判断字符串位数
    strYear = t.year.to_s
# “小时”格式，判断方式同上
    if(t.hour.to_s.length == 1)
      strHour = '0' + t.hour.to_s
    else
      strHour = t.hour.to_s
    end
# “分钟”格式，判断方式同上
    if(t.min.to_s.length == 1)
      strMinutes = '0' + t.min.to_s
    else
      strMinutes = t.min.to_s
    end
# “秒”格式，判断方式同上，多了一个为0位的情况
    if(t.sec.to_s.length == 1)
      strSeconds = '0' + t.sec.to_s
    elsif (t.sec.to_s.length == 0)
      strSeconds = '00'
    else
      strSeconds = t.sec.to_s
    end
    @CASENUM = casenum
    @RUNTIME4 = strYear + '-' + strMonth + '-' + strDay + ' @ ' + strHour + ':' + strMinutes + ':' + strSeconds    
    @HTMLCODE4 = '
      <table width=95% cellpadding=2 cellspacing=0>
      <tbody>
      <tr>
      <td class=border_left width=30%><p class=casenum>' + @CASENUM + '</p></td>
      <td class=border_right width=20%><p class=result_nok>人工判断</p></td>
      <td class=border_right width=50%><p class=normal_text>' + @RUNTIME4 + '</p></td>
      </tr>
      </tbody>
      </table>
      '
    @HtmlReport = File.new(File.join(@REPORTPATH,@REPORTNAME), "a+")  
    @HtmlReport.puts(@HTMLCODE4)
    @HtmlReport.close 
    
  end
  def html_finish(reportname)
     @REPORTNAME = reportname
     @REPORTPATH = 'F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\TestReport\\'
     @HTMLCODE5 = '
      <table>
      <tr>
      <td class=bborder_left width=30%><p> </p></td>
      <td class=bborder_left width=20%><p> </p></td>
      <td class=bborder_right width=50%><p> </p></td>
      </tr>
      </table>
      <hr width=100% class=border size=1px>
      <center><p class=small_text>©2013 All Rights Reserved By JetsenNet TestTeam</p></center>
      '
    @HtmlReport = File.new(File.join(@REPORTPATH,@REPORTNAME), "a+")  
    @HtmlReport.puts(@HTMLCODE5)
    @HtmlReport.close
  end
end