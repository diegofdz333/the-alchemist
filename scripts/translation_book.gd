extends "res://scripts/book.gd"

var translations = [];

func _ready():
	for i in range(pages.size()):
		translations.append(["","","","","",""]);
	super();

func set_translation(page, line, text):
	translations[page - 1][line] = text


func change_page(page_):
	super(page_);
	if page_ >= 1 and page_ < pages.size():
		var lineNum = 0;
		for child in get_children():
			if child is LineEdit:
				child.text = translations[page_ - 1][lineNum];
				lineNum += 1;


func _on_line_0_text_changed(new_text):
	set_translation(page, 0, new_text);


func _on_line_1_text_changed(new_text):
	set_translation(page, 1, new_text);


func _on_line_2_text_changed(new_text):
	set_translation(page, 2, new_text);


func _on_line_3_text_changed(new_text):
	set_translation(page, 3, new_text);


func _on_line_4_text_changed(new_text):
	set_translation(page, 4, new_text);


func _on_line_5_text_changed(new_text):
	set_translation(page, 5, new_text);
