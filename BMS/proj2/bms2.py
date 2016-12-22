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
import Tkinter
import tkMessageBox
import tkFileDialog
import sys
from optparse import OptionParser
from cStringIO import StringIO
import pdb

from nit import printNIT, parseNITSection

programs = dict()
packets = dict()
SDTpacket = ""
NIT = {"network_id" : 0}
zero = 0

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


PAT = dict()

def parsePATSection(filehandle, k, p=False):

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
			#if p: print 'program_map_PID = 0x%04X' %program_map_PID

		if program_number != 0 and hex(program_map_PID) not in NIT:
			PAT["0x{:04X}".format(program_map_PID)] = {"service_provider": "", "service_name" : "", "program_number" : hex(program_number)}

		length = length - 4;
		j += 4


def parsePMTSection(filehandle, k):

	local = readFile(filehandle,k,4)

	table_id = (local>>24)
	if (table_id != 0x2):
		print 'Ooops! error in parsePMTSection()!'
		return

	print '------- PMT Information -------'

	section_length = (local>>8)&0xFFF
	print 'section_length = %d' %section_length

	program_number = (local&0xFF) << 8;

	local = readFile(filehandle, k+4, 4)

	program_number += (local>>24)&0xFF
	print 'program_number = %d' %program_number

	version_number = (local>>17)&0x1F
	current_next_indicator = (local>>16)&0x1
	section_number = (local>>8)&0xFF
	last_section_number = local&0xFF;
	print 'section_number = %d, last_section_number = %d' %(section_number, last_section_number)

	local = readFile(filehandle, k+8, 4)

	PCR_PID = (local>>16)&0x1FFF
	print 'PCR_PID = 0x%X' %PCR_PID
	program_info_length = (local&0xFFF)
	print 'program_info_length = %d' %program_info_length

	n = program_info_length
	m = k + 12;
	while (n>0):
		descriptor_tag = readFile(filehandle, m, 1)
		if descriptor_tag == 64:
			found = True
		descriptor_length = readFile(filehandle, m+1, 1)
		print 'descriptor_tag = %d, descriptor_length = %d' %(descriptor_tag, descriptor_length)
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

		print 'stream_type = 0x%X, elementary_PID = 0x%X, ES_info_length = %d' %(stream_type, elementary_PID, ES_info_length)
		n = ES_info_length
		m = j+5;
		while (n>0):
			descriptor_tag = readFile(filehandle, m, 1)
			descriptor_length = readFile(filehandle, m+1, 1)
			print 'descriptor_tag = %d, descriptor_length = %d' %(descriptor_tag, descriptor_length)
			n -= descriptor_length + 2
			m += descriptor_length + 2


		j += 5 + ES_info_length
		length -= 5 + ES_info_length

	print ''

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
	#pdb.set_trace()
	#print('----------------SDT packet-----------')
	global NIT
	filehandle = StringIO(rawPacket)

	#print(filehandle.read().encode('hex'))

	table_id = readFile(filehandle, k, 1)
	section_length = (readFile(filehandle, k+1, 2) & 0xFFF) - 12
	ts_id = readFile(filehandle, k +3, 2)
	current_next_indicator = readFile(filehandle, k+5, 1)&0x1
	section_number = readFile(filehandle, k+6, 1)
	last_section_number = readFile(filehandle, k+7, 1)
	orig_network_id = readFile(filehandle, k+8, 2)

	#print("section_length: " + str(section_length))

	try:
		sec = 0
		while sec < section_length:
			service_id = readFile(filehandle, k + 11 + sec, 2)
			#print("service_id", hex(service_id))

			desc_loop_len = readFile(filehandle, k + 14 + sec, 2)& 0xFFF
			#print("desc_loop_len", desc_loop_len)

			i = 0
			m = k + 14 + 2 + sec
			while i <= desc_loop_len:
				#print("i", i)
				tag = readFile(filehandle, m + i, 1)
				length = readFile(filehandle, m + i + 1, 1)

				# parse service_descriptor
				if tag == 0x48:
					provider_name = ""
					provider_name_len = readFile(filehandle,  m + i + 3, 1)
					#print('provider_name_len', provider_name_len)
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


					#print(provider_name)
					#print(service_name)

					for key in PAT:
						print "prog num", PAT[key]["program_number"]
						print "service_id", hex(service_id)
						if hex(service_id) == PAT[key]["program_number"]:
							print("match!")
							PAT[key]["service_name"] = service_name
							PAT[key]["service_provider"] = provider_name
							print(PAT)


				i += length + 2
			sec += desc_loop_len + 5
			#print("sec:", sec)
	except IOError:
		print("io error")
		filehandle.seek(0,0)
		print(filehandle.read().encode('hex'))
		filehandle.seek(0,0)
		print(filehandle.read())
		return



	#print("0x{:04X}".format(ts_id))
def parseTSMain(filehandle, packet_size, mode, pid, psi_mode, searchItem):
	global SDTpacket, zero

	PCR = SystemClock()
	PESPktInfo = PESPacketInfo()

	n = 0
	packetCount = 0
	rdi_count = 0

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

			payload_unit_start_indicator = (PacketHeader >> 22) & 0x1

			PID = ((PacketHeader>>8) & 0x1FFF)
