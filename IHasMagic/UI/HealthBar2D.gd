extends Control

onready var health_bar = $TextureProgress
var max_value
var value

func update_texture_max(_value):
	max_value = _value
	health_bar.max_value = _value
	
func update_texture_current(_value):
	value = _value
	health_bar.value = _value
