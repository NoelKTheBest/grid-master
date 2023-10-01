extends RigidBody2D

@export var speed = 300
var active

# Called when the node enters the scene tree for the first time.
func _ready():
	# set active to true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# get inputs
	# move_and_collide()
	var x_velocity = Input.get_axis("left", "right")
	var y_velocity = Input.get_axis("up", "down")
	move_and_collide(Vector2(x_velocity, y_velocity))
	pass

