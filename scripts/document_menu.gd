extends Area2D

signal expand_button_pressed()

var retracted_pos: Vector2 = Vector2.ZERO
var expanded_pos: Vector2 = Vector2.ZERO
var expanded: bool = false

var documents: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_width = get_viewport().size.x
	var sprite_width = $Sprite2D.texture.get_width()
	var peek = 0.02 * viewport_width
	retracted_pos = Vector2(-viewport_width / 2 - sprite_width / 2 + peek, 0)
	expanded_pos = retracted_pos + Vector2(sprite_width - peek, 0)
	position = retracted_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_expand_button_pressed():
	expand_button_pressed.emit()
	$ExpandButton.flip_h = not $ExpandButton.flip_h
	expanded = not expanded
