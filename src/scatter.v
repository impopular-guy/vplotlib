module vplotlib

import gg
import gx

struct ScatterPlot[T] {
	x []T
	y []T

	po PlotOptions
}

pub fn scatter[T](x []T, y []T, po PlotOptions) {
	l_info('SCATTER START')

	// check len(x) == len(y)

	mut plot := ScatterPlot[T]{
		x: x
		y: y
		po: unsafe { po }
	}
	run(plot)
	l_info('SCATTER END')
}

fn (plot &ScatterPlot[T]) draw(ctx &gg.Context) {
	ctx.draw_text_def(200, 20, 'hello world!')
	ctx.draw_text_def(300, 300, 'привет')
	ctx.draw_rect_filled(10, 10, 100, 30, gx.blue)
	ctx.draw_rect_empty(110, 150, 80, 40, gx.black)
}
