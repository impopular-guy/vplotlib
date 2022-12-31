module vplotlib

import gg
import gx

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

pub fn (mut fig Figure) line[T](params LineParams[T]) {
	l_info('LINE START')

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

	// draw plot
	fig.plots << plot
	fig.g_po.update_lims(plot.x_lim, plot.y_lim)

	l_info('LINE END')
}

fn (plot &LinePlot) draw(ctx &gg.Context, g_po PlotOptions) {
	cnf := gg.PenConfig{
		color: plot.color
		line_type: plot.line_type
		thickness: plot.thickness
	}
	mut x := g_po.norm_x(plot.x[0])
	mut y := g_po.norm_y(plot.y[0])
	for i := 1; i < plot.x.len; i += 1 {
		x2 := g_po.norm_x(plot.x[i])
		y2 := g_po.norm_y(plot.y[i])
		ctx.draw_line_with_config(x, y, x2, y2, cnf)
		x, y = x2, y2
	}
}
