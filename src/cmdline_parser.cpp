#include <iostream>
#include <boost/program_options.hpp>
#include "cmdline_parser.hpp"

namespace po = boost::program_options;

void ParseArgs(int argc, char *argv[]) {
    po::options_description desc("General option");
    desc.add_options()
        ("help,h", "produce help message")
    ;

    po::variables_map vm;
    po::store(po::parse_command_line(argc, argv, desc), vm);

    if (vm.count("help")) {
        std::cout << desc;
    }
    return;
}