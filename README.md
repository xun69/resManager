# resManager
Godot4资源管理器插件
因为之前开发的间断，以及没有用Git进行版本管理，所以这里上传的版本是截止2023年10月5日00:26:09我自己家电脑上的版本。
这个版本的功能几乎是没有写的状态。
## 更新日志
- GDEditor的face_root问题
GDEditor是我自己（Bilibili@巽星石）编写的插件核心类，并基于这些核心类，创建出Godot4.x的诸多编辑器插件。

Godot4.x在4.0到4.1的改进中，也会存在一定的API变化，这个错误就是如此。

```
# 4.0版本
face_root = face.get_root().root
# 4.1及以后改为
face_root = face.get_base_control().get_viewport()
```
- 
