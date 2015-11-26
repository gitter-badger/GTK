
#include "monitor_dbs.h"

namespace p2psp {

MonitorDBS::MonitorDBS() { LOG("Initialized"); };

MonitorDBS::~MonitorDBS(){};

// def print_the_module_name(self):
// {{{

// sys.stdout.write(Color.red)
//_print_("Monitor DBS")
// sys.stdout.write(Color.none)

// }}}

void MonitorDBS::Complain(uint16_t chunk_number) {
  std::vector<char> message(2);
  std::memcpy(message.data(), &chunk_number, sizeof(uint16_t));

  team_socket_.send_to(buffer(message), splitter_);

  LOG("lost chunk:" << std::to_string(chunk_number));
};

uint16_t MonitorDBS::FindNextChunk() {
  uint16_t chunk_number = (played_chunk_ + 1) % Common::kMaxChunkNumber;

  while (!chunks_[chunk_number % buffer_size_].received) {
    Complain(chunk_number);
    chunk_number = (chunk_number + 1) % Common::kMaxChunkNumber;
  }
  return chunk_number;
}
}