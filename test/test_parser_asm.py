import pytest
from pathlib import Path

from src.commands.parser_asm import parse_instruction

ROOT_DIR_PATH = Path(__file__).parent

ASM_INSTR = [
    'add',
    'addi',
    'bne',
    'jal',
    'lui',
    'sw',
]


@pytest.mark.parametrize("name_instr", ASM_INSTR)
def test_parse_instruction(name_instr: str) -> None:
    asm_file = Path(ROOT_DIR_PATH / "data" / "instr_asm" / (name_instr + '.asm'))
    asm_src = asm_file.read_text().strip().split('\n')

    hex_file = Path(ROOT_DIR_PATH / "data" / "instr_hex" / (name_instr + '.hex'))
    hex_src = hex_file.read_text().strip().split('\n')

    assert len(asm_src) == len(hex_src)
    for asm_instr, hex_instr in zip(asm_src, hex_src):
        assert hex_instr == parse_instruction(asm_instr).hex_format()
