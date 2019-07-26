from argparse import ArgumentParser
import os
import re
import subprocess


def main():
    parser = ArgumentParser()
    parser.add_argument('files')

    args = parser.parse_args()
    walk(args.files)


def build(root_dir, file_name, prog):
    file_path = os.path.join(root_dir, file_name)
    if not prog.match(file_path):
        return
    try:
        print(subprocess.check_output(
            ["texliveonfly", file_name], cwd=root_dir))
        print(subprocess.check_output(
            ["pdflatex", file_name], cwd=root_dir))
        print(subprocess.check_output(
            ["pdflatex", file_name], cwd=root_dir))
    except subprocess.CalledProcessError:
        print("Failed to build %s." % (file_path,))


def walk(pattern):
    prog = re.compile(pattern)
    for root, dirs, files in os.walk("."):
        for file_name in files:
            build(root, file_name, prog)


if __name__ == '__main__':
    main()
