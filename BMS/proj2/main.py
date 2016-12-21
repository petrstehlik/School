import sys
import os
import argparse
import binascii
import struct

def bytes_from_file(filename, chunksize=8192):
    with open(filename, "rb") as f:
        while True:
            chunk = f.read(chunksize)
            if chunk:
                for b in chunk:
                    yield b
            else:
                break

# example:
#for b in bytes_from_file('multiplex.ts', chunksize=188*8):
#    print(b, end="")


class TSRead():
	def __init__(self, tsfile):
		self.tsfile = tsfile
		self.descriptor = open(tsfile, 'rb')
		self.packet_number = 0
		self.packets = os.path.getsize(tsfile) / 188
		self.pos = 0

	def header(self):
		self.pos += 188
		self.header_bytes = self.descriptor.read(188)
		self.packet_number += 1

	def print_tables(self):
		while True:
			packet = self.descriptor.read(188)
			print(packet[:1])


def readFile(handle, startPos, width = 4):
	handle.seek(startPos, 0)

	if width > 4:
		raise Exception("Cannot read more than 4 bytes at a time")

	string = handle.read(width)
	if string == '':
		raise IOError

	if width == 4:
		return struct.unpack('>L',string[:4])[0]
	elif width == 2:
		return struct.unpack('>H',string[:2])[0]
	elif width == 1:
		return struct.unpack('>B',string[:1])[0]
	else:
		raise Exception("Supported widths are 4, 2 or 1")


def parseMain(handle):
	n = 0
	packet_count = 0
	pid_packet_count = 0

	PIDList = []

	try:
		while(True):
			PacketHeader = readFile(handle, n)

			syncByte = (PacketHeader>>24)
			if syncByte is not 0x47:
				raise Exception("Bad sync byte")

			PID = ((PacketHeader>>8) & 0x1FFF)

			if PID in [0x100, 0x101, 0x111, 0x113, 0x113, 0x121, 0x370]:
				pid_packet_count += 1

			if PID not in PIDList:
				PIDList.append(PID)

			if PID == 0x0010:
				print("Found PID table!")

			n += 188
			packet_count += 1

	except IOError as e:
		print(e)
		print("n: " + str(n))
		print("packet count: " + str(packet_count))
		print("pid packet count: " + str(pid_packet_count))
		print(PIDList)


if __name__ == "__main__":
	if len(sys.argv) > 1:
		file = sys.argv[1]
	else:
		raise Exception("Missing input file arguments")

	num_pac = 0

	with open(file, 'rb') as tsfile:
		parseMain(tsfile)
		"""while True:
			pac = tsfile.read(188)

			# Finish reading the file
			if not pac:
				break

			# Identify last incomplete packet
			if len(pac) != 188:
				print(pac)
				num_pac = num_pac - 1
			num_pac = num_pac + 1
			hexpac = binascii.hexlify(pac)
			un_pac = struct.unpack('>L', pac[:4])[0]
			#print(hexpac[0:2])
			if "VLTAVA" in pac:
				print("Raw packet: " + pac)
				print("HEX: " + hexpac)
			if hexpac[0:6] == '470011' or hexpac[0:8] == '4740111c':
				print(pac)
				print(hexpac)
				print(bin(un_pac))
			#if b'40' in hexpac:
		#		print(hexpac)
	print(num_pac)

	#reader = TSRead(file)
	#reader.print_tables();"""


