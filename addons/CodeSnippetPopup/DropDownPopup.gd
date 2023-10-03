@tool
extends PopupMenu

signal show_options
var code_editor : TextEdit
var main : PopupPanel
var placeholder : String


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") and placeholder:
		placeholder = ""
		var tmp = OS.clipboard
		code_editor.cut()
		OS.clipboard = tmp
	if visible:
		get_viewport().set_input_as_handled()


func _on_DropDown_shown(option_string : String) -> void:
	placeholder = option_string
	size = Vector2.ZERO
	var options = placeholder.split(",")
	for option in options:
		add_item(option)
	await get_tree().idle_frame
	var down = InputEventAction.new()
	down.action = "ui_down"
	down.button_pressed = true
	Input.parse_input_event(down)


func _on_DropDownPopup_popup_hide() -> void:
	clear()


func _on_DropDownPopup_index_pressed(index: int) -> void:
	var text = get_item_text(index)
	code_editor.insert_text_at_cursor(text)
	placeholder = ""
	hide()
	main._jump_to_and_delete_next_marker(code_editor)
