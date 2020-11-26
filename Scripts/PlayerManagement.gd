extends KinematicBody2D

var movespeed = 10

var playerPosition = Vector2()

enum MoveDirection { UP, DOWN, LEFT, RIGHT, NONE}

slave var slave_position = Vector2()
slave var slave_movement = MoveDirection.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var direction = MoveDirection.NONE
	if is_network_master():	
		if Input.is_action_pressed("player_up"):
			direction = MoveDirection.UP
		if Input.is_action_pressed("player_down"):
			direction = MoveDirection.DOWN
		if Input.is_action_pressed("player_left"):
			direction = MoveDirection.LEFT
		if Input.is_action_pressed("player_right"):
			direction = MoveDirection.RIGHT
		
		rset_unreliable('slave_position', position)
		rset_unreliable('slave_movement', direction)
		_move(direction)
	
	else:
		_move(slave_movement)
		position = slave_position
		
	if get_tree().is_network_server():
		Network.update_position(int(name), playerPosition)
		
func _move(direction):
	match direction: 
		MoveDirection.NONE: 
			return
		MoveDirection.UP:
			move_and_collide(Vector2(0, -movespeed))
		MoveDirection.DOWN:
			move_and_collide(Vector2(0, movespeed))
		MoveDirection.LEFT:
			move_and_collide(Vector2(-movespeed, 0 ))
		MoveDirection.RIGHT:
			move_and_collide(Vector2(movespeed, 0 ))
		
func init(name, position, is_slave):
	playerPosition = position
	if is_slave:
		$Sprite.texture = load('res://Resources/Player.png')
