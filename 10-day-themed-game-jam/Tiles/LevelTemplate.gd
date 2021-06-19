extends Node2D

""" 
TODOs:
1. Layering between Enemy and Towers

Nice to have:
1. Add trees/environment
2. Center camera on map

Code taken from:
https://youtu.be/hVAdr0AboYU
https://youtu.be/YShYWaGF3Nc?list=PLsk-HSGFjnaH82Bn6xbQNehatj3sIvtMQ
"""

# Tile Map variables
onready var Map = $MapTemplate

# Tile Map custom autotile variables
const N = 1
const E = 2
const S = 4
const W = 8

var road_connections = {Vector2(0,  1): N, Vector2(-1, 0): E,
						Vector2(0, -1): S, Vector2( 1, 0): W}

# Astar variables
var astar: AStar
var starting_point: Vector2
var ending_point: Vector2
var final_path: PoolVector3Array

const top_margin = 1
const bottom_margin = 2

var size_of_astar_obstacles = 3
var num_of_astar_obstacles = 12

# Autotile metadata
var diagonal = 24 # diagonal of the map
onready var tile_h: int = Map.cell_size.y
onready var tile_w: int = Map.cell_size.x

# TODO: move enemy logic to PlacerNode
# Move later logic
export(NodePath) onready var enemyContainer = get_node(enemyContainer)
export(NodePath) onready var enemyPath = get_node(enemyPath)
onready var enemyClass = preload("res://Characters/UgaBunga.tscn")
var num_of_enemies = 3

# TODO: give LevelTemplate instance as argument to PlacerNode
# Tower colors
var build_mode = false
var can_build = false
var current_tower_tile = Vector2.ZERO
var buildable_tiles = [15]

export(NodePath) onready var towerContainer = get_node(towerContainer)
export(NodePath) onready var buildTool = get_node(buildTool)
export(NodePath) onready var buildInterface = get_node(buildInterface)

export(NodePath) onready var projectileContainer = get_node(projectileContainer)

var yellow = Color(0.875, 0.875, 0.095, 0.575)
var red = Color(0.875, 0.095, 0.095, 0.575)
var current_color = yellow

# Tower textures
var UI_red_tower = preload("res://Assets/Structures/towerRound_sampleE_W.png")
var UI_purple_tower = preload("res://Assets/Structures/towerSquare_sampleF_W.png")
var UI_tower_list = {
	"Red_Tower": UI_red_tower,
	"Purple_Tower": UI_purple_tower
}

var red_tower = preload("res://Structures/RedTower.tscn")
var purple_tower = preload("res://Structures/PurpleTower.tscn")
var tower_list = {
	"Red_Tower": red_tower,
	"Purple_Tower": purple_tower
}
var current_tower = red_tower

func _ready():
	Globals.main_game_node = self
	reset_map()
	create_map()
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_reset"):
		reset_map()
		create_map()
	if build_mode:
		_update_build_tool()
		if Input.is_action_just_pressed("ui_mouse_left"):
			build_tower()
		if Input.is_action_just_pressed("ui_mouse_right"):
			build_mode = false
			buildTool.hide()
	
