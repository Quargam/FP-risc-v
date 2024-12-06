import argparse
import pytest
from pathlib import Path
import typing


from src.commands import riscv_processor
from src.commands.parser_asm import parse_instruction


ROOT_DIR_PATH = Path(__file__).parent


def parse_reg_mem(file_reg_mem: Path) -> typing.List[typing.Optional[int]]:
    register_x: typing.List[typing.Optional[int]] = []
    reg_mem_src = file_reg_mem.read_text()
    for reg_mem_line in reg_mem_src.strip().split("\n"):
        if "//" in reg_mem_line:
            continue
        if "x" in reg_mem_line:
            register_x.append(None)
        else:
            register_x.append(int(reg_mem_line, base=16))
    return register_x


RISC_V_PROG_HEX = [
    (
        "addi_add.asm",
        [
            (1, 6),
            (2, 4),
            (3, 10),
        ],
    ),
    (
        "bne_not_equal.asm",
        [
            (1, 1),
            (2, 2),
            (3, 3),
        ],
    ),
    (
        "bne_equal.asm",
        [
            (1, 1),
            (2, 1),
            (3, 2),
        ],
    ),
    (
        "ori.asm",
        [
            (1, 0),
            (2, 7),
            (3, 63),
        ],
    ),
]


def run_risc_v_single(prog_path: str, register_x_path: str) -> None:
    cmd_args: typing.List[str] = [
        prog_path,
        "--dump-register-x",
        register_x_path,
        "--run-vvp",
    ]
    arg_parser = argparse.ArgumentParser()
    riscv_processor.parse_arguments(arg_parser)
    args = arg_parser.parse_args(cmd_args)
    riscv_processor.exec_command(args)


@pytest.mark.parametrize("name_prog, vals_reg_x", RISC_V_PROG_HEX)
def test_risc_v_single(
    name_prog: str,
    vals_reg_x: typing.List[typing.Tuple[int, int]],
    tmp_path: Path,
) -> None:
    prog_asm_path: Path = ROOT_DIR_PATH / "data" / "risc_v_prog_asm" / name_prog
    prog_hex_path: Path = tmp_path / (name_prog.replace(".asm", ".hex"))
    register_x_path: Path = tmp_path / "register_x"
    _convert_asm_hex_instr(prog_asm_path, prog_hex_path)
    run_risc_v_single(prog_hex_path.as_posix(), register_x_path.as_posix())

    assert register_x_path.exists()
    register_x = parse_reg_mem(register_x_path)
    for ind_reg_x, val_reg_x in vals_reg_x:
        assert register_x[ind_reg_x] == val_reg_x


def _convert_asm_hex_instr(prog_asm_path: Path, prog_hex_path: Path) -> None:
    asm_src = prog_asm_path.read_text().strip().split("\n")

    with open(prog_hex_path, "w") as hex_file:
        for asm_instr in asm_src:
            hex_file.write(parse_instruction(asm_instr).hex_format() + "\n")
