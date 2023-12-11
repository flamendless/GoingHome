import argparse
from enum import Enum
import os
import platform
from shutil import copy2
from typing import Dict, Callable, List
from zipfile import ZipFile

GAME_NAME: str = "GoingHomeRevisited"
IDENTITY: str = "GoingHomeRevisited"
WSL_DRIVE: str = "Z:"
GAME_DIR: str = "game/"
RELEASE_DIR: str = "release/"
ROOT_DIR: str = os.path.join(os.getcwd())

EXCLUDE: List[str] = [
    "*.ase",
    ".git",
    ".test",
    ".gitignore",
    ".gitattributes",
    ".travis.yml",
    "test",
    "docs",
    "spec",
    "cases",
    "bench",
    ".github",
    "README.md",
    "CHANGELOG.md",
    "changelog.txt",
    "Makefile",
    "assets_old",
    "new_assets",
]


class Mode(Enum):
    NONE = -1
    LINUX = 0,
    WSL = 1,
    WINDOWS = 2,


def get_mode() -> Mode:
    if "wsl" in platform.platform().lower():
        return Mode.WSL
    else:
        return Mode[platform.system().upper()]


def zip_files(out: str) -> bool:
    os.chdir(GAME_DIR)
    with ZipFile(out, "w") as zip:
        for path, subdirs, files in os.walk("."):
            for ex in EXCLUDE:
                if ex in subdirs:
                    subdirs.remove(ex)
                if ex in files:
                    files.remove(ex)

                if ex.startswith("*."):
                    for file in list(files):
                        if file.endswith(ex[1:]):
                            files.remove(file)

            for file in files:
                f: str = os.path.join(path, file)
                print(f"Adding {f} to {out}")
                zip.write(f)
    os.chdir(ROOT_DIR)
    return True


def build(args: argparse.Namespace) -> None:
    filename: str = f"{GAME_NAME}.love"
    out: str = f"{ROOT_DIR}/{RELEASE_DIR}{filename}"
    print(f"building '{out}'...")
    res: bool = zip_files(out)
    if not res:
        raise Exception(f"Zipping '{out}' failed")

    if args.outpath:
        copy2(out, args.outpath)


def run(args: argparse.Namespace) -> None:
    print("running...")

    if not os.path.exists(f"{RELEASE_DIR}{GAME_NAME}.love"):
        raise Exception(f"no love file found in {RELEASE_DIR}")

    dev_mode: str = "dev" if args.dev else None
    profile_mode: str = "profile" if args.profile else None

    love_file_path: str = f"{ROOT_DIR}/{RELEASE_DIR}/{GAME_NAME}.love"
    cmd: str = None
    mode: Mode = get_mode()
    if mode == Mode.WSL:
        love_win_dir = "C:\\Program Files\\LOVE"
        cmd_path = "/mnt/c/Windows/System32/cmd.exe"
        game_path: str = f"{WSL_DRIVE}/{love_file_path}"
        cmd = f"{cmd_path} /c start cmd.exe /c 'cd {love_win_dir} && lovec.exe {game_path} {dev_mode} {profile_mode} & pause'"
    elif mode == Mode.LINUX:
        cmd = f"love {love_file_path} {dev_mode}"

    if cmd:
        print(f"Running {cmd}")
        os.system(cmd)


def clean(*args):
    appdata_dir: str = None
    mode: Mode = get_mode()
    if mode == Mode.WSL:
        appdata_dir = f"/mnt/c/Users/user/AppData/Roaming/LOVE/{IDENTITY}"
    elif mode == Mode.LINUX:
        home_dir: str = os.path.expanduser("~")
        appdata_dir = f"{home_dir}/share/love/{IDENTITY}"

    if appdata_dir:
        print(f"Deleting {appdata_dir}")
        os.rmdir(appdata_dir)


def build_run(*args):
    build(args)
    run(args)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-d",
        "--dev",
        action="store_true",
        dest="dev",
        help="Enable DEV mode"
    )
    parser.add_argument(
        "-p",
        "--profile",
        action="store_true",
        dest="profile",
        help="Enable PROFILE mode"
    )
    parser.add_argument(
        "-b",
        "--build",
        action="store_true",
        dest="build",
        help="Build game"
    )
    parser.add_argument(
        "-r",
        "--run",
        action="store_true",
        dest="run",
        help="Run game"
    )

    # For Android
    parser.add_argument(
        "-o",
        "--outpath",
        action="store",
        dest="outpath",
        help="Output to path"
    )

    args: argparse.Namespace = parser.parse_args()

    if (not args.build) and (not args.run):
        raise Exception("Must pass argument(s)")

    cmds: Dict[str, Callable] = {
        "build": build,
        "run": run,
        "clean": clean,
    }

    if args.build:
        build(args)

    if args.run:
        run(args)
