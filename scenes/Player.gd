tool # this is a tool or provides aid during level editing
class_name Player # name of this node in PascalCase
extends ChunkySpaceObject
# control movement of player


## signals ##
# Example: "signal door_opened"

## enums ##
# Example: "enum Jobs {KNIGHT, WIZARD, ROGUE, HEALER, SHAMAN}"

## constans ##
const INPUTS = {"ui_right": 1.0, # angle to rotate right
			"ui_left": -1.0, # angle to rotate left
			"ui_up": Vector2.UP,  # vector to move up
			"ui_down": Vector2.DOWN, # vector to move down
			}

## exported variables ##
# Example: "export(Jobs) var job = Jobs.KNIGHT"
export var test = true

## public variables ##
# Example: "var health = max_health setget set_health"

## private variables ##
var _speed = 150.0
var _torque = 300
onready var _linear_dampening = self.linear_damp
onready var _angular_dampening = self.angular_damp

## onready variables ##
# Example: "onready var gun = get_node("Gun")"


# Called upon creating the object in memory. #
#func _init():
#	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.


## remaining built-in virtual methods ##

# Update direction buffer depending in pressed keys
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		$Weapon.shoot()


func _integrate_forces(_state) -> void:
	applied_force = Vector2.ZERO
	applied_torque = 0.0
	
	for direction in INPUTS.keys():
		if Input.is_action_pressed(direction):
			match direction:
				"ui_up", "ui_down":
					# movement direction
					applied_force = (INPUTS[direction].rotated(rotation) * _speed)
				"ui_left", "ui_right":
					# rotation
					applied_torque = (INPUTS[direction] * _torque)
	
	if applied_force != Vector2.ZERO:
		# force is applied, button is pressed
		linear_damp = 0
	else:
		# no button for movement pressed
		linear_damp = _linear_dampening
	if not is_zero_approx(applied_torque):
		# torque is applied, button is pressed
		angular_damp = 0
	else:
		angular_damp = _angular_dampening
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# reset forces
	#applied_force = Vector2.ZERO
	#applied_torque = 0.0
	pass


## public methods ##
# Example: "func sum(a, b):"

## private methods ##
# Example: "func _on_state_changed(previous, new):"
