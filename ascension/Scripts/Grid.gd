extends Node2D

@export var grid_columns = 3
@export var grid_rows = 5

var grid = []
var block_scale
var initial_position
var inc
var block_path = "../RigidBody2D/CollisionShape2D"

var screen_width
var screen_height
var grid_width


# Called when the node enters the scene tree for the first time.
func _ready():
	var block_size = get_node(block_path).shape.get_rect().size
	block_scale = get_node(block_path).scale
	inc = block_size.x * block_scale.x
	grid_width = inc * grid_columns
	
	screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	print(screen_width)
	print(screen_height)
	
	initial_position = Vector2((screen_width / 2) - (grid_width / 2) + (inc / 2),
	 screen_height - (screen_height % (int)(inc / 2)) - inc)
	
	for i in grid_rows:
		grid.append([])
		for j in grid_columns:
			grid[i].append(Cell.new()) # Set a starter value for each position
			grid[i][j].position = initial_position + Vector2(inc * j, -inc * i)
			grid[i][j].occupied = false
	
	_print_grid()


func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		_append_new_row()
		_pop_last_row()
		_print_grid()



func _print_grid():
	print("------------New Grid------------")
	
	for i in grid_rows:
		for j in grid_columns:
			print(str(grid[i][j].position) + ", " + str(grid[i][j].occupied))
	
	print("------------Done------------")


func _append_new_row():
	grid.append([])
	var len = grid.size() - 1
	
	for j in grid_columns:
		grid[len].append(Cell.new())
		grid[len][j].position = grid[len - 1][0].position + Vector2(inc * j, -inc)
		grid[len][j].occupied = false


func _pop_last_row():
	grid.pop_front()


func _check_row(i):
	for j in grid_columns:
		if grid[i][j].occupied:
			return grid[i][j]
	
	return false


class Cell :
	var position
	var occupied
