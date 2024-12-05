import subprocess
import typing


def run_shell(args: typing.List[str]) -> None:
    proc = subprocess.Popen(
        args,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    stdout, stderr = proc.communicate()
    if proc.returncode != 0:
        print("Error running iverilog:")
        print(stderr)
    print(stdout)
