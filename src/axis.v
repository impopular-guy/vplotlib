module vplotlib

import gx
import ui

const (
	tick_size = 0.02
	tsp_h     = ui.TextStyleParams{
		align: .center
		vertical_align: .top
	}
	tsp_v = ui.TextStyleParams{
		align: .right
		vertical_align: .middle
	}
)

enum AxisType {
	linear
	// log // these values should probably come from SubFigure
	// polar
	// discrete
}

enum PositionType {
	horizontal
	vertical
}

struct Axis {
mut:
	atype       AxisType = .linear
	pos         PositionType
	lim         []f32
	n           int
	ticks       []f32 // ticks is n len array with all values between 0 and 1
	tick_labels []string
}

fn (mut ax Axis) update_lim_ticks(lim []f32) {
	if ax.lim.len == 0 {
		ax.lim = lim
	}
	ax.n = 5
	if ax.ticks.len == 0 {
		// TODO: might better logic needed
		match ax.atype {
			.linear { ax.ticks = get_ticks_frac(ax.n) }
		}
	}
	if ax.tick_labels.len == 0 {
		for t in ax.ticks {
			l := lim[0] + (lim[1] - lim[0]) * t
			ax.tick_labels << '${l:.2f}'
		}
	}
}

// (x, y): starting point on the canvas for drawing the ticks
// (x+dx, y+dy): ending point on the canvas for drawing the ticks
fn (ax Axis) draw_ticks(d ui.DrawDevice, c &ui.CanvasLayout, x f32, y f32, dx f32, dy f32) {
	match ax.pos {
		.horizontal {
			tick_len := vplotlib.tick_size * f32(c.height)
			for i, t in ax.ticks {
				x_n := x + dx * t
				y_n := y + dy * t
				c.draw_device_line(d, x_n, y_n, x_n, y_n + tick_len, gx.black)
				c.draw_device_styled_text(d, int(x_n), int(y_n + tick_len), ax.tick_labels[i],
					vplotlib.tsp_h)
			}
		}
		.vertical {
			tick_len := vplotlib.tick_size * f32(c.width)
			for i, t in ax.ticks {
				x_n := x + dx * t
				y_n := y + dy * t
				c.draw_device_line(d, x_n, y_n, x_n - tick_len, y_n, gx.black)
				c.draw_device_styled_text(d, int(x_n - tick_len), int(y_n), ax.tick_labels[i],
					vplotlib.tsp_v)
			}
		}
	}
}
