extends CanvasLayer

@export var crosshair_container: Control
@export var crosshair_code: String

var settings = {
	"c": 5,
	"h": 0,
	"f": 0,
	"0t": 1,
	"0l": 4,
	"0o": 2,
	"0a": 1,
	"0m": 1,
	"0f": 0,
	"1b": 0,
	"1t": 0,
	"1l": 0,
	"1o": 0,
	"1a": 1
}

var colors = {
	0: "#FFFFFF",
	1: "#00FF00",
	2: "#7FFF00",
	3: "#DFFF00",
	4: "#FFFF00",
	5: "#00FFFF",
	6: "#FF00FF",
	7: "#FF0000"
}

class CrosshairDrawer:
	extends Control

	var settings: Dictionary

	func _draw():
		var center = size / 2.0

		var color = Color(str(settings["c"]))

		var inner_opacity = clampf(float(settings["0a"]), 0.0, 1.0)
		var outer_opacity = clampf(float(settings.get("1a", 1)), 0.0, 1.0)

		var inner_color = color
		inner_color.a = inner_opacity

		var outer_color = color
		outer_color.a = outer_opacity

		var thickness = float(settings["0t"]) * 2.0
		var length = float(settings["0l"]) * 2.0
		var offset = float(settings["0o"]) * 2.0

		if thickness > 0 and length > 0:
			_draw_lines(center, thickness, length, offset, inner_color)

		var outer_thickness = float(settings["1t"]) * 2.0
		var outer_length = float(settings["1l"]) * 2.0
		var outer_offset = float(settings["1o"]) * 2.0

		if int(settings["1b"]) == 1 and outer_thickness > 0 and outer_length > 0:
			_draw_lines(center, outer_thickness, outer_length, outer_offset, outer_color)

		if int(settings["h"]) == 1:
			var dot_size = 2.0
			draw_rect(
				Rect2(center - Vector2.ONE * dot_size / 2.0, Vector2.ONE * dot_size),
				color
			)

	func _draw_lines(center: Vector2, thickness: float, length: float, offset: float, color: Color):
		var half = thickness / 2.0

		draw_rect(Rect2(
			center.x - offset - length,
			center.y - half,
			length,
			thickness
		), color)

		draw_rect(Rect2(
			center.x + offset,
			center.y - half,
			length,
			thickness
		), color)

		draw_rect(Rect2(
			center.x - half,
			center.y - offset - length,
			thickness,
			length
		), color)

		draw_rect(Rect2(
			center.x - half,
			center.y + offset,
			thickness,
			length
		), color)


func _parse_code(code: String):
	settings = settings.duplicate()

	var parts = code.split(";")
	var inside_primary = false

	for i in range(parts.size()):
		match parts[i]:
			"P":
				inside_primary = true
				continue
			"S":
				inside_primary = false
				continue

		if not inside_primary:
			continue

		match parts[i]:
			"c", "h", "f", "0t", "0l", "0o", "0a", "0m", "0f", "1b", "1t", "1l", "1o", "1a":
				if i + 1 < parts.size():
					settings[parts[i]] = parts[i + 1]

	settings["c"] = colors.get(int(settings["c"]), "#FFFFFF")


func _ready():
	if crosshair_code.is_empty():
		_parse_code("0;s;1;P;c;5;h;0;m;1;0l;4;0o;2;0a;1;0f;0;1b;0")
	else:
		_parse_code(crosshair_code)

	_draw_crosshair()


func _draw_crosshair():
	if crosshair_container == null:
		return

	var drawer = CrosshairDrawer.new()
	drawer.settings = settings.duplicate()
	drawer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	crosshair_container.add_child(drawer)
	drawer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	drawer.queue_redraw()
