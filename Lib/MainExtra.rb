#encoding: utf-8
require 'find'
class MainExtra
#定义一个关闭所有IE窗口的方法
def
  close_all_IE(i,j)
  for i in i..j
    Watir::IE.each do |ie|
    ie.close
  end
      i=i+1
  end      
end

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

#关闭ruby程序的进程，用于遇到异常恢复环境的操作
def closeRUBY
 mgmt = WIN32OLE.connect('winmgmts:\\\\.') 
 processes=mgmt.instancesof("win32_process")
 processes.each do |process|
   #puts process
   if process.name =="rubyw.exe"
     then process.terminate()
   end
 end
end

#关闭CamRecorder
def closeRecorder
 mgmt = WIN32OLE.connect('winmgmts:\\\\.') 
 processes=mgmt.instancesof("win32_process")
 processes.each do |process|
   #puts process
   if process.name =="Recorder.exe"
     then process.terminate()
   end
 end
end
#返回某文件夹下的所有文件，结果输出在控制台
def showfiles(filepath)
  @filepath = filepath
          Dir.foreach(@filepath) {
        |x| puts x if x != "." && x != ".."
    }
end
#查询某路径下是否包含某文件
def findfile(filepath)
  @filepath = filepath
  File::exists?(@filepath)
end
def pause
  sleep 2
end  
end  #end class