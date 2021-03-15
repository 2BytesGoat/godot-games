extends Spatial

onready var status = $Status
onready var destruction = $Destruction

# Called when the node enters the scene tree for the first time.
func _ready():
	status.max_health = 10
	
func _on_Hurtbox_area_entered(area):
	status.health -= area.damage

func _on_Status_no_health():
	destruction.destroy()

