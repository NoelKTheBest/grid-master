extends Node2D

@onready var grid_position = $"../Grid".initial_position
@onready var max_rows = $"../Grid".grid_rows + 1
@onready var max_columns = $"../Grid".grid_columns
@onready var max_blocks = max_rows * max_columns

var blocks = []

var block_scene = preload("res://Scenes/MovableBlock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in max_blocks:
		var instance = block_scene.instantiate()
		add_child(instance)
		blocks.append(instance)
		instance.visible = false
		instance.position = grid_position
	
	print(blocks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
