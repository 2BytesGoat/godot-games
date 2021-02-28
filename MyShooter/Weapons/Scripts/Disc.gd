extends Bullet

func _ready():
	bounce = 0.25

func _on_RigidBody_body_entered(body):
	if body.is_in_group('Enemy'):
		self.queue_free()
		
