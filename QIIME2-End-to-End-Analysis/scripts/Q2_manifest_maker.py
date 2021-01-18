#!/usr/bin/env python3

import argparse
import glob
import os
import send2trash

script_info = ("""

Script to make a Manifest.csv file for importing fastq.gz files into a qiime 2 environment.

  To Install:
    Open Qiime2 conda environment
    Install python package "send2trash" using: pip install send2trash
    Put script in path and navigate to your working directory
    python ./q2_manifest_maker.py --input_dir <data_directory>
    
    Acceptable formats include:
    
        <sampleid>.R1.fastq.gz
        <sampleid>.R2.fastq.gz
        
    or
    
        <sampleid>_S6_L001_R1_001.fastq.gz
        <sampleid>_S6_L001_R2_001.fastq.gz
    
""")

#Class Objects

class FormatError(Exception):
    '''Formating of file is incompatioble with this program.'''
    pass

class Fasta_File_Meta:

    '''A class used to store metadata for fasta files, for importing into qiime2.'''

    def __init__(self, file_path):
        self.absolute_path = file_path

        path,file_name = os.path.split(file_path)
        self.filename = file_name

        try:
            file_parts = file_name.split(".")
            if file_parts[1][0] is "R":
                self.format = "Basic"
            else:
                raise ValueError
            self.sample_id = file_parts[0]
        except ValueError:
            file_parts = file_name.split("_")
            if file_parts[1][0] is "S":
                self.format = "Illumina"
                self.sample_id = file_parts[0]
            else:
                self.format = "Unknown"
        
        
        if self.format == "Basic":
            if file_parts[1] == "R1":
                self.direction = "forward"
            else:
                if file_parts[1] == "R2":
                    self.direction = "reverse"
                else:
                    raise FormatError("Files do not follow Illumina or Basic filename conventions.")
        if self.format == "Illumina":
            if file_parts[3] == "R1":
                self.direction = "forward"
            else:
                if file_parts[3] == "R2":
                    self.direction = "reverse"
                else:
                    raise FormatError("Files do not follow Illumina or Basic filename conventions.")
        if self.format == "Unknown":
            raise FormatError("Files do not follow Illumina or Basic filename conventions.")

#Global functions

def delete_file(file_in):
    file_exists = os.path.isfile(file_in)
    if file_exists == True:
        send2trash.send2trash(file_in)

def save_manifest_file(fasta_list):
    writer_name = "Manifest.csv"
    delete_file(writer_name)
    writer = open(writer_name, "w")
    header = "sample-id,absolute-filepath,direction\n"
    writer.write(header)
    for fasta in fasta_list:
        line =  str(fasta.sample_id) + "," + str(fasta.absolute_path) + "," + str(fasta.direction) + "\n"
        writer.write(line)
    writer.close()

def assign_fasta_2_class(file_paths):
    fasta_meta_list = []
    for path in file_paths:
        info = Fasta_File_Meta(path)
        fasta_meta_list.append(info)
    return fasta_meta_list

def get_file_list(directory):
    dir_abs = os.path.abspath(directory)
    print("Making manifest file for fastq.gz files in " + dir_abs + "/*.fastq.gz")
    file_paths_rel = glob.glob(dir_abs + "/*.fastq.gz")
    file_paths_abs = []
    for path in file_paths_rel:
        path_abs = os.path.abspath(path)
        file_paths_abs.append(path_abs)
    return file_paths_abs

def get_args():
    parser = argparse.ArgumentParser(description='''Script to make a Manifest.csv file for importing fastq.gz files into a qiime 2 environment.''')
    parser.add_argument("--input_dir", help="Essential: Input directory for samples.", required=True)
    args = parser.parse_args()
    return args


def main():
    options = get_args()

    file_paths = get_file_list(options.input_dir)
    
    fasta_class_list = assign_fasta_2_class(file_paths)

    save_manifest_file(fasta_class_list)

main()
