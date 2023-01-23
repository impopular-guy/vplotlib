module vplotlib

import gg
import gx
import ui

pub type LineType = gg.PenLineType

pub struct LineParams[T] {
mut:
	x         []T
	y         []T
	color     gx.Color = gx.blue
	line_type LineType = .solid
	thickness int      = 2
}

struct LinePlot {
	x         []f32
	y         []f32
	color     gx.Color
	line_type LineType
	thickness int
	x_lim     []f32
	y_lim     []f32
}

fn validate_line_params[T](p LineParams[T]) {
	if p.x.len != p.y.len {
		panic('Length of `x` and `y` must be equal')
	}
	if p.x.len < 2 {
		println('vplotlib warning: data length should be greater than 1')
	}
	if p.thickness < 1 {
		panic('`thickness` must be greater or equal to 1')
	}
}

pub fn line[T](params LineParams[T]) LinePlot {
	validate_line_params[T](params)

	// init
	x := to_f32_array(params.x)
	y := to_f32_array(params.y)
	plot := LinePlot{
		x: x
		y: y
		color: params.color
		line_type: params.line_type
		thickness: params.thickness
		x_lim: find_axis_lims(x)
		y_lim: find_axis_lims(y)
	}
	l_info('ADDED PLOT: ${typeof(plot).name}')
	return plot
}

fn (plot &LinePlot) draw(d ui.DrawDevice, c &ui.CanvasLayout, fig &SubFigure) {
	// cnf := gg.PenConfig{
	// 	color: plot.color
	// 	line_type: plot.line_type
	// 	thickness: plot.thickness
	// }
	mut x, mut y := fig.norm_xy(plot.x[0], plot.y[0], c.width, c.height)
	for i := 1; i < plot.x.len; i += 1 {
		x2, y2 := fig.norm_xy(plot.x[i], plot.y[i], c.width, c.height)
		c.draw_device_line(d, x, y, x2, y2, plot.color)
		x, y = x2, y2
	}
}
