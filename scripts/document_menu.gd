extends Area2D

signal expand_button_pressed()

const DOCUMENT_MENU_Z: int = 50
const ROWS: int = 5
const COLS: int = 2

var retracted_pos: Vector2 = Vector2.ZERO
var expanded_pos: Vector2 = Vector2.ZERO
var width: int = 0
var height: int = 0
var expanded: bool = false

var documents: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_width = get_viewport().size.x
	width = $Sprite2D.texture.get_width()
	height = $Sprite2D.texture.get_height()
	var peek = 0.07 * viewport_width
	var full = 0.3 * viewport_width
	retracted_pos = Vector2(-viewport_width / 2 - width / 2 + peek, 0)
	expanded_pos = Vector2(-viewport_width / 2 - width / 2 + full, 0)
	position = retracted_pos
	z_index = DOCUMENT_MENU_Z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func in_menu(pos):
	var right = expanded_pos.x + width / 2
	var top = expanded_pos.y + height / 2
	var bottom = expanded_pos.y - height / 2
	return pos.x < right and pos.y < top and pos.y > bottom


func update_documents():
	for doc in documents:
		if expanded:
			doc.show()
			doc.set_process_input(true)
		else:
			doc.hide()
			doc.set_process_input(false)


func _on_documents_dropped(doc):
	if expanded:
		doc.in_menu = in_menu(doc.position)
		if doc in documents and not doc.in_menu:
			documents.erase(doc)
		elif doc not in documents and doc.in_menu:
			print("adding doc")
			documents[doc] = null


func _on_expand_button_pressed():
	expand_button_pressed.emit()
	expanded = not expanded
	update_documents()


func _on_organize_button_pressed():
	pass # Replace with function body.
		
