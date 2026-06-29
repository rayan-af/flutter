import os

def bundle_code():
    output_file = 'codebase_context.txt'
    directories_to_scan = ['lib']
    files_to_include = ['pubspec.yaml', 'README.md']
    
    with open(output_file, 'w', encoding='utf-8') as outfile:
        # Write individual files first
        for file_name in files_to_include:
            if os.path.exists(file_name):
                outfile.write(f"--- File: {file_name} ---\n")
                with open(file_name, 'r', encoding='utf-8') as f:
                    outfile.write(f.read())
                outfile.write("\n\n")
        
        # Walk through directories and write .dart files
        for directory in directories_to_scan:
            for root, _, files in os.walk(directory):
                for file in files:
                    if file.endswith('.dart'):
                        file_path = os.path.join(root, file)
                        outfile.write(f"--- File: {file_path} ---\n")
                        try:
                            with open(file_path, 'r', encoding='utf-8') as f:
                                outfile.write(f.read())
                        except Exception as e:
                            outfile.write(f"Error reading file: {e}\n")
                        outfile.write("\n\n")

if __name__ == '__main__':
    bundle_code()
    print("Codebase successfully bundled into codebase_context.txt!")
