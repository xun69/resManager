@tool
extends VBoxContainer


@onready var item_list = %ItemList
@onready var title_lab = %titleLab
@onready var toggle_btn = %toggleBtn
@onready var rename_txt = %renameTxt

signal title_renamed(new_title) # 标题重命名后发出
signal drop_item_added(files)  # 通过拖放添加项后触发


@export_category("Group")
@export var title = "":
	set(val):
		title = val
		if has_ready:
			title_lab.text = val
	get:
		if has_ready:
			return title_lab.text

@export var down_icon:CompressedTexture2D = preload("res://addons/resManager/icons/down.png"):
	set(val):
		down_icon = val
		if has_ready:
			toggle_btn.icon = val

@export var right_icon:CompressedTexture2D = preload("res://addons/resManager/icons/right.png")

var GDEditor = preload("res://addons/resManager/class/GDEditor.gd").new()

var has_ready = false

func _ready():
	toggle_btn.icon = down_icon
	has_ready = true

# 添加子节点
func add_item(title:String,icon:Texture2D):
	item_list.add_item(title,icon)
	
# 添加子节点
func remove_item(idx:int):
	item_list.remove_item(idx)

# 添加子节点
func get_selected_items():
	item_list.get_selected_items()

# 清空
func clear():
	item_list.clear()

# 返回项的数目
func get_item_count():
	return item_list.item_count
	
# 返回项的数目
func get_item_text(idx:int):
	return item_list.get_item_text(idx)

# 返回项的元数据
func get_item_metadata(idx:int):
	return item_list.get_item_metadata(idx)

# 返回项的元数据
func set_item_metadata(idx:int, metadata:Variant):
	item_list.set_item_metadata(idx,metadata)

# 展开或隐藏分组
func _on_toggle_btn_pressed():
	item_list.visible = not item_list.visible
	toggle_btn.icon = down_icon if item_list.visible else right_icon 

# 进入标题编辑模式
func edit_title():
	rename_txt.text = title_lab.text
	title_lab.hide()
	rename_txt.show()

# 退出标题编辑模式
func quit_title_edit():
	title_lab.text = rename_txt.text
	rename_txt.hide()
	title_lab.show()
	emit_signal("title_renamed",rename_txt.text)

# 分组名称被双击
func _on_title_lab_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.double_click and event.is_pressed():
				edit_title()

# 重命名标题 - 按回车
func _on_rename_txt_text_submitted(new_text):
	if new_text != "":
		quit_title_edit()


func _on_item_list_drop_item_added(files):
	emit_signal("drop_item_added",[files])
	pass


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	
	pass 
