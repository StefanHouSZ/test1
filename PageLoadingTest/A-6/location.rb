﻿#coding: UTF-8
require 'win32ole'  
require 'watir'
  
  @ie = Watir::IE.new
  @ie.close
  
 def gotoA_6  #媒体内容管理-->磁带管理系统

   if
     @ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").exist?()
     @ie.div(:xpath,"//img[@src='http://192.168.8.27:8081/js46/juum/jnetsystemweb/images/icons/mam.gif']/").click
     else
     @ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").exist?()
     @ie.div(:xpath,"//img[@src='images/icons/mam.gif']/").click
   end
   @ie.image(:id,'tree10000000-5-img').click

   num = 0
#循环执行每一个链接，num小于的个数要等于被测区域的实际链接数   
   while num < 20 
   num1 = num.to_s 
   @linkid = 'tree10000000-5-' + num1 +'-a' 
   @ie.link(:id,@linkid).click  
   num+=1
   end #end loop         
 end #end func
 
 
 
