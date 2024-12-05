# задание: 
 
Необходимо на синтезируемом подмножестве языка SystemVerilog создать синхронную схему реализующую небольшую часть функционала процессора с архитектурой RISC-V и тестовое окружение для него. 

## Условия: 
 
* Логика должна поддерживать по меньшей мере исполнение 5 инструкций: ADD, SUB, OR, ADDI, BEQ (см. The RISC-V Instruction Set Manual); 
 
* Необходимо поддерживать только базовый 32-битный режим работы (RV32I) и не менее 5 32-разрядных регистров общего назначения (x0-x4 в соответствии со спецификацией); 
 
* Необходимо использовать структуры для кодирования полей инструкции процессора, описанные в отдельном SystemVerilog pkg;
 
* Тестовое окружение процессорного ядра должно проверять все инструкции которые поддерживаются вашей реализацией ядра.  
 
## В качестве дополнительного задания предлагается реализовать: 
 
* Поддержка более сложных инструкций и их проверку в тестовом окружении: SRL, LUI, ORI, BNE, J, (LW, SW – память данных); 

* Реализация парсера RISC-V .asm в .hex. 

# Описание

В рамках задания был создан однотактный процессор `riscvsingle` с архитектурой RISC-V, окружение на Python для тестирования его функциональности, а также парсер для преобразования инструкций `asm` в `hex`.

На выполнение работы потребовалось 1 день и 2 вечера.

---

## Требования

Для запуска проекта необходимо:
* Python версии **3.8** или выше;
* **Icarus Verilog**;
* Утилиты **vvp** и **gtkwave** (входят в состав Icarus Verilog).

---

## Как запустить

### Установка
1. Установите Python версии 3.8 или выше.
2. Установите Icarus Verilog и добавьте исполняемые файлы в `PATH`. В состав Icarus Verilog входят утилиты **vvp** и **gtkwave**.

---

### Запуск без Python

Для выполнения симуляции без использования Python выполните следующие команды:

```bash
mkdir build
iverilog -g2012 -I ./riscvsingle/test -I ./riscvsingle/src -o ./build/testbench.vvp ./riscvsingle/test/testbench_common.sv
vvp ./build/testbench.vvp
gtkwave build/testbench.vcd
```

---

### Запуск с Python

Python-окружение состоит из двух частей:
1. Компиляция и симуляция кода на Verilog.
2. Парсер, преобразующий инструкции `ASM RV32I` в `HEX`.

Чтобы узнать больше, выполните:

```bash
./main.py -h
```

#### Парсер ASM

Парсер принимает два аргумента. Для просмотра поддерживаемых инструкций откройте файл `src/constants.py`.

```bash
usage: main.py parser_asm [-h] [--out FILE.hex] SOURCE_FILE.asm

positional arguments:
  SOURCE_FILE.asm    Входной файл с инструкциями в формате ASM.

options:
  -h, --help         Показать справку и выйти.
  --out FILE.hex     Указать путь для сохранения выходного HEX-файла.
```

---

### Тесты

Основной тест симуляции находится в файле `./riscvsingle/test/testbench_common.sv` и проверяет корректность работы процессора.

Для запуска тестов на основе `pytest` выполните следующие команды:

```bash
python -m venv venv
source venv/bin/activate  # Для Windows: venv\Scripts\activate
pip install pytest
pytest
```

Эти тесты проверяют корректность работы парсера и процессора.

---

### Запуск процессора (`riscvsingle`)

```bash
usage: main.py risc_v_single [-h] [--out-vvp FILE.vvp] [--out-vcd FILE.vcd] [--dump-data-mem [DUMP_DATA_MEM]] [--dump-register-x [DUMP_REGISTER_X]] [--run-vvp] [--run-gtkwave] SOURCE_FILE.hex

positional arguments:
  SOURCE_FILE.hex          Входной файл в формате HEX.

options:
  -h, --help            show this help message and exit
  --out-vvp FILE.vvp
  --out-vcd FILE.vcd
  --dump-data-mem [DUMP_DATA_MEM]
  --dump-register-x [DUMP_REGISTER_X]
  --run-vvp
  --run-gtkwave
```

Описание аргументов:
* `--out-vvp`: Путь для сохранения файла `.vvp`.
* `--out-vcd`: Путь для сохранения файла `.vcd`.
* `--dump-data-mem`: Путь для сохранения содержимого ОЗУ.
* `--dump-register-x`: Путь для сохранения значений регистров.
* `--run-vvp`: Запускает симуляцию через `vvp`.
* `--run-gtkwave`: Открывает файл `.vcd` в `gtkwave`.

---

## Источники

* **Рэндал Э. Брайант, Дэвид Р. О'Халларон. Компьютерные системы: архитектура и программирование** (3-е издание).
* **Сара Л. Харрис, Дэвид Харрис. Цифровая схемотехника и архитектура компьютера: RISC-V**.
* *The RISC-V Instruction Set Manual. Volume I: User-Level ISA Document Version 2.2*.