import argparse
import gzip
import ntpath
import re
import subprocess
import os

import sys


def main():
    parser = argparse.ArgumentParser(description='Process arguments')
    parser.add_argument('--fastq_file', type=str, help='Fastq file')
    parser.add_argument('--sample_id', help='Sample Id', type=str)
    parser.add_argument('--file_size_name', help='Output file size name', type=str)
    parser.add_argument('--r_index', help='R index', type=str)

    args = parser.parse_args()

    fastqFile = args.fastq_file
    if os.path.exists(fastqFile):
        fcid = getFcid(fastqFile)
        if fcid == None:
            sys.stderr.write("Sequence id (instrument) not found in fastq file: " + fastqFile)
        else:
            inputSize = getFastqFileSize(fastqFile)
            fileId = getFileId(fastqFile, fcid)

            writeSizeFile(args, fileId, inputSize)
            r_index = args.r_index
            saveSplitLanesFiles(fastqFile, fileId, r_index)
    else:
        sys.stderr.write("Fastq file doesn't exist: " + fastqFile)


def saveSplitLanesFiles(fastqFile, fileId, index):
    fastqSequenceLines = 4
    command = 'zcat < %s | awk \'BEGIN {FS = ":"} {lane=$4 ; print | "gzip > %s_L00"lane"_R%s.splitLanes.fastq.gz" ; for (i = 1; i <= %s; i++) {getline ; print | "gzip > %s_L00"lane"_R%s.splitLanes.fastq.gz"}} \' ' % (
    fastqFile, fileId, index, fastqSequenceLines - 1, fileId, index)

    sys.stderr.write("Split lanes command: " + command + "\n")

    cmd = ["-c", command]
    subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)


def writeSizeFile(args, fileId, inputSize):
    e = 'echo -e "' + args.sample_id + '@' + fileId + '@R1\t' + inputSize + '" > ' + args.file_size_name

    sys.stderr.write("Write size file command: " + e + "\n")


    subprocess.call(e, shell=True)


def getFileId(fastqFile, fcid):
    fileId = re.sub("_+R[12](?!.*R[12])", "", ntpath.basename(fastqFile))
    fileId = fileId.replace(".fastq", "") + "@" + fcid.replace(":", "@")

    sys.stderr.write("File id generated: " + fileId + "\n")

    return fileId


def getFastqFileSize(fastqFile):
    fastqStats = os.stat(fastqFile)
    inputSize = str(fastqStats.st_size)
    return inputSize


def getFcid(fastqFile):
    with gzip.open(fastqFile, 'rt') as f:
        for line in f:
            if line.startswith("@"):
                line = line[1:]
                fields = line.split(":")
                fcid = fields[0]
                break
    return fcid


if __name__ == "__main__":
    main()
