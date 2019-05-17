#!/usr/bin/env python3

import argparse
import io
import os
import struct
import re
import wave

def main():
	ap = argparse.ArgumentParser(description='Extract all sound effects from a Croc 2 wad file')
	ap.add_argument('wadfile', help='Input file')
	ap.add_argument('--list-only', action='store_true', help='List files without extracting')
	ap.add_argument('--no-decode', action='store_true', help='Do not convert to uncompressed PCM')
	ap.add_argument('--prefix', default='', help='Prefix for output file paths')
	args = ap.parse_args()

	with open(args.wadfile, 'rb') as wad:
		# Go to SMPC chunk and read number of sound files
		go_to_smpc_body(wad)
		num, = unpack_strm('<I', wad)
		# Read sound files
		for i in range(num):
			# Read magic number
			magic_number, = unpack_strm('<4s', wad)
			idx_padded = f'{i:0{str(len(str(num)))}}'
			print(f'{idx_padded}: {magic_number}')
			out_name = args.prefix + idx_padded
			out_wavname = out_name + '.wav'
			# Wave file: copy as is
			if magic_number == b'RIFF':
				riff_len, = unpack_strm('<I', wad)
				if args.list_only:
					wad.seek(riff_len, os.SEEK_CUR)
				else:
					copy_from_file(wad, out_wavname, riff_len,
						struct.pack('<4sI', magic_number, riff_len))
			# cvg
			elif magic_number == b'cvg ':
				cvg_len, = unpack_strm('<I', wad)
				if args.list_only:
					wad.seek(cvg_len, os.SEEK_CUR)
				elif args.no_decode:
					copy_from_file(wad, out_name + '.cvg', cvg_len,
						struct.pack('<4sI', magic_number, cvg_len))
				else:
					cvg = CvgFile()
					cvg.sample_rate, cvg.hdr4, cvg.hdr8, cvg.hdrC, cvg.len = \
						unpack_strm('<IIIII', wad)
					cvg.body = read_exactly(wad, cvg.len)
					cvg.decode(out_wavname)
			# Unknown magic number
			else:
				raise RuntimeError(f'Unknown audio format "{magic_number}"')

def go_to_smpc_body(f):
	buf = read_exactly(f, 48)
	if not re.match(b'^' +
		br'....' +
		br'OFNI\x04\x00\x00\x00\x01\x00\x00\x00' +
		br'SREV\x04\x00\x00\x00\x01\x00\x00\x00' +
		br'CPFW\x04\00\00\00....' +
		br'CPMS....' +
		b'$', buf
	):
		raise RuntimeError('Could not find SMPC chunk')

class CvgFile:
	def decode(self, wav_filename):
		with \
		open(wav_filename, 'xb') as f, \
		wave.open(f, 'wb') as wav:
			wav.setnchannels(1)
			wav.setframerate(self.sample_rate)
			wav.setsampwidth(2)
			decoded = SpuAdpcmDecoder().decode(self.body)
			wav.writeframes(struct.pack(f'<{len(decoded)}H', *decoded))

class SpuAdpcmDecoder:
	K0 = (0.0, 0.9375,  1.796875,  1.53125 ,  1.90625)
	K1 = (0.0, 0.0   , -0.8125  , -0.859375, -0.9375)

	def decode(self, buf):
		outbuf = []
		self.history1 = 0.0
		self.history2 = 0.0
		reader = io.BytesIO(buf)
		while True:
			block = reader.read(16)
			# Read block header
			shamt = block[0] & 0xf
			fltr_idx = block[0] >> 4
			is_last_block = block[1] & 1
			# Decode samples
			for i in range(2, 16):
				outbuf.append(self.dec_sample(block[i] & 0xf, fltr_idx, shamt))
				outbuf.append(self.dec_sample(block[i] >> 4 , fltr_idx, shamt))
			if is_last_block:
				break
		return outbuf

	def dec_sample(self, input, filter_idx, shamt):
		# Convert uint4 to int4
		input = input - 16 if input & 8 else input

		history = \
			self.history1 * self.K0[filter_idx] + \
			self.history2 * self.K1[filter_idx]
		self.history2 = self.history1
		self.history1 = history + (input << (12 - shamt))
		return int(self.history1 + 0.4999999999) & 0xffff

def copy_from_file(in_file, out_filename, num_copy, prepend_bytes):
	with open(out_filename, 'xb') as out_file:
		out_file.write(prepend_bytes)
		out_file.write(read_exactly(in_file, num_copy))

def read_exactly(strm, size):
	buf = strm.read(size)
	if len(buf) != size:
		raise RuntimeError('Unexpected end of file')
	return buf

def unpack_strm(fmt, strm):
	strct = struct.Struct(fmt)
	buf = strm.read(strct.size)
	if not buf:
		return None
	return struct.unpack(fmt, buf)

if __name__ == '__main__':
	main()
