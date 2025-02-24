extends Label

var win = false;




func _on_button_button_down():
	if not win:
		hide();


func _on_main_win():
	text = "As soon as you make the potion you see it turn a deep green.
You quickly run into the now dry dry forest and pour it on the ground.
The brown quickly turns to green as life begins to slowly bloom again.
You know that you have been successful, as all the greenery returns.
Yes, the greenery is back!

YOU WIN!"
	win = true;
	show();
