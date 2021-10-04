#tool # this is a tool or provides aid during level editing
#class_name <ClassName> # name of this node in PascalCase
extends Node2D
# Comment describing content of this script


## signals ##
# Example: "signal door_opened"

## enums ##
# Example: "enum Jobs {KNIGHT, WIZARD, ROGUE, HEALER, SHAMAN}"

## constans ##
# Example: "MAX_LIVES = 3"

## exported variables ##
# Example: "export(Jobs) var job = Jobs.KNIGHT"

## public variables ##
var laser_scene := preload("res://scenes/Laser.tscn")

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
	pass # Replace with function body.

## remaining built-in virtual methods ##
# Example: func _unhandled_input(event):
# Example: func _physics_process()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


## public methods ##
func shoot():
	var new_laser = laser_scene.instance()
	new_laser.global_position = self.global_position
	new_laser.global_rotation = self.global_rotation
	# add bullet to game, as it should not move with this node
	get_node("/root/Game").add_child(new_laser)

## private methods ##
# Example: "func _on_state_changed(previous, new):"
