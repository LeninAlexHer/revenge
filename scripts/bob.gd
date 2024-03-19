extends CharacterBody2D

const moveSpeed = 50
const maxSpeed = 100

const jumpHeight = -300.0
const counterDashCooldown = 1

var gravity = 15

@export var can_dash: bool
var dash : bool

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer

var timer = 1

var motion = Vector2()

func _physics_process(_delta):
	velocity.y += gravity
	var friction = false

	if Input.is_action_pressed("move_right"):
		sprite.flip_h = true
		animationPlayer.play("Walk")
		velocity.x = min(velocity.x + moveSpeed, maxSpeed)

	elif Input.is_action_pressed("move_left"):
		sprite.flip_h = false
		animationPlayer.play("Walk")
		velocity.x = max(velocity.x - moveSpeed, -maxSpeed)
		
	else:
		animationPlayer.play("Idle")
		friction = true
		
	if Input.is_action_pressed("move_dash"):
			dash_timer()
			
	if is_on_floor():
		if Input.is_action_pressed("move_up"):
			velocity.y = jumpHeight
		if friction:
			velocity.x = lerp(velocity.x, 0.0, 0.5)
	else:
		if friction:
			velocity.x = lerp(velocity.x, 0.0, 0.01)
			
	move_and_slide()

func dash_timer():
	if sprite.flip_h == true:
		velocity.x = max(velocity.x , maxSpeed * 3)
	elif sprite.flip_h == false:
		velocity.x = min(velocity.x , -(maxSpeed * 3))
