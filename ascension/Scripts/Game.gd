extends Node2D

@onready var grid_rows = $Grid.grid_rows
@onready var grid_columns = $Grid.grid_columns
@onready var grid_position = $Grid.initial_position
@onready var grid_inc = $Grid.inc
@onready var grid_outer_bounds = grid_position - Vector2(grid_inc, -grid_inc)

var init_row
var init_column
var row
var column

var is_select_row
var is_select_column
var is_going_right

# Called when the node enters the scene tree for the first time.
func _ready():
	init_row = grid_rows - floor(grid_rows / 2)
	init_column = grid_columns - floor(grid_columns / 2)
	row = init_row
	column = init_column
	is_select_row = false
	is_select_column = false
	is_going_right = true
	
	print(grid_position)
	print(grid_outer_bounds)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Select a column or row to start
	if !is_select_column and !is_select_row:
		if Input.is_action_just_pressed("left"):
			is_select_row = true
			is_going_right = false
		elif Input.is_action_just_pressed("right"):
			is_select_row = true
			is_going_right = true
		elif Input.is_action_just_pressed("up"):
			is_select_column = true
	elif is_select_column:
		if Input.is_action_just_pressed("down"):
			is_select_column = false
		
		if Input.is_action_just_pressed("right"):
			column += 1
		elif Input.is_action_just_pressed("left"):
			column -= 1
		
		column = clamp(column, 0, grid_columns - 1)
	elif is_select_row:
		if Input.is_action_just_pressed("right") and !is_going_right:
			is_select_row = false
		elif Input.is_action_just_pressed("left") and is_going_right:
			is_select_row = false
		
		if !is_going_right:
			if Input.is_action_just_pressed("up"):
				row += 1
			elif Input.is_action_just_pressed("down"):
				row -= 1
			
			row = clamp(row, 0, grid_rows - 1)
		elif is_going_right:
			if Input.is_action_just_pressed("up"):
				row += 1
			elif Input.is_action_just_pressed("down"):
				row -= 1
			
			row = clamp(row, 0, grid_rows - 1)
	
	if is_select_column:
		$RigidBody2D.position = Vector2(_get_position("x"), grid_outer_bounds.y)
	elif is_select_row:
		if !is_going_right:
			$RigidBody2D.position = Vector2(grid_outer_bounds.x + ((init_column + 1) * grid_inc), _get_position("y"))
		else:
			$RigidBody2D.position = Vector2(grid_outer_bounds.x, _get_position("y"))
	
	if Input.is_action_just_pressed("set_block"):
		if is_select_row : print($Grid._check_row(row))
		elif is_select_column : print($Grid._check_column(column))
	#print("row: " + str(row))
	#print("column: " + str(column))


func _get_position(axis):
	if axis == "x" : return $Grid.grid[row][column].position.x
	elif axis == "y" : return $Grid.grid[row][column].position.y
