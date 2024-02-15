from sys import version_info

if (version_info.major < 3) and (version_info.minor < 11):
    raise Exception("At least Python 3.11 is required")

import argparse
import os
import platform

from enum import Enum
from shutil import copy2
from typing import Callable
from zipfile import ZipFile

GAME_NAME: str = "GoingHomeRevisited"
IDENTITY: str = "GoingHomeRevisited"
WSL_DRIVE: str = "Z:"
CMD_PATH: str = "/mnt/c/Windows/System32/cmd.exe"
GAME_DIR: str = "game/"
RELEASE_DIR: str = "release/"
ROOT_DIR: str = os.path.join(os.getcwd())

EXCLUDE: list[str] = [
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


def copy_files(out: str) -> bool:
    os.chdir(GAME_DIR)
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
            base: str = os.path.dirname(f).removeprefix("./")
            basedir: str = f"{out}{base}"
            if not os.path.exists(basedir):
                os.mkdir(basedir)
            temp_out: str = f"{basedir}/{file}"
            print(f"Copying {f} to {temp_out}")
            copy2(f, temp_out)
    os.chdir(ROOT_DIR)
    return True


def build(args: argparse.Namespace) -> None:
    filename: str = f"{GAME_NAME}.love"
    out: str = f"{ROOT_DIR}/{RELEASE_DIR}{filename}"
    print(f"building '{out}'...")

    res: bool = None
    if args.nozip:
        if not args.outpath:
            raise Exception("'outpath' is required when using this")
        res = copy_files(args.outpath)
    else:
        res = zip_files(out)

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
        game_path: str = f"{WSL_DRIVE}/{love_file_path}"
        cmd = f"{CMD_PATH} /c start cmd.exe /c 'cd {love_win_dir} && lovec.exe {game_path} {dev_mode} {profile_mode} & pause'"
    elif mode == Mode.LINUX:
        cmd = f"love {love_file_path} {dev_mode}"

    if cmd:
        print(f"Running {cmd}")
        os.system(cmd)


def clean(*args):
    appdata_dir: str = None
    mode: Mode = get_mode()
    match mode:
        case Mode.WSL:
            appdata_dir = f"/mnt/c/Users/user/AppData/Roaming/LOVE/{IDENTITY}"
        case Mode.LINUX:
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
        help="Enable DEV mode",
    )
    parser.add_argument(
        "-p",
        "--profile",
        action="store_true",
        dest="profile",
        help="Enable PROFILE mode",
    )
    parser.add_argument(
        "-b",
        "--build",
        action="store_true",
        dest="build",
        help="Build game",
    )
    parser.add_argument(
        "-r",
        "--run",
        action="store_true",
        dest="run",
        help="Run game",
    )

    # For Android
    parser.add_argument(
        "-o",
        "--outpath",
        action="store",
        dest="outpath",
        help="Output to path",
    )
    parser.add_argument(
        "--nozip",
        action="store_true",
        dest="nozip",
        help="Instead of zipping, just copy files",
    )

    args: argparse.Namespace = parser.parse_args()

    if (not args.build) and (not args.run):
        raise Exception("Must pass argument(s)")

    cmds: dict[str, Callable] = {
        "build": build,
        "run": run,
        "clean": clean,
    }

    if not os.path.exists(RELEASE_DIR):
        os.makedirs(f"./{RELEASE_DIR}")

    if args.build:
        build(args)

    if args.run:
        run(args)
