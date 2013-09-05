=begin
#删除文件的路径
path_file = File.join("c:/","WebConfigData_require.txt")
File.delete(path_file)
=end
require 'savon'
=begin
client1 = Savon.client do
  wsdl "http://192.168.8.27:8081/js46/services/CMPCatalogService?wsdl"
end
puts client1
client2 = Savon.client(wsdl:"http://192.168.8.27:8081/js46/services/CMPCatalogService?wsdl")
puts client2
=end



@wsdl = "http://192.168.8.56:8088/jmtc-manager-2.0/services/MtsWebService?wsdl"
client = Savon.client do |globals|
  globals.wsdl @wsdl
end
client.operations
#response = client.call(:authenticate) do
#  message username: "luke", password: "secret"
#  convert_request_keys_to :camelcase
#end

