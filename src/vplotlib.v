module vplotlib

import gg
import gx

pub const (
	version = '0.1.0'
)

interface Plot {
	x_lim []f32
	y_lim []f32
	draw(&gg.Context, PlotOptions)
}

// the struct names are subject to change
struct Figure {
mut:
	ctx   &gg.Context = unsafe { nil }
	rows  int = 1
	cols  int = 1
	plots []Plot
	g_po  PlotOptions // global plotoptions
}

pub fn figure(po PlotOptions) &Figure {
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

pub struct AddParams {
	i     int
	j     int
	plots []Plot
}

pub fn (mut fig Figure) add(params AddParams) {
	// clean/update global plotoptions here
	for plot in params.plots {
		fig.plots << plot
		fig.g_po.update_lims(plot.x_lim, plot.y_lim)
	}
}

pub fn (fig &Figure) show() {
	fig.ctx.run()
}

fn frame(fig &Figure) {
	fig.ctx.begin()
	x_c := fig.g_po.width * fig.g_po.axis_pad_x
	y_c := fig.g_po.height * fig.g_po.axis_pad_y
	w := fig.g_po.width * (1 - 2 * fig.g_po.axis_pad_x)
	h := fig.g_po.height * (1 - 2 * fig.g_po.axis_pad_y)
	fig.ctx.draw_rect_empty(x_c, y_c, w, h, gx.black)

	// fig.ctx.draw_text_def(int(x_c + w / 2), int(y_c/2), fig.g_po.title)

	for plot in fig.plots {
		plot.draw(fig.ctx, fig.g_po)
	}
	fig.ctx.end()
}

fn on_resize(e &gg.Event, mut fig Figure) {
	fig.g_po.width = e.window_width
	fig.g_po.height = e.window_height
}
