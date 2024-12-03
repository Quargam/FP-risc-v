import argparse
from pathlib import Path
import typing


class CommandArgument(typing.Protocol):
    args: Path


def parse_arguments(arg_parser: argparse.ArgumentParser) -> None:
    arg_parser.add_argument(
        dest='args',
        metavar='SOURCE_FILE.asm',
        type=Path,
    )
    arg_parser.add_argument(
        '--out',
        dest='out',
        metavar='FILE.hex',
        default='out.hex',
        type=Path,
    )
    arg_parser.set_defaults(command=exec_command)


def exec_command(args: CommandArgument) -> None:
    pass
