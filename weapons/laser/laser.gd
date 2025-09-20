extends Area2D

@export var max_length := 300
@export var dps = 100
@export var growth_time := .1

@onready var line_2d: Line2D = %Line2D
@onready var line_width := line_2d.width
@onready var collision_circle : CircleShape2D = %CollisionShape2D.shape
@onready var casting_particles: GPUParticles2D = %CastingParticles2D
@onready var collision_particles: GPUParticles2D = %CollisionParticles2D
@onready var beam_particles: GPUParticles2D = %BeamParticles2D
@onready var collision_light: PointLight2D = %CollisionLight
@onready var rc: RayCast2D = %RayCast2D

var tween: Tween = null
var laser_active := false
var current_target : Mob

func _ready() -> void:
	set_length(max_length)
	casting_particles.position = %Line2D.points[0]
	beam_particles.position = %Line2D.points[0]
	collision_light.visible = false
	%Line2D.visible = false

func _physics_process(delta: float) -> void:
	var bodies := get_overlapping_bodies()
	if bodies.is_empty():
		_clear_aim_and_hide()
		return

	# 1) Find nearest mob that we can actually raycast-hit (no blockers).
	var target_enemy := find_valid_mob(bodies)
	if target_enemy == null:
		_clear_aim_and_hide()
		return

	# 2) Aim ray at that mob and confirm the hit point/end.
	var local_target = rc.to_local(target_enemy.global_position)
	rc.target_position = local_target
	rc.force_raycast_update()

	var end_local: Vector2 = local_target
	var hit_mob := false
	if rc.is_colliding():
		var col := rc.get_collider()
		hit_mob = _collider_matches_target(col, target_enemy)
		end_local = to_local(rc.get_collision_point())

	if hit_mob:
		current_target = target_enemy
		target_enemy.take_damage(dps * delta)
		collision_particles.position = end_local
		collision_particles.emitting = true
		collision_light.visible = true
	else:
		current_target = null
		collision_particles.emitting = false
		collision_light.visible = false

	# 3) Orient visuals/particles and draw line.
	var dir_local: Vector2 = end_local - %Line2D.points[0]
	if dir_local.length_squared() > 0.0001:
		var ang := dir_local.angle()
		casting_particles.rotation = ang
		beam_particles.rotation = ang
		beam_particles.emitting = true
		var half_len := end_local.distance_to(%Line2D.points[0]) * 0.5
		beam_particles.process_material.emission_shape_offset.x = half_len
		beam_particles.process_material.emission_box_extents.x = half_len

	appear()
	%Line2D.points[1] = end_local

func find_valid_mob(bodies: Array) -> Node2D:
	# Sort candidates by distance and pick the first whose raycast hits *that* mob.
	var my_pos := global_position
	var candidates: Array = []

	for b in bodies:
		if not is_instance_valid(b): 
			continue
		if not (b is Node2D):
			continue
		# Prefer actual Mob type; if you use a group instead, swap this to: if not b.is_in_group("mobs"): continue
		if not (b is Mob):
			continue
		candidates.append(b)

	if candidates.is_empty():
		return null

	candidates.sort_custom(func(a, b):
		return my_pos.distance_squared_to(a.global_position) < my_pos.distance_squared_to(b.global_position)
	)

	for mob in candidates:
		var local_target := rc.to_local(mob.global_position)
		rc.target_position = local_target
		rc.force_raycast_update()
		if rc.is_colliding():
			var col := rc.get_collider()
			if _collider_matches_target(col, mob):
				return mob
		# If not colliding, we didn't hit anything (or target has no collider) — treat as invalid.
	return null

func _collider_matches_target(hit: Object, target: Object) -> bool:
	if hit == target:
		return true
	if (hit is Node) and (target is Node):
		var h: Node = hit
		var t: Node = target
		# Handles cases where the collider is a child CollisionObject2D of the Mob, or vice-versa.
		return h.is_ancestor_of(t) or t.is_ancestor_of(h)
	return false

func set_laser_damage(new_dps: float):
	dps = new_dps

func set_length(new_length: float):
	collision_circle.radius = new_length
	rc.target_position.y = new_length

func appear() -> void:
	line_2d.visible = true
	if laser_active:
		return
	laser_active = true
	casting_particles.emitting = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(%Line2D, "width", line_width, growth_time).from(0.0)

func disappear() -> void:
	if not laser_active:
		return
	laser_active = false
	collision_light.visible = false
	casting_particles.emitting = false
	beam_particles.emitting = false
	collision_particles.emitting = false
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(%Line2D, "width", 0.0, .1).from_current()
	tween.tween_callback(%Line2D.hide)

func _clear_aim_and_hide() -> void:
	disappear()
	rc.target_position = Vector2.ZERO
	current_target = null
