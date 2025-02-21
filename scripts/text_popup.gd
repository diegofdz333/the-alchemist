extends Label

@export var isEnglishLabel: bool;
var max_line = 0;
var current_line = 0;
var doc_text = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func languagesAgree(isEnglishLanguage):
	return (isEnglishLabel && isEnglishLanguage) || (!isEnglishLabel && !isEnglishLanguage);

func _on_documents_selected_document_changed(new_doc):
	if new_doc != null && languagesAgree(new_doc.isEnglish):
		doc_text = new_doc.text;
		current_line = 0;
		max_line = doc_text.split("\n").size() - 1;
	else:
		doc_text = null;
		max_line = 0;
	update_text();

func update_text():
	if doc_text != null:
		var split_text = doc_text.split("\n");
		text = split_text[current_line];
	else:
		text = "";
	


func _on_left_text_button_down():
	if current_line > 0:
		current_line -= 1;
		update_text();


func _on_right_text_button_down():
	if current_line < max_line:
		current_line += 1;
		update_text();