##            if (PID == 0x0):
##                print 'Found PAT Packet! packet No. %d' %packetCount
##                print 'payload_unit_start_indicator = %d' %payload_unit_start_indicator

			if PID not in packets:
				packets[PID] = { "count" : 1, "hex" : hex(PID) }
			else:
				packets[PID]["count"] += 1

			adapt_field = ((PacketHeader>>4)&0x3)
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

				#if ((table_id == 0x0)&(PID != 0x0)):
				#		print(table_id)
				#		print 'Something wrong in packet No. %d' %packetCount

				if (adapt_field == 0x3):
					Adaptation_Field_Length = readFile(filehandle, n + 4, 1)

				k = n+Adaptation_Field_Length+4+1+pointer_field
				table_id = readFile(filehandle, k, 1)

				# PAT packet
				if (PID == 0x0):
					#print 'pasing PAT Packet! packet No. %d, PID = 0x%X' %(packetCount, PID)
					parsePATSection(filehandle, k, p=True)

				# NIT packet
				elif (PID == 0x10):
					#print("found NIT packet")
					parseNITSection(filehandle, k)

				# SDT
				elif PID == 0x11:
					#pdb.set_trace()
					if payload_unit_start_indicator == 1:
						if SDTpacket != "":
							parseSDTSection(SDTpacket, 0)
						filehandle.seek(k,0)
						SDTpacket = filehandle.read(184)
					else:
						filehandle.seek(k - pointer_field,0)
						SDTpacket += filehandle.read(184)


				# PMT packet
				"""elif (table_id == 0x2):
					if ((psi_mode == 2) & (searchItem == "PMT")):
						if PID not in PIDList:
							PIDList.append(PID)
						else:
							n += packet_size
							packetCount += 1
							continue
					#print 'pasing PMT Packet! packet No. %d, PID = 0x%X' %(packetCount, PID)
					#parsePMTSection(filehandle, k)

				# SIT packet
				elif (table_id == 0x7F):
					if ((psi_mode == 2)&(searchItem == "SIT")):
						if PID not in PIDList:
							PIDList.append(PID)
						else:
							n += packet_size
							packetCount += 1
							continue
					#print 'pasing SIT Packet! packet No. %d, PID = 0x%X' %(packetCount, PID)
					#parseSITSection(filehandle, k)

				if (PID == pid):
					last_SameES_packetNo = packetCount
					"""

			# skip to next TS packet and increase packet count by 1.
			n += packet_size
			packetCount += 1

	except IOError:
		print 'Finished reading TS file'
		print(PIDList)
		print 'Packet count: %S', packetCount
		filehandle.close()
	else:
		filehandle.close()

	print '================================================\n'
	for i in range(len(EntryPESPacketNumList)):
		print 'TPI = 0x%x, PTS = 0x%x, EntryPESPacketNum = 0x%x' %(TPIList[i], PTSList[i], EntryPESPacketNumList[i])


def getFilename():
	root=Tkinter.Tk()
	fTyp=[('.ts File','*.ts'),('.TOD File','*.TOD'),('.trp File','*.trp'),('All Files','*.*')]
	iDir='~/'
	filename=tkFileDialog.askopenfilename(filetypes=fTyp,initialdir=iDir)
	root.destroy()
	return filename;

def Main():

	description = "This is a python script for parsing MPEG-2 TS stream"
	usage = "\n\t%prog -t <188|192|204> -m PAT\
			\n\t%prog -t <188|192|204> -m <PMT|ES|SIT> PID\
			\n\t%prog -s PCR \
			\n\t%prog -s <PAT|PMT|SIT> --all \
			\n\t%prog -s <PAT|PMT|SIT> --unique\n\n \
			Example: TSParser.py -t 188 -m PMT 1fc8"

	cml_parser = OptionParser(description = description, usage=usage)
	cml_parser.add_option("-f", "--file", action="store", type="string", dest="filename", default="",
			help="specify file name, if not specified, a file open dialogbox will be shown.")

	cml_parser.add_option("-t", "--type", action="store", type="int", dest="packet_size", default="188",
			help="specify TS packet size[188, 192, 204], default = 188")

	cml_parser.add_option("-m", "--mode", action="store", type="string", dest="mode", default="PAT",
			help="specify parsing mode[PAT, PMT, SIT, ES], default = PAT")

	cml_parser.add_option("-s", "--search", action="store", type="string", dest="searchItem", default="FFF",
			help="search PAT/PMT/PCR/SIT packets and output Information.")

	cml_parser.add_option("--all", action="store_const", const=10, dest="psi_mode", default=0,
			help="Output all PAT/PMT/SIT packets Information. default, only the first one is output.")

	cml_parser.add_option("--unique", action="store_const", const=2, dest="psi_mode", default=0,
			help="Output unique PAT/PMT/SIT packets Information. default, only the first one is output.")

	(opts, args) = cml_parser.parse_args(sys.argv)

	if ((opts.searchItem == "FFF") & (opts.mode != "PAT") & (len(args) < 2)):
		cml_parser.print_help()
		return

	if ((opts.searchItem == "FFF") & (opts.mode != "PAT")):
		pid = int(args[1], 16)
	else:
		pid = 0;

	if ((opts.searchItem != "FFF") & (opts.searchItem != "PAT") & \
			(opts.searchItem != "PMT") & (opts.searchItem != "PCR") &
			(opts.searchItem != "SIT")):
		cml_parser.print_help()
		return

	psi_mode = 0
	if (opts.searchItem != "FFF"):
		psi_mode = opts.psi_mode

	if (opts.filename == ""):
		filename = getFilename()
	else:
		filename = opts.filename

	if (filename == ""):
		return

	print filename
	filehandle = open(filename,'rb')

	parseTSMain(filehandle, opts.packet_size, opts.mode, pid, psi_mode, opts.searchItem)


if __name__ == "__main__":
	global NIT

	Main()
	#print(programs)
	#print(packets)

	#for pid in packets:
#		if pid in programs:
#			print("\t\t" + hex(pid))
#			print(packets[pid])
#			print(programs[pid])

	printNIT()

	print PAT

	for key, value in sorted(PAT.iteritems()):
		print "%s: %s" % (key, value)
