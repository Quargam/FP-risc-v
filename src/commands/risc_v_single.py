import argparse
from pathlib import Path
import subprocess
import typing


class CommandArgument(typing.Protocol):
    args: str
    out_vvp: str
    out_vcd: str


def parse_arguments(arg_parser: argparse.ArgumentParser) -> None:
    arg_parser.add_argument(
        dest='args',
        metavar='SOURCE_FILE.hex',
        type=str,
    )
    arg_parser.add_argument(
        "--out-vvp",
        dest="out_vvp",
        metavar="FILE.vvp",
        default="./build/testbench.vvp",
        type=str,
    )
    arg_parser.add_argument(
        "--out-vcd",
        dest="out_vcd",
        metavar="FILE.vcd",
        default="./build/testbench.vcd",
        type=str,
    )
    arg_parser.set_defaults(command=exec_command)


def exec_command(args: CommandArgument) -> None:
    # Формируем строку с экранированными кавычками
    source_file_hex = 'SOURCE_FILE_HEX=' + "\"" + str(args.args) + "\""
    save_file_hex = 'SAVE_FILE_VCD=' + "\"" + str(args.out_vcd) + "\""
    proc = subprocess.Popen(
        [
            "iverilog",
            "-g2012",
            "-D",
            source_file_hex,
            "-D",
            save_file_hex,
            "-I",
            "./riscvsingle/test",
            "-I",
            "./riscvsingle//src",
            "-o",
            str(args.out_vvp),
            "./riscvsingle/test/testbench_common.sv",
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
