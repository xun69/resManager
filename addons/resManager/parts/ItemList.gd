# ========================================================
# 名称：接收来自“文件系统”面板的文件拖放并生成图标
# 类型：
# 简介：
# 作者：
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-24 00:39:34
# 最后修改时间：2023-04-24 00:39:34
# ========================================================
@tool
extends ItemList
signal drop_item_added(files) # 通过拖放添加项后触发

func _can_drop_data(at_position, data):
	return data["type"] == "files" # 限定只有文件才能放

# 接收来自“文件系统”面板的拖放
func _drop_data(at_position, data):
	var files:PackedStringArray = data["files"]
	for file in files:
		if file.ends_with(".tscn"): # 限定只有.tscn才能被添加
			get_preview_texture(file,func(preview):
				add_item(file.get_file(),preview)
				set_item_metadata(item_count-1,file)
			)
	emit_signal("drop_item_added",[files])

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

## 双击打开场景
func _on_item_activated(index):
	var plugin = EditorPlugin.new()
	var face = plugin.get_editor_interface()
	face.open_scene_from_path(get_item_metadata(index))
	pass
