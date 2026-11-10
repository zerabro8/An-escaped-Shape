extends CharacterBody2D

var MAX_SPEED = 100
var ROAMING_SPEED = 50
const CENTER = Vector2(450,300)
enum {CHASING, ROAMING}
var state = ROAMING
var body_to_chase : CharacterBody2D
var random_target_pos : Vector2 = Vector2(450,300)
var _position_last_frame := Vector2()
var _cardinal_direction = 0
@onready var chase_timer: Timer = $Node/Chase_timer
@onready var walk_timer: Timer = $Node/Walk_timer
@onready var rest_timer: Timer = $Node/Rest_timer
@onready var Guard_animation: AnimatedSprite2D = $Guard_animation


func _process(delta):
	match state:
		CHASING:
			position += position.direction_to(body_to_chase.position) * MAX_SPEED * delta
		ROAMING:
			if position.distance_to(random_target_pos) <= ROAMING_SPEED * delta:
				random_target_pos = CENTER + Vector2(0,100).rotated(randf() * 2 * PI)
			else:
				position += position.direction_to(random_target_pos) * ROAMING_SPEED * delta
	



func _ready() -> void:
	_on_rest_timer_timeout()

func _physics_process(delta):
	# Get motion vector between previous and current position
	var motion = position - _position_last_frame

	# If the node actually moved, we'll recompute its direction.
	# If it didn't, we'll just the last known one.
	if motion.length() > 0.0001:
		# Now if you want a value between N.S.W.E,
		# you can use the angle of the motion.
		# I came up with this formula last time I needed it:
		_cardinal_direction = int(4.0 * (motion.rotated(PI / 4.0).angle() + PI) / TAU)

	# And now you have it!
	# You can even use it with an array since it's like an index
	match _cardinal_direction:
		0:
			
			Guard_animation.play("Guard_walk_left")
		1:
			
			Guard_animation.play("Guard_walk_forward")
		2:
			
			Guard_animation.play("Guard_walk_right")
		3:
			
			Guard_animation.play("Guard_walk_backward")

	# Remember our current position for next frame
	_position_last_frame = position


func _on_rest_timer_timeout() -> void:
	walk_timer.start()
	state = ROAMING
	ROAMING_SPEED = 50


func _on_walk_timer_timeout() -> void:
	rest_timer.start()
	ROAMING_SPEED = 0


func _on_player_detector_g_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		walk_timer.stop()
		rest_timer.stop()
		chase_timer.start()
		state = CHASING
		body_to_chase = body
		


func _on_chase_timer_timeout() -> void:
	_on_rest_timer_timeout()
	print("Chase Stops")
