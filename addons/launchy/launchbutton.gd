@tool
extends Button

var plugin #A reference to the EdititorPlugin, provided by `plugin.gd`
var exe="" #String to editor executable
var res    #RefCounted to the editor's currently selected resource.

func _ready():
	self.connect("pressed", Callable(self, "_on_ToolButton_pressed"))
	$Config.editor_settings = plugin.editor_settings
#	$PopupMenu.connect("index_pressed", self, '_launchSettings')

#For right clicking.
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.button_pressed == true:
		_launchSettings(0)

#For left clicking.
func _on_ToolButton_pressed():
	if exe == '':
		print('Launchy: Warning, no external editor has been assigned to launch for this resource.')
	elif exe !='' and File.new().file_exists(exe):
		#Get the path to the resource on disk.
		var path = ProjectSettings.globalize_path(res.resource_path)
		OS.execute(exe, [path], false)
	else:  #Path3D doesn't exist?
		print("Launchy: Warning, couldn't launch external editor ", exe)

#Right-click menu selected
func _launchSettings(idx):
	$Config.popup_centered()