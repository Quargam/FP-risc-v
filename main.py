#!/usr/bin/env python

import argparse
import typing
import sys


from src.commands import parser_asm, riscv_processor


def parse_arguments(cmd_args: typing.Optional[typing.List[str]]) -> argparse.Namespace:
    arg_parser = argparse.ArgumentParser()
    subparsers = arg_parser.add_subparsers()
    parser_asm.parse_arguments(subparsers.add_parser(
        'parser_asm',
    ))
    riscv_processor.parse_arguments(subparsers.add_parser(
        'riscv_processor',
    ))
    return arg_parser.parse_args(cmd_args)


def main(cmd_args: typing.Optional[typing.List[str]]) -> None:
    if len(cmd_args) == 0:
        cmd_args = ['-h',]
    args = parse_arguments(cmd_args)
    args.command(args)  # Запуск команды с аргументом.


if __name__ == '__main__':
    main(sys.argv[1:])
