extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass():
	var grass_effect = GrassEffect.instance()
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position

func _on_HurtBox_area_entered(area):
	create_grass()
	queue_free()
