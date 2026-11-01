extends CharacterBody3D

@export_category("Mouse Settings")
@export var valorant_sens: float = 0.35
@export var head: Camera3D

@export_category("Gun Settings")
@export var guns: Array[Node3D]
@export var max_bullets: int = 3
@export var gun_recoil_kick: float = 0.15
@export var gun_recoil_rotation: float = 6.0
@export var recoil_snappiness: float = 25.0
@export var recoil_return_speed: float = 12.0
@export var hitscan_ray: RayCast3D

@export_category("Camera Screenshake Settings")
@export var random_strength: float = 25.0
@export var shake_fade: float = 8.0
@export var backward_kick_strength: float = 0.12

@export_category("UI Settings")
@export var ui_scene : CanvasLayer

const VALORANT_SCALAR: float = 0.00122173
var mouse_motion: Vector2 = Vector2.ZERO
var shoot_timer: float = 0.0
var bullets: int = 3

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var head_default_position: Vector3

var gun: Node3D
var curr_gun: int = 0
var default_gun_pos: Vector3
var default_gun_rot: Vector3
var target_gun_pos: Vector3
var target_gun_rot: Vector3

func _ready() -> void:
	gun = guns[curr_gun]
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if gun:
		if "fire_rate" in gun:
			gun.fire_rate = gun.fire_rate
		shot_time = 1.0 / 9.75
		default_gun_pos = gun.position
		default_gun_rot = gun.rotation
		target_gun_pos = default_gun_pos
		target_gun_rot = default_gun_rot
	
	if head:
		head_default_position = head.position

var shot_time: float = 1.0 / 9.75

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_move_head(event.relative)

func _process(delta: float) -> void:
	if !gun.sprayable:
		max_bullets = 1
	else:
		max_bullets = 3
	
	shoot_timer -= delta
	ui_scene._ammo(bullets)
	_shoot()
	_calculate_screenshake(delta)
	_update_gun_recoil(delta)
	_select_gun()

func _select_gun():
	if Input.is_action_just_released("scroll_down") and curr_gun < guns.size() - 1:
		guns[curr_gun].visible = false
		guns[curr_gun + 1].visible = true
		gun = guns[curr_gun + 1]
		curr_gun += 1
		_update_gun_stats()
		
	elif Input.is_action_just_released("scroll_up") and curr_gun > 0:
		guns[curr_gun].visible = false
		guns[curr_gun - 1].visible = true
		gun = guns[curr_gun - 1]
		curr_gun -= 1
		_update_gun_stats()

func _update_gun_stats():
	if "fire_rate" in gun:
			gun.fire_rate = gun.fire_rate
	shot_time = 1.0 / 9.75
	default_gun_pos = gun.position
	default_gun_rot = gun.rotation
	target_gun_pos = default_gun_pos
	target_gun_rot = default_gun_rot

func _move_head(motion: Vector2) -> void:
	var rotation_amount = motion * valorant_sens * VALORANT_SCALAR
	rotate_y(-rotation_amount.x)
	
	if head:
		var new_rot_x = head.rotation.x - rotation_amount.y
		head.rotation.x = clamp(new_rot_x, deg_to_rad(-89.0), deg_to_rad(89.0))

func _shoot() -> void:
	if shoot_timer <= 0 and Input.is_action_pressed("fire") and bullets > 0:
		if gun and gun.has_method("_shoot"):
			gun._shoot()
		shoot_timer = shot_time
		bullets -= 1
		_apply_shake(random_strength)
		_apply_gun_recoil()

		if hitscan_ray.is_colliding():
			if hitscan_ray.get_collider().has_method("_hit"):
				hitscan_ray.get_collider()._hit()
	
	if Input.is_action_just_released("fire"):
		bullets = max_bullets
		stop_shake()

func _apply_shake(strength: float) -> void:
	shake_strength = strength

func stop_shake() -> void:
	shake_strength = 0.0
	if head:
		head.position = head_default_position

func _calculate_screenshake(dt: float) -> void:
	if not head:
		return
		
	if shake_strength > 0.001:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * dt)
		var offset = _random_offset()
		var z_kick = (shake_strength / random_strength) * backward_kick_strength
		head.position = head_default_position + Vector3(offset.x, offset.y, z_kick)
	else:
		stop_shake()

func _random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)

func _apply_gun_recoil() -> void:
	target_gun_pos = default_gun_pos + Vector3(0, 0, gun_recoil_kick)
	target_gun_rot = default_gun_rot + Vector3(deg_to_rad(-gun_recoil_rotation), 0, 0)

func _update_gun_recoil(delta: float) -> void:
	if not gun:
		return
		
	target_gun_pos = lerp(target_gun_pos, default_gun_pos, recoil_return_speed * delta)
	target_gun_rot = lerp(target_gun_rot, default_gun_rot, recoil_return_speed * delta)
	
	gun.position = lerp(gun.position, target_gun_pos, recoil_snappiness * delta)
	gun.rotation = lerp(gun.rotation, target_gun_rot, recoil_snappiness * delta)
