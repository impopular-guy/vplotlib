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
	for plot in fig.plots {
		plot.draw(fig.ctx, fig.g_po)
	}
	fig.ctx.end()
}
