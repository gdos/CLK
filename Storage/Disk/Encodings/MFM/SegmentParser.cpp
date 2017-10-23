//
//  SegmentParser.cpp
//  Clock Signal
//
//  Created by Thomas Harte on 24/09/2017.
//  Copyright © 2017 Thomas Harte. All rights reserved.
//

#include "SegmentParser.hpp"
#include "Shifter.hpp"

using namespace Storage::Encodings::MFM;

std::map<size_t, Storage::Encodings::MFM::Sector> Storage::Encodings::MFM::sectors_from_segment(const Storage::Disk::PCMSegment &&segment, bool is_double_density) {
	std::map<size_t, Sector> result;
	Shifter shifter;
	shifter.set_is_double_density(is_double_density);
	shifter.set_should_obey_syncs(true);

	std::unique_ptr<Storage::Encodings::MFM::Sector> new_sector;
	bool is_reading = false;
	size_t position = 0;
	size_t size = 0;
	size_t start_location = 0;

	for(unsigned int bit = 0; bit < segment.number_of_bits; ++bit) {
		shifter.add_input_bit(segment.bit(bit));
		switch(shifter.get_token()) {
			case Shifter::Token::None:
			case Shifter::Token::Sync:
			case Shifter::Token::Index:
			break;

			case Shifter::Token::ID:
				new_sector.reset(new Storage::Encodings::MFM::Sector);
				is_reading = true;
				start_location = bit;
				position = 0;
				shifter.set_should_obey_syncs(false);
			break;

			case Shifter::Token::Data:
			case Shifter::Token::DeletedData:
				if(new_sector) {
					is_reading = true;
					shifter.set_should_obey_syncs(false);
					new_sector->is_deleted = (shifter.get_token() == Shifter::Token::DeletedData);
				}
			break;

			case Shifter::Token::Byte:
				if(is_reading) {
					switch(position) {
						case 0:	new_sector->address.track = shifter.get_byte(); ++position; break;
						case 1:	new_sector->address.side = shifter.get_byte(); ++position; break;
						case 2:	new_sector->address.sector = shifter.get_byte(); ++position; break;
						case 3:
							new_sector->size = shifter.get_byte();
							size = static_cast<size_t>(128 << new_sector->size);
							++position;
							is_reading = false;
							shifter.set_should_obey_syncs(true);
						break;
						default:
							new_sector->data.push_back(shifter.get_byte());
							++position;
							if(position == size + 4) {
								result.insert(std::make_pair(start_location, std::move(*new_sector)));
								is_reading = false;
								shifter.set_should_obey_syncs(true);
								new_sector.reset();
							}
						break;
					}
				}
			break;
		}
	}

	return result;
}