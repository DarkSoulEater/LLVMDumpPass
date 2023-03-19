//#include "cmdline_parser.hpp"

int F(int a) {
    return a * 2 + 3;
}

int main(int argc, char *argv[]) {
    //ParseArgs(argc, argv);
    //Agraph_t *g;
    //g = agopen("G", Agdirected, NULL);
    F(F(10));
    return 0;
}
