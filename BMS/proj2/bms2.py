#! /usr/bin/python
# -*- coding: cp932 -*-

#this Python script is used to parse MPEG-2 TS stream
#
#Author: Zhaohui Guo (guo.zhaohui@gmail.com)
#Copyright(c)2012 Zhaohui GUO

"""this script is used to parse MPEG-2 TS stream.
"""
import sys
import struct
#import Tkinter
#import tkMessageBox
#import tkFileDialog
import sys
#from optparse import OptionParser
from cStringIO import StringIO
#import pdb
from os.path import basename, splitext

from nit import printNIT, parseNITSection, calcBitrate

programs = dict()
packets = dict()
SDTpacket = ""
NIT = {"network_id" : 0}
PAT = dict()
packetCount = 0

class SystemClock:
	def __init__(self):
		self.PCR_base_hi = 0x0
		self.PCR_base_lo = 0x0
		self.PCR_extension = 0x0
	def setPCR(self, PCR_base_hi, PCR_base_lo, PCR_extension):
		self.PCR_base_hi = PCR_base_hi
		self.PCR_base_lo = PCR_base_lo
		self.PCR_extension = PCR_extension
	def getPCR(self):
		return self.PCR_base_hi, self.PCR_base_lo, self.PCR_extension

class PESPacketInfo:
	def __init__(self):
		self.PTS_hi = 0
		self.PTS_lo = 0
		self.streamID = 0
		self.AUType = ""
	def setPTS(self, PTS_hi, PTS_lo):
		self.PTS_hi = PTS_hi
		self.PTS_lo = PTS_lo
	def getPTS(self):
		return self.PTS_hi, self.PTS_lo
	def setStreamID(self, streamID):
		self.streamID = streamID
	def setAUType(self, auType):
		self.AUType = auType
	def getStreamID(self):
		return self.streamID
	def getAUType(self):
		return self.AUType

def readFile(filehandle, startPos, width):
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

def parseAdaptation_Field(filehandle, startPos, PCR):
	n = startPos
	flags = 0
	adaptation_field_length = readFile(filehandle,n,1)
	if adaptation_field_length > 0:
		flags = readFile(filehandle,n+1,1)
		PCR_flag = (flags>>4)&0x1
		if PCR_flag == 1:
			PCR1 = readFile(filehandle,n+2,4)
			PCR2 = readFile(filehandle,n+6,2)
			PCR_base_hi = (PCR1>>31)&0x1
			PCR_base_lo = (PCR1<<1)+ ((PCR2>>15)&0x1)
			PCR_ext = PCR2&0x1FF
			PCR.setPCR(PCR_base_hi, PCR_base_lo, PCR_ext)
	return [adaptation_field_length + 1, flags]

def getPTS(filehandle, startPos):
	n = startPos
	time1 = readFile(filehandle,n,1)
	time2 = readFile(filehandle,n+1,2)
	time3 = readFile(filehandle,n+3,2)
	PTS_hi = (time1>>3)&0x1
	PTS_low = ((time1>>1)&0x3)<<30
	PTS_low += ((time2>>1)&0x7FFF)<<15
	PTS_low += ((time3>>1)&0x7FFF)

	return PTS_hi, PTS_low

def parseIndividualPESPayload(filehandle, startPos):

	n = startPos

##    local1 = readFile(filehandle,n,4)
##    local2 = readFile(filehandle,n+4,4)
##    local3 = readFile(filehandle,n+8,4)
##    print 'NAL header = 0x%08X%08X%08X' %(local1,local2,local3)

	local = readFile(filehandle,n,4)
	k = 0
	while((local&0xFFFFFF00) != 0x00000100):
		k += 1;
		if (k > 100):
			return "Unknown AU type"
		local = readFile(filehandle,n+k,4)

	if(((local&0xFFFFFF00) == 0x00000100)&(local&0x1F == 0x9)):
		primary_pic_type = readFile(filehandle,n+k+4,1)
		primary_pic_type = (primary_pic_type&0xE0)>>5
		if (primary_pic_type == 0x0):
			return "IDR_picture"
		else:
			return "non_IDR_picture"

def parsePESHeader(filehandle, startPos,PESPktInfo):
	n = startPos
	stream_ID = readFile(filehandle, n+3, 1)
	PES_packetLength = readFile(filehandle, n+4, 2)
	PESPktInfo.setStreamID(stream_ID)

	k = 6

	if ((stream_ID != 0xBC)& \
			(stream_ID != 0xBE)& \
			(stream_ID != 0xF0)& \
			(stream_ID != 0xF1)& \
			(stream_ID != 0xFF)& \
			(stream_ID != 0xF9)& \
			(stream_ID != 0xF8)):

		PES_packet_flags = readFile(filehandle, n+5, 4)
		PTS_DTS_flag = ((PES_packet_flags>>14)&0x3)
		PES_header_data_length = PES_packet_flags&0xFF

		k += PES_header_data_length + 3

		if (PTS_DTS_flag == 0x2):
			(PTS_hi, PTS_low) = getPTS(filehandle, n+9)
