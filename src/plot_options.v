module vplotlib

import gg
import gx

pub struct PlotOptions {
pub mut:
	height int    = 600
	width  int    = 600
	title  string = 'Plot'
	// axes limits
	x_lim []f32 = [f32(-10), 10]
	y_lim []f32 = [f32(-10), 10]
	// padding
	pad_x f32 = 10
	pad_y f32 = 10
	// line configs
	line_color     gx.Color       = gx.blue
	line_type      gg.PenLineType = .solid
	line_thickness int = 3
}

fn (po PlotOptions) norm_x(x f32) f32 {
	return po.pad_x + (po.width - 2 * po.pad_x) * (x - po.x_lim[0]) / (po.x_lim[1] - po.x_lim[0])
}

fn (po PlotOptions) norm_y(y f32) f32 {
	return po.height - po.pad_y +
		(2 * po.pad_y - po.height) * (y - po.y_lim[0]) / (po.y_lim[1] - po.y_lim[0])
}

fn (mut po PlotOptions) update_lims(x []f32, y []f32) {
	mut x_min := x[0]
	mut y_min := y[0]
	mut x_max := x[0]
	mut y_max := y[0]
	for xi in x {
		if xi < x_min {
			x_min = xi
		}
		if xi > x_max {
			x_max = xi
		}
	}
	for yi in y {
		if yi < y_min {
			y_min = yi
		}
		if yi > y_max {
			y_max = yi
		}
	}
	po.x_lim = [x_min, x_max]
	po.y_lim = [y_min, y_max]
}
