extends Spatial

var is_fps_visible = false
onready var fps_lbl = $CanvasLayer/FPS_label

func _process(_delta):
	if is_fps_visible:
		var fps = str(Performance.get_monitor(Performance.TIME_FPS))
		fps_lbl.text = "FPS: " + fps

func _input(_event):
	if Input.is_action_just_pressed("ui_show_hide_fps"):
		fps_lbl.visible = not fps_lbl.visible
		is_fps_visible = fps_lbl.visible
