extends CharacterBody2D

@export var boostStrength: float = 700.0;
@export var coyoteTime: float = 0.2;

@export var zoom_strength: float = 0.0010;
@export var zoom_speed: float = 5.0

const SPEED = 250.0;
const JUMP_VELOCITY = -300.0;
const DASH_VELOCITY = 400;
const DEATH_Y = 100;
var coyoteTimer = coyoteTime;
var dashCount = 1;
var hasDashed : bool = false;
var isDashing : bool = false;
var extraJumps = 1;
var accel: Vector2 = Vector2.ZERO;
@onready var line2d = $Line2D;
@onready var sprite := $AnimatedSprite2D
@onready var initCameraZoom = $Camera2D.zoom;

func death():
	var spawn = get_parent().get_child(2).get_child(0).get_node("SpawnPoint")
	line2d.clear_points()
	if spawn:
		global_position = spawn.global_position

# who up rotting they brain rn
var sixsevendetector: Array[int] = []
var brainrotcombo: Array[int] = [KEY_6, KEY_7]
@onready var sixsevensound = $sixseven

# six seveeeeeeen
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		sixsevendetector.append(event.keycode)

		if sixsevendetector.size() > brainrotcombo.size():
			sixsevendetector.pop_front()

		if sixsevendetector == brainrotcombo:
			sixsevensound.play()
			sixsevendetector.clear()

func _physics_process(delta: float) -> void:
	
	velocity.y += get_gravity().y * delta
	
	var direction := Input.get_axis("left", "right")

	if Input.is_action_just_pressed("dash") and dashCount > 0 and direction != 0:
		accel.x = DASH_VELOCITY * direction
		dashCount -= 1
		hasDashed = true
		isDashing = true
		sprite.play("dash")

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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor():
		accel.x = move_toward(accel.x, 0, 50)
	else:
		accel.x = move_toward(accel.x, 0, 10)

	if position.y >= DEATH_Y:
		death()
	
	line2d.enabled = abs(velocity.x) > SPEED
	
	move_and_slide()

	if abs(velocity.x) > 5.0:
		sprite.flip_h = velocity.x < 0

	if not isDashing:
		if not is_on_floor():
			if velocity.y < 0:
				if sprite.animation != "jump":
					sprite.play("jump")
			else:
				if sprite.animation != "fall":
					sprite.play("fall")

		elif abs(velocity.x) > 5.0:
			if sprite.animation != "walk":
				sprite.play("walk")
		else:
			if sprite.animation != "idle":
				sprite.play("idle")
	
	# zOOOOOm
	var vertical_speed = abs(velocity.y)
	var target_zoom_factor = initCameraZoom.x - (vertical_speed * zoom_strength)
	target_zoom_factor = clamp(target_zoom_factor, 0.5, initCameraZoom.x)
	var target_vector = Vector2(target_zoom_factor, target_zoom_factor)
	$Camera2D.zoom = $Camera2D.zoom.lerp(target_vector, zoom_speed * delta)

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "dash":
		isDashing = false
		if not is_on_floor():
			sprite.play("fall")
		else:
			sprite.play("idle")

func _on_area_2d_area_entered(_area: Area2D) -> void:
	velocity.y = -boostStrength

func _on_area_2d_body_entered(_body: Node2D) -> void:
	velocity.y = -boostStrength

func _on_hurtbox_body_entered(_body: Node2D) -> void:
	death()

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	death()
