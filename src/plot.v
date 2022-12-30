module vplotlib

import gg
import gx

interface Plot {
	po PlotOptions
	draw(&gg.Context)
}

// the struct names are subject to change
struct App {
mut:
	gg    &gg.Context = unsafe { nil }
	plots []Plot
	g_po  PlotOptions // global plotoptions
}

pub fn new_app(po PlotOptions) &App {
	mut app := &App{
		gg: 0
		g_po: po
	}
	app.gg = gg.new_context(
		bg_color: gx.white
		width: po.width
		height: po.height
		create_window: true
		window_title: po.title
		frame_fn: frame
		user_data: app
	)
	return app
}

pub fn (app &App) show() {
	// clean plotoptions here
	app.gg.run()
}

fn frame(app &App) {
	app.gg.begin()
	for plot in app.plots {
		plot.draw(app.gg)
	}
	app.gg.end()
}
