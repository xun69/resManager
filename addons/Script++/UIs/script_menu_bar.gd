# ========================================================
## Script++插件的主要UI部分，一个MenuBar
##
## 名称：script_menu_bar.tscn
## [br]类型：场景
## [br]作者：巽星石
## [br]Godot版本：4.1-stable (official)
## [br]---------------------------------------------------
## [br]创建时间：2023-07-09 15:42:56
## [br]最后修改时间：2023-07-09 15:42:56
## 
## @tutorial(课程标题): 网址
# ========================================================
@tool
extends MenuBar
# =================================== 依赖 ===================================
var ScriptPlugin = preload("res://addons/Script++/class/sub_class/ScriptPlugin.gd").new()
var WindowPlugin = preload("res://addons/Script++/class/sub_class/WindowPlugin.gd").new()
var ScriptDoc = preload("res://addons/Script++/lib/ScriptDoc.gd")
var myFile = preload("res://addons/Script++/lib/myFile.gd")

# =================================== 对象引用 ===================================
@onready var insert_menu = $"[插入]"
@onready var export_menu = $"[导出]"
@onready var creat_menu = $"[创建]"
@onready var txts_menu = $"[创建]/txts"

# =================================== 菜单项数据 ===================================
# 内部可编辑的纯文本文件
var text_file_types = ["txt","md","cfg","ini","log","json","yml","yaml","toml","xml"]
# 插入 - 菜单 - 菜单项
var arr = ["元信息注释","分割线注释","等待施工",
"--文档注释--",
"顶部","在线教程",
"--普通URL链接--",
"URL链接","URL文本链接",
"--文档链接--",
"链接-类","链接-常量","链接-枚举",
"链接-方法","链接-成员","链接-信号",
"--文字样式--",
"粗体","斜体","下划线","删除线","快捷键",
"--图片--",
"图片",
"--代码块--",
"代码块"]

# =================================== 虚函数 ===================================
# 初始化和加载
func _ready():
	# 清空之前的菜单项然后重新加载
	menu_load(insert_menu,arr)
	menu_load(txts_menu,text_file_types)
	menu_load(creat_menu,["EditorScript","Resource","----"])
	creat_menu.add_submenu_item("纯文本","txts")
	creat_menu.add_submenu_item("办公文档","docs")
	creat_menu.set_item_accelerator(0,KEY_MASK_ALT|KEY_1) # 创建EditorScript
	creat_menu.set_item_accelerator(1,KEY_MASK_ALT|KEY_2) # 创建Resource
	
# =================================== 信号处理 ===================================
# 插入 - 菜单
func _on_insert_menu_index_pressed(index):
	match insert_menu.get_item_text(index):
		"元信息注释":
			ScriptPlugin.add_top_meta_comment()
		"分割线注释":
			ScriptPlugin.insert_HR_comment("XXX")
		"等待施工":
			var tmp = """
# --------------------------------------------------------------------------------
#                   以下等待施工！  [time]
# --------------------------------------------------------------------------------
""".replace("[time]",ScriptPlugin.Now())
			ScriptPlugin.insert_string_at_caret(tmp)
		"代码块":
			var tmp = "## 示例代码:\n## [codeblock]\n## 代码\n## [/codeblock]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"顶部":
			var tmp = """
## 简要描述。
##
## 更详细描述。
##
	"""
			ScriptPlugin.insert_string_at_caret(tmp)
		"在线教程":
			var tmp = "## @tutorial(课程标题): 网址" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"URL链接":
			var tmp = "[url]网址[/url]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"URL文本链接":
			var tmp = "[url=网址]文本[/url]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"链接-类":
			var tmp = "[Class]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"链接-常量":
			var tmp = "[constant <类名.>常量名]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"链接-枚举":
			var tmp = "[enum <类名.>枚举名]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"链接-方法":
			var tmp = "[method <类名.>方法名]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"链接-成员":
			var tmp = "[member <类名.>成员名]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"链接-信号":
			var tmp = "[signal <类名.>信号名]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"粗体":
			var tmp = "[b]粗体[/b]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"斜体":
			var tmp = "[i]斜体[/i]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"下划线":
			var tmp = "[u]下划线[/u]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"删除线":
			var tmp = "[s]删除线[/s]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"快捷键":
			var tmp = "[kbd]快捷键[/kbd]" 
			ScriptPlugin.insert_string_at_caret(tmp)
		"图片":
			var tmp = "[img]图片路径[/img]" 
			ScriptPlugin.insert_string_at_caret(tmp)
			

