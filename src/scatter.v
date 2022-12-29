module vplotlib

import gg
import gx

struct ScatterPlot {
	x []f32
	y []f32

	po PlotOptions
}

pub fn scatter[T](x_in []T, y_in []T, mut po PlotOptions) {
	l_info('SCATTER START')

	// check len(x) == len(y)

	// init
	mut x, mut y := []f32{}, []f32{}
	for i, _ in x_in {
		x << f32(x_in[i])
		y << f32(y_in[i])
	}

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

	mut plot := ScatterPlot{
		x: x
		y: y
		po: unsafe { po }
	}

	// draw plot
	run(plot)
	l_info('SCATTER END')
}

fn (plot &ScatterPlot) draw(ctx &gg.Context) {
	for i, xi in plot.x {
		ctx.draw_circle_filled(plot.po.norm_x(xi), plot.po.norm_y(plot.y[i]), 5, gx.black)
	}
}
