import argparse
import typing

from src.utils.shell import run_shell


class CommandArgument(typing.Protocol):
    args: str
    out_vvp: str
    out_vcd: str
    dump_data_mem: typing.Optional[str]
    dump_register_x: typing.Optional[str]
    run_vvp: bool
    run_gtkwave: bool
    processor_type: str


def parse_arguments(arg_parser: argparse.ArgumentParser) -> None:
    arg_parser.add_argument(
        dest="args",
        metavar="SOURCE_FILE.hex",
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
    arg_parser.add_argument(
        "--dump-data-mem",
        dest="dump_data_mem",
        nargs="?",
        const="./build/data_memory_dump.hex",
        default=None,
        type=str,
    )
    arg_parser.add_argument(
        "--dump-register-x",
        dest="dump_register_x",
        nargs="?",
        const="./build/register_memory_dump.hex",
        default=None,
        type=str,
    )
    arg_parser.add_argument(
        "--run-vvp",
        dest="run_vvp",
        action="store_true",
    )
    arg_parser.add_argument(
        "--run-gtkwave",
        dest="run_gtkwave",
        action="store_true",
    )
    arg_parser.add_argument(
        "--processor-type",
        dest="processor_type",
        choices=["riscv_single", "riscv_pipeline"],
        default="riscv_single",
    )
    arg_parser.set_defaults(command=exec_command)


def exec_command(args: CommandArgument) -> None:
    defines = [
        *form_arg_directive_cli("-D", "SOURCE_FILE_HEX", args.args),
        *form_arg_directive_cli("-D", "SAVE_FILE_VCD", args.out_vcd),
    ]
    if args.dump_data_mem:
        defines.extend(
            form_arg_directive_cli("-D", "DATA_MEM_FILE_HEX", args.dump_data_mem)
        )
    if args.dump_register_x:
        defines.extend(
            form_arg_directive_cli("-D", "REGISTER_MEM_FILE_HEX", args.dump_register_x)
        )
    includes = [
        *["-I", f"./{args.processor_type}"],
    ]
    run_iverilog(
        f"./{args.processor_type}/testbench.sv",
        args.out_vvp,
        defines,
        includes,
    )
    if args.run_vvp:
        run_shell(["vvp", args.out_vvp])
    if args.run_gtkwave:
        run_shell(["gtkwave", args.out_vcd])


def form_arg_directive_cli(
    directive: str, name_define: str, value_define: str
) -> typing.Tuple[str, str]:
    return (directive, f"{name_define}=" + '"' + value_define + '"')


def run_iverilog(
    testbench_file: str,
    out_file: str,
    defines: typing.List[typing.Tuple[str, str]],
    includes: typing.List[typing.Tuple[str, str]],
) -> None:
    args: typing.List[str] = [
        "iverilog",
        "-g2012",
        *defines,
        *includes,
        "-o",
        out_file,
        testbench_file,
    ]
    run_shell(args)
