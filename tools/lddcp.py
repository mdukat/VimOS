#!/usr/bin/python3
# Usage: lddcp.py $(which PROG)
# Returns: cp command without output directory

from sys import stdin

files = []
outcp = "cp "

for line in stdin:
	line = line[1:line.find("(")-1]
	if(line == "linux-vdso.so.1" or line == "/lib64/ld-linux-x86-64.so.2"):
		pass
	else:
		files.append(line[line.find("=>")+3:])

for a in files:
	outcp += a + " "

print(outcp)
