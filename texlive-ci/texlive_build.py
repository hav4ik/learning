from argparse import ArgumentParser
import os
import re
import subprocess


def main():
    parser = ArgumentParser()
    parser.add_argument('files')

    args = parser.parse_args()
    walk(args.files)


def build(file_path):
    try:
        print(subprocess.check_output(["texliveonfly", file_path]))
        print(subprocess.check_output(["pdflatex", file_path]))
        print(subprocess.check_output(["pdflatex", file_path]))
    except subprocess.CalledProcessError:
        print("Failed to build %s." % (file_path,))


def walk(pattern):
    prog = re.compile(pattern)
    for root, dirs, files in os.walk("."):
        for file_name in files:
            file_path = os.path.join(root, file_name)
            if not prog.match(file_path):
                continue
            build(file_path)


if __name__ == '__main__':
    main()
