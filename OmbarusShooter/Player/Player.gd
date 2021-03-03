extends KinematicBody

export(NodePath) var PlayerAnimationTree
onready var _animation_tree = get_node(PlayerAnimationTree)

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var root_motion: Transform = _animation_tree.get_root_motion_transform()
	var v = root_motion.origin 
	
	if Input.is_action_pressed("move_forward"):
		_animation_tree['parameters/playback'].travel("Running")
	else:
		_animation_tree['parameters/playback'].travel("Idle")
		
	move_and_slide(v, Vector3.UP)
