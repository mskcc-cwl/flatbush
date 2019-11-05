import sys, os
import argparse
import subprocess

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--BAIT_INTERVALS", default=None)
  parser.add_argument("--TARGET_INTERVALS", default=None)
  parser.add_argument("--REFERENCE_SEQUENCE", required=True)
  parser.add_argument("--INPUT", required=True)
  parser.add_argument("--OUTPUT", required=True)
  parser.add_argument("--TMP_DIR", default=".")
  parser.add_argument("--mem_option", default=None)

  args = parser.parse_args()

  baits = args.BAIT_INTERVALS
  targets = args.TARGET_INTERVALS
  output_file = args.OUTPUT
  input_file = args.INPUT
  reference_file = args.REFERENCE_SEQUENCE
  tmp_dir = args.TMP_DIR
  mem = args.mem_option

  if baits is None or targets is None:
    open(output_file, 'w').write("No baits/targets file provided for this run")
    sys.exit(0)
  else:
    java_options = ""
    if mem is not None:
      java_options = "--java-options '-Xmx %ig'" % mem
    command = list()
    command.append("gatk CollectHsMetrics")
    command.append(java_options)
    command.append("--TMP_DIR %s" % tmp_dir)
    command.append("--INPUT %s" % input_file)
    command.append("--OUTPUT %s" % output_file)
    command.append("--REFERENCE_SEQUENCE %s" % reference_file)
    command.append("--BAIT_INTERVALS %s" % baits) 
    command.append("--TARGET_INTERVALS %s" % targets)
    run_command = " ".join(command)
    subprocess.call(run_command, shell=True)
