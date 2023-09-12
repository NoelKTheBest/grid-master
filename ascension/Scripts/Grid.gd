extends Node2D

var grid = []
var grid_width = 5
var grid_height = 5
var initial_block_side = 20
var block_scale = 5
var block_side = 100
var initial_position = Vector2(50, 50)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in grid_height:
		grid.append([])
		for j in grid_width:
			grid[i].append(Cell.new()) # Set a starter value for each position
			grid[i][j].position = initial_position + Vector2(100 * i, 100 * j)
	
	_print_grid()

func _print_grid():
	for i in grid_width:
		for j in grid_height:
			print(grid[i][j].position)


class Cell :
	var position
	var ocuppied
