module vplotlib

import gg
import gx

struct ScatterPlot {
	x []f32
	y []f32

	po PlotOptions
}

pub fn (mut fig Figure) scatter[T](x_in []T, y_in []T, mut po PlotOptions) {
	l_info('SCATTER START')

	// check len(x) == len(y)

	// init
	mut x, mut y := []f32{}, []f32{}
	for i, _ in x_in {
		x << f32(x_in[i])
		y << f32(y_in[i])
	}
	po.update_lims(x, y)
	plot := ScatterPlot{
		x: x
		y: y
		po: unsafe { po }
	}

	// Add plot
	fig.plots << plot
	l_info('SCATTER END')
}

fn (plot &ScatterPlot) draw(ctx &gg.Context) {
	for i, xi in plot.x {
		ctx.draw_circle_filled(plot.po.norm_x(xi), plot.po.norm_y(plot.y[i]), 5, gx.black)
	}
}
