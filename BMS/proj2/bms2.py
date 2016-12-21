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

programs = dict()
packets = dict()
found = False
NIT = {"network_id" : 0}

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

def parsePATSection(filehandle, k, p=False):

	local = readFile(filehandle,k,4)
	table_id = (local>>24)
	if (table_id != 0x0):
		print 'Ooops! error in parsePATSection()!'
		return

	if p: print '------- PAT Information -------'
	section_length = (local>>8)&0xFFF
	if p: print 'section_length = %d' %section_length

	transport_stream_id = (local&0xFF) << 8;
	local = readFile(filehandle, k+4, 4)
	transport_stream_id += (local>>24)&0xFF
	transport_stream_id = (local >> 16)
	version_number = (local>>17)&0x1F
	current_next_indicator = (local>>16)&0x1
	section_number = (local>>8)&0xFF
	last_section_number = local&0xFF;
	if p: print 'section_number = %d, last_section_number = %d' %(section_number, last_section_number)

	length = section_length - 4 - 5
	j = k + 8

	while (length > 0):
		local = readFile(filehandle, j, 4)
		program_number = (local >> 16)
		program_map_PID = local & 0x1FFF
		if p: print 'program_number = 0x%X' %program_number
		if (program_number == 0):
			if p: print 'network_PID = 0x%X' %program_map_PID
		else:
			if p: print 'program_map_PID = 0x%4X' %program_map_PID

		if program_map_PID not in programs:
			programs[program_map_PID] = { "packets" : 1 }
		else:
			programs[program_map_PID]["packets"] += 1

		length = length - 4;
		j += 4

		if p: print ''

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

def readDescriptors(filehandle, k):
	desc = readFile(filehandle, k, 2)
	return (desc)&0xFF, (desc>>8)&0xFF

NIT_done = False

NIT_desc = [0x40, 0x41, 0x42, 0x43, 0x44, 0x4A, 0x5A,0x5B,0x5F,0x62,0x6C, 0x6D, 0x73, 0x77, 0x79, 0x7D, 0x7E, 0x7F]

#5A terestial delivery

def parseNITSection(filehandle, k):
	table_id = readFile(filehandle, k, 1)
	section_length = readFile(filehandle, k+1, 2) & 0xFFF
	network_id = readFile(filehandle, k+3, 2)
	desc_length = (readFile(filehandle, k + 8, 2))&0xFFF

	NIT['table_id'] = hex(table_id)
	NIT['network_id'] = network_id
	NIT['desc_length'] = desc_length

	print("desc_length: " + str(desc_length))

	# first part of NIT
	if desc_length != 0:
		i = 0
		while i <= NIT['desc_length']:
			length, tag = readDescriptors(filehandle, k + 10 + i)

			#if int(tag) not in NIT_desc and tag < 0x80:
			#	raise Exception("BAD DESCRIPTOR")

			#print(tag)
			print("tag: " + str(tag) + " len: " + str(length))

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
				print("bandwidth" + str(local&0xE0))
				print(NIT)
				exit(0)

			i += length + 2
	m = k + desc_length + 10

	NIT['ts_length'] = (readFile(filehandle, m, 2))&0xFFF

	if NIT['ts_length'] > 0:
		desc_len = readFile(filehandle, m+6, 2)&0xFFF

		i = 0

		while i < desc_len:
			length, tag = readDescriptors(filehandle, m + 8 + i)
			print("#2 tag: " + str(tag) + " len: " + str(length))

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

	print NIT

def parseTSMain(filehandle, packet_size, mode, pid, psi_mode, searchItem):

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
				table_id = readFile(filehandle,n+Adaptation_Field_Length+4+1+pointer_field,1)

				#if ((table_id == 0x0)&(PID != 0x0)):
				#		print(table_id)
				#		print 'Something wrong in packet No. %d' %packetCount

				k = n+Adaptation_Field_Length+4+1+pointer_field

				# PAT packet
				"""if (table_id == 0x0):
					if PID not in PIDList:
						PIDList.append(PID)
					else:
						n += packet_size
						packetCount += 1
						continue"""

					#print 'pasing PAT Packet! packet No. %d, PID = 0x%X' %(packetCount, PID)
					#parsePATSection(filehandle, k)

				# NIT packet
				if (PID == 0x10):
					#if (table_id == 0x0040):
					parseNITSection(filehandle, k)


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

	Main()
	print(programs)
	print(packets)

	for pid in packets:
		if pid in programs:
			print("\t\t" + hex(pid))
			print(packets[pid])
			print(programs[pid])

	print found
