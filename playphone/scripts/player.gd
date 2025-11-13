extends CharacterBody2D

@export var boostStrength: float = 700.0;
@export var coyoteTime: float = 0.2;
const SPEED = 250.0;
const JUMP_VELOCITY = -300.0;
const DASH_VELOCITY = 400;
const DEATH_Y = 100;
var coyoteTimer = coyoteTime;
var dashCount = 1;
var extraJumps = 1;
var accel: Vector2 = Vector2.ZERO;
@onready var line2d = $Line2D;

func death():
	var spawn = get_parent().get_child(2).get_child(0).get_node("SpawnPoint")
	line2d.clear_points()
	if spawn:
		global_position = spawn.global_position


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if Input.is_action_just_pressed("dash") and (dashCount > 0 and direction != 0):
		accel.x = DASH_VELOCITY * direction
		if dashCount > 0:
			dashCount -= 1

	# Jumpand (is_on_floor() or extraJumps > 0)
	if Input.is_action_just_pressed("up") and (is_on_floor() or extraJumps > 0 or coyoteTimer > 0):
		velocity.y = JUMP_VELOCITY
		if coyoteTimer <= 0 and extraJumps > 0:
			extraJumps -= 1

	if is_on_floor():
		extraJumps = 1
		dashCount = 1
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= delta

	if direction != 0:
		velocity.x = direction * SPEED + accel.x
		$AnimatedSprite2D.flip_h = direction < 0
		if not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

	if is_on_floor():
		accel.x = move_toward(accel.x, 0, 50)
	else:
		accel.x = move_toward(accel.x, 0, 10)

	if position.y >= DEATH_Y:
		death()
	
	line2d.enabled = abs(velocity.x) > SPEED

	move_and_slide()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	velocity.y = -boostStrength


func _on_area_2d_body_entered(_body: Node2D) -> void:
	velocity.y = -boostStrength


func _on_hurtbox_body_entered(_body: Node2D) -> void:
	death()


func _on_hurtbox_area_entered(_area: Area2D) -> void:
	death()
