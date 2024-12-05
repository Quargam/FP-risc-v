import argparse
from pathlib import Path
import typing

from src.instruction_format import BaseType
from src.constants import RISC_V_INSTRUCTION_FORMATS


class CommandArgument(typing.Protocol):
    args: Path
    out: Path


def parse_arguments(arg_parser: argparse.ArgumentParser) -> None:
    arg_parser.add_argument(
        dest="args",
        metavar="SOURCE_FILE.asm",
        type=Path,
    )
    arg_parser.add_argument(
        "--out",
        dest="out",
        metavar="FILE.hex",
        default="out.hex",
        type=Path,
    )
    arg_parser.set_defaults(command=exec_command)


def exec_command(args: CommandArgument) -> None:
    with open(args.args, "r") as src, open(args.out, "w") as out:
        for line in src:
            if not line or line.startswith("#"):
                continue
            instr = parse_instruction(line)
            out.write(instr.hex_format() + "\n")


def parse_instruction(instr: str) -> BaseType:
    instr = instr.strip().split()
    name_instr = instr[0]
    if name_instr in RISC_V_INSTRUCTION_FORMATS:
        instr_formats = RISC_V_INSTRUCTION_FORMATS[name_instr]
        if instr_formats["fmt"] == "R" and len(instr) == 4:
            return instr_formats["class"](
                opcode=int(instr_formats["opcode"], base=2),
                funct7=int(instr_formats["funct7"], base=2),
                rs2=register_to_address(instr[3]),
                rs1=register_to_address(instr[2]),
                funct3=int(instr_formats["funct3"], base=2),
                rd=register_to_address(instr[1]),
            )
        elif instr_formats["fmt"] == "I" and len(instr) == 4:
            return instr_formats["class"](
                opcode=int(instr_formats["opcode"], base=2),
                imm=int(instr[3]),
                rs1=register_to_address(instr[2]),
                funct3=int(instr_formats["funct3"], base=2),
                rd=register_to_address(instr[1]),
            )
        elif instr_formats["fmt"] == "S" and len(instr) == 3:
            if "(" in instr[2]:
                imm, rs1 = parser_offser_and_rs1(instr[2])
            else:
                imm, rs1 = "0", instr[2]
            return instr_formats["class"](
                opcode=int(instr_formats["opcode"], base=2),
                imm=int(imm),
                rs2=register_to_address(instr[1]),
                rs1=register_to_address(rs1),
                funct3=int(instr_formats["funct3"], base=2),
            )
        elif instr_formats["fmt"] == "B" and len(instr) == 4:
            return instr_formats["class"](
                opcode=int(instr_formats["opcode"], base=2),
                imm=int(instr[3]),
                rs2=register_to_address(instr[2]),
                rs1=register_to_address(instr[1]),
                funct3=int(instr_formats["funct3"], base=2),
            )
        elif instr_formats["fmt"] == "U" and len(instr) == 3:
            return instr_formats["class"](
                opcode=int(instr_formats["opcode"], base=2),
                imm=int(instr[2]),
                rd=register_to_address(instr[1]),
            )
        elif instr_formats["fmt"] == "J" and len(instr) == 3:
            return instr_formats["class"](
                opcode=int(instr_formats["opcode"], base=2),
                imm=int(instr[2]),
                rd=register_to_address(instr[1]),
            )
    else:
        raise ValueError(f"Unsupported instruction: {instr}")


def parser_offser_and_rs1(arg: str) -> typing.Tuple[str, str]:
    offser, rs1 = arg.split("(")
    return offser, rs1.replace(")", "")


def register_to_address(reg_name: str) -> int:
    """
    Функция, которая переводит название регистра (например, x1) в его адрес (индекс).

    :param reg_name: Название регистра, например, 'x1', 'x2', ..., 'x31'.
    :return: Индекс регистра в виде целого числа (0-31).
    :raises ValueError: Если регистр имеет некорректное имя.
    """
    reg_name = reg_name.replace(",", "")
    if reg_name.startswith("x") and reg_name[1:].isdigit():
        reg_index = int(reg_name[1:])
        if 0 <= reg_index <= 31:
            return reg_index
        else:
            raise ValueError("Номер регистра должен быть в диапазоне от 0 до 31.")
    else:
        raise ValueError(
            f"Неверное имя регистра: {reg_name}. Ожидается формат 'xN', где N — целое число от 0 до 31."
        )
