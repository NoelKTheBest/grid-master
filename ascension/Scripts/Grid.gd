# Grid.gd contains all necessary functions for grid initialization, and manipulation

extends Node2D

@export var grid_columns = 3
@export var grid_rows = 5

var grid = []
var occupied_spaces = []
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
	
	initial_position = Vector2((screen_width / 2) - (grid_width / 2) + (inc / 2),
	 screen_height - (screen_height % (int)(inc / 2)) - inc)
	
	for i in grid_rows:
		grid.append([])
		for j in grid_columns:
			grid[i].append(Cell.new()) # Set a starter value for each position
			grid[i][j].position = initial_position + Vector2(inc * j, -inc * i)
			grid[i][j].occupied = true if randi_range(0, 1) == 1 else false
			
			if grid[i][j].occupied:
				occupied_spaces.append(Vector2(grid[i][j].position.x, grid[i][j].position.y))


func _draw():
	for v in occupied_spaces:
		draw_rect(Rect2(v.x - (25.0 / 2), v.y - (25.0 / 2), 25.0, 25.0), Color.GOLD)


func print_grid():
	print("------------New Grid------------")
	
	for i in grid_rows:
		for j in grid_columns:
			print(str(grid[i][j].position) + ", " + str(grid[i][j].occupied))
	
	print("------------Done------------")


func append_new_row():
	grid.append([])
	var grid_len = grid.size() - 1
	
	for j in grid_columns:
		grid[grid_len].append(Cell.new())
		grid[grid_len][j].position = grid[grid_len - 1][0].position + Vector2(inc * j, -inc)
		grid[grid_len][j].occupied = true if randi_range(0, 1) == 1 else false


func pop_last_row():
	grid.pop_front()


func check_row(i, going_right, pos):
	var min_x = 1000
	var cell
	
	for j in grid_columns:
		if grid[i][j].occupied:
			if !going_right:
				var a = pos.x - grid[i][j].position.x
				if a < min_x:
					min_x = a
					cell = grid[i][j]
			else:
				var a = grid[i][j].position.x - pos.x
				if a < min_x:
					min_x = a
					cell = grid[i][j]
	
	return cell


func check_column(j):
	for i in grid_rows:
		if grid[i][j].occupied:
			return grid[i][j]
	
	return null

func clear_row(i):
	for j in grid_columns:
		grid[i][j].occupied = false
		occupied_spaces.erase(grid[i][j].position)


func clear_column(j):
	for i in grid_rows:
		grid[i][j].occupied = false
		occupied_spaces.erase(grid[i][j].position)


func refill_grid():
	occupied_spaces = []
	
	for i in grid_rows:
		for j in grid_columns:
			grid[i][j].occupied = true if randi_range(0, 1) == 1 else false
			if grid[i][j].occupied: occupied_spaces.append(grid[i][j].position)


# Define grid cell class to be used exclusively by the grid
class Cell :
	var position
	var occupied
