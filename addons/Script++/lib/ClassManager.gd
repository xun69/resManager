# ========================================================
# 名称：ClassManger
# 类型：静态函数库
# 简介：提供获取内部类和自定义类列表以及相关继承等的函数。
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-19 00:56:45
# 最后修改时间：2023年4月19日01:27:52
# ========================================================


class_name ClassManger

# 返回Godot4内置类的名称列表
static func get_built_in_class_list() -> PackedStringArray:
	var list = ClassDB.get_class_list()
	list.sort()
	return list
	
# 返回继承自className类的子类名称
static func get_inheriters_from_class(className:String) -> PackedStringArray:
	var list = ClassDB.get_inheriters_from_class(className)
	var list2 = []
	# 过滤不能继承的类型
	for cla in list:
		if ClassDB.can_instantiate(cla):
			list2.append(cla)
	list2.sort()
	return list2

# 返回Godot4用户自定义类的信息列表
static func get_custom_class_list() ->Array[Dictionary]:
	var list = ProjectSettings.get_global_class_list()
	list.sort()
	return list
