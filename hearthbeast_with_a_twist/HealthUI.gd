extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var health_ui_empty = $HearthUIEmpty
onready var health_ui_full = $HearthUIFull

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	health_ui_full.margin_right = 15 * hearts
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(max_hearts, self.hearts)
	health_ui_empty.margin_right = 15 * max_hearts

func _ready():
	max_hearts = PlayerStats.max_health
	hearts = PlayerStats.health
	health_ui_empty.margin_right = 15 * max_hearts
	health_ui_full.margin_right = 15 * hearts
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	
