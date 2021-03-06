extends AnimationTree

var blend_position = Vector2.ZERO

onready var animation_playback = get("parameters/playback")

func _ready():
	pass # Replace with function body.

func update_animation(input_vector:Vector3, is_running:bool):
	# move animation related code in a AnimationTree script
	# for smooth animtions use velocity instead of input_vector
	if input_vector != Vector3.ZERO:
		if input_vector.z >= 0:
			blend_position = Vector2(input_vector.x, input_vector.z)
		else:
			blend_position = Vector2(-input_vector.x, input_vector.z)
		set("parameters/Walking/blend_position", blend_position)
		set("parameters/Running/blend_position", blend_position)
		
		if is_running and input_vector.z > 0:
			animation_playback.travel('Running')
		else:
			animation_playback.travel('Walking')
	else:
		animation_playback.travel('Idle')
