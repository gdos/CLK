//
//  AppleGCR.hpp
//  Clock Signal
//
//  Created by Thomas Harte on 21/04/2018.
//  Copyright © 2018 Thomas Harte. All rights reserved.
//

#ifndef AppleGCR_hpp
#define AppleGCR_hpp

#include <cstdint>
#include "../../../Disk/Track/PCMSegment.hpp"

namespace Storage {
namespace Encodings {
namespace AppleGCR {

/// Describes the standard three-byte prologue that begins a header.
const uint8_t header_prologue[3] = {0xd5, 0xaa, 0x96};
/// Describes the standard three-byte prologue that begins a data section.
const uint8_t data_prologue[3] = {0xd5, 0xaa, 0xad};
/// Describes the epilogue that ends both data sections and headers.
const uint8_t epilogue[3] = {0xde, 0xaa, 0xeb};

/*!
	Produces the Apple-standard four-and-four per-sector header. This is the same
	for both the 13- and 16-sector formats, and is 112 bits long.
*/
Storage::Disk::PCMSegment header(uint8_t volume, uint8_t track, uint8_t sector);

/*!
	Produces the data section of a six-and-two format sector; the segment returned
	will be 2,792 bits long, encoding the first 256 bytes from @c source.
*/
Storage::Disk::PCMSegment six_and_two_data(const uint8_t *source);

/*!
	Produces @c length sync six-and-two format sync bytes. The segment returned
	is @c 10*length bits long.
*/
Storage::Disk::PCMSegment six_and_two_sync(int length);

/*!
	Produces the data section of a five-and-three format sector; the segment returned
	will be 3,336 bits long, encoding the first 256 bytes from @c source.
*/
Storage::Disk::PCMSegment five_and_three_data(const uint8_t *source);

/*!
	Produces @c length sync five-and-three format sync bytes. The segment returned
	is @c 9*length bits long.
*/
Storage::Disk::PCMSegment five_and_three_sync(int length);

}
}
}

#endif /* AppleGCR_hpp */
