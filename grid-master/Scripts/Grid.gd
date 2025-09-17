# Grid.gd contains all necessary functions for grid initialization, and manipulation

extends Node2D

@export var grid_columns = 7
@export var grid_rows = 5
@export var initial_cell_size = 20
@export var cell_scale = 5
var cell_size

var grid = []
var occupied_spaces = []
var occupied_cells = []
var open_cells = []

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
	calculate_cell_size(1, 1)
	grid_width = inc * grid_columns
	
	screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	initial_position = Vector2((screen_width / 2) - (grid_width / 2) + (inc / 2),
	 200)
	var bottom_screen_position = screen_height - (screen_height % (int)(inc / 2)) - inc
	
	
	for i in grid_rows:
		grid.append([])
		for j in grid_columns:
			grid[i].append(Cell.new()) # Set a starter value for each position
			var new_cell = grid[i][j]
			new_cell.position = initial_position + Vector2(inc * j, inc * i)
			new_cell.row = i
			new_cell.column = j
			new_cell.occupied = true if randi_range(0, 1) == 1 else false
			set_edges(i, j, new_cell)
			
			# add cells and positions to occupied arrays
			if new_cell.occupied:
				occupied_spaces.append(Vector2(new_cell.position.x, new_cell.position.y))
				occupied_cells.append(new_cell)
	
	print_grid()


# mask is applied everytime _draw() is called
func _draw():
	# new scales
	var ns = apply_mask(0, 0, grid.size(), 0, 0.5)
	var nsi = 0
	var nsx = 1
	var nsy = 1
	
	for v in occupied_spaces:
		if ns.size() != 0:
			if ns[nsi] == v:
				nsx = 0.5
				nsy = 0.5
				nsi += 1
				nsi = clampi(nsi, 0, ns.size() - 1)
			else:
				nsx = 1
				nsy = 1
		
		draw_rect(Rect2(v.x - ((cell_size.x * nsx) / 2), v.y - ((cell_size.y * nsy) / 2), cell_size.x * nsx, cell_size.y * nsy), Color.GOLD)
		


# --------------------------- Grid Creation --------------------------
func calculate_cell_size(x_multi: float, y_multi: float):
	"""
	Calculates size of cells using cell_scale and x and y multipliers
	
	Args:
		x_multi (float): x multiplication value: 0-1
		y_multi (float): y multiplication value: 0-1
	"""
	cell_size = (initial_cell_size * cell_scale) * Vector2(1, 1)


# ---------------------------- Grid Query ---------------------------- 
func print_grid():
	print("------------New Grid------------")
	
	for i in grid_rows:
		for j in grid_columns:
			print(str(grid[i][j].position) + ", " + str(grid[i][j].occupied))
	
	print("------------Done------------")


func check_row(i, going_right, pos):
	var min_x = 1000
	var cell
	
	for j in grid_columns:
		if grid[i][j].occupied:
			var a = grid[i][j].position.distance_to(pos)
			if a < min_x:
				min_x = a
				cell = grid[i][j]
				check_adjacent_cells(i, j)
	
	return cell


func check_column(j):
	for i in grid_rows:
		if grid[i][j].occupied:
			check_adjacent_cells(i, j)
			return grid[i][j]
	
	return null


func get_cell(i, j):
	return grid[i][j]


# check all cells in a n x n square 
func check_adjacent_cells(i, j):
	open_cells = []
	var col_start = j - 1
	var col_end = j + 1
	var row_start = i - 1
	var row_end = i + 1
	
	if grid[i][j].edges.has("up"): row_end -= 1
	if grid[i][j].edges.has("down"): row_start += 1
	if grid[i][j].edges.has("left"): col_start += 1
	if grid[i][j].edges.has("right"): col_end -= 1
	
	for n in range(row_start, row_end + 1):
		for m in range(col_start, col_end + 1):
			var cell = grid[n][m]
			if !cell.occupied: open_cells.append(cell)
	
	print(open_cells)


# Check all adjacent cells within a specific range
func check_adjacent_cells_range():
	pass


func get_min_distance(i, j, open_cells):
	var min_dist = 1000
	var new_cell
	
	for cell in open_cells:
		var a = grid[i][j].position.distance_to(cell.position)
		if a < min_dist:
			min_dist = a
			new_cell = cell
	
	return new_cell


# Sets the edges for cells at the edge of the grid
func set_edges(i, j, c):
	if i == 0: c.edges.append("down")
	if i == grid_rows - 1: c.edges.append("up")
	if j == 0: c.edges.append("left")
	if j == grid_columns - 1: c.edges.append("right")


func get_edges(i, j):
	return grid[i][j].edges


func get_axis(i, j, axis):
	return grid[i][j].position.x if axis == "x" else grid[i][j].position.y


# ---------------------------- Grid Manipulation ---------------------------- 
func clear_row(i):
	for j in grid_columns:
		grid[i][j].occupied = false
		occupied_spaces.erase(grid[i][j].position)


func clear_column(j):
	for i in grid_rows:
		grid[i][j].occupied = false
		occupied_spaces.erase(grid[i][j].position)


# rerolls grid, creating new occupied spaces arrays
func refill_grid():
	occupied_spaces = []
	occupied_cells = []
	
	for i in grid_rows:
		for j in grid_columns:
			grid[i][j].occupied = true if randi_range(0, 1) == 1 else false
			if grid[i][j].occupied: 
				occupied_spaces.append(grid[i][j].position)
				occupied_cells.append(grid[i][j])


func append_new_row():
	grid.append([])
	var grid_len = grid.size() - 1
	
	for j in grid_columns:
		grid[grid_len].append(Cell.new())
		grid[grid_len][j].position = grid[grid_len - 1][0].position + Vector2(inc * j, -inc)
		grid[grid_len][j].occupied = true if randi_range(0, 1) == 1 else false


func pop_last_row():
	grid.pop_front()


# Edits scale of a specific grid element
func edit_cell_scale(i, j):
	pass


# Applies a simple rectangle mask (to be continued....)
func apply_mask(i, j, i_range, j_range, new_scale):
	print(i)
	print(j)
	print(i_range)
	print(j_range)
	print(new_scale)
	
	var return_array = []
	
	for c in occupied_cells:
		if (c.row >= i and c.row <= i_range) and (c.column >= j and c.column <= j_range):
			print("mask applies")
			return_array.append(c.position)
		print("row: " + str(c.row) + "; column: " + str(c.column))
	
	print(return_array)
	return return_array


func edit_grid_scale():
	pass


func append_layer():
	pass


func copy_to_layer(layer):
	pass


func cut_to_layer(layer):
	pass


func create_mask_from_selection(selected_cells):
	pass


# Define grid cell class to be used exclusively by the grid
class Cell :
	var position
	var occupied
	var row
	var column
	var edges = []
	var local_scale
