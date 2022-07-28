module main

import nedpals.vex.router
import nedpals.vex.server
import nedpals.vex.ctx

import json

struct RequestBody {
	name string
}

fn print_req_info(mut req ctx.Req, mut res ctx.Resp) {
	println('${req.method} ${req.path}')
}

fn do_stuff(mut req ctx.Req, mut res ctx.Resp) {
	println('incoming request')
}

fn main() {
	mut app := router.new()
	app.use(do_stuff, print_req_info)

	app.route(.get, '/', fn (req &ctx.Req, mut res ctx.Resp) {
		res.send_file('index.html', 200)
	})

	app.route(.post, '/', fn (req &ctx.Req, mut res ctx.Resp) {
		body := json.decode(RequestBody, req.body.bytestr()) or { RequestBody{''} }

		dump(body)

		res.send('OK', 200)
	})

	app.route(.post, '/builtin', fn (req &ctx.Req, mut res ctx.Resp) {
		body :=  req.parse_form() or { map[string]string{} }

		dump(body)

		res.send('OK', 200)
	})

	server.serve(app, 3000)
}
