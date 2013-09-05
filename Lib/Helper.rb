#encoding: utf-8
#自定义一个Helper，辅助测试脚本编写模块，目的是为了更进一步简化自动化工程脚本的编写

require 'watir'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/Ini.rb'

class Helper < Ini
  def loginsys(url,username,pwd)
    @utl = url
    @username = username
    @pwd = pwd    
    $ie.goto(@utl)
    $ie.text_field(:id,'txtUserName').clear
    $ie.text_field(:id,'txtUserName').set(@username)
    $ie.text_field(:id, 'txtPassword').set(@pwd)
    $ie.link(:class,'login-button').click      
  end #end def
#显示frame信息
  def showframes
    $ie.show_frames
  end  #end def  
#显示frame外的所有图片信息
  def showimagesoutframe
    puts $ie.images.each { |i| puts i.to_s }
  end  #end def

#显示frame里的所有图片信息
  def showimagesinframe
    puts $ie.frame(:name,'JetsenMain').images.each { |i| puts i.to_s }
  end  #end def  

#定位到没有文件夹的页面 
  def gotopageclass1(linkid)
    @linkid = linkid
#定位一级功能栏，这里的图片的src路径没有设置成参数形式    
    if
      $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").exist?()
      $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").click
      else if
        $ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").exist?()
        $ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").click
      end #end else if  
    end #end if
#定位二级功能栏
    $ie.link(:id,@linkid).click
    $ie.wait
  end #end def

#定位到有文件夹的页面
  def gotopageclass2(linkid1,linkid2)
    @linkid1 = linkid1
    @linkid2 = linkid2
#定位一级功能栏，这里的图片的src路径没有设置成参数形式    
    if
    $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").exist?()
    $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").click
     else if
      $ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").exist?()
      $ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").click
     end #end elseif
    end #end if
#双击link    
    $ie.link(:id,@linkid1).fire_event('ondblclick')
#进入到指定的link页面
    $ie.link(:id,@linkid2).click        
  end #end def
  
  #定位到没有文件夹的页面，互联互通平台 
  def gotopageclass3(linkid)
    @linkid = linkid
#定位一级功能栏，这里的图片的src路径没有设置成参数形式    
    if
      $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/dma.gif']/").exist?()
      $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/dma.gif']/").click
      else if
        $ie.div(:xpath,"//img[@src='images/icons/dma.gif']/").exist?()
        $ie.div(:xpath,"//img[@src='images/icons/dma.gif']/").click
      end #end else if  
    end #end if
#定位二级功能栏
    $ie.link(:id,@linkid).click
    $ie.wait
  end #end def

  #定位到没有文件夹的页面 ，统一用户管理
  def gotopageclass4(linkid)
    @linkid = linkid
#定位一级功能栏，这里的图片的src路径没有设置成参数形式    
    if
      $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/uum.gif']/").exist?()
      $ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/uum.gif']/").click
      else if
        $ie.div(:xpath,"//img[@src='images/icons/uum.gif']/").exist?()
        $ie.div(:xpath,"//img[@src='images/icons/uum.gif']/").click
      end #end else if  
    end #end if
#定位二级功能栏
    $ie.link(:id,@linkid).click
    $ie.wait
  end #end def

#文件导出方法
  def fileExport(title,filepath)
    @Title = title
    @FilePath = filepath
    $at.WinWaitActive('另存为')
#设置“导出路径”    
    $at.Send(@FilePath) 
#确定     
    $at.Send("{TAB 2}")
    $at.Send("{ENTER}")  
  end  #end def

#文件导入方法（可包括视频，音频，图片，文稿）
  def  fileImport(title,filepath)
    @Title = title
    @FilePath = filepath   
    $at.WinWait(@Title)
#找到“导入路径”
    $at.Send(@FilePath)
    sleep 1
#确定
    $at.Send("{ENTER}")        
  end  #end def
#生成指定位数的随机字符串  
  def randomchar(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    randomchar = ""
    1.upto(len) { |i| randomchar << chars[rand(chars.size-1)] }
    return randomchar
  end      
end #end class
