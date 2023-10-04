# resManager
Godot4资源管理器插件
因为之前开发的间断，以及没有用Git进行版本管理，所以这里上传的版本是截止2023年10月5日00:26:09我自己家电脑上的版本。
这个版本的功能几乎是没有写的状态。
## 更新日志
- GDEditor的face_root问题
```
# 4.0版本
face_root = face.get_().root
# 4.1及以后改为
face_root = face.get_base_control().get_viewport()
```
- 
