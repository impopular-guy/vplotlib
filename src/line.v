module vplotlib

import gg

struct LinePlot {
	x []f32
	y []f32

	po PlotOptions
}

pub fn line[T](x_in []T, y_in []T, mut po PlotOptions) {
	l_info('LINE START')

	// check len(x) == len(y)
	// check len(x) > 2

	// init
	mut x, mut y := []f32{}, []f32{}
	for i, _ in x_in {
		x << f32(x_in[i])
		y << f32(y_in[i])
	}
	po.update_lims(x, y)
	mut plot := LinePlot{
		x: x
		y: y
		po: unsafe { po }
	}

	// draw plot
	run(plot)
	l_info('LINE END')
}

fn (plot &LinePlot) draw(ctx &gg.Context) {
	cnf := gg.PenConfig{
		color: plot.po.line_color
		line_type: plot.po.line_type
		thickness: plot.po.line_thickness
	}

	mut x := plot.po.norm_x(plot.x[0])
	mut y := plot.po.norm_y(plot.y[0])
	for i := 1; i < plot.x.len - 1; i += 1 {
		x2 := plot.po.norm_x(plot.x[i + 1])
		y2 := plot.po.norm_y(plot.y[i + 1])
		ctx.draw_line_with_config(x, y, x2, y2, cnf)
		x, y = x2, y2
	}
}
