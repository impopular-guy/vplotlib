module vplotlib

import time

pub const (
	version = '0.0.0'
)

pub fn l_info(s string) {
	println('INFO ${time.now()} : ${s}')
}
