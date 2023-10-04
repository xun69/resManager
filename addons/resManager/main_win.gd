# ========================================================
# 名称：资产管理器
# 类型：
# 简介：
# 作者：
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-23 20:48:20
# 最后修改时间：2023-04-23 20:48:20
# ========================================================
@tool
extends PanelContainer

var GDEditor = preload("res://addons/resManager/class/GDEditor.gd").new()
var SceneTreePlugin = preload("res://addons/resManager/class/sub_class/SceneTreePlugin.gd").new()
var myConfig = preload("res://addons/resManager/lib/myConfig.gd")

const tscn_groups_path = "res://addons/resManager/data/tscn_groups.cfg" 

@onready var res_type_list = %resTypeList
@onready var scene_nodes_tree = %SceneNodesTree
@onready var scene_item_groups = %SceneItemGroups


func _ready():
	# 添加左侧资源类型列表
	res_type_list.clear()
	var res_types = [
		["PackedScene","场景"],
		["GDScript","脚本"],
		["Object","资源"],
		["Mesh","数据"],
		["Help","文档"],
		["EditorPlugin","插件"],
	]
	
	for type in res_types:
		res_type_list.add_item(type[1],GDEditor.get_icon(type[0]))
	res_type_list.select(0)
	
	
	# 添加场景分组列表
	load_groups()
	
		
	# 加载场景的节点结构 - 仅做演示
	var root1:TreeItem = scene_nodes_tree.create_item()
	root1.set_text(0,"Vbox")
	root1.set_icon(0,GDEditor.get_icon("VBoxContainer"))
	for type in ["Label","CodeEdit"]:
		var itm:TreeItem = scene_nodes_tree.create_item(root1)
		itm.set_text(0,type)
		itm.set_icon(0,GDEditor.get_icon(type))
	
	pass


func _on_add_scene_group_pressed():
	# 添加场景分组列表
	scene_item_groups.add_group("未命名分组")
	save_groups_info()
	pass

# 将存储的在.cfg文件中的分组信息加载到场景管理器
func load_groups():
	if FileAccess.file_exists(tscn_groups_path):
		var dict = myConfig.load_config_as_dic(tscn_groups_path)
		
		for gup in dict:
#			print(JSON.stringify(dict[gup],"\t"))
			var g = scene_item_groups.add_group(dict[gup]["gup_title"])
			for itm in dict[gup]["items"]:
				get_preview_texture(itm,func(preview):
					g.add_item(itm.get_file(),preview)
					g.set_item_metadata(g.get_item_count()-1,itm)
				)

# 将分组和分组下的元素信息保存到指定的.cfg文件中
func save_groups_info():
	var dict = {}
	for i in scene_item_groups.get_groups_count():
		var gup = scene_item_groups.get_group(i)
		var gup_dict = {}
		gup_dict["gup_title"] = gup.title
		gup_dict["items"] = []
		for j in gup.get_item_count():
			gup_dict["items"].append(gup.get_item_metadata(j))
		dict["group_%s" % (i+1)] = gup_dict
	myConfig.save_dic_as_config("res://addons/resManager/data/tscn_groups.cfg",dict)


# 获取指定路径res_path的资源的预览图
# call_back返回一个参数preview，即获得的预览图
func get_preview_texture(res_path:String,call_back:Callable):
	var texture
	var plugin = EditorPlugin.new()
	var face = plugin.get_editor_interface()
	var pr = face.get_resource_previewer()
	pr.queue_resource_preview(res_path,self, "_preview", func(preview, thumbnail_preview):
		call_back.call(preview)
	)
	
# 由get_preview_texture()调用
func _preview(path: String, preview: Texture2D, thumbnail_preview: Texture2D, userdata: Callable):
	userdata.call(preview, thumbnail_preview)
	pass


func _on_scene_item_groups_drop_item_added(files, index):
	save_groups_info()
	pass


func _on_scene_item_groups_title_renamed(new_title, index):
	save_groups_info()
	pass

