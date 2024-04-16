extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

var input_movement = Vector2.ZERO

enum player_state {MOVE, JUMP, PUNCH, DISTANCE, ROLL}
var current_state = player_state.MOVE
var speed = 70

func _physics_process(delta):
	match current_state:
		player_state.MOVE:
			move()
		player_state.PUNCH:
			attack()
		player_state.JUMP:
			jump()

func move():
	input_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	$Punch/CollisionShape2D.disabled= true
	
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_movement)
		anim_tree.set("parameters/Walk/blend_position", input_movement)
		anim_tree.set("parameters/Attack/blend_position", input_movement)
		anim_tree.set("parameters/Jump/blend_position", input_movement)
		anim_state.travel("Walk")
		velocity = input_movement * speed
	
	if input_movement == Vector2.ZERO:
		anim_state.travel("Idle")
		velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("attack"):
		current_state = player_state.PUNCH
	
	if Input.is_action_just_pressed("Jump"):
		current_state = player_state.JUMP
	
	move_and_slide()

func attack():
	anim_state.travel("Attack")

func jump():
	anim_state.travel("Jump")
	velocity = input_movement * speed * 1.5
	move_and_slide()

func on_state_change():
	current_state = player_state.MOVE

func clear_collision():
	$CollisionShape2D.disabled = true

func create_collision():
	$CollisionShape2D.disabled = false
