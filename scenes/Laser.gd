#tool # this is a tool or provides aid during level editing
#class_name <ClassName> # name of this node in PascalCase
extends Area2D
# Comment describing content of this script


## signals ##
# Example: "signal door_opened"

## enums ##
# Example: "enum Jobs {KNIGHT, WIZARD, ROGUE, HEALER, SHAMAN}"

## constans ##
# Example: "MAX_LIVES = 3"

## exported variables ##
export (float) var shot_speed = 100.0

## public variables ##
var direction :Vector2 = Vector2.ZERO setget set_direction

## private variables ##
# Example: "var _speed = 300.0"

## onready variables ##
# Example: "onready var sword = $Sword"
# Example: "onready var gun = get_node("Gun")"

# Called upon creating the object in memory. #
#func _init():
#	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2.UP.rotated(global_rotation)

## remaining built-in virtual methods ##
# Example: func _unhandled_input(event):
# Example: func _physics_process()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * shot_speed * delta


## public methods ##
func set_direction(new_dir: Vector2) -> void:
	direction = new_dir

## private methods ##
# Example: "func _on_state_changed(previous, new):"


func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	queue_free()


func _on_Laser_body_shape_entered(body_id: int, body: Node, body_shape: int, area_shape: int) -> void:
	if body.is_in_group("asteroids"):
		body.call_deferred("on_hit")
		# delet the laser
		queue_free()
