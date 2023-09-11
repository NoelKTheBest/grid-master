extends RigidBody2D

@export var speed = 300
var active

# Called when the node enters the scene tree for the first time.
func _ready():
	# set active to true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# get inputs
	# move_and_collide()
	pass

# func _on_collision_enter():
	# if collided with another block
		# set active to false
	# if collided with player
		# set player velocity to our velocity
