module vplotlib

import gg
import gx

interface Plot {
	po PlotOptions
	draw(&gg.Context, PlotOptions)
}

// the struct names are subject to change
struct Figure {
mut:
	ctx   &gg.Context = unsafe { nil }
	plots []Plot
	g_po  PlotOptions // global plotoptions
}

pub fn new_figure(po PlotOptions) &Figure {
	mut fig := &Figure{
		ctx: 0
		g_po: po
	}
	fig.ctx = gg.new_context(
		bg_color: gx.white
		width: po.width
		height: po.height
		create_window: true
		window_title: po.title
		frame_fn: frame
		resized_fn: on_resize
		user_data: fig
	)
	return fig
}

pub fn (fig &Figure) show() {
	// clean/update global plotoptions here

	fig.ctx.run()
}

fn frame(fig &Figure) {
	fig.ctx.begin()
	x_c := fig.g_po.width * fig.g_po.axis_pad_x
	y_c := fig.g_po.height * fig.g_po.axis_pad_y
	w := fig.g_po.width * (1 - 2 * fig.g_po.axis_pad_x)
	h := fig.g_po.height * (1 - 2 * fig.g_po.axis_pad_y)
	fig.ctx.draw_rect_empty(x_c, y_c, w, h, gx.black)

	for plot in fig.plots {
		plot.draw(fig.ctx, fig.g_po)
	}
	fig.ctx.end()
}

fn on_resize (e &gg.Event, mut fig Figure){
	fig.g_po.width = e.window_width
	fig.g_po.height = e.window_height
}