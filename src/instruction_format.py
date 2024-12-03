from dataclasses import dataclass


@dataclass
class BaseType:
    opcode: int

    def hex_format(self) -> str:
        raise NotImplementedError

# Формат для R-type инструкции
@dataclass
class RType(BaseType):
    funct7: int
    rs2: int
    rs1: int
    funct3: int
    rd: int

    def hex_format(self) -> str:
        # Формируем 32-битную инструкцию для R-type
        instr = (
            (self.funct7 << 25)
            | (self.rs2 << 20)
            | (self.rs1 << 15)
            | (self.funct3 << 12)
            | (self.rd << 7)
            | self.opcode
        )
        return f"{instr:08x}"


# Формат для I-type инструкции
@dataclass
class IType(BaseType):
    imm: int
    rs1: int
    funct3: int
    rd: int

    def hex_format(self) -> str:
        # Формируем 32-битную инструкцию для I-type
        instr = (
            (self.imm << 20)
            | (self.rs1 << 15)
            | (self.funct3 << 12)
            | (self.rd << 7)
            | self.opcode
        )
        return f"{instr:08x}"


# Формат для S-type инструкции
@dataclass
class SType(BaseType):
    imm: int  # Для S-type imm состоит из двух частей (11:5 и 4:0)
    rs2: int
    rs1: int
    funct3: int

    def hex_format(self) -> str:
        # Разделяем imm на две части
        imm_upper = (self.imm >> 5) & 0b111111  # imm[11:5]
        imm_lower = self.imm & 0b11111  # imm[4:0]
        instr = (
            (imm_upper << 25)  # imm[11:5] в биты 25-31
            | (self.rs2 << 20)  # rs2 в биты 20-24
            | (self.rs1 << 15)  # rs1 в биты 15-19
            | (self.funct3 << 12)  # funct3 в биты 12-14
            | (imm_lower << 7)  # imm[4:0] в биты 7-11
            | self.opcode  # opcode в биты 0-6
        )
        # Форматируем результат в шестнадцатеричный формат
        return f"0x{instr:08x}"

# Формат для B-type инструкции
@dataclass
class BType(BaseType):
    imm: int  # Для B-type imm состоит из нескольких частей
    rs2: int
    rs1: int
    funct3: int

    def hex_format(self) -> str:
        # Для B-type imm состоит из частей: imm[12], imm[10:5], imm[4:1], imm[11]
        imm_upper = (self.imm >> 11) & 0x1
        imm_middle = (self.imm >> 5) & 0x3F
        imm_lower = self.imm & 0x1E
        instr = (
            (imm_upper << 31)
            | (imm_middle << 25)
            | (self.rs2 << 20)
            | (self.rs1 << 15)
            | (self.funct3 << 12)
            | (imm_lower << 7)
            | self.opcode
        )
        return f"{instr:08x}"


# Формат для U-type инструкции
@dataclass
class UType(BaseType):
    imm: int
    rd: int

    def hex_format(self) -> str:
        # Для U-type инструкция состоит из imm[31:12] и rd
        instr = (self.imm << 12) | (self.rd << 7) | self.opcode
        return f"{instr:08x}"


# Формат для J-type инструкции
@dataclass
class JType(BaseType):
    imm: int
    rd: int

    def hex_format(self) -> str:
        # Для J-type imm состоит из нескольких частей: imm[19:12], imm[11], imm[10:1], imm[20]
        imm_upper = (self.imm >> 12) & 0xFF    # imm[19:12]
        imm_middle = (self.imm >> 1) & 0x3FF    # imm[10:1]
        imm_lower = (self.imm >> 11) & 0x1      # imm[11]
        imm_sign = (self.imm >> 20) & 0x1       # imm[20]

        # Собираем инструкцию
        instr = (imm_sign << 31) | (imm_upper << 12) | (imm_middle << 1) | (imm_lower << 11) | (self.rd << 7) | self.opcode
        return f"0x{instr:08x}"
