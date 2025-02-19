extends Area2D

signal expand_button_pressed()

const menu_z = 50

var retracted_pos: Vector2 = Vector2.ZERO
var expanded_pos: Vector2 = Vector2.ZERO
var width: int = 0
var height: int = 0
var expanded: bool = false

var documents: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_width = get_viewport().size.x
	width = $Sprite2D.texture.get_width()
	height = $Sprite2D.texture.get_height()
	var peek = 0.02 * viewport_width
	retracted_pos = Vector2(-viewport_width / 2 - width / 2 + peek, 0)
	expanded_pos = retracted_pos + Vector2(width - peek, 0)
	position = retracted_pos
	z_index = menu_z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_expand_button_pressed():
	expand_button_pressed.emit()
	$ExpandButton.flip_h = not $ExpandButton.flip_h
	expanded = not expanded