func create_map():
	var height = diagonal / 2
	for y in range(height):
		var length = diagonal - (2 * y)
		for x in range(length):
			Map.set_cell(x + y, y, 15)
			if y != 0: # ignores second pass on diagonal
				Map.set_cell(x + y, -y, 15)
			
			if x >= top_margin and x <= (length - bottom_margin):
				var current_id = astar.get_available_point_id()
				astar.add_point(current_id, Vector3(x + y, y, 0))
				if x > top_margin:
					astar.connect_points(current_id, astar.get_closest_point(Vector3(x + y - 1, y, 0)))

				if y != 0:
					astar.connect_points(current_id, astar.get_closest_point(Vector3(x + y, y - 1, 0)))
					current_id = astar.get_available_point_id()
					astar.add_point(current_id, Vector3(x + y, -y, 0))
					astar.connect_points(current_id, astar.get_closest_point(Vector3(x + y, -y + 1, 0)))
					if x > top_margin:
						astar.connect_points(current_id, astar.get_closest_point(Vector3(x + y - 1, -y, 0)))

	var starting_point_offset = (randi() % (height - (top_margin + bottom_margin))) + top_margin
	var ending_point_offset = (randi() % (height - (top_margin + bottom_margin))) + top_margin
	
	starting_point = Vector2(starting_point_offset, starting_point_offset)
	ending_point = Vector2((diagonal-1) - ending_point_offset, -ending_point_offset)
	
	Map.set_cellv(starting_point, 17)
	Map.set_cellv(ending_point, 17)
	
	var starting_id = astar.get_closest_point(Vector3(starting_point.x, starting_point.y, 0))
	var ending_id = astar.get_closest_point(Vector3(ending_point.x, ending_point.y, 0))
	

	for num in range(num_of_astar_obstacles):
		var current_path = astar.get_point_path(starting_id, ending_id)
		var current_path_section_length = int(round(current_path.size()/(num_of_astar_obstacles)))
		var point_in_section = (randi() % (current_path_section_length - (current_path_section_length/2))) + (current_path_section_length / 4)
		var current_obstacle_point = ((num) * current_path_section_length) + point_in_section
		
		if num == 0 and current_obstacle_point < 3:
			current_obstacle_point = 3
		if num == num_of_astar_obstacles and current_obstacle_point > (current_path.size() - 3):
			current_obstacle_point = current_path.size() - 3
		
		var point_to_change_weight = current_path[current_obstacle_point]
		
		for size in range(size_of_astar_obstacles):
			for tile in [-size, size]:
				# skip cell if it's outside the game area
				if Map.get_cellv(Vector2(point_to_change_weight.x + tile,
									point_to_change_weight.y + tile)) != 15:
					continue
				# add weights to the cell such that astar avoids it
				var current_title_id = astar.get_closest_point(point_to_change_weight + Vector3(tile, tile, 0))
				astar.set_point_weight_scale(current_title_id, 500)
				# change obstacle cell color for debug
				Map.set_cellv(Vector2(point_to_change_weight.x + tile, point_to_change_weight.y + tile), 16)

	final_path = astar.get_point_path(starting_id, ending_id)
	
	for tile in final_path:
		Map.set_cell(tile.x, tile.y, 17)
		yield(get_tree(), "idle_frame")
	
	for tile in final_path:
		var current_tile = N|E|S|W
		for dir in road_connections:
			if Map.get_cellv(Vector2(tile.x, tile.y) + dir) != N|E|S|W:
				if Map.get_cellv(Vector2(tile.x, tile.y) + dir) != 16:
					current_tile -= road_connections[dir]
	
		Map.set_cellv(Vector2(tile.x, tile.y), current_tile)
		
	spawn_enemies()
	
func reset_map():
	# set random seed to random
	randomize()
	# reinitialize AStar
	astar = AStar.new()
	# remove existing enemies from container
	for enemy in enemyContainer.get_children():
		enemyContainer.remove_child(enemy)
		enemy.queue_free()
	# remove enemy refference from enemyPath
	for enemy in enemyPath.get_children():
		enemyPath.remove_child(enemy)
		enemy.queue_free()
	# remove existing towers from container
	for tower in towerContainer.get_children():
		towerContainer.remove_child(tower)
		tower.queue_free()
	
func spawn_enemies():
	# define path which enemies will follow
	var enemy_curve = Curve2D.new()
	for point in final_path:
		# transform from cartesian to isometric and scale by size of tile map
		enemy_curve.add_point(Vector2(
			(point.x - point.y) * tile_h, (point.x + point.y) * tile_w / 4 
		))
	enemyPath.curve = enemy_curve

	for _enemy_idx in range(num_of_enemies):
		# create instance of enemy in a YSort
		var enemy = enemyClass.instance()
		enemyContainer.add_child(enemy)
		
		# refference enemy using remote transform
		var remote_transform = RemoteTransform2D.new()
		remote_transform.remote_path = enemy.get_path()
		
		# create enemy path follower by passing refference
		var enemy_path_follow = PathFollow2D.new()
		enemy_path_follow.add_child(remote_transform)
		enemy_path_follow.rotate = false
		# add path follower to path2D parent
		enemyPath.add_child(enemy_path_follow)
		
		# give enemy information about path it must follow
		var positioning_node_path = get_node(enemy_path_follow.get_path())
		enemy.positioning_node = positioning_node_path
		
		# wait before next enemy spawn based on spawn_rate
		yield(get_tree().create_timer(enemy.spawn_rate), "timeout")
		
func _update_build_tool():
	var mouse_pos = get_global_mouse_position()
	current_tower_tile = Map.world_to_map(mouse_pos)
	buildTool.position = Map.map_to_world(current_tower_tile)
	
	if Map.get_cellv(current_tower_tile) in buildable_tiles:
		current_color = yellow
		can_build = true
	else:
		current_color = red
		can_build = false
	buildInterface.material.set_shader_param("current_color", current_color)
	
func build_tower():
	if can_build:
		Map.set_cellv(current_tower_tile, 16)
		var new_tower = current_tower.instance()
		new_tower.global_position = Map.map_to_world(current_tower_tile)
		towerContainer.add_child(new_tower)
		build_mode = false
		buildTool.hide()
		
func spawn_projectile(_projectile, _pos, _target):
	var projectile = _projectile.instance()
	projectile.position = _pos
	projectile.rotation = Vector2(0, 1).angle_to((_target.position - _pos).normalized())
	projectileContainer.add_child(projectile)

func _on_TowerButton_pressed(tower):
	current_tower = tower_list[tower]
	buildInterface.texture = UI_tower_list[tower]
	build_mode = true
	buildTool.show()
