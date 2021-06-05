extends Camera2D

const SCROLL_MARGIN = 45
const SCROLL_SPEED = 135

func _input(event):
	if event.is_action_pressed("zoom_in"):
		zoom = zoom - Vector2(0.05, 0.05)
	if event.is_action_pressed("zoom_out"):
		zoom = zoom + Vector2(0.05, 0.05)

func _process(delta):
	var v_size = get_viewport().size
	var m_pos = get_viewport().get_mouse_position()
	var move_vec = Vector2.ZERO
	
	if m_pos.x < SCROLL_MARGIN:
		move_vec += Vector2(1, 0)
	elif m_pos.x > v_size.x - SCROLL_MARGIN:
		move_vec -= Vector2(1, 0)
	if m_pos.y < SCROLL_MARGIN:
		move_vec += Vector2(0, 1)
	elif m_pos.y > v_size.y - SCROLL_MARGIN:
		move_vec -= Vector2(0, 1)
	offset -= move_vec * SCROLL_SPEED * delta
