extends Node2D

# Grab values from out grid node to setup the game. The grid needs to be initialized first
@onready var grid_rows = $Grid.grid_rows
@onready var grid_columns = $Grid.grid_columns
@onready var grid_position = $Grid.initial_position
@onready var grid_inc = $Grid.inc
@onready var grid_outer_bounds = grid_position - Vector2(grid_inc, -grid_inc)

var init_row
var init_column
var row
var column

var selecting_row
var selecting_column
var going_right

# Called when the node enters the scene tree for the first time.
func _ready():
	init_row = grid_rows - floor(grid_rows / 2)
	init_column = grid_columns - floor(grid_columns / 2)
	row = init_row
	column = init_column
	selecting_row = false
	selecting_column = false
	going_right = true


# Check for inputs regarding various actions and utilize grid functions
func _process(_delta):
	
	# Select a column or row to start
	if !selecting_column and !selecting_row:
		if Input.is_action_just_pressed("left"):
			selecting_row = true
			going_right = false
		elif Input.is_action_just_pressed("right"):
			selecting_row = true
			going_right = true
		elif Input.is_action_just_pressed("up"):
			selecting_column = true
	elif selecting_column:
		if Input.is_action_just_pressed("down"):
			selecting_column = false
		
		if Input.is_action_just_pressed("right"):
			column += 1
		elif Input.is_action_just_pressed("left"):
			column -= 1
		
		column = clamp(column, 0, grid_columns - 1)
	elif selecting_row:
		if Input.is_action_just_pressed("right") and !going_right:
			selecting_row = false
		elif Input.is_action_just_pressed("left") and going_right:
			selecting_row = false
		
		if !going_right:
			if Input.is_action_just_pressed("up"):
				row += 1
			elif Input.is_action_just_pressed("down"):
				row -= 1
			
			row = clamp(row, 0, grid_rows - 1)
		elif going_right:
			if Input.is_action_just_pressed("up"):
				row += 1
			elif Input.is_action_just_pressed("down"):
				row -= 1
			
			row = clamp(row, 0, grid_rows - 1)
	
	if selecting_column:
		$RigidBody2D.position = Vector2(_get_position("x"), grid_outer_bounds.y)
		$".".queue_redraw()
	elif selecting_row:
		if !going_right:
			$RigidBody2D.position = Vector2(grid_outer_bounds.x + ((grid_columns + 1) * grid_inc),
			 _get_position("y"))
		else:
			$RigidBody2D.position = Vector2(grid_outer_bounds.x, _get_position("y"))
		
		$".".queue_redraw()
	
	if Input.is_action_just_pressed("set_block"):
		if selecting_row:
			print(row)
			var cell = $Grid.check_row(row, going_right, $RigidBody2D.position)
			if cell != null:
				$RigidBody2D.position = cell.position
				selecting_row = false
		elif selecting_column:
			print(column)
			var cell = $Grid.check_column(column)
			if cell != null:
				$RigidBody2D.position = cell.position
				selecting_column = false
	
	if Input.is_action_just_pressed("delete"):
		if selecting_row: $Grid.clear_row(row)
		if selecting_column: $Grid.clear_column(column)
		$Grid.queue_redraw()
	
	if Input.is_action_just_pressed("refill"):
		$Grid.refill_grid()
		$Grid.queue_redraw()


func _draw():
	if selecting_row:
		draw_rect(Rect2(grid_position.x - (grid_inc / 2), _get_position("y") - (grid_inc / 2),
		 grid_columns * grid_inc, grid_inc), Color.ORANGE, false, 1)
	
	if selecting_column:
		draw_rect(Rect2(_get_position("x") - (grid_inc / 2),
		 grid_position.y  - (grid_rows * grid_inc) + (grid_inc / 2),
		 grid_inc, grid_inc + (grid_rows * grid_inc)), Color.ORANGE, false, 1)
	

func _get_position(axis):
	if axis == "x" : return $Grid.grid[row][column].position.x
	elif axis == "y" : return $Grid.grid[row][column].position.y
