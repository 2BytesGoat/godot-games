extends Sprite3D

onready var health_bar = $Viewport/HealthBar2D

func _ready():
	texture = $Viewport.get_texture()

func _on_Status_max_health_changed(value):
	health_bar.update_texture_max(value)

func _on_Status_health_changed(value):
	if not self.visible and (health_bar.max_value != health_bar.value):
		self.visible = true
	health_bar.update_texture_current(value)
