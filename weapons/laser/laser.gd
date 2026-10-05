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
		disappear()
		%RayCast2D.target_position = Vector2.ZERO
		return

	var my_pos: Vector2 = global_position
	var target_enemy: Node2D = null
	var best_d2 := INF

	# Find closest enemy
	for b in bodies:
		if not is_instance_valid(b): 
			continue
		if not (b is Node2D):
			continue

		var d2 := my_pos.distance_squared_to(b.global_position)
		if d2 < best_d2:
			best_d2 = d2
			target_enemy = b

	if target_enemy == null:
		disappear()
		%RayCast2D.target_position = Vector2.ZERO
		return

	
	var local_target = %RayCast2D.to_local(target_enemy.global_position)


	
	

	%RayCast2D.target_position = local_target
	%RayCast2D.force_raycast_update()


	

	# Compute the line end in THIS node's local space
	var end_local: Vector2 = local_target
	if %RayCast2D.is_colliding():
		end_local = to_local(%RayCast2D.get_collision_point())
		if target_enemy is Mob:
			current_target = target_enemy
			target_enemy.take_damage(dps * delta)
			collision_particles.position = end_local
			collision_particles.emitting = true
			collision_light.visible = true
			
	else:
		collision_particles.emitting = false
		collision_light.visible = false
	
	# make the casting particles face the direction of the end_local
	var dir_local: Vector2 = end_local - %Line2D.points[0]
	if dir_local.length_squared() > 0.0001:
		casting_particles.rotation = dir_local.angle()
		
		beam_particles.rotation = dir_local.angle()
		beam_particles.emitting = true

		beam_particles.process_material.emission_shape_offset.x = end_local.distance_to(%Line2D.points[0]) * 0.5
		beam_particles.process_material.emission_box_extents.x = end_local.distance_to(%Line2D.points[0]) * 0.5
		
	appear()
	%Line2D.points[1] = end_local


func set_laser_damage(new_dps: float):
	dps = new_dps

func set_length(new_length: float):
	collision_circle.radius = new_length
	%RayCast2D.target_position.y = new_length


func appear() -> void:
	line_2d.visible = true
	
	if laser_active == true:
		return
	laser_active = true
	
	casting_particles.emitting = true
	
	
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(%Line2D, "width", line_width, growth_time).from(0.0)


func disappear() -> void:
	if laser_active == false:
		return
	laser_active = false
	
	collision_light.visible = false
	
	casting_particles.emitting = false
	beam_particles.emitting = false
	collision_particles.emitting = false
	
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(%Line2D, "width", 0.0, growth_time).from_current()
	tween.tween_callback(%Line2D.hide)
