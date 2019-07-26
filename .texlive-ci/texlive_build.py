from argparse import ArgumentParser
import os
import re
import subprocess


def main():
    parser = ArgumentParser()
    parser.add_argument('files')
    parser.add_argument('--deploy')

    args = parser.parse_args()
    walk(args.files, args.deploy)


def build(root_dir, file_name, prog, deploy_dir):
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

    if deploy_dir is not None:
        if not os.path.isdir(deploy_dir):
            os.makedirs(deploy_dir)
        pdf_path = os.path.splitext(file_path)[0] + '.pdf'
        deploy_path = os.path.join(deploy_dir, pdf_path)
        subprocess.call(["mv", pdf_path, deploy_path])


def walk(pattern, deploy_dir):
    prog = re.compile(pattern)
    for root, dirs, files in os.walk("."):
        for file_name in files:
            build(root, file_name, prog, deploy_dir)


if __name__ == '__main__':
    main()
