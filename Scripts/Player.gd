extends KinematicBody2D

var movespeed = 400



enum MoveDirection { UP, DOWN, LEFT, RIGHT, NONE}

slave var slave_position = Vector2()
slave var slave_movement = MoveDirection.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process (delta):
	var direction = []
	if is_network_master():	
		if Input.is_action_pressed("player_up"):
			direction.append(MoveDirection.UP) 		
		if Input.is_action_pressed("player_down"):
			direction.append(MoveDirection.DOWN) 	
		if Input.is_action_pressed("player_left"):
			direction.append(MoveDirection.LEFT) 	
		if Input.is_action_pressed("player_right"):
			direction.append(MoveDirection.RIGHT) 	
		
		rset_unreliable('slave_position', position)
		rset_unreliable('slave_movement', direction)
		_move(direction, delta)
	
	else:
		_move(slave_movement, delta)
		position = slave_position
		
	if get_tree().is_network_server():
		Network.update_position(int(name), position)
		
func _move(direction, delta):
	print(direction)
	print(delta)
	var velocity = Vector2()
	if not direction:
		return
	if MoveDirection.RIGHT in direction:
		velocity.x += 1
	if  MoveDirection.LEFT in direction:
		velocity.x -= 1
	if MoveDirection.DOWN in direction:
		velocity.y += 1
	if MoveDirection.UP in direction:
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * movespeed

	position += velocity * delta



		
func init(name, position, is_slave):
	position = position
	if is_slave:
		$Sprite.texture = load('res://Resources/Player.png')
