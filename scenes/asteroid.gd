tool # this is a tool or provides aid during level editing
class_name Asteroid # name of this node in PascalCase
extends ChunkySpaceObject
# Comment describing content of this script


## signals ##
# Example: "signal door_opened"

## enums ##
# Example: "enum Jobs {KNIGHT, WIZARD, ROGUE, HEALER, SHAMAN}"

## constans ##
# Example: "MAX_LIVES = 3"

## exported variables ##
export (float) var mass_factor = 10

## public variables ##


## private variables ##
# Example: "var _speed = 300.0"

## onready variables ##
# Example: "onready var sword = $Sword"
# Example: "onready var gun = get_node("Gun")"


# Called upon creating the object in memory. #
#func _init():
#	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready():
	# Asteroids do not slow down
	linear_damp = 0
	angular_damp = 0
	health = Polygon.size()
	mass = Polygon.size() * mass_factor
	

## remaining built-in virtual methods ##
# Example: func _unhandled_input(event):
# Example: func _physics_process()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


## public methods ##
func on_hit() -> void:
	health -= 1
	if health <= 0 and is_alive:
		# health of asteroid depleted
		is_alive = false
		queue_free()

## private methods ##
# Example: "func _on_state_changed(previous, new):"
