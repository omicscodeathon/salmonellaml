import argparse
import pandas as pd
import os

def extract_biosamples(input_file):
    # Load data from the input TSV file
    df = pd.read_table(input_file)

    # Extract Biosamples from the specified column
    column_name = 'BioSample'
    column_data = df[column_name]
    print(column_name)

    # Extract the input file name (without extension)
    input_filename = os.path.splitext(os.path.basename(input_file))[0]

    # Construct the output file path with the input file name
    output_directory = "./"
#     os.makedirs(output_directory, exist_ok=False)
    output_file = f"{output_directory}/{input_filename}_biosamples.txt"

    # Save the column data to the output text file
    column_data.to_csv(output_file, index=False, header=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract Biosamples from TSV files in a folder and save to text files.")
    parser.add_argument("folder_path", help="Path to the folder containing TSV files")
    args = parser.parse_args()

    if not os.path.isdir(args.folder_path):
        print(f"Error: The folder '{args.folder_path}' does not exist.")
    else:
        folder_path = os.path.abspath(args.folder_path)
        for filename in os.listdir(folder_path):
            if filename.endswith(".tsv"):
                input_file = os.path.join(folder_path, filename)
                extract_biosamples(input_file)
                print(f"Biosamples extracted and saved to '{input_file}_biosamples.txt'")
