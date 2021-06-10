tool
extends Node2D

export (int) var attack_range = 1 setget set_attack_range
export (PackedScene) var projectile

var target_list = []

func _physics_process(_delta):
	if target_list:
		# get closest enemy
		# launch missle in that direction
		pass

func set_attack_range(num=1):
	attack_range = max(1, num)
	if $AttackRange:
		$AttackRange.scale = Vector2(1 + 0.1*num, 1 + 0.1*num)

func _on_AttackRange_area_entered(area):
	print('and another one')
	target_list.append(area)

func _on_AttackRange_area_exited(area):
	print('it left')
	target_list.erase(area)
