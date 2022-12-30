module vplotlib

import gg
import gx

interface Plot {
	po PlotOptions
	draw(&gg.Context)
}

// the struct names are subject to change
struct Figure {
mut:
	gg    &gg.Context = unsafe { nil }
	plots []Plot
	g_po  PlotOptions // global plotoptions
}

pub fn new_figure(po PlotOptions) &Figure {
	mut fig := &Figure{
		gg: 0
		g_po: po
	}
	fig.gg = gg.new_context(
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
	// clean plotoptions here
	fig.gg.run()
}

fn frame(fig &Figure) {
	fig.gg.begin()
	for plot in fig.plots {
		plot.draw(fig.gg)
	}
	fig.gg.end()
}
