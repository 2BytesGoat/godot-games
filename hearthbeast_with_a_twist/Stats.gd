extends Node

export var max_health = 3 setget set_max_health
var health = 3 setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = max(value, 1)
	health = min(value, health)
	emit_signal("max_health_changed", value)

func set_health(value):
	health = value
	emit_signal("health_changed", value)
	if health <= 0:
		emit_signal("no_health")
		
func _ready():
	self.health = max_health
