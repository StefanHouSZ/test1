require 'yaml'

array = [1, 2, 3, [4, "five", :six]]

puts "Original array:"

puts array.inspect

yarray = array.to_yaml

puts "YAML representation of array: "

puts yarray

thawed = YAML.load(yarray)

puts "Array re-loaded from YAML string: "

wWWiinnddoowowswspsPpcCcMMmeEEnnccooddeerr