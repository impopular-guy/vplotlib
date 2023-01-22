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

pub fn line[T](params LineParams[T]) LinePlot {
	// check len(x) == len(y)
	// check len(x) > 2

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

fn (plot &LinePlot) draw(ctx &gg.Context, c &ui.Canvas, fig &Figure) {
	cnf := gg.PenConfig{
		color: plot.color
		line_type: plot.line_type
		thickness: plot.thickness
	}
	mut x := fig.norm_x(plot.x[0])
	mut y := fig.norm_y(plot.y[0])
	for i := 1; i < plot.x.len; i += 1 {
		x2 := fig.norm_x(plot.x[i])
		y2 := fig.norm_y(plot.y[i])
		ctx.draw_line_with_config(x, y, x2, y2, cnf)
		x, y = x2, y2
	}
}
