#encoding: utf-8
require 'savon'
client = Savon.client(wsdl: "http://192.168.8.27:8081/js46/services/CMPCatalogService?wsdl",raise_errors: false)
serviceAPI = Array.new
serviceAPI = client.operations
#puts serviceAPI[0..20]

res = client.call(:cmp_get_table_data) do
  message tableName:"catalog",condition:"test",fields:'10',rowCount:"8",orderString:"1"
end  #end do
puts res