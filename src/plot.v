module vplotlib

import gg
import gx

interface Plot {
	po PlotOptions
	draw(&gg.Context)
}

struct App {
mut:
	gg   &gg.Context = unsafe { nil }
	plot Plot
}

fn run(plot Plot) {
	mut app := &App{
		gg: 0
		plot: plot
	}
	app.gg = gg.new_context(
		bg_color: gx.white
		width: plot.po.width
		height: plot.po.height
		create_window: true
		window_title: plot.po.title
		frame_fn: frame
		user_data: app
	)
	app.gg.run()
}

fn frame(app &App) {
	app.gg.begin()
	app.plot.draw(app.gg)
	app.gg.end()
}
