#tool # this is a tool or provides aid during level editing
#class_name <ClassName> # name of this node in PascalCase
extends Node
# Comment describing content of this script


## signals ##
# Example: "signal door_opened"

## enums ##
enum Sides {TOP = 0, BOTTOM = 1, LEFT = 2, RIGHT = 3}

## constans ##
const ANGLE_INSIDE:float = 2 * PI # full turn around

## exported variables ##
export (Rect2) var viewport_rect = Rect2(0, 0, 1024, 600) # screen dimensions. get this from parent with get_viewport_rect()
export (Color, RGB) var OutLine = Color(0,0,0)
export (Color, RGB) var Fill = Color(0,0,0)
export (float) var LineWidth = 2.0
export (float) var edge_lenght_min = 10
export (float) var edge_lenght_max = 30
export (int) var point_amount_min = 5
export (int) var point_amount_max = 12
export (float) var asteroid_speed_min = 70.0
export (float) var asteroid_speed_max = 150.0
export (float) var torque_inertia = 10.0 # how much torque has to be applied to rotate
export (float) var torque_max = 10.0

## public variables ##
var asteroid_scene = preload("res://scenes/Asteroid.tscn")
var rng = RandomNumberGenerator.new()

## private variables ##
var spawn_position: Vector2 = Vector2.ZERO
var movement_direction: Vector2 = Vector2.ZERO
var asteroid_rotation: float = 0.0

## onready variables ##
# Example: "onready var sword = $Sword"
# Example: "onready var gun = get_node("Gun")"


# Called upon creating the object in memory. #
#func _init():
#	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize() # setup numbergenerator with timebased seed
	spawn_asteroid()

## remaining built-in virtual methods ##
# Example: func _unhandled_input(event: String) -> void:
# Example: func _physics_process() -> void

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


## public methods ##
# Example: "func sum(a: int, b: int):"

## private methods ##
func spawn_asteroid(edge_points := 0, position := Vector2.INF, directed_force := Vector2.INF, torque := 0.0) -> void:
	var new_asteroid = asteroid_scene.instance()
	
	new_asteroid.Polygon = generate_polygon(edge_points)
	generate_pos_dir() # TODO: prevent unecessary call of this function, if pos||dir ist explicitly set
	if position == Vector2.INF:
		# use generated position
		new_asteroid.position = spawn_position
	else:
		# use explicit position
		new_asteroid.position = position
	
	new_asteroid.set_outline_color(OutLine)
	new_asteroid.set_filling_color(Fill)
	new_asteroid.set_width(LineWidth)
	#new_asteroid.Polygon = PoolVector2Array([Vector2(0, 0), Vector2(-10, 10), Vector2(0, 20), Vector2(10, 10), Vector2(10, 0)])
	add_child(new_asteroid)
	
	if directed_force == Vector2.INF:
		# use generated force
		directed_force = movement_direction * rng.randf_range(asteroid_speed_min, asteroid_speed_max)
	else:
		# use explicitly set force
		pass
	new_asteroid.apply_central_impulse(directed_force)
	
	if is_zero_approx(torque):
		# generate some random torque
		torque = rng.randf_range(-torque_max, torque_max)
	else:
		# use explicitly set torque
		pass
	print_debug(new_asteroid.get_inertia())
	# doesnt autocompute the inertia. see https://github.com/godotengine/godot/issues/4439
	new_asteroid.inertia = torque_inertia #
	
	new_asteroid.inertia = 0 # reset to autocompute
	new_asteroid.apply_torque_impulse(torque)


func generate_polygon(edge_points := 0) -> PoolVector2Array:
	var point_amount: int = edge_points
	if point_amount == 0:
		# no amount of points explicitly set
		# get random amount
		point_amount = rng.randi_range(point_amount_min, point_amount_max)
	var polygon: PoolVector2Array = PoolVector2Array()
	var optimal_angle: float = ANGLE_INSIDE / point_amount
	var current_polar_angle: float = 0.0
	polygon.resize(point_amount) # resize array once to not use append

	for index in range(0, point_amount):
		var distance_to_next_point:float = rng.randf_range(edge_lenght_min, edge_lenght_max)
		polygon[index] = polar2cartesian(distance_to_next_point, current_polar_angle)
		current_polar_angle += optimal_angle
	
	return polygon

# generate spawn position and movement direction
# use an offset of edge_lenght_max to ensure the asteroids spawn out of view
func generate_pos_dir() -> void:
	# determine spawn position
	var side_for_spawn:int = rng.randi_range(0, Sides.size()) # side on which to spawn asteroid
	match side_for_spawn:
		Sides.TOP:
			# set position on TOP of viewport with an offset of edge_lenght_max
			spawn_position.y = viewport_rect.position.y - edge_lenght_max
			spawn_position.x = rng.randi_range(viewport_rect.position.x, viewport_rect.size.x)
		Sides.BOTTOM:
			# set position on BOTTOM of viewport with an offset of edge_lenght_max
			spawn_position.y = viewport_rect.position.y + viewport_rect.size.y + edge_lenght_max
			spawn_position.x = rng.randi_range(viewport_rect.position.x, viewport_rect.size.x)
		Sides.LEFT:
			# set position on LEFT of viewport with an offset of edge_lenght_max
			spawn_position.x = viewport_rect.position.x - edge_lenght_max
			spawn_position.y = rng.randi_range(viewport_rect.position.y, viewport_rect.size.y)
		Sides.RIGHT:
			# set position on RIGHT of viewport with an offset of edge_lenght_max
			spawn_position.x = viewport_rect.position.x + viewport_rect.size.x + edge_lenght_max
			spawn_position.y = rng.randi_range(viewport_rect.position.y, viewport_rect.size.y)
	
	# determine movement direction of asteroid
	var point_in_view: Vector2 = Vector2.ZERO # point in view the asteroid should move towards
	# use an offset of edge_lenght_max so asteroid will be fully visible if it reaches the point
	point_in_view.x = rng.randi_range(viewport_rect.position.x + edge_lenght_max, viewport_rect.position.x + viewport_rect.size.x - edge_lenght_max)
	point_in_view.y = rng.randi_range(viewport_rect.position.y + edge_lenght_max, viewport_rect.position.y + viewport_rect.size.y - edge_lenght_max)
	
	movement_direction = spawn_position.direction_to(point_in_view)


func _on_SpawnTimer_timeout() -> void:
	spawn_asteroid() 
