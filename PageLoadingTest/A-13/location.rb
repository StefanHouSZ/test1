#coding: UTF-8
require 'win32ole'  
require 'watir'
  
  @ie = Watir::IE.new
  @ie.close
  
 def gotoA_13  #媒体内容管理-->其他链接

   if
     @ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").exist?()
     @ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").click
     else
     @ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").exist?()
     @ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").click
   end

   num = 0
   num2 = 11

#循环执行每一个链接，num小于的个数要等于被测区域的实际链接数   
   while num < 9 
   num3 = num2.to_s 
   @linkid = 'tree10000000-' + num3 +'-a' 
   @ie.link(:id,@linkid).click  
   num+=1
   num2+=1
   end #end loop         
 end #end func
 
 
 
