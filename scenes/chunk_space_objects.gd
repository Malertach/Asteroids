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
@export var OutLine: Color = Color(0,0,0): set = set_outline_color
@export var Fill: Color = Color(0,0,0): set = set_filling_color
@export var LineWidth: float = 2.0: set = set_width
@export var Polygon: PackedVector2Array = []

## public variables ##
var health = 0: set = set_health
var is_alive = true

## private variables ##
# Example: "var _speed = 300.0"

## onready variables ##
@onready var visuals: Polygon2D = $Visuals
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D


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

func set_outline_color(color:Color) -> void:
	OutLine = color
	if visuals != null:
		visuals.queue_redraw()


func set_filling_color(color:Color) -> void:
	Fill = color
	if visuals != null:
		visuals.queue_redraw()


func set_width(new_width:float) -> void:
	LineWidth = new_width
	if visuals != null:
		visuals.queue_redraw()


func set_health(new_health) -> void:
	health = new_health

func set_polygon(poly: PackedVector2Array) -> void:
	visuals.polygon = poly
	collision.polygon = poly
	if visuals != null:
		visuals.queue_redraw()

## private methods ##
# Example: "func _on_state_changed(previous, new):"