##            print 'PTS_hi = 0x%X, PTS_low = 0x%X' %(PTS_hi, PTS_low)
			PESPktInfo.setPTS(PTS_hi, PTS_low)

		elif (PTS_DTS_flag == 0x3):
			(PTS_hi, PTS_low) = getPTS(filehandle, n+9)
##            print 'PTS_hi = 0x%X, PTS_low = 0x%X' %(PTS_hi, PTS_low)
			PESPktInfo.setPTS(PTS_hi, PTS_low)

			(DTS_hi, DTS_low) = getPTS(filehandle, n+14)
##            print 'DTS_hi = 0x%X, DTS_low = 0x%X' %(DTS_hi, DTS_low)
		else:
			k = k
			return

		auType = parseIndividualPESPayload(filehandle, n+k)
		PESPktInfo.setAUType(auType)


def parsePATSection(filehandle, k):

	local = readFile(filehandle,k,4)
	table_id = (local>>24)
	if (table_id != 0x0):
		raise Exception('Table ID not valid (' + str(table_id) + ')')

	section_length = (local>>8)&0xFFF
	transport_stream_id = (local&0xFF) << 8;
	local = readFile(filehandle, k+4, 4)
	transport_stream_id += (local>>24)&0xFF
	transport_stream_id = (local >> 16)
	version_number = (local>>17)&0x1F
	current_next_indicator = (local>>16)&0x1
	section_number = (local>>8)&0xFF
	last_section_number = local&0xFF;

	length = section_length - 4 - 5
	j = k + 8

	while (length > 0):
		local = readFile(filehandle, j, 4)
		program_number = (local>>16)
		program_map_PID = local&0x1FFF

		if program_number != 0 and hex(program_map_PID) not in PAT:
			PAT[hex(program_map_PID)] = {
					"service_provider": "",
					"service_name" : "",
					"program_number" : hex(program_number),
					"pmt" : []
				}

		length = length - 4;
		j += 4


def parsePMTSection(filehandle, k, PID):

	local = readFile(filehandle,k,4)

	table_id = (local>>24)
	if (table_id != 0x2):
		raise Exception('table_id doesn\'t match 0x2 (' + hex(table_id) +')!')

	section_length = (local>>8)&0xFFF

	program_number = (local&0xFF) << 8;

	local = readFile(filehandle, k+4, 4)

	program_number += (local>>24)&0xFF

	version_number = (local>>17)&0x1F
	current_next_indicator = (local>>16)&0x1
	section_number = (local>>8)&0xFF
	last_section_number = local&0xFF;

	local = readFile(filehandle, k+8, 4)

	PCR_PID = (local>>16)&0x1FFF
	program_info_length = (local&0xFFF)

	n = program_info_length
	m = k + 12;
	while (n>0):
		descriptor_tag = readFile(filehandle, m, 1)
		descriptor_length = readFile(filehandle, m+1, 1)
		n -= descriptor_length + 2
		m += descriptor_length + 2

	j = k + 12 + program_info_length
	length = section_length - 4 - 9 - program_info_length

	while (length > 0):
		local1 = readFile(filehandle, j, 1)
		local2 = readFile(filehandle, j+1, 4)

		stream_type = local1;
		elementary_PID = (local2>>16)&0x1FFF
		ES_info_length = local2&0xFFF

		if elementary_PID not in PAT[hex(PID)]["pmt"]:
			PAT[hex(PID)]["pmt"].append(elementary_PID)

		n = ES_info_length
		m = j+5;
		while (n>0):
			descriptor_tag = readFile(filehandle, m, 1)
			descriptor_length = readFile(filehandle, m+1, 1)
			n -= descriptor_length + 2
			m += descriptor_length + 2

		j += 5 + ES_info_length
		length -= 5 + ES_info_length


