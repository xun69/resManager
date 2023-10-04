# ========================================================
# 名称：ClassInfo
# 类型：静态函数库
# 简介：基于ClassDB，获得更加简化和丰富的内部类信息
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-18 22:26:03
# 最后修改时间：2023年4月19日00:40:45
# ========================================================

class_name ClassInfo

# =================================== 获取内置类成员列表 ===================================
# 获取内置类的信号列表
static func get_signal_lists(className:String) -> PackedStringArray:
	var signal_arr:PackedStringArray = []
	var list = ClassDB.class_get_signal_list(className,true)
	for sig in list:
		var args:PackedStringArray = []
		for arg in sig["args"]:
			args.append(arg["name"])
		signal_arr.append("%s(%s)" % [sig["name"],",".join(args)])
	signal_arr.sort() # 按字母进行升序
	return signal_arr

# 获取内置类的枚举列表
static func get_enum_lists(className:String) -> Array[Dictionary]:
	var enums_arr:Array[Dictionary] = []
	var enum_list = ClassDB.class_get_enum_list(className,true)
	for enm in enum_list:
		var enum_dict = {}
		enum_dict["name"] = enm
		enum_dict["vals"] = ClassDB.class_get_enum_constants(className,enm,true)
		enums_arr.append(enum_dict)
	enums_arr.sort() # 按字母进行升序
	return enums_arr

# 获取内置类的变量列表
static func get_property_lists(className:String) -> Array[Dictionary]:
	var prop_arr:Array[Dictionary] = []
	var list = ClassDB.class_get_property_list(className,true)
	# 按照属性名称字母进行升序排列
	list.sort_custom(func(a,b):
		return a["name"] < b["name"]
	)
	for prop in list:
		var dict = {}
		dict["name"] = prop["name"]
		if prop["type"] != 24: # 不是object类型
			dict["type"] = get_type_name(prop["type"])
		else:
			dict["type"] = prop["class_name"]
		prop_arr.append(dict)
	return prop_arr

# 返回一个Script对象的方法字符串列表
static func get_method_lists(className:String) -> PackedStringArray:
	var list = ClassDB.class_get_method_list(className,true)
	# 按照属性名称字母进行升序排列
	list.sort_custom(func(a,b):
		return a["name"] < b["name"]
	)
	var str_list:PackedStringArray = []
	for mtod in list:
		var aa = "%s(%s) -> %s" % [mtod["name"],get_arg_str(mtod["args"]),get_return_str(mtod["return"])]
		str_list.append(aa)
	return str_list

# +++++++++++++++++ 以下两个函数仅用于get_method_lists()方法调用 +++++++++++++++++
# 返回函数参数列表字符串
static func get_arg_str(args_arr:Array) -> String:
	var str_list:PackedStringArray = []
	if args_arr.size() == 0:
		return ""
	else:
		for arg in args_arr:
			var aa = "%s:%s" % [arg["name"],get_type_name(arg["type"])]
			str_list.append(aa)
		return ",".join(str_list)

# 返回函数return的类型字符串
static func get_return_str(return_dic:Dictionary) -> String:
	var rt_str = "void"
	if return_dic["type"] != 0:
		rt_str = get_type_name(return_dic["type"])
	return rt_str

# 根据类型返回类型名称
static func get_type_name(type:int) ->String:
	var name_str_arr = ["null","bool","int","float","String","Vector2","Vector2i","Rect2","Rect2i","Vector3",
						"Vector3i","Transform2D","Vector4","Vector4i","Plane","Quaternion","AABB","Basis","Transform3D","Projection",
						"Color","StringName","NodePath","RID","Object","Callable","Signal","Dictionary","Array","PackedByteArray",
						"PackedInt32Array","PackedInt64Array","PackedFloat32Array","PackedFloat64Array","PackedStringArray","PackedVector2Array","PackedVector3Array","PackedColorArray"]
	return name_str_arr[type]