# 导出 - 菜单
func _on_export_menu_index_pressed(index):
	match export_menu.get_item_text(index):
		"HTML":
			if ScriptPlugin.current_is_script():
				var current_Script = ScriptPlugin.get_current_Script_Obj()
				var dlg:FileDialog = WindowPlugin.show_save_dialog("导出HTML（打印）","res://",["*.html;HTML文档"])
				dlg.current_file = "%s.html" % current_Script.resource_path.get_file().replace(".gd","")
				dlg.file_selected.connect(func(path:String):
					if dlg.current_file != "":
						var doc = ScriptDoc.get_Script_HTMLPrint_str(current_Script)
						var files_path = "%s/%s_files" % [path.get_base_dir(),dlg.current_file.get_file().replace(".html","")]
						var css_path = "res://addons/Script++/lib/HTML_tmps/atom-one-light.min.css"
						var js_path = "res://addons/Script++/lib/HTML_tmps/highlight.min.js"
						
						DirAccess.make_dir_recursive_absolute(files_path)
						DirAccess.copy_absolute(css_path,files_path + "/atom-one-light.min.css")
						DirAccess.copy_absolute(js_path,files_path + "/highlight.min.js")
						myFile.saveString("res://%s" % dlg.current_path,doc)
						myFile.shell_open("res://%s" % dlg.current_path)
				)
		"MarkDown":
			if ScriptPlugin.current_is_script():
				var current_Script = ScriptPlugin.get_current_Script_Obj()
				var dlg:FileDialog = WindowPlugin.show_save_dialog("导出MarkDown","res://",["*.md;MarkDown文档"])
				dlg.current_file = "%s.md" % current_Script.resource_path.get_file().replace(".gd","")
				dlg.file_selected.connect(func(path):
					if dlg.current_file != "":
						var doc = ScriptDoc.get_Script_MDdoc_str(current_Script)
						myFile.saveString("res://%s" % dlg.current_path,doc)
						myFile.shell_open("res://%s" % dlg.current_path)
				)
		"当前文档":
			if ScriptPlugin.current_is_help():
				var tab = ScriptPlugin.ScriptEditor_TabContainer
				var title = tab.get_tab_title(tab.current_tab)
				var dlg:FileDialog = WindowPlugin.show_save_dialog("导出内置文档","res://",["*.md;MarkDown文档"])
				dlg.current_file = "%s.md" % title
				dlg.file_selected.connect(func(path):
					if dlg.current_file != "":
						var txt = ScriptPlugin.get_current_Help_text()
						var H2s = ["类","描述\n","主体属性\n","属性说明\n","属性\n","方法说明\n","方法\n","信号\n"]
						var H3s = ["● "]
						for h2 in H2s:
							txt = txt.replace(h2,"## %s" % h2)
						txt = txt.replace("● ","### ")
						txt = txt.replace("\t","")
						txt = txt.replace(" [默认：","\n[默认：")
						myFile.saveString("res://%s" % dlg.current_path,txt)
						myFile.shell_open("res://%s" % dlg.current_path)
				)

# 创建 - 菜单
func _on_creat_menu_index_pressed(index):
	match creat_menu.get_item_text(index):
		"EditorScript","Resource":
			var cls = creat_menu.get_item_text(index)
			ScriptPlugin.open_script_create_dialog(cls)
	pass

# 创建 - 纯文本
func _on_txts_index_pressed(index):
	match txts_menu.get_item_text(index):
		"txt","md","cfg","ini","log","json","yml","yaml","toml","xml":
			var cur_dir = ScriptPlugin.get_file_sys_dock_current_dir()+ "/"
			var end_str = "." + creat_menu.get_item_text(index)
			WindowPlugin.show_input_dialog(func(text:String):
				if text != "":
					var file_path = "%s%s" % [cur_dir,text] if text.ends_with(end_str) else "%s%s%s" % [cur_dir,text,end_str]
					
					myFile.saveString(file_path,"")
					ScriptPlugin.update_file_sys_dock()
					myFile.shell_open(file_path)
					ScriptPlugin.face.select_file(file_path)
			,"创建%s" % creat_menu.get_item_text(index).to_upper(),"当前路径：%s" % cur_dir,"输入%s文件的名称" % creat_menu.get_item_text(index).to_upper())
	pass
# =================================== 方法 ===================================
# 为菜单加载菜单项
func menu_load(menu:PopupMenu,options:PackedStringArray) -> void:
	# 清空原有菜单项
	menu.clear()
	# 重新加载
	for itm in options:
		if itm.begins_with("--") and itm.ends_with("--"): # 处理形如"----"或"--分组名称--"
			menu.add_separator(itm.replace("--",""))      # 添加分割线
		else:
			menu.add_item(itm)