def parseSITSection(filehandle, k):
	local = readFile(filehandle,k,4)

	table_id = (local>>24)
	if (table_id != 0x7F):
		print 'Ooops! error in parseSITSection()!'
		return

	print '------- SIT Information -------'

	section_length = (local>>8)&0xFFF
	print 'section_length = %d' %section_length
	local = readFile(filehandle, k+4, 4)

	section_number = (local>>8)&0xFF
	last_section_number = local&0xFF;
	print 'section_number = %d, last_section_number = %d' %(section_number, last_section_number)
	local = readFile(filehandle, k+8, 2)
	transmission_info_loop_length = local&0xFFF
	print 'transmission_info_loop_length = %d' %transmission_info_loop_length

	n = transmission_info_loop_length
	m = k + 10;
	while (n>0):
		descriptor_tag = readFile(filehandle, m, 1)
		descriptor_length = readFile(filehandle, m+1, 1)
		print 'descriptor_tag = %d, descriptor_length = %d' %(descriptor_tag, descriptor_length)
		n -= descriptor_length + 2
		m += descriptor_length + 2

	j = k + 10 + transmission_info_loop_length
	length = section_length - 4 - 7 - transmission_info_loop_length

	while (length > 0):
		local1 = readFile(filehandle, j, 4)
		service_id = (local1>>16)&0xFFFF;
		service_loop_length = local1&0xFFF
		print 'service_id = %d, service_loop_length = %d' %(service_id, service_loop_length)

		n = service_loop_length
		m = j+4;
		while (n>0):
			descriptor_tag = readFile(filehandle, m, 1)
			descriptor_length = readFile(filehandle, m+1, 1)
			print 'descriptor_tag = %d, descriptor_length = %d' %(descriptor_tag, descriptor_length)
			n -= descriptor_length + 2
			m += descriptor_length + 2

		j += 4 + service_loop_length
		length -= 4 + service_loop_length
	print ''






def parseSDTSection(rawPacket, k):
	global NIT
	filehandle = StringIO(rawPacket)

	table_id = readFile(filehandle, k, 1)
	section_length = (readFile(filehandle, k+1, 2) & 0xFFF) - 12
	ts_id = readFile(filehandle, k +3, 2)
	current_next_indicator = readFile(filehandle, k+5, 1)&0x1
	section_number = readFile(filehandle, k+6, 1)
	last_section_number = readFile(filehandle, k+7, 1)
	orig_network_id = readFile(filehandle, k+8, 2)

	try:
		sec = 0
		while sec < section_length:
			service_id = readFile(filehandle, k + 11 + sec, 2)

			desc_loop_len = readFile(filehandle, k + 14 + sec, 2)& 0xFFF

			i = 0
			m = k + 14 + 2 + sec
			while i <= desc_loop_len:
				tag = readFile(filehandle, m + i, 1)
				length = readFile(filehandle, m + i + 1, 1)

				# parse service_descriptor
				if tag == 0x48:
					provider_name = ""
					provider_name_len = readFile(filehandle,  m + i + 3, 1)
					j = 1
					while j <= provider_name_len:
						provider_name += chr(readFile(filehandle, m + i + 3 + j, 1))
						j += 1

					service_name = ""
					service_name_len = readFile(filehandle,  m + i + provider_name_len + 4, 1)

					j = 1
					while j <= service_name_len:
						service_name += chr(readFile(filehandle, m + 4 + i + j + provider_name_len, 1))
						j += 1

					for key in PAT:
						if hex(service_id) == PAT[key]["program_number"]:
							PAT[key]["service_name"] = service_name
							PAT[key]["service_provider"] = provider_name

				i += length + 2
			sec += desc_loop_len + 5
	except IOError:
		return



