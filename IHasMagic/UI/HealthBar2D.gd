extends Control

onready var health_bar = $TextureProgress

func update_texture_max(value):
	health_bar.max_value = value
	
func update_texture_current(value):
	health_bar.value = value
