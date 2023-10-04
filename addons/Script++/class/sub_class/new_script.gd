#@tool
#extends EditorScript
#
#var myFile = preload("res://addons/Script++/lib/myFile.gd").new()
## 运行函数
#func _run():
#	var md = myFile.loadString("res://doc/myDocStation.md")
#	var doc = md2HTML.parse_code_block(md)
	
#@tool
#extends EditorScript
#
## 运行函数
#func _run():
#	var doc = myDocStation.new("我的文档","测试","res://doc/")
#	doc.create_station()


#@tool
#extends EditorScript
#
## 常用网址
#var links = [
#	["百度","https://www.baidu.com"]
#]
#
#func _run():
#	var station = myPicStation.new("游戏素材库","E:/图库","绘画参考",links)
#	station.create_station()