def parseTSMain():
	filename = sys.argv[1]

	filehandle = open(filename,'rb')

	global SDTpacket, zero

	PCR = SystemClock()
	PESPktInfo = PESPacketInfo()

	n = 0
	rdi_count = 0
	packet_size = 188
	global packetCount

	EntryPESPacketNumList = []
	TPIList = []
	PTSList = []
	PIDList = []

	idr_flag = False
	last_SameES_packetNo = 0
	last_EntryTPI = 0

	try:
		while(True):
			PacketHeader = readFile(filehandle,n,4)

			if ((PacketHeader>>24) != 0x47):
				raise Exception("SyncByte not found!")

			payload_unit_start_indicator = (PacketHeader>>22)&0x1

			PID = (PacketHeader>>8)&0x1FFF

			if PID not in packets:
				packets[PID] = 0
			else:
				packets[PID] += 1

			adapt_field = (PacketHeader>>4)&0x3
			Adaptation_Field_Length = 0

			if (adapt_field == 0x1) or (adapt_field == 0x3):
				PESstartCode = readFile(filehandle, n+4, 4)

				"""if ((PESstartCode&0xFFFFFF00) == 0x00000100)&(PID == pid)&(payload_unit_start_indicator == 1):
					parsePESHeader(filehandle, n+Adaptation_Field_Length+4, PESPktInfo)
					PTS_MSB24 = ((PESPktInfo.PTS_hi&0x1)<<23)|((PESPktInfo.PTS_lo>>9)&0x7FFFFF)
					print 'PES start, packet No. %d, PID = 0x%x, PTS_MSB24 = 0x%x PTS_hi = 0x%X, PTS_low = 0x%X' \
							%(packetCount, PID, PTS_MSB24, PESPktInfo.PTS_hi, PESPktInfo.PTS_lo)

					if (mode == 'ES'):
						print 'packet No. %d,  ES PID = 0x%X,  Steam_ID = 0x%X,  AU_Type = %s' \
								%(packetCount, PID, PESPktInfo.getStreamID(), PESPktInfo.getAUType())

						if (idr_flag == True):
							EntryPESPacketNumList.append(last_SameES_packetNo - last_EntryTPI +1)
							print 'packet No. %d, ES PID = 0x%X, Steam_ID = 0x%X, AU_Type = %s' \
									%(packetCount, PID, PESPktInfo.getStreamID(), PESPktInfo.getAUType())


						if (PESPktInfo.getAUType() == "IDR_picture"):
							idr_flag = True
							last_EntryTPI = packetCount
							print 'packet No. %d, ES PID = 0x%X, Steam_ID = 0x%X, AU_Type = %s' \
									%(packetCount, PID, PESPktInfo.getStreamID(), PESPktInfo.getAUType())
							TPIList.append(packetCount)
							PTSList.append(PTS_MSB24)
						else:
							idr_flag = False

				elif (((PESstartCode&0xFFFFFF00) != 0x00000100)&(payload_unit_start_indicator == 1)):
"""
				pointer_field = (PESstartCode >> 24)

				# Adapt Field has length
				if (adapt_field == 0x3):
					Adaptation_Field_Length = readFile(filehandle, n + 4, 1)

				k = n + Adaptation_Field_Length + 4 + 1 + pointer_field

				table_id = readFile(filehandle, k, 1)

				# PAT packet
				if (PID == 0x0):
					parsePATSection(filehandle, k)

				# NIT packet
				elif (PID == 0x10):
					parseNITSection(filehandle, k)

				# SDT packet
				elif PID == 0x11:
					if payload_unit_start_indicator == 1:
						if SDTpacket != "":
							parseSDTSection(SDTpacket, 0)
						filehandle.seek(k,0)
						SDTpacket = filehandle.read(183)
					else:
						filehandle.seek(k - pointer_field-1,0)
						SDTpacket += filehandle.read(184)

				# PMT packet
				elif (table_id == 0x2) and hex(PID) in PAT:
					parsePMTSection(filehandle, k, PID)

			# seek to next packet and increment packet count
			n += packet_size
			packetCount += 1

	except IOError:
		filehandle.close()
	else:
		filehandle.close()


def getFilename():
	root=Tkinter.Tk()
	fTyp=[('.ts File','*.ts'),('.TOD File','*.TOD'),('.trp File','*.trp'),('All Files','*.*')]
	iDir='~/'
	filename=tkFileDialog.askopenfilename(filetypes=fTyp,initialdir=iDir)
	root.destroy()
	return filename

def calcProgramBitrate(pids, bitrate):
	prog_packets = 0
	for pid in pids:
		try:
			prog_packets += packets[pid]
		except:
			pass

	res = (float(prog_packets) / packetCount) * bitrate
	return res

def printPAT():
	tmp_PAT = dict()
	bitrate = calcBitrate()

	#reorder keys
	for key, value in PAT.iteritems():
		tmp_PAT["0x{:04x}".format(int(key, 16))] = value

	for key, value in sorted(tmp_PAT.iteritems()):
		pids = value['pmt']
		pids.append(int(key, 16))
		print "%s-%s-%s: %.2f Mbps" % (key, value['service_provider'], value['service_name'], calcProgramBitrate(pids, bitrate))


if __name__ == "__main__":
	if len(sys.argv) != 2:
		raise Exception("You can specify only filename to read from!")

	fileout = splitext(sys.argv[1])[0] + '.txt'

	outhandle = open(fileout, 'w')
	sys.stdout = outhandle

	parseTSMain()
	bandwidth = calcBitrate()

	printNIT()
	printPAT()

	outhandle.close()

	"""for key, value in sorted(PAT.iteritems()):
		print "%s (%d): %s" % (key, int(key, 16), value)

	for key, value in sorted(packets.iteritems()):
		print "%s: %s" % (key, value)"""


