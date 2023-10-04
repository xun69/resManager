@tool
extends ScrollContainer


signal title_renamed(new_title,index) # 标题重命名后发出
signal drop_item_added(files,index)  # 通过拖放添加项后触发

@export var group_tscn:PackedScene = preload("res://addons/resManager/parts/Group.tscn")
@onready var vbox = %VBox

# 添加分组
func add_group(title:String):
	var gup = group_tscn.instantiate()
	vbox.add_child(gup)
	gup.title_renamed.connect(func(new_title):
		emit_signal("title_renamed",new_title,gup.get_index())
	)
	gup.drop_item_added.connect(func(files):
		emit_signal("drop_item_added",files,gup.get_index())
	)
	gup.title = title
	return gup

# 获取相应group的引用
func get_group(idx):
	return vbox.get_child(idx) if idx < vbox.get_child_count() else null

# 返回group的数量
func get_groups_count():
	return vbox.get_child_count()

# 移除指定索引的分组
func remove_group(idx:int):
	if idx < vbox.get_child_count():
		vbox.get_child(idx).queue_free()
	pass

# 全部清除
func clear():
	for i in vbox.get_child_count():
		vbox.get_child(i).queue_free()
	pass
