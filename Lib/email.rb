#encoding:utf-8
require 'net/smtp'
require 'mailfactory'

class SendEmail
# sendmail(to1,subject,text,file)
def sendmail(testermailaddr,develepormailaddr,subject,text)
 @testermailaddr = testermailaddr
 @develepormailaddr = develepormailaddr
 mail = MailFactory.new
 mail.from="SmartJetsen"
 mail.subject=subject
 mail.text=text
# mail.attach(file);
 mail.to = @testermailaddr
 mail.to = @develepormailaddr

#填写SMTP的相关信息
 Net::SMTP.start('mail.jetsen.cn', 25, 'jetsen.cn', 'SmartJetsen', 'Jetsentest123', :plain) do |smtp|
   smtp.send_mail(mail.to_s().force_encoding('UTF-8'), "SmartJetsen@jetsen.cn", @testermailaddr,@develepormailaddr)
 end  #end do
end  #end def
end  #end class
