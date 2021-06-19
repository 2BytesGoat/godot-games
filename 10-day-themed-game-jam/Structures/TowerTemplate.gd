tool
extends Node2D

signal shoot

export (int) var attack_range = 1 setget set_attack_range
export (PackedScene) var projectile

var target_list = []
var can_shoot = true

func _ready():
	connect("shoot", Globals.main_game_node, "spawn_projectile")

func _physics_process(_delta):
	if target_list and can_shoot:
		shoot()

func shoot():
	can_shoot = false
	$ReloadTimer.start() # create dynamic timer based on tower type?
	var pos = $Node2D/ProjectileSpawn.global_position
	var target = target_list[0]
	emit_signal("shoot", projectile, pos, target)
	
func set_attack_range(num=1):
	attack_range = max(1, num)
	if $AttackRange:
		$AttackRange.scale = Vector2(1 + 0.1*num, 1 + 0.1*num)
	
func _on_ReloadTimer_timeout():
	can_shoot = true

func _on_AttackRange_area_entered(area):
	print('and another one')
	target_list.append(area)

func _on_AttackRange_area_exited(area):
	print('it left')
	target_list.erase(area)


