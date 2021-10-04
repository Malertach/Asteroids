tool # this is a tool or provides aid during level editing
class_name ChunkySpaceObject # name of this node in PascalCase
extends RigidBody2D
# Collision and visuals


## signals ##
# Example: "signal door_opened"

## enums ##
# Example: "enum Jobs {KNIGHT, WIZARD, ROGUE, HEALER, SHAMAN}"

## constans ##
# Example: "MAX_LIVES = 3"

## exported variables ##
export (Color) var OutLine = Color(0,0,0) setget set_outline_color
export (Color) var Fill = Color(0,0,0) setget set_filling_color
export (float) var LineWidth = 2.0 setget set_width
export (PoolVector2Array) var Polygon = []

## public variables ##
var health = 0 setget set_health
var is_alive = true

## private variables ##
# Example: "var _speed = 300.0"

## onready variables ##
onready var visuals = $Visuals
onready var collision = $CollisionPolygon2D


# Called upon creating the object in memory. #
#func _init():
#	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready():
	# provide polygon and colors to underlying objects
	visuals.color = Fill
	visuals.polygon = Polygon
	collision.polygon = Polygon

## remaining built-in virtual methods ##
func _draw():
	if Polygon.size() > 0 :
		for i in range(1 , Polygon.size()):
			draw_line(Polygon[i-1] , Polygon[i], OutLine , LineWidth)
		draw_line(Polygon[Polygon.size() - 1] , Polygon[0], OutLine , LineWidth)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


## public methods ##
func property_list_changed_notify():
	# provide polygon and colors to underlying objects
	visuals.color = Fill
	visuals.polygon = Polygon
	collision.polygon = Polygon
	_draw()

func set_outline_color(color:Color) -> void:
	OutLine = color
	update()


func set_filling_color(color:Color) -> void:
	Fill = color
	update()


func set_width(new_width:float) -> void:
	LineWidth = new_width
	update()


func set_health(new_health) -> void:
	health = new_health


## private methods ##
# Example: "func _on_state_changed(previous, new):"
