extends CharacterBody2D

@export var walk_speed = 100
@export var sprint_bonus = 70
var max_speed = 170



func get_input():
	var input_direction = Input.get_vector("left", "right", "forward", "back")
	velocity = input_direction * walk_speed
	_sprint()

func move():
	if Input.is_action_pressed("left") and Input.is_action_pressed("forward"):
		($Player_animation as AnimatedSprite2D).play("Player_walk_left")
	if Input.is_action_pressed("left") and Input.is_action_pressed("back"):
		($Player_animation as AnimatedSprite2D).play("Player_walk_left")
	if Input.is_action_pressed("right") and Input.is_action_pressed("forward"):
		($Player_animation as AnimatedSprite2D).play("Player_walk_right")
	if Input.is_action_pressed("right") and Input.is_action_pressed("back"):
		($Player_animation as AnimatedSprite2D).play("Player_walk_right")
	elif Input.is_action_pressed("right"):
		($Player_animation as AnimatedSprite2D).play("Player_walk_right")
	elif Input.is_action_pressed("left"):
		($Player_animation as AnimatedSprite2D).play("Player_walk_left")
	elif Input.is_action_pressed("forward"):
		($Player_animation as AnimatedSprite2D).play("Player_walk_forward")
	elif Input.is_action_pressed("back"):
		($Player_animation as AnimatedSprite2D).play("Player_walk_back")
	
	

func _physics_process(delta):
	get_input()
	move_and_slide()
	move()

func _sprint():
	if Input.is_action_just_pressed("sprint"):
		walk_speed = max_speed
	elif Input.is_action_just_released("sprint"):
		walk_speed = 100
