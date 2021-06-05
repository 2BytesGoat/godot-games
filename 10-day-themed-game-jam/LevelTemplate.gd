extends Node2D

# Tile Map variables
onready var Map = $MapTemplate

# Tile Map custom autotile variables
const N = 1
const E = 2
const S = 4
const W = 8

var road_connections = {Vector2(0, -1): N, Vector2( 1, 0): E,
						Vector2(0,  1): S, Vector2(-1, 0): W}

# Astar variables
var astar = AStar.new()

## buffers such that the path does not start from an edge
const top_margin = 2
const bottom_margin = 3

var num_of_astar_obstacles = 5
var size_of_astar_obstacles = 5

var starting_point
var ending_point
var final_path

# Autotile metadata
var hypotenuse = 24 # hypotenuse or diagonal length of the map

func _ready():
	randomize()
	create_map() 
	
func _physics_process(_delta):
	pass
	
func create_map():
	var current_id = Vector3.ZERO
	var height = hypotenuse / 2
	for y in range(height):
		var length = hypotenuse - (2 * y)
		for x in range(length):
			Map.set_cell(x + y, y, 15)
			if y != 0: # ignores second pass on diagonal
				Map.set_cell(x + y, -y, 15)
			
			if x >= top_margin and x <= (length - bottom_margin):
				current_id = astar.get_available_point_id()
				astar.add_point(current_id, Vector3(x + y, y, 0))
				if x > top_margin:
					astar.connect_points(current_id, astar.get_closest_point(Vector3(x + y - 1, y, 0)))

			if y != 0:
				astar.connect_points(current_id, astar.get_closest_point(Vector3(x + y, y - 1, 0)))
				current_id = astar.get_available_point_id()
				astar.add_point(current_id, Vector3(x + y, -y, 0))
				astar.connect_points(current_id, astar.get_closest_point(Vector3(x + y, -y + 1, 0)))
				if x > top_margin:
					astar.connect_points(current_id, astar.get_closest_point(Vector3((x + y) - 1, -y, 0)))

	var starting_point_offset = (randi() % (height - (top_margin + bottom_margin))) + top_margin
	var ending_point_offset = (randi() % (height - (top_margin + bottom_margin))) + top_margin
	
	var starting_point = Vector2(starting_point_offset, starting_point_offset)
	var ending_point = Vector2((hypotenuse-1) - ending_point_offset, -ending_point_offset)
	
	Map.set_cellv(starting_point, 17)
	Map.set_cellv(ending_point, 17)
	
	var starting_id = astar.get_closest_point(Vector3(starting_point.x, starting_point.y, 0))
	var ending_id = astar.get_closest_point(Vector3(ending_point.x, ending_point.y, 0))
	
	"""
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
				var current_title_id = astar.get_closest_point(point_to_change_weight + Vector3(tile, tile, 0))
				astar.set_point_weight_scale(current_title_id, 500)
				Map.set_cellv(Vector2(point_to_change_weight.x + tile, point_to_change_weight.y + tile), 16)
	"""
	final_path = astar.get_point_path(starting_id, ending_id)
	
	for tile in final_path:
		Map.set_cell(tile.x, tile.y, 17)
