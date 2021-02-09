extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

export(bool) var showHit = true

func _on_HurtBox_area_entered(_area):
	if showHit:
		var effect = HitEffect.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
