#! /usr/bin/env python
# -*- coding: utf-8 -*-
# Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
# Description: project #2 module for BMS course @ FIT VUT
# This module parses NIT and stores info about the stream

import struct

NIT = dict()

def readFile(filehandle, startPos, width):
	"""
	Same as in the main file, just lazy to link it
	"""
	filehandle.seek(startPos,0)
	if width == 4:
		string = filehandle.read(4)
		if string == '':
			raise IOError
		return struct.unpack('>L',string[:4])[0]
	elif width == 2:
		string = filehandle.read(2)
		if string == '':
			raise IOError
		return struct.unpack('>H',string[:2])[0]
	elif width == 1:
		string = filehandle.read(1)
		if string == '':
			raise IOError
		return struct.unpack('>B',string[:1])[0]

def readDescriptors(filehandle, k):
	desc = readFile(filehandle, k, 2)
	return (desc)&0xFF, (desc>>8)&0xFF

def printNIT():
	print "Network name: %s" % NIT['network_name']
	print "Network ID: %s" % NIT['network_id']
	print "Bandwidth: %s" % NIT['bandwidth']
	print "Constellation: %s" % NIT['constellation']
	print "Guard interval: %s" % NIT['guard_interval']
	print "Code rate: %s" % NIT['code_rate']
	print ""

def calcBitrate():
	"""
	Calculate bitrate of the whole stream

	Origin: http://www.dveo.com/broadcast/bit-rate-calculation-for-COFDM-modulation.shtml
	"""
	base = 49764705.88

	if NIT['constellation'] == '64-QAM':
		modulation = 0.75
	elif NIT['constellation'] == '16-QAM':
		modulation = 0.5
	elif NIT['constellation'] == 'QPSK':
		modulation = 0.25

	if NIT['code_rate'] == '1/2':
		code_rate = 0.5
	elif NIT['code_rate'] == '2/3':
		code_rate = 2.0/3.0
	elif NIT['code_rate'] == '3/4':
		code_rate = 0.75
	elif NIT['code_rate'] == '5/6':
		code_rate = 5.0/6.0
	elif NIT['code_rate'] == '7/8':
		code_rate = 7.0/8.0

	if NIT['guard_interval'] == '1/32':
		guard_interval = 32.0/33.0
	elif NIT['guard_interval'] == '1/16':
		guard_interval = 16.0/17.0
	elif NIT['guard_interval'] == '1/8':
		guard_interval = 8.0/9.0
	elif NIT['guard_interval'] == '1/4':
		guard_interval = 4.0/5.0

	mbps = 1000.0 * 1000.0

	C = base * modulation * code_rate * guard_interval

	return(C / mbps)

def parseNITSection(filehandle, k):
	"""
	Parse NIT and extract all needed info from descriptors
	"""

	table_id = readFile(filehandle, k, 1)
	section_length = readFile(filehandle, k+1, 2) & 0xFFF
	network_id = readFile(filehandle, k+3, 2)
	desc_length = (readFile(filehandle, k + 8, 2))&0xFFF

	# We need to parse the table only the first time we have NIT packet
	if 'network_id' in NIT and network_id == NIT['network_id']:
		return

	NIT['network_id'] = network_id
	NIT['table_id'] = hex(table_id)
	NIT['desc_length'] = desc_length

	# first part of NIT
	if desc_length != 0:
		i = 0
		while i <= NIT['desc_length']:
			length, tag = readDescriptors(filehandle, k + 10 + i)

			if tag == 0x40:
				name = ""
				j = 2
				while j <= length+1:
					name += chr(readFile(filehandle, k + 10 + i + j, 1))
					j += 1
				NIT['network_name'] = name

			elif tag == 0x5A:
				local = readFile(filehandle, k + 16 + i, 1)
				NIT["bandwidth"] = local&0xE0
				exit(0)

			i += length + 2

	m = k + desc_length + 10

	NIT['ts_length'] = (readFile(filehandle, m, 2))&0xFFF

	if NIT['ts_length'] > 0:
		desc_len = readFile(filehandle, m+6, 2)&0xFFF

		i = 0

		while i < desc_len:
			length, tag = readDescriptors(filehandle, m + 8 + i)

			if tag == 0x5A:
				NIT['bandwidth'] = readFile(filehandle, m + 8 + i + 6, 1)>>5

				if NIT['bandwidth'] != 0:
					raise Exception("I am ready only for 8 MHz bandwidth")
				else:
					NIT['bandwidth'] = '8 Mhz'

				m += 1

				loc = readFile(filehandle, m + 8 + i + 6, 2)

				constellation = loc>>14

				if constellation == 0:
					NIT['constellation'] = 'QPSK'
				elif constellation == 1:
					NIT['constellation'] = '16-QAM'
				elif constellation == 2:
					NIT['constellation'] = '64-QAM'

				code_rate = (loc>>8)&0x7

				if code_rate == 0:
					NIT['code_rate'] = '1/2'
				elif code_rate == 1:
					NIT['code_rate'] = '2/3'
				elif code_rate == 2:
					NIT['code_rate'] = '3/4'
				elif code_rate == 3:
					NIT['code_rate'] = '5/6'
				elif code_rate == 4:
					NIT['code_rate'] = '7/8'

				guard_interval = (loc>>3)&0x3

				if guard_interval == 0:
					NIT['guard_interval'] = '1/32'
				elif guard_interval == 1:
					NIT['guard_interval'] = '1/16'
				elif guard_interval == 2:
					NIT['guard_interval'] = '1/8'
				elif guard_interval == 3:
					NIT['guard_interval'] = '1/4'

			i += length + 2

