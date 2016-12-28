//
//  CRCTests.m
//  Clock Signal
//
//  Created by Thomas Harte on 27/12/2016.
//  Copyright © 2016 Thomas Harte. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "CRC.hpp"

@interface CRCTests : XCTestCase
@end

@implementation CRCTests

- (NumberTheory::CRC16)mfmCRCGenerator
{
	return NumberTheory::CRC16(0x1021, 0xffff);
}

- (uint16_t)crcOfData:(uint8_t *)data length:(size_t)length generator:(NumberTheory::CRC16 &)generator
{
	generator.reset();
	for(size_t c = 0; c < length; c++) generator.add(data[c]);
	return generator.get_value();
}

- (void)testIDMark
{
	uint8_t IDMark[] =
	{
		0xa1, 0xa1, 0xa1, 0xfe, 0x00, 0x00, 0x01, 0x01
	};
	uint16_t crc = 0xfa0c;
	NumberTheory::CRC16 crcGenerator = self.mfmCRCGenerator;

	uint16_t computedCRC = [self crcOfData:IDMark length:sizeof(IDMark) generator:crcGenerator];
	XCTAssert(computedCRC == crc, @"Calculated CRC should have been %04x, was %04x", crc, computedCRC);
}

- (void)testData
{
	uint8_t sectorData[] =
	{
		0xa1, 0xa1, 0xa1, 0xfb, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x01, 0x00, 0x53, 0x45, 0x44, 0x4f,
		0x52, 0x49, 0x43, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x53, 0x45, 0x44, 0x4f, 0x52, 0x49, 0x43, 0x20, 0x56, 0x31, 0x2e, 0x30,
		0x30, 0x36, 0x20, 0x30, 0x31, 0x2f, 0x30, 0x31, 0x2f, 0x38, 0x36, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
		0x20, 0x20, 0x20, 0x20
	};
	uint16_t crc = 0x4de7;
	NumberTheory::CRC16 crcGenerator = self.mfmCRCGenerator;

	uint16_t computedCRC = [self crcOfData:sectorData length:sizeof(sectorData) generator:crcGenerator];
	XCTAssert(computedCRC == crc, @"Calculated CRC should have been %04x, was %04x", crc, computedCRC);
}

@end
